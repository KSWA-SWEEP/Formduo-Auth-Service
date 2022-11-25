package com.sweep.authservice.config;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;


import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.GroupedOpenApi;
import org.springdoc.core.customizers.OpenApiCustomiser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Collections;


@OpenAPIDefinition(
        servers = { @Server(url = "http://localhost:8762/auth"),
                    @Server(url = "http://210.109.60.247:10023/auth"),
                    @Server(url = "http://210.109.61.31:10010/auth"),
                    @Server(url = "http://210.109.63.227:10001/auth")},
        info = @Info(
                title = "인증 서비스",
                description = "설문 서비스 \"폼듀\" API 명세서",
                version = "v1"))

@RequiredArgsConstructor
@Configuration
public class SwaggerConfig {
    @Bean
    public GroupedOpenApi publicApi() {
        String[] paths = {"/api/v1/**"};

        return GroupedOpenApi.builder()
                .group("v1-definition")
                .pathsToMatch(paths)
                .build();
    }

    public OpenApiCustomiser buildSecurityOpenApi() {
        SecurityScheme securityScheme = new SecurityScheme()
                .name("Authorization")
                .type(SecurityScheme.Type.HTTP)
                .in(SecurityScheme.In.HEADER)
                .bearerFormat("JWT")
                .scheme("bearer");

        return OpenApi -> OpenApi
                .addSecurityItem(new SecurityRequirement().addList("jwt token"))
                .getComponents().addSecuritySchemes("jwt token", securityScheme);
    }
}


