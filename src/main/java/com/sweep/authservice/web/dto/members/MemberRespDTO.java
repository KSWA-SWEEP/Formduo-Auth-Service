package com.sweep.authservice.web.dto.members;

import com.sweep.authservice.domain.members.Members;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemberRespDTO {

    private String email;
    private String username;

    public static MemberRespDTO of(Members members) {
        return new MemberRespDTO(members.getEmail(), members.getUsername());
    }
}