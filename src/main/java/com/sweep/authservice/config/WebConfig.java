package com.sweep.authservice.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry){
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:8762", "http://210.109.60.247:10023", "http://localhost:3000", "https://formduo.ddns.net")
                .allowedMethods("*")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
