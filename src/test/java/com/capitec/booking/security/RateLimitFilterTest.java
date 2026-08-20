package com.capitec.booking.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import java.io.IOException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

class RateLimitFilterTest {

    private RateLimitFilter filter;
    private FilterChain filterChain;
    private MockHttpServletResponse response;

    @BeforeEach
    void setUp() {
        filter = new RateLimitFilter();
        filterChain = mock(FilterChain.class);
        response = new MockHttpServletResponse();
    }

    @Test
    void nonAuthPath_passesThrough() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRequestURI("/api/v1/branches");

        filter.doFilterInternal(request, response, filterChain);

        verify(filterChain).doFilter(request, response);
        assertThat(response.getStatus()).isEqualTo(200);
    }

    @Test
    void authPath_withinLimit_passesThrough() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRequestURI("/api/v1/auth/login");
        request.setRemoteAddr("192.168.1.1");

        filter.doFilterInternal(request, response, filterChain);

        verify(filterChain).doFilter(request, response);
        assertThat(response.getStatus()).isEqualTo(200);
    }

    @Test
    void authPath_exceedsLimit_returns429() throws ServletException, IOException {
        for (int i = 0; i < 6; i++) {
            MockHttpServletRequest request = new MockHttpServletRequest();
            request.setRequestURI("/api/v1/auth/login");
            request.setRemoteAddr("10.0.0.1");
            response = new MockHttpServletResponse();
            filter.doFilterInternal(request, response, filterChain);
        }

        assertThat(response.getStatus()).isEqualTo(429);
        assertThat(response.getContentAsString()).contains("Too many requests");
    }

    @Test
    void differentIPs_haveSeparateLimits() throws ServletException, IOException {
        for (int i = 0; i < 5; i++) {
            MockHttpServletRequest request = new MockHttpServletRequest();
            request.setRequestURI("/api/v1/auth/login");
            request.setRemoteAddr("10.0.0.2");
            filter.doFilterInternal(request, new MockHttpServletResponse(), filterChain);
        }

        MockHttpServletRequest newIpRequest = new MockHttpServletRequest();
        newIpRequest.setRequestURI("/api/v1/auth/login");
        newIpRequest.setRemoteAddr("10.0.0.3");
        MockHttpServletResponse newIpResponse = new MockHttpServletResponse();

        filter.doFilterInternal(newIpRequest, newIpResponse, filterChain);

        assertThat(newIpResponse.getStatus()).isEqualTo(200);
    }

    @Test
    void xForwardedFor_usedForClientIp() throws ServletException, IOException {
        for (int i = 0; i < 6; i++) {
            MockHttpServletRequest request = new MockHttpServletRequest();
            request.setRequestURI("/api/v1/auth/login");
            request.setRemoteAddr("127.0.0.1");
            request.addHeader("X-Forwarded-For", "203.0.113.50, 70.41.3.18");
            response = new MockHttpServletResponse();
            filter.doFilterInternal(request, response, filterChain);
        }

        assertThat(response.getStatus()).isEqualTo(429);
    }
}
