package com.example.secondcarpurchasesystem.controllers;

import com.example.secondcarpurchasesystem.models.Auction;
import com.example.secondcarpurchasesystem.models.Car;
import com.example.secondcarpurchasesystem.services.AuctionService;
import com.example.secondcarpurchasesystem.services.CarService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/auctions")
public class AuctionController {
    private final AuctionService auctionService;
    private final CarService carService;

    public AuctionController(AuctionService auctionService, CarService carService) {
        this.auctionService = auctionService;
        this.carService = carService;
    }

    // Create a new auction
    @PostMapping
    public ResponseEntity<?> createAuction(
            @RequestParam("carId") String carId,
            @RequestParam("bidStartPrice") double bidStartPrice,
            @RequestParam("status") String status,
            @RequestParam("auctionDate") String auctionDate) {

        try {
            // Check if car exists
            Optional<Car> car = carService.getCarById(carId);
            if (car.isEmpty()) {
                return ResponseEntity.badRequest().body("Car not found");
            }

            // Check if car is already in an active auction
            System.out.println("Car has "+auctionService.carHasActiveAuction(carId));
            // if (auctionService.carHasActiveAuction(carId)) {
            //   return ResponseEntity.badRequest().body("This car is already in an active auction");
            // }

            // Validate status
            if (!status.equals("OPEN") && !status.equals("CLOSED")) {
                return ResponseEntity.badRequest().body("Status must be either OPEN or CLOSED");
            }

            // Create auction object
            Auction auction = new Auction(
                    car.get(),
                    bidStartPrice,
                    status,
                    auctionDate
            );

            // Save auction
            Auction createdAuction = auctionService.createAuction(auction);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdAuction);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating auction");
        }
    }

    // Get all active auctions
    @GetMapping
    public ResponseEntity<?> getAllActiveAuctions() {
        try {
            List<Auction> auctions = auctionService.getAllActiveAuctions();
            return ResponseEntity.ok(auctions);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving auctions");
        }
    }

    // Get all auctions including deleted ones (admin only)
    @GetMapping("/all")
    public ResponseEntity<?> getAllAuctions() {
        try {
            List<Auction> auctions = auctionService.getAllAuctions();
            return ResponseEntity.ok(auctions);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving auctions");
        }
    }

    // Get auction by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getAuctionById(@PathVariable String id) {
        try {
            Optional<Auction> auction = auctionService.getAuctionById(id);
            return auction.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving auction");
        }
    }

    // Update auction
    @PutMapping("/{id}")
    public ResponseEntity<?> updateAuction(
            @PathVariable String id,
            @RequestParam(value = "carId", required = false) String carId,
            @RequestParam(value = "bidStartPrice", required = false) Double bidStartPrice,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "auctionDate", required = false) String auctionDate) {

        try {
            Optional<Auction> existingAuctionOpt = auctionService.getAuctionById(id);
            if (existingAuctionOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Auction existingAuction = existingAuctionOpt.get();
            Auction updatedAuction = new Auction();

            // Update fields only if they are provided
            if (carId != null) {
                Optional<Car> car = carService.getCarById(carId);
                if (car.isEmpty()) {
                    return ResponseEntity.badRequest().body("Car not found");
                }
                if (!existingAuction.getCar().getId().equals(carId) &&
                        auctionService.carHasActiveAuction(carId)) {
                    return ResponseEntity.badRequest().body("This car is already in an active auction");
                }
                updatedAuction.setCar(car.get());
            } else {
                updatedAuction.setCar(existingAuction.getCar());
            }

            if (bidStartPrice != null) {
                updatedAuction.setBidStartPrice(bidStartPrice);
            } else {
                updatedAuction.setBidStartPrice(existingAuction.getBidStartPrice());
            }

            if (status != null) {
                if (!status.equals("OPEN") && !status.equals("CLOSED")) {
                    return ResponseEntity.badRequest().body("Status must be either OPEN or CLOSED");
                }
                updatedAuction.setStatus(status);
            } else {
                updatedAuction.setStatus(existingAuction.getStatus());
            }

            if (auctionDate != null) {
                updatedAuction.setAuctionDate(auctionDate);
            } else {
                updatedAuction.setAuctionDate(existingAuction.getAuctionDate());
            }

            updatedAuction.setId(id);
            updatedAuction.setDeleteStatus(existingAuction.isDeleteStatus());

            Auction savedAuction = auctionService.updateAuction(id, updatedAuction);
            return ResponseEntity.ok(savedAuction);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating auction");
        }
    }

    // Soft delete auction (mark as deleted)
    @DeleteMapping("/{id}")
    public ResponseEntity<?> softDeleteAuction(@PathVariable String id) {
        try {
            boolean deleted = auctionService.softDeleteAuction(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting auction");
        }
    }

    // Hard delete auction (admin only)
    @DeleteMapping("/{id}/hard")
    public ResponseEntity<?> hardDeleteAuction(@PathVariable String id) {
        try {
            boolean deleted = auctionService.hardDeleteAuction(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting auction");
        }
    }

    // Search auctions
    @GetMapping("/search")
    public ResponseEntity<?> searchAuctions(
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "sort", required = false) String sortBy) {
        try {
            List<Auction> auctions = auctionService.searchAuctions(status, sortBy);
            return ResponseEntity.ok(auctions);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error searching auctions");
        }
    }

    // Check if car has active auction
    @GetMapping("/check-car/{carId}")
    public ResponseEntity<?> checkCarInAuction(@PathVariable String carId) {
        try {
            boolean hasAuction = auctionService.carHasActiveAuction(carId);
            return ResponseEntity.ok(hasAuction);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error checking car auction status");
        }
    }
}