package com.capitec.booking.service;

import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.exception.ResourceNotFoundException;
import com.capitec.booking.repository.BranchRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BranchService {

    private final BranchRepository branchRepository;

    public BranchService(BranchRepository branchRepository) {
        this.branchRepository = branchRepository;
    }

    @Transactional(readOnly = true)
    public List<Branch> getAllBranches() {
        return branchRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Branch getBranchById(Long id) {
        return branchRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Branch not found: " + id));
    }
}
