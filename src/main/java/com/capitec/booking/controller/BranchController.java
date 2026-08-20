package com.capitec.booking.controller;

import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.dto.response.BranchResponse;
import com.capitec.booking.service.BranchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/branches")
@Tag(name = "Branches", description = "Branch information and operating hours")
public class BranchController {

    private final BranchService branchService;

    public BranchController(BranchService branchService) {
        this.branchService = branchService;
    }

    @Operation(summary = "List all branches", description = "Returns all bank branches with operating hours")
    @GetMapping
    public ResponseEntity<List<BranchResponse>> getAllBranches() {
        List<BranchResponse> branches = branchService.getAllBranches()
                .stream()
                .map(this::toResponse)
                .toList();
        return ResponseEntity.ok(branches);
    }

    @Operation(summary = "Get branch by ID", description = "Returns branch details including operating hours")
    @GetMapping("/{id}")
    public ResponseEntity<BranchResponse> getBranch(@PathVariable Long id) {
        Branch branch = branchService.getBranchById(id);
        return ResponseEntity.ok(toResponse(branch));
    }

    private BranchResponse toResponse(Branch branch) {
        BranchResponse response = new BranchResponse();
        response.setId(branch.getId());
        response.setName(branch.getName());
        response.setCode(branch.getCode());
        response.setAddress(branch.getAddress());
        response.setProvince(branch.getProvince());
        response.setLatitude(branch.getLatitude());
        response.setLongitude(branch.getLongitude());

        if (branch.getOperatingHours() != null) {
            List<BranchResponse.OperatingHoursResponse> hours = branch.getOperatingHours().stream()
                    .map(oh -> {
                        BranchResponse.OperatingHoursResponse hr = new BranchResponse.OperatingHoursResponse();
                        hr.setDayOfWeek(oh.getDayOfWeek().name());
                        hr.setOpenTime(oh.getOpenTime() != null ? oh.getOpenTime().toString() : null);
                        hr.setCloseTime(oh.getCloseTime() != null ? oh.getCloseTime().toString() : null);
                        hr.setClosed(oh.isClosed());
                        return hr;
                    })
                    .toList();
            response.setOperatingHours(hours);
        }

        return response;
    }
}
