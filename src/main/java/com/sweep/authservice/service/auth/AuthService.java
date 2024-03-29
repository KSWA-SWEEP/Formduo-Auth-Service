package com.sweep.authservice.service.auth;

import antlr.Token;
import com.sweep.authservice.domain.auth.MemberAuth;
import com.sweep.authservice.domain.auth.Authority;
import com.sweep.authservice.domain.auth.AuthorityRepository;

import com.sweep.authservice.domain.members.MemberRepository;
import com.sweep.authservice.domain.members.Members;
import com.sweep.authservice.domain.token.RefreshToken;
import com.sweep.authservice.domain.token.RefreshTokenRepository;
import com.sweep.authservice.util.HeaderUtil;
import com.sweep.authservice.service.members.CustomUserDetailsService;
import com.sweep.authservice.util.CookieUtil;
import com.sweep.authservice.web.dto.jwt.TokenDTO;
import com.sweep.authservice.web.dto.jwt.TokenReqDTO;
import com.sweep.authservice.web.dto.login.LoginReqDTO;
import com.sweep.authservice.web.dto.members.MemberEmailDto;
import com.sweep.authservice.web.dto.members.MemberReqDTO;
import com.sweep.authservice.util.exceptionhandler.AuthorityExceptionType;
import com.sweep.authservice.util.exceptionhandler.BizException;
import com.sweep.authservice.util.exceptionhandler.JwtExceptionType;
import com.sweep.authservice.util.exceptionhandler.MemberExceptionType;
import com.sweep.authservice.jwt.CustomEmailPasswordAuthToken;
import com.sweep.authservice.jwt.TokenProvider;
import com.sweep.authservice.web.dto.members.MemberRespDTO;
import com.sweep.authservice.web.dto.members.MemberUpdateDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final MemberRepository memberRepository;
    private final AuthorityRepository authorityRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;
    private final RefreshTokenRepository refreshTokenRepository;
    private final CustomUserDetailsService customUserDetailsService;
    private final RedisService redisService;
    @Value("${jwt.refresh-token-expire-time}")
    private long rtkLive;
    @Value("${jwt.access-token-expire-time}")
    private long accExpTime;


    @Transactional
    public MemberRespDTO signup(MemberReqDTO memberRequestDto) {
        if (memberRepository.existsByEmail(memberRequestDto.getEmail())) {
            throw new BizException(MemberExceptionType.DUPLICATE_USER);
        }

        // DB 에서 ROLE_USER를 찾아서 권한으로 추가한다.
        Authority authority = authorityRepository
                .findByAuthorityName(MemberAuth.ROLE_USER).orElseThrow(()->new BizException(AuthorityExceptionType.NOT_FOUND_AUTHORITY));

        Set<Authority> set = new HashSet<>();
        set.add(authority);


        Members members = memberRequestDto.toMember(passwordEncoder,set);
        log.debug("member = {}", members);
        return MemberRespDTO.of(memberRepository.save(members));
    }

    @Transactional
    public TokenDTO login(LoginReqDTO loginReqDTO, HttpServletResponse response) {
        CustomEmailPasswordAuthToken customEmailPasswordAuthToken = new CustomEmailPasswordAuthToken(loginReqDTO.getEmail(),loginReqDTO.getPassword());
        Authentication authenticate = authenticationManager.authenticate(customEmailPasswordAuthToken);
        String email = authenticate.getName();
        Members members = customUserDetailsService.getMember(email);

        if (members.getDelYn() == 'Y'){
            throw new IllegalArgumentException("탈퇴환 회원입니다.");
        }
//        System.out.println(email + members.toString());

        String accessToken = tokenProvider.createAccessToken(email, members.getAuthorities());
        String refreshToken = tokenProvider.createRefreshToken(email, members.getAuthorities());

//        System.out.println(accessToken);
//        System.out.println(refreshToken);

        //redis에 refresh token 저장
        redisService.setValues(email, refreshToken, Duration.ofMillis(rtkLive));

        int cookieMaxAge = (int) rtkLive / 60;

//        CookieUtil.addCookie(response, "access_token", accessToken, cookieMaxAge);
        CookieUtil.addCookie(response, "refresh_token", refreshToken, cookieMaxAge);

        // 로그인 여부 및 토큰 만료 시간 Cookie 설정
        String isLogin = "true";
        Date newExpTime = new Date(System.currentTimeMillis() + accExpTime);
        SimpleDateFormat sdf;
        sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
        String expTime = sdf.format(newExpTime);
        CookieUtil.addPublicCookie(response, "isLogin", isLogin, cookieMaxAge);
        CookieUtil.addPublicCookie(response, "expTime", expTime, cookieMaxAge);
//        System.out.println("redis " + redisService.getValues(email));

        //mysql에 refresh token 저장
        refreshTokenRepository.save(
                RefreshToken.builder()
                        .email(email)
                        .value(refreshToken)
                        .build()
        );

        return tokenProvider.createTokenDTO(accessToken,refreshToken, expTime);

    }

    @Transactional
    public TokenDTO reissue(TokenReqDTO tokenReqDTO,
                            HttpServletResponse response) {
        /*
         *  accessToken 은 JWT Filter 에서 검증되고 옴
         * */
//        String originAccessToken = HeaderUtil.getAccessToken(request);
//        String originRefreshToken = CookieUtil.getCookie(request, "refresh_token")
//                .map(Cookie::getValue)
//                .orElse((null));

//        String originRefreshToken = tokenRequestDto.getRefreshToken(request);
//        String originAccessToken = tokenRequestDto.getAccessToken();
//        String originRefreshToken = tokenRequestDto.getRefreshToken();

        String originRefreshToken = tokenReqDTO.getRefreshToken();
        // refreshToken 검증
        int refreshTokenFlag = tokenProvider.validateToken(originRefreshToken);

        log.debug("refreshTokenFlag = {}", refreshTokenFlag);

        //refreshToken 검증하고 상황에 맞는 오류를 내보낸다.
        if (refreshTokenFlag == -1) {
            throw new BizException(JwtExceptionType.BAD_TOKEN); // 잘못된 리프레시 토큰
        } else if (refreshTokenFlag == 2) {
            throw new BizException(JwtExceptionType.REFRESH_TOKEN_EXPIRED); // 유효기간 끝난 토큰
        }

        // 2. Access Token 에서 Member Email 가져오기
        Authentication authentication = tokenProvider.getAuthentication(originRefreshToken);
//        Authentication authentication = tokenProvider.getAuthentication(originAccessToken);
        log.debug("Authentication = {}", authentication);


        // Redis에서 mail기반으로 refresh token을 가져옴.
        String rtkInRedis = redisService.getValues(authentication.getName());

        // Cache miss가 일어났을 경우
        if (!rtkInRedis.equals(originRefreshToken)) {
            // DB에서 Member Email 를 기반으로 Refresh Token 값 가져옴
            RefreshToken refreshToken = refreshTokenRepository.findByEmail(authentication.getName())
                    .orElseThrow(() -> new BizException(MemberExceptionType.LOGOUT_MEMBER)); // 로그 아웃된 사용자

            // Refresh Token 일치하는지 검사
            if (!refreshToken.getValue().equals(originRefreshToken)) {
                throw new BizException(JwtExceptionType.BAD_TOKEN); // 토큰이 일치하지 않습니다.
            }
        }


//        }

        Date newExpTime = new Date(System.currentTimeMillis() + accExpTime);
        SimpleDateFormat sdf;
        sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
        String expTime = sdf.format(newExpTime);

        // 5. 새로운 토큰 생성
        String email = tokenProvider.getMemberEmailByToken(originRefreshToken);
//            String email = tokenProvider.getMemberEmailByToken(originAccessToken);
        Members members = customUserDetailsService.getMember(email);

        String newAccessToken = tokenProvider.createAccessToken(email, members.getAuthorities());
        String newRefreshToken = tokenProvider.createRefreshToken(email, members.getAuthorities());
        TokenDTO tokenDto = tokenProvider.createTokenDTO(newAccessToken, newRefreshToken, expTime);

        log.debug("refresh Origin = {}", originRefreshToken);
        log.debug("refresh New = {} ", newRefreshToken);

        // 6. Redis 정보 업데이트
        redisService.setValues(email, newRefreshToken, Duration.ofMillis(rtkLive));
        refreshTokenRepository.save(
                RefreshToken.builder()
                        .email(email)
                        .value(newRefreshToken)
                        .build()
        );

        int cookieMaxAge = (int) rtkLive / 60;
//            CookieUtil.deleteCookie(request, response, "access_token");
//        CookieUtil.deleteCookie(request, response, "refresh_token");
//            CookieUtil.addCookie(response, "access_token", newAccessToken, cookieMaxAge);
        CookieUtil.addCookie(response, "refresh_token", newRefreshToken, cookieMaxAge);

        // 로그인 여부 및 토큰 만료 시간 Cookie 설정
        String isLogin = "true";
        CookieUtil.addPublicCookie(response, "isLogin", isLogin, cookieMaxAge);
        CookieUtil.addPublicCookie(response, "expTime", expTime, cookieMaxAge);


        return tokenDto;
    }

    @Transactional
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<?> logout(HttpServletRequest request, HttpServletResponse response){

        String originAccessToken = HeaderUtil.getAccessToken(request);

//        CookieUtil.deleteCookie(request, response, "access_token");
//        CookieUtil.deleteCookie(request, response, "refresh_token");
        String initValue = "";
//        CookieUtil.addCookie(response, "access_token", initValue,0);
        CookieUtil.addCookie(response, "refresh_token", initValue, 0);

        // 로그인 여부 및 토큰 만료 시간 Cookie 설정
        String isLogin = "false";
        String expTime = "expTime";
        CookieUtil.addPublicCookie(response, "isLogin", isLogin, 0);
        CookieUtil.addPublicCookie(response, "expTime", expTime, 0);

        Authentication authentication = tokenProvider.getAuthentication(originAccessToken);
        String email = authentication.getName();

        try{
            if(redisService.getValues(email).isEmpty()){
                if(refreshTokenRepository.findByEmail(email).isPresent()){
                    redisService.deleteValues(email);
                    refreshTokenRepository.deleteByEmail(email);
                }
            }
        } catch (NullPointerException e){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        redisService.deleteValues(email);
        refreshTokenRepository.deleteByEmail(email);

//        System.out.println(redisService.getValues(email));

        return ResponseEntity.ok("로그아웃 되었습니다.");
    }

    @Transactional(readOnly = true)
    public Optional<Members> isMember(MemberEmailDto memberRequestDto) {
        if (memberRepository.existsByEmail(memberRequestDto.getEmail())) {
            return memberRepository.findByEmail(memberRequestDto.getEmail());
        }else
            return null;
    }

    @Transactional
    public void updatePw(MemberUpdateDTO dto) {
        Members members = memberRepository
                .findByEmail(dto.getEmail())
                .orElseThrow(() -> new BizException(MemberExceptionType.NOT_FOUND_USER));

        members.updateMember(dto, passwordEncoder);
    }

}
