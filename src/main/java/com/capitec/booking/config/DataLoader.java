package com.capitec.booking.config;

import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.model.User;
import com.capitec.booking.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner seedUsers(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        return args -> {
            if (!userRepository.existsByEmail("admin@capitec.co.za")) {
                User admin = new User();
                admin.setEmail("admin@capitec.co.za");
                admin.setPassword(passwordEncoder.encode("Admin@123"));
                admin.setFirstName("System");
                admin.setLastName("Admin");
                admin.setPhoneNumber("0800 10 20 43");
                admin.setRole(Role.ADMIN);
                userRepository.save(admin);
            }

            if (!userRepository.existsByEmail("user@capitec.co.za")) {
                User user = new User();
                user.setEmail("user@capitec.co.za");
                user.setPassword(passwordEncoder.encode("User@123"));
                user.setFirstName("Demo");
                user.setLastName("User");
                user.setPhoneNumber("0821234567");
                user.setRole(Role.USER);
                userRepository.save(user);
            }
        };
    }
}
