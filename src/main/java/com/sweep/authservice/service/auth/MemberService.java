package com.sweep.authservice.service.auth;

import com.sweep.authservice.domain.members.MemberRepository;
import com.sweep.authservice.domain.members.MemberRepository;
import com.sweep.authservice.domain.members.Members;
import com.sweep.authservice.jwt.TokenProvider;
import com.sweep.authservice.util.HeaderUtil;
import com.sweep.authservice.util.exceptionhandler.BizException;
import com.sweep.authservice.util.exceptionhandler.MemberExceptionType;
import com.sweep.authservice.web.dto.members.MemberIsMyPwDTO;
import com.sweep.authservice.web.dto.members.MemberRemoveDTO;
import com.sweep.authservice.web.dto.members.MemberRespDTO;
import com.sweep.authservice.web.dto.members.MemberUpdateDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;


/**
 * MemberService 설명 : 멤버 등록 및 조회
 * @version 1.0.0
 **/
@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    private final TokenProvider tokenProvider;

    /**
     * @param email
     * @return email에 해당하는 멤버의 정보를 반환한다.
     */
    @Transactional(readOnly = true)
    public MemberRespDTO getMemberInfo(String email) {
        return memberRepository.findByEmail(email)
                .map(MemberRespDTO::of)
                .orElseThrow(() -> new BizException(MemberExceptionType.NOT_FOUND_USER)); // 유저를 찾을 수 없습니다.
    }

    /**
     * @return 현재 securityContext에 있는 유저 정보를 반환한다.
     */
    @Transactional(readOnly = true)
    public MemberRespDTO getMyInfo(HttpServletRequest request) {
        String accessToken = HeaderUtil.getAccessToken(request);
//        String accessToken = CookieUtil.getCookie(request, "access_token")
//                .map(Cookie::getValue)
//                .orElse((null));
//        System.out.println("ACCESS : " + accessToken);
        String email = tokenProvider.getMemberEmailByToken(accessToken);
        return memberRepository.findByEmail(email)
                .map(MemberRespDTO::of)
                .orElseThrow(() -> new BizException(MemberExceptionType.NOT_FOUND_USER));
    }


    /**
     * @param MemberUpdateDTO DirtyChecking 을 통한 멤버 업데이트 ( Email은 업데이트 할 수 없다.)
     */
    @Transactional
    public void updateMemberInfo(MemberUpdateDTO dto) {
        Members members = memberRepository
                .findByEmail(dto.getEmail())
                .orElseThrow(() -> new BizException(MemberExceptionType.NOT_FOUND_USER));

        members.updateMember(dto, passwordEncoder);
    }

    @Transactional(readOnly = true)
    public boolean isMyPassword(MemberIsMyPwDTO dto){
        Members members = memberRepository
                .findByEmail(dto.getEmail())
                .orElseThrow(() -> new BizException(MemberExceptionType.NOT_FOUND_USER));

        if (passwordEncoder.matches(dto.getPassword(), members.getPassword())) return true;
        else return false;
    }

    @Transactional
    public String remove(MemberRemoveDTO dto) {
        Members entity = memberRepository
                .findByEmail(dto.getEmail())
                .orElseThrow(() -> new BizException(MemberExceptionType.NOT_FOUND_USER));

        entity.remove('Y');
        memberRepository.save(entity);
        return entity.getEmail();
    }

}
