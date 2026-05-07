package com.example.secondcarpurchasesystem.services;

import com.example.secondcarpurchasesystem.models.Auction;
import com.example.secondcarpurchasesystem.models.Car;
import com.example.secondcarpurchasesystem.datastructures.CustomLinkedList;
import com.example.secondcarpurchasesystem.datastructures.CustomMergeSort;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AuctionService {
    private static final String AUCTIONS_JSON_FILE = "C:\\Users\\ghdha\\IdeaProjects\\SecondCarPurchaseSystem\\SecondCarPurchaseSystem\\auctions.json";
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final CarService carService;

    public AuctionService(CarService carService) {
        this.carService = carService;
    }

    // Create a new auction
    public Auction createAuction(Auction auction) throws IOException {
        CustomLinkedList<Auction> auctions = getAllAuctionsLinkedList();
        auctions.add(auction);
        saveAuctionsToFile(convertToList(auctions));
        return auction;
    }

    // Get all active auctions
    public List<Auction> getAllActiveAuctions() throws IOException {
        return getAllAuctions().stream()
                .filter(auction -> !auction.isDeleteStatus())
                .collect(Collectors.toList());
    }

    // Get all auctions including deleted ones (for admin purposes)
    public List<Auction> getAllAuctions() throws IOException {
        File file = new File(AUCTIONS_JSON_FILE);
        if (!file.exists()) {
            return new ArrayList<>();
        }
        return objectMapper.readValue(file, new TypeReference<List<Auction>>() {});
    }

    // Convert list to CustomLinkedList
    private CustomLinkedList<Auction> getAllAuctionsLinkedList() throws IOException {
        CustomLinkedList<Auction> linkedList = new CustomLinkedList<>();
        List<Auction> auctions = getAllAuctions();
        for (Auction auction : auctions) {
            linkedList.add(auction);
        }
        return linkedList;
    }

    // Convert CustomLinkedList to ArrayList
    private List<Auction> convertToList(CustomLinkedList<Auction> linkedList) {
        List<Auction> list = new ArrayList<>();
        for (int i = 0; i < linkedList.size(); i++) {
            list.add(linkedList.get(i));
        }
        return list;
    }

    // Get auction by ID
    public Optional<Auction> getAuctionById(String id) throws IOException {
        return getAllAuctions().stream()
                .filter(auction -> auction.getId().equals(id))
                .findFirst();
    }

    // Update auction
    public Auction updateAuction(String id, Auction updatedAuction) throws IOException {
        List<Auction> auctions = getAllAuctions();
        auctions = auctions.stream()
                .map(auction -> auction.getId().equals(id) ? updatedAuction : auction)
                .collect(Collectors.toList());
        saveAuctionsToFile(auctions);
        return updatedAuction;
    }

    // Soft delete auction (mark as deleted)
    public boolean softDeleteAuction(String id) throws IOException {
        List<Auction> auctions = getAllAuctions();
        Optional<Auction> auctionToDelete = auctions.stream()
                .filter(auction -> auction.getId().equals(id))
                .findFirst();

        if (auctionToDelete.isPresent()) {
            auctionToDelete.get().setDeleteStatus(true);
            saveAuctionsToFile(auctions);
            return true;
        }
        return false;
    }

    // Hard delete auction (remove from file)
    public boolean hardDeleteAuction(String id) throws IOException {
        List<Auction> auctions = getAllAuctions();
        boolean removed = auctions.removeIf(auction -> auction.getId().equals(id));
        if (removed) {
            saveAuctionsToFile(auctions);
        }
        return removed;
    }

    // Search auctions with sorting using MergeSort
    public List<Auction> searchAuctions(String status, String sortBy) throws IOException {
        // Get active auctions that match criteria
        List<Auction> matchingAuctions = getAllActiveAuctions().stream()
                .filter(auction ->
                        (status == null || auction.getStatus().equalsIgnoreCase(status))
                )
                .collect(Collectors.toList());

        // Convert to linked list
        CustomLinkedList<Auction> auctionLinkedList = new CustomLinkedList<>();
        for (Auction auction : matchingAuctions) {
            auctionLinkedList.add(auction);
        }

        // Sort using custom merge sort
        CustomMergeSort<Auction> sorter;
        if (sortBy != null) {
            Comparator<Auction> comparator = getComparatorByCriteria(sortBy);
            sorter = new CustomMergeSort<>(comparator);
        } else {
            // Default sorting by auction date (newest first)
            sorter = new CustomMergeSort<>(Comparator.comparing(Auction::getAuctionDate).reversed());
        }

        sorter.sortLinkedList(auctionLinkedList);

        // Convert back to list
        return convertToList(auctionLinkedList);
    }

    // Get comparator based on sort criteria
    private Comparator<Auction> getComparatorByCriteria(String criteria) {
        switch (criteria.toLowerCase()) {
            case "date_asc":
                return Comparator.comparing(Auction::getAuctionDate);
            case "date_desc":
                return Comparator.comparing(Auction::getAuctionDate).reversed();
            case "price_asc":
                return Comparator.comparing(Auction::getBidStartPrice);
            case "price_desc":
                return Comparator.comparing(Auction::getBidStartPrice).reversed();
            case "status_asc":
                return Comparator.comparing(Auction::getStatus);
            case "status_desc":
                return Comparator.comparing(Auction::getStatus).reversed();
            default:
                return Comparator.comparing(Auction::getAuctionDate).reversed();
        }
    }

    // Check if car is already in an active auction
    public boolean carHasActiveAuction(String carId) throws IOException {
        return getAllActiveAuctions().stream()
                .noneMatch(auction ->
                        auction.getCar().getId().equals(carId) &&
                                !(auction.getStatus().equals("OPEN"))
                );
    }

    // Helper method to save auctions to JSON file
    private void saveAuctionsToFile(List<Auction> auctions) throws IOException {
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(new File(AUCTIONS_JSON_FILE), auctions);
    }

    // Initialize sample data
    public void initializeSampleAuctions() throws IOException {
        if (getAllAuctions().isEmpty()) {
            List<Auction> sampleAuctions = new ArrayList<>();
            List<Car> cars = carService.getAllActiveCars();

            if (!cars.isEmpty()) {
                sampleAuctions.add(new Auction(
                        cars.get(0),
                        15000.00,
                        "OPEN",
                        "2023-12-15"
                ));

                sampleAuctions.add(new Auction(
                        cars.get(1),
                        25000.00,
                        "OPEN",
                        "2023-12-20"
                ));

                sampleAuctions.add(new Auction(
                        cars.get(2),
                        35000.00,
                        "CLOSED",
                        "2023-11-30"
                ));

                saveAuctionsToFile(sampleAuctions);
            }
        }
    }
}