package com.capitec.booking.config;

import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.User;
import com.capitec.booking.repository.BranchRepository;
import com.capitec.booking.repository.UserRepository;
import com.capitec.booking.service.SlotGenerationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.List;

@Configuration
public class DataLoader {

    private static final Logger log = LoggerFactory.getLogger(DataLoader.class);

    @Bean
    CommandLineRunner seedData(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            BranchRepository branchRepository,
            SlotGenerationService slotGenerationService) {
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

            // Generate slots for all branches for the next 30 days so every branch
            // has bookable slots on startup. existsByBranchIdAndDateAndStartTime checks
            // prevent duplicates with any slots already inserted by the SQL seed file.
            LocalDate today = LocalDate.now();
            LocalDate endDate = today.plusDays(30);
            List<Branch> branches = branchRepository.findAll();
            log.info("Generating slots for {} branches from {} to {}", branches.size(), today, endDate);
            for (Branch branch : branches) {
                slotGenerationService.generateSlotsForDateRange(branch.getId(), today, endDate);
            }
            log.info("Slot generation complete");
        };
    }
}
