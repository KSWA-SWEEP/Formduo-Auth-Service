package com.sweep.authservice.domain.token;

import com.sweep.authservice.domain.token.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, String> {
    Optional<RefreshToken> findByEmail(String email);

    void deleteByEmail(String email);
}
