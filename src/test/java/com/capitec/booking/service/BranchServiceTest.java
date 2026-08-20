package com.capitec.booking.service;

import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.exception.ResourceNotFoundException;
import com.capitec.booking.repository.BranchRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BranchServiceTest {

    @Mock
    private BranchRepository branchRepository;

    @InjectMocks
    private BranchService branchService;

    @Test
    void shouldReturnAllBranches() {
        Branch branch1 = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        Branch branch2 = new Branch("Capitec Rosebank", "CAP-RSB", "Rosebank");
        when(branchRepository.findAll()).thenReturn(List.of(branch1, branch2));

        List<Branch> branches = branchService.getAllBranches();

        assertThat(branches).hasSize(2);
        assertThat(branches.get(0).getName()).isEqualTo("Capitec Sandton");
    }

    @Test
    void shouldReturnBranchById() {
        Branch branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);
        when(branchRepository.findById(1L)).thenReturn(Optional.of(branch));

        Branch result = branchService.getBranchById(1L);

        assertThat(result.getName()).isEqualTo("Capitec Sandton");
    }

    @Test
    void shouldThrowWhenBranchNotFound() {
        when(branchRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> branchService.getBranchById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Branch not found");
    }
}
