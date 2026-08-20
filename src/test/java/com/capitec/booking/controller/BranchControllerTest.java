package com.capitec.booking.controller;

import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.dto.response.BranchResponse;
import com.capitec.booking.service.BranchService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class BranchControllerTest {

    private BranchService branchService;
    private BranchController controller;

    @BeforeEach
    void setUp() {
        branchService = mock(BranchService.class);
        controller = new BranchController(branchService);
    }

    private Branch createBranch(Long id, String name, String province) {
        Branch branch = new Branch();
        branch.setId(id);
        branch.setName(name);
        branch.setCode("CAP-" + id);
        branch.setAddress("123 Test St");
        branch.setProvince(province);
        branch.setLatitude(-26.0);
        branch.setLongitude(28.0);
        return branch;
    }

    @Test
    void getAllBranches_returns200WithList() {
        List<Branch> branches = List.of(
                createBranch(1L, "Capitec Sandton", "Gauteng"),
                createBranch(2L, "Capitec Canal Walk", "Western Cape")
        );
        when(branchService.getAllBranches()).thenReturn(branches);

        ResponseEntity<List<BranchResponse>> response = controller.getAllBranches();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).hasSize(2);
        assertThat(response.getBody().get(0).getName()).isEqualTo("Capitec Sandton");
        assertThat(response.getBody().get(0).getProvince()).isEqualTo("Gauteng");
        assertThat(response.getBody().get(1).getName()).isEqualTo("Capitec Canal Walk");
    }

    @Test
    void getBranch_returns200WithBranch() {
        Branch branch = createBranch(1L, "Capitec Sandton", "Gauteng");
        when(branchService.getBranchById(1L)).thenReturn(branch);

        ResponseEntity<BranchResponse> response = controller.getBranch(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody().getName()).isEqualTo("Capitec Sandton");
        assertThat(response.getBody().getProvince()).isEqualTo("Gauteng");
        assertThat(response.getBody().getCode()).isEqualTo("CAP-1");
    }

    @Test
    void getAllBranches_emptyList() {
        when(branchService.getAllBranches()).thenReturn(List.of());

        ResponseEntity<List<BranchResponse>> response = controller.getAllBranches();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isEmpty();
    }
}
