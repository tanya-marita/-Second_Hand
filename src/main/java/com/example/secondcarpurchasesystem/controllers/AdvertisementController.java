package com.example.secondcarpurchasesystem.controllers;

import com.example.secondcarpurchasesystem.models.Advertisement;
import com.example.secondcarpurchasesystem.services.AdvertisementService;
import com.example.secondcarpurchasesystem.services.FileStorageService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/ads")
public class AdvertisementController {
    private final AdvertisementService adService;
    private final FileStorageService fileStorageService;

    public AdvertisementController(AdvertisementService adService, FileStorageService fileStorageService) {
        this.adService = adService;
        this.fileStorageService = fileStorageService;
    }

    // Create a new advertisement
    @PostMapping
    public ResponseEntity<?> createAd(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("image") MultipartFile image) {

        try {
            // Upload image first
            String imageUrl = fileStorageService.storeFile(image);

            // Create ad object
            Advertisement ad = new Advertisement(
                    title,
                    description,
                    imageUrl
            );

            // Save ad
            Advertisement createdAd = adService.createAdvertisement(ad);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdAd);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating advertisement");
        }
    }

    // Get all active advertisements
    @GetMapping
    public ResponseEntity<?> getAllActiveAds() {
        try {
            List<Advertisement> ads = adService.getAllActiveAds();
            return ResponseEntity.ok(ads);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving advertisements");
        }
    }

    // Get all advertisements including deleted ones (admin only)
    @GetMapping("/all")
    public ResponseEntity<?> getAllAds() {
        try {
            List<Advertisement> ads = adService.getAllAds();
            return ResponseEntity.ok(ads);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving advertisements");
        }
    }

    // Get advertisement by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getAdById(@PathVariable String id) {
        try {
            Optional<Advertisement> ad = adService.getAdById(id);
            return ad.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving advertisement");
        }
    }

    // Update advertisement
    @PutMapping("/{id}")
    public ResponseEntity<?> updateAd(
            @PathVariable String id,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "image", required = false) MultipartFile image) {

        try {
            Optional<Advertisement> existingAdOpt = adService.getAdById(id);
            if (existingAdOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Advertisement existingAd = existingAdOpt.get();
            Advertisement updatedAd = new Advertisement();

            // Update fields only if they are provided
            if (title != null) {
                if (!existingAd.getTitle().equals(title)) {
                    if (adService.titleExists(title)) {
                        return ResponseEntity.badRequest().body("Title already exists");
                    }
                }
                updatedAd.setTitle(title);
            } else {
                updatedAd.setTitle(existingAd.getTitle());
            }

            if (description != null) {
                updatedAd.setDescription(description);
            } else {
                updatedAd.setDescription(existingAd.getDescription());
            }

            // Handle image update
            if (image != null && !image.isEmpty()) {
                String imageUrl = fileStorageService.storeFile(image);
                updatedAd.setImageUrl(imageUrl);
            } else {
                updatedAd.setImageUrl(existingAd.getImageUrl());
            }

            updatedAd.setId(id);
            updatedAd.setDeleteStatus(existingAd.isDeleteStatus());

            Advertisement savedAd = adService.updateAd(id, updatedAd);
            return ResponseEntity.ok(savedAd);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating advertisement");
        }
    }

    // Soft delete advertisement (mark as deleted)
    @DeleteMapping("/{id}")
    public ResponseEntity<?> softDeleteAd(@PathVariable String id) {
        try {
            boolean deleted = adService.softDeleteAd(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting advertisement");
        }
    }

    // Hard delete advertisement (admin only)
    @DeleteMapping("/{id}/hard")
    public ResponseEntity<?> hardDeleteAd(@PathVariable String id) {
        try {
            boolean deleted = adService.hardDeleteAd(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting advertisement");
        }
    }

    // Search advertisements
    @GetMapping("/search")
    public ResponseEntity<?> searchAds(
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "sort", required = false) String sortBy) {
        try {
            List<Advertisement> ads = adService.searchAds(title, sortBy);
            return ResponseEntity.ok(ads);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error searching advertisements");
        }
    }

    // Check if title exists
    @GetMapping("/check-title/{title}")
    public ResponseEntity<?> checkTitle(@PathVariable String title) {
        try {
            boolean exists = adService.titleExists(title);
            return ResponseEntity.ok(exists);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error checking title");
        }
    }
}