package com.example.secondcarpurchasesystem.controllers;

import com.example.secondcarpurchasesystem.models.Car;
import com.example.secondcarpurchasesystem.services.CarService;
import com.example.secondcarpurchasesystem.services.FileStorageService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cars")
public class CarController {
    private final CarService carService;
    private final FileStorageService fileStorageService;

    public CarController(CarService carService, FileStorageService fileStorageService) {
        this.carService = carService;
        this.fileStorageService = fileStorageService;
    }

    // Create a new car
    @PostMapping
    public ResponseEntity<?> createCar(
            @RequestParam("engineNumber") String engineNumber,
            @RequestParam("chassisNumber") String chassisNumber,
            @RequestParam("manufacturedYear") int manufacturedYear,
            @RequestParam("brand") String brand,
            @RequestParam("manufacturedCountry") String manufacturedCountry,
            @RequestParam("registrationNumber") String registrationNumber,
            @RequestParam("image") MultipartFile image) {

        try {
            // Upload image first
            String imageUrl = fileStorageService.storeFile(image);

            // Create car object
            Car car = new Car(
                    engineNumber,
                    chassisNumber,
                    manufacturedYear,
                    brand,
                    manufacturedCountry,
                    registrationNumber,
                    imageUrl
            );

            // Save car
            Car createdCar = carService.createCar(car);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdCar);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating car");
        }
    }

    // Get all active cars
    @GetMapping
    public ResponseEntity<?> getAllActiveCars() {
        try {
            List<Car> cars = carService.getAllActiveCars();
            return ResponseEntity.ok(cars);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving cars");
        }
    }

    // Get all cars including deleted ones (admin only)
    @GetMapping("/all")
    public ResponseEntity<?> getAllCars() {
        try {
            List<Car> cars = carService.getAllCars();
            return ResponseEntity.ok(cars);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving cars");
        }
    }

    // Get car by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getCarById(@PathVariable String id) {
        try {
            Optional<Car> car = carService.getCarById(id);
            return car.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving car");
        }
    }

    // Update car
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCar(
            @PathVariable String id,
            @RequestParam(value = "engineNumber", required = false) String engineNumber,
            @RequestParam(value = "chassisNumber", required = false) String chassisNumber,
            @RequestParam(value = "manufacturedYear", required = false) Integer manufacturedYear,
            @RequestParam(value = "brand", required = false) String brand,
            @RequestParam(value = "manufacturedCountry", required = false) String manufacturedCountry,
            @RequestParam(value = "registrationNumber", required = false) String registrationNumber,
            @RequestParam(value = "image", required = false) MultipartFile image) {

        try {
            Optional<Car> existingCarOpt = carService.getCarById(id);
            if (existingCarOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Car existingCar = existingCarOpt.get();
            Car updatedCar = new Car();

            // Update fields only if they are provided
            if (engineNumber != null) {
                if (!existingCar.getEngineNumber().equals(engineNumber)) {
                    if (carService.engineNumberExists(engineNumber)) {
                        return ResponseEntity.badRequest().body("Engine number already exists");
                    }
                }
                updatedCar.setEngineNumber(engineNumber);
            } else {
                updatedCar.setEngineNumber(existingCar.getEngineNumber());
            }

            if (chassisNumber != null) {
                if (!existingCar.getChassisNumber().equals(chassisNumber)) {
                    if (carService.chassisNumberExists(chassisNumber)) {
                        return ResponseEntity.badRequest().body("Chassis number already exists");
                    }
                }
                updatedCar.setChassisNumber(chassisNumber);
            } else {
                updatedCar.setChassisNumber(existingCar.getChassisNumber());
            }

            if (manufacturedYear != null) {
                updatedCar.setManufacturedYear(manufacturedYear);
            } else {
                updatedCar.setManufacturedYear(existingCar.getManufacturedYear());
            }

            if (brand != null) {
                updatedCar.setBrand(brand);
            } else {
                updatedCar.setBrand(existingCar.getBrand());
            }

            if (manufacturedCountry != null) {
                updatedCar.setManufacturedCountry(manufacturedCountry);
            } else {
                updatedCar.setManufacturedCountry(existingCar.getManufacturedCountry());
            }

            if (registrationNumber != null) {
                if (!existingCar.getRegistrationNumber().equals(registrationNumber)) {
                    if (carService.registrationNumberExists(registrationNumber)) {
                        return ResponseEntity.badRequest().body("Registration number already exists");
                    }
                }
                updatedCar.setRegistrationNumber(registrationNumber);
            } else {
                updatedCar.setRegistrationNumber(existingCar.getRegistrationNumber());
            }

            // Handle image update
            if (image != null && !image.isEmpty()) {
                String imageUrl = fileStorageService.storeFile(image);
                updatedCar.setImageUrl(imageUrl);
            } else {
                updatedCar.setImageUrl(existingCar.getImageUrl());
            }

            updatedCar.setId(id);
            updatedCar.setDeleteStatus(existingCar.isDeleteStatus());

            Car savedCar = carService.updateCar(id, updatedCar);
            return ResponseEntity.ok(savedCar);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating car");
        }
    }


    // Soft delete car (mark as deleted)
    @DeleteMapping("/{id}")
    public ResponseEntity<?> softDeleteCar(@PathVariable String id) {
        try {
            boolean deleted = carService.softDeleteCar(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting car");
        }
    }

    // Hard delete car (admin only)
    @DeleteMapping("/{id}/hard")
    public ResponseEntity<?> hardDeleteCar(@PathVariable String id) {
        try {
            boolean deleted = carService.hardDeleteCar(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting car");
        }
    }




    // Check if engine number exists
    @GetMapping("/check-engine/{engineNumber}")
    public ResponseEntity<?> checkEngineNumber(@PathVariable String engineNumber) {
        try {
            boolean exists = carService.engineNumberExists(engineNumber);
            return ResponseEntity.ok(exists);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error checking engine number");
        }
    }

    // Check if chassis number exists
    @GetMapping("/check-chassis/{chassisNumber}")
    public ResponseEntity<?> checkChassisNumber(@PathVariable String chassisNumber) {
        try {
            boolean exists = carService.chassisNumberExists(chassisNumber);
            return ResponseEntity.ok(exists);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error checking chassis number");
        }
    }

    // Check if registration number exists
    @GetMapping("/check-registration/{registrationNumber}")
    public ResponseEntity<?> checkRegistrationNumber(@PathVariable String registrationNumber) {
        try {
            boolean exists = carService.registrationNumberExists(registrationNumber);
            return ResponseEntity.ok(exists);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error checking registration number");
        }
    }
}
