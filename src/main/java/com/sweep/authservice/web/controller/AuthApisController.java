package com.sweep.authservice.web.controller;

import com.sweep.authservice.domain.members.Members;
import com.sweep.authservice.web.dto.jwt.TokenDTO;
import com.sweep.authservice.web.dto.jwt.TokenReqDTO;
import com.sweep.authservice.web.dto.login.LoginReqDTO;
import com.sweep.authservice.web.dto.members.MemberEmailDto;
import com.sweep.authservice.web.dto.members.MemberReqDTO;
import com.sweep.authservice.service.auth.AuthService;
import com.sweep.authservice.web.dto.members.MemberRespDTO;
import com.sweep.authservice.web.dto.members.MemberUpdateDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Optional;


@Slf4j
@RestController
@Tag(name = "인증", description = "인증 관련 api 입니다.")
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthApisController {

    private final AuthService authService;
    @Value("${jwt.refresh-token-expire-time}")
    private long rtkLive;

    @GetMapping("/test")
    public String test(){
        return "OK";
    }

    @Operation(summary = "회원가입")
    @PostMapping("/signup")
    public MemberRespDTO signup(@RequestBody MemberReqDTO memberRequestDto) {
        log.debug("memberRequestDto = {}",memberRequestDto);
        return authService.signup(memberRequestDto);
    }

    @Operation(summary = "로그인")
    @PostMapping("/login")
    public TokenDTO login(
            HttpServletResponse response,
            @RequestBody LoginReqDTO loginReqDTO) {
        return authService.login(loginReqDTO, response);
    }

    @Operation(summary = "회원여부 확인")
    @PostMapping("/is-member")
    public Optional<Members> isMember(
            @RequestBody MemberEmailDto memberRequestDto) {
        return authService.isMember(memberRequestDto);
    }

    @Operation(summary = "비밀번호 변경", description = "비밀번호 재설정을 요청합니다.")
    @PutMapping("/change-pw")
    public void changePw(@RequestBody MemberUpdateDTO dto) {
        authService.updatePw(dto);
    }

    @Operation(summary = "토큰 재발급")
    @PostMapping("/reissue")
    public TokenDTO reissue(@RequestBody TokenReqDTO tokenReqDTO,
                            HttpServletResponse response
    ) {
        return authService.reissue(tokenReqDTO, response);
    }

    @Operation(summary = "로그아웃")
    @PostMapping("/logout")
    public ResponseEntity<?> logout(
            HttpServletRequest request, HttpServletResponse response) {

        return authService.logout(request, response);
    }
}
