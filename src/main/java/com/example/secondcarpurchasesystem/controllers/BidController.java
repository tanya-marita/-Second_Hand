package com.example.secondcarpurchasesystem.controllers;

import com.example.secondcarpurchasesystem.dto.CreateBidRequest;
import com.example.secondcarpurchasesystem.dto.UpdateBidStatusRequest;
import com.example.secondcarpurchasesystem.models.Bid;
import com.example.secondcarpurchasesystem.services.BidService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/bids")
public class BidController {
    private final BidService bidService;

    public BidController(BidService bidService) {
        this.bidService = bidService;
    }

    // Create a new bid
    @PostMapping
    public ResponseEntity<?> createBid(@RequestBody CreateBidRequest bidRequest) {
        try {
            // Validate bid amount
            Optional<Bid> highestBid = bidService.getHighestBidForAuction(bidRequest.getAuctionId());
            double minBidAmount = highestBid.isPresent()
                    ? highestBid.get().getBidAmount() + 100
                    : 100;

            if (bidRequest.getBidAmount() < minBidAmount) {
                return ResponseEntity.badRequest().body(
                        "Bid amount must be at least $" + minBidAmount);
            }

            // Create bid object with current timestamp
            String biddedAt = LocalDateTime.now()
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            Bid bid = new Bid(
                    bidRequest.getUserEmail(),
                    bidRequest.getAuctionId(),
                    biddedAt,
                    bidRequest.getBidAmount()
            );

            // Save bid
            Bid createdBid = bidService.createBid(bid);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdBid);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error creating bid");
        }
    }

    // Update bid statuses when auction closes
    @PostMapping("/update-status")
    public ResponseEntity<?> updateBidStatuses(@RequestBody UpdateBidStatusRequest request) {
        try {
            bidService.updateBidStatusesForClosedAuction(request.getAuctionId(), request.getWinningBidId());
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating bid statuses");
        }
    }

    // Get all bids for an auction
    @GetMapping("/auction/{auctionId}")
    public ResponseEntity<?> getBidsByAuctionId(@PathVariable String auctionId) {
        try {
            List<Bid> bids = bidService.getBidsByAuctionId(auctionId);
            return ResponseEntity.ok(bids);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving bids");
        }
    }

    // Get bids by user email
    @GetMapping("/user/{userEmail}")
    public ResponseEntity<?> getBidsByUserEmail(@PathVariable String userEmail) {
        try {
            List<Bid> bids = bidService.getBidsByUserEmail(userEmail);
            return ResponseEntity.ok(bids);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving user bids");
        }
    }

    // Get highest bid for an auction
    @GetMapping("/auction/{auctionId}/highest")
    public ResponseEntity<?> getHighestBidForAuction(@PathVariable String auctionId) {
        try {
            Optional<Bid> highestBid = bidService.getHighestBidForAuction(auctionId);
            return highestBid.isPresent() ?
                    ResponseEntity.ok(highestBid.get()) :
                    ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving highest bid");
        }
    }

    // Get all bids
    @GetMapping
    public ResponseEntity<?> getAllBids() {
        try {
            List<Bid> bids = bidService.getAllBids();
            return ResponseEntity.ok(bids);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving bids");
        }
    }

    // Get bid by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getBidById(@PathVariable String id) {
        try {
            Optional<Bid> bid = bidService.getBidById(id);
            return bid.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving bid");
        }
    }

    // Update bid
    @PutMapping("/{id}")
    public ResponseEntity<?> updateBid(
            @PathVariable String id,
            @RequestParam(value = "bidAmount", required = false) Double bidAmount,
            @RequestParam(value = "status", required = false) String status) {

        try {
            Optional<Bid> existingBidOpt = bidService.getBidById(id);
            if (existingBidOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Bid existingBid = existingBidOpt.get();
            Bid updatedBid = new Bid();

            // Update fields only if they are provided
            updatedBid.setUserEmail(existingBid.getUserEmail());
            updatedBid.setAuctionId(existingBid.getAuctionId());
            updatedBid.setBiddedAt(existingBid.getBiddedAt());

            if (bidAmount != null) {
                updatedBid.setBidAmount(bidAmount);
            } else {
                updatedBid.setBidAmount(existingBid.getBidAmount());
            }

            if (status != null) {
                updatedBid.setStatus(status);
            } else {
                updatedBid.setStatus(existingBid.getStatus());
            }

            updatedBid.setId(id);
            updatedBid.setDeleteStatus(existingBid.isDeleteStatus());

            Bid savedBid = bidService.updateBid(id, updatedBid);
            return ResponseEntity.ok(savedBid);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating bid");
        }
    }

    // Soft delete bid (mark as deleted)
    @DeleteMapping("/{id}")
    public ResponseEntity<?> softDeleteBid(@PathVariable String id) {
        try {
            boolean deleted = bidService.softDeleteBid(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting bid");
        }
    }

    // Hard delete bid (admin only)
    @DeleteMapping("/{id}/hard")
    public ResponseEntity<?> hardDeleteBid(@PathVariable String id) {
        try {
            boolean deleted = bidService.hardDeleteBid(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting bid");
        }
    }

    // Search bids with sorting
    @GetMapping("/search")
    public ResponseEntity<?> searchBids(
            @RequestParam(value = "auctionId", required = false) String auctionId,
            @RequestParam(value = "userEmail", required = false) String userEmail,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "sort", required = false) String sortBy) {
        try {
            List<Bid> bids = bidService.searchBids(auctionId, userEmail, status, sortBy);
            return ResponseEntity.ok(bids);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error searching bids");
        }
    }
}