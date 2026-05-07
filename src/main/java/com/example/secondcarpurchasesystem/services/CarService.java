package com.example.secondcarpurchasesystem.services;

import com.example.secondcarpurchasesystem.models.Car;
import com.example.secondcarpurchasesystem.datastructures.CustomLinkedList;
import com.example.secondcarpurchasesystem.datastructures.CustomMergeSort;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.UUID;

@Service
public class CarService {
    private static final String CARS_JSON_FILE = "C:\\Users\\ghdha\\IdeaProjects\\SecondCarPurchaseSystem\\SecondCarPurchaseSystem\\cars.json";
    private static final String UPLOAD_DIR = "uploads"; // Folder for image uploads
    private final ObjectMapper objectMapper = new ObjectMapper();

    // Constructor to initialize upload directory
    public CarService() {
        // Create uploads directory if it doesn't exist
        try {
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
                System.out.println("Upload directory created: " + uploadPath.toAbsolutePath());
            }
        } catch (IOException e) {
            throw new RuntimeException("Could not create upload directory!", e);
        }
    }

    // Save uploaded image and return filename
    public String saveImage(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IOException("Failed to store empty file");
        }

        String filename = UUID.randomUUID() + "-" + file.getOriginalFilename();
        Path destinationFile = Paths.get(UPLOAD_DIR).resolve(
                Paths.get(filename)).normalize().toAbsolutePath();

        // Make sure the target location is within the uploads directory
        if (!destinationFile.getParent().equals(Paths.get(UPLOAD_DIR).toAbsolutePath())) {
            throw new IOException("Cannot store file outside upload directory.");
        }

        // Save the file
        Files.copy(file.getInputStream(), destinationFile);

        return filename;
    }

    // Create a new car
    public Car createCar(Car car) throws IOException {
        CustomLinkedList<Car> cars = getAllCarsLinkedList();
        cars.add(car);
        saveCarsToFile(convertToList(cars));
        return car;
    }

    // Get all cars (excluding deleted ones)
    public List<Car> getAllActiveCars() throws IOException {
        return getAllCars().stream()
                .filter(car -> !car.isDeleteStatus())
                .collect(Collectors.toList());
    }

    // Get all cars including deleted ones (for admin purposes)
    public List<Car> getAllCars() throws IOException {
        File file = new File(CARS_JSON_FILE);
        if (!file.exists()) {
            return new ArrayList<>();
        }
        return objectMapper.readValue(file, new TypeReference<List<Car>>() {});
    }

    // Convert list to CustomLinkedList
    private CustomLinkedList<Car> getAllCarsLinkedList() throws IOException {
        CustomLinkedList<Car> linkedList = new CustomLinkedList<>();
        List<Car> cars = getAllCars();
        for (Car car : cars) {
            linkedList.add(car);
        }
        return linkedList;
    }

    // Convert CustomLinkedList to ArrayList
    private List<Car> convertToList(CustomLinkedList<Car> linkedList) {
        List<Car> list = new ArrayList<>();
        for (int i = 0; i < linkedList.size(); i++) {
            list.add(linkedList.get(i));
        }
        return list;
    }

    // Get car by ID
    public Optional<Car> getCarById(String id) throws IOException {
        return getAllCars().stream()
                .filter(car -> car.getId().equals(id))
                .findFirst();
    }

    // Update car
    public Car updateCar(String id, Car updatedCar) throws IOException {
        List<Car> cars = getAllCars();
        cars = cars.stream()
                .map(car -> car.getId().equals(id) ? updatedCar : car)
                .collect(Collectors.toList());
        saveCarsToFile(cars);
        return updatedCar;
    }

    // Soft delete car (mark as deleted)
    public boolean softDeleteCar(String id) throws IOException {
        List<Car> cars = getAllCars();
        Optional<Car> carToDelete = cars.stream()
                .filter(car -> car.getId().equals(id))
                .findFirst();

        if (carToDelete.isPresent()) {
            carToDelete.get().setDeleteStatus(true);
            saveCarsToFile(cars);
            return true;
        }
        return false;
    }

    // Hard delete car (remove from file)
    public boolean hardDeleteCar(String id) throws IOException {
        List<Car> cars = getAllCars();
        boolean removed = cars.removeIf(car -> car.getId().equals(id));
        if (removed) {
            saveCarsToFile(cars);
        }
        return removed;
    }

    // Search cars by various criteria using MergeSort
    public List<Car> searchCars(String brand, Integer minYear, Integer maxYear,
                                String country, String sortBy) throws IOException {
        // Get active cars that match criteria
        List<Car> matchingCars = getAllActiveCars().stream()
                .filter(car ->
                        (brand == null || car.getBrand().equalsIgnoreCase(brand)) &&
                                (minYear == null || car.getManufacturedYear() >= minYear) &&
                                (maxYear == null || car.getManufacturedYear() <= maxYear) &&
                                (country == null || car.getManufacturedCountry().equalsIgnoreCase(country))
                )
                .collect(Collectors.toList());

        // Convert to linked list
        CustomLinkedList<Car> carLinkedList = new CustomLinkedList<>();
        for (Car car : matchingCars) {
            carLinkedList.add(car);
        }

        // Sort using custom merge sort
        CustomMergeSort<Car> sorter;
        if (sortBy != null) {
            Comparator<Car> comparator = getComparatorByCriteria(sortBy);
            sorter = new CustomMergeSort<>(comparator);
        } else {
            // Default sorting by year (newest first)
            sorter = new CustomMergeSort<>(Comparator.comparing(Car::getManufacturedYear).reversed());
        }

        sorter.sortLinkedList(carLinkedList);

        // Convert back to list
        return convertToList(carLinkedList);
    }

    // Get comparator based on sort criteria
    private Comparator<Car> getComparatorByCriteria(String criteria) {
        switch (criteria.toLowerCase()) {
            case "year_asc":
                return Comparator.comparing(Car::getManufacturedYear);
            case "year_desc":
                return Comparator.comparing(Car::getManufacturedYear).reversed();
            case "brand_asc":
                return Comparator.comparing(Car::getBrand);
            case "brand_desc":
                return Comparator.comparing(Car::getBrand).reversed();
            case "country_asc":
                return Comparator.comparing(Car::getManufacturedCountry);
            case "country_desc":
                return Comparator.comparing(Car::getManufacturedCountry).reversed();
            default:
                return Comparator.comparing(Car::getManufacturedYear).reversed();
        }
    }

    // Check if engine number exists
    public boolean engineNumberExists(String engineNumber) throws IOException {
        return getAllCars().stream()
                .anyMatch(car -> car.getEngineNumber().equalsIgnoreCase(engineNumber));
    }

    // Check if chassis number exists
    public boolean chassisNumberExists(String chassisNumber) throws IOException {
        return getAllCars().stream()
                .anyMatch(car -> car.getChassisNumber().equalsIgnoreCase(chassisNumber));
    }

    // Check if registration number exists
    public boolean registrationNumberExists(String registrationNumber) throws IOException {
        return getAllCars().stream()
                .anyMatch(car -> car.getRegistrationNumber().equalsIgnoreCase(registrationNumber));
    }

    // Helper method to save cars to JSON file
    private void saveCarsToFile(List<Car> cars) throws IOException {
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(new File(CARS_JSON_FILE), cars);
    }

    // Initialize sample data
    public void initializeSampleCars() throws IOException {
        if (getAllCars().isEmpty()) {
            List<Car> sampleCars = new ArrayList<>();

            sampleCars.add(new Car(
                    "ENG12345678",
                    "CHS12345678901234",
                    2020,
                    "Toyota",
                    "Japan",
                    "ABC-1234",
                    "/uploads/sample-toyota.jpg" // Use local path rather than URL
            ));

            sampleCars.add(new Car(
                    "ENG87654321",
                    "CHS98765432109876",
                    2018,
                    "BMW",
                    "Germany",
                    "XYZ-5678",
                    "/uploads/sample-bmw.jpg"
            ));

            sampleCars.add(new Car(
                    "ENG13579246",
                    "CHS24681357924680",
                    2022,
                    "Tesla",
                    "USA",
                    "TES-2022",
                    "/uploads/sample-tesla.jpg"
            ));

            saveCarsToFile(sampleCars);
        }
    }
}
