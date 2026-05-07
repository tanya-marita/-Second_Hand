package com.example.secondcarpurchasesystem.services;

import com.example.secondcarpurchasesystem.models.Bid;
import com.example.secondcarpurchasesystem.datastructures.CustomLinkedList;
import com.example.secondcarpurchasesystem.datastructures.CustomMergeSort;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class BidService {
    private static final String BIDS_JSON_FILE = "C:\\Users\\ghdha\\IdeaProjects\\SecondCarPurchaseSystem\\SecondCarPurchaseSystem\\bids.json";
    private final ObjectMapper objectMapper = new ObjectMapper();

    // Create a new bid and update statuses of other bids
    public Bid createBid(Bid bid) throws IOException {
        List<Bid> bids = getAllBids();

        // Update statuses of existing bids for this auction
        List<Bid> auctionBids = bids.stream()
                .filter(b -> b.getAuctionId().equals(bid.getAuctionId()))
                .collect(Collectors.toList());

        for (Bid existingBid : auctionBids) {
            if (existingBid.getBidAmount() < bid.getBidAmount()) {
                existingBid.setStatus(Bid.STATUS_OUTBID);
            } else if (existingBid.getUserEmail().equals(bid.getUserEmail())) {
                existingBid.setStatus(Bid.STATUS_ACTIVE);
            }
        }

        // Add the new bid
        bid.setStatus(Bid.STATUS_WINNING); // Initially set as winning
        bids.add(bid);

        saveBidsToFile(bids);
        return bid;
    }

    // Update bid statuses when auction closes
    public void updateBidStatusesForClosedAuction(String auctionId, String winningBidId) throws IOException {
        List<Bid> bids = getAllBids();

        for (Bid bid : bids) {
            if (bid.getAuctionId().equals(auctionId)) {
                if (bid.getId().equals(winningBidId)) {
                    bid.setStatus(Bid.STATUS_WINNING);
                } else {
                    bid.setStatus(Bid.STATUS_LOST);
                }
            }
        }

        saveBidsToFile(bids);
    }

    // Get all bids (excluding deleted ones)
    public List<Bid> getAllActiveBids() throws IOException {
        return getAllBids().stream()
                .filter(bid -> !bid.isDeleteStatus())
                .collect(Collectors.toList());
    }

    // Get all bids including deleted ones (for admin purposes)
    public List<Bid> getAllBids() throws IOException {
        File file = new File(BIDS_JSON_FILE);
        if (!file.exists()) {
            return new ArrayList<>();
        }
        return objectMapper.readValue(file, new TypeReference<List<Bid>>() {});
    }

    // Get bids by auction ID
    public List<Bid> getBidsByAuctionId(String auctionId) throws IOException {
        return getAllActiveBids().stream()
                .filter(bid -> bid.getAuctionId().equals(auctionId))
                .collect(Collectors.toList());
    }

    // Get bids by user email
    public List<Bid> getBidsByUserEmail(String userEmail) throws IOException {
        return getAllActiveBids().stream()
                .filter(bid -> bid.getUserEmail().equals(userEmail))
                .collect(Collectors.toList());
    }

    // Get highest bid for an auction
    public Optional<Bid> getHighestBidForAuction(String auctionId) throws IOException {
        return getBidsByAuctionId(auctionId).stream()
                .max(Comparator.comparingDouble(Bid::getBidAmount));
    }

    // Convert list to CustomLinkedList
    private CustomLinkedList<Bid> getAllBidsLinkedList() throws IOException {
        CustomLinkedList<Bid> linkedList = new CustomLinkedList<>();
        List<Bid> bids = getAllBids();
        for (Bid bid : bids) {
            linkedList.add(bid);
        }
        return linkedList;
    }

    // Convert CustomLinkedList to ArrayList
    private List<Bid> convertToList(CustomLinkedList<Bid> linkedList) {
        List<Bid> list = new ArrayList<>();
        for (int i = 0; i < linkedList.size(); i++) {
            list.add(linkedList.get(i));
        }
        return list;
    }

    // Get bid by ID
    public Optional<Bid> getBidById(String id) throws IOException {
        return getAllBids().stream()
                .filter(bid -> bid.getId().equals(id))
                .findFirst();
    }

    // Update bid
    public Bid updateBid(String id, Bid updatedBid) throws IOException {
        List<Bid> bids = getAllBids();
        bids = bids.stream()
                .map(bid -> bid.getId().equals(id) ? updatedBid : bid)
                .collect(Collectors.toList());
        saveBidsToFile(bids);
        return updatedBid;
    }

    // Soft delete bid (mark as deleted)
    public boolean softDeleteBid(String id) throws IOException {
        List<Bid> bids = getAllBids();
        Optional<Bid> bidToDelete = bids.stream()
                .filter(bid -> bid.getId().equals(id))
                .findFirst();

        if (bidToDelete.isPresent()) {
            bidToDelete.get().setDeleteStatus(true);
            saveBidsToFile(bids);
            return true;
        }
        return false;
    }

    // Hard delete bid (remove from file)
    public boolean hardDeleteBid(String id) throws IOException {
        List<Bid> bids = getAllBids();
        boolean removed = bids.removeIf(bid -> bid.getId().equals(id));
        if (removed) {
            saveBidsToFile(bids);
        }
        return removed;
    }

    // Search bids with sorting using MergeSort
    public List<Bid> searchBids(String auctionId, String userEmail, String status, String sortBy) throws IOException {
        // Get active bids that match criteria
        List<Bid> matchingBids = getAllActiveBids().stream()
                .filter(bid ->
                        (auctionId == null || bid.getAuctionId().equals(auctionId)) &&
                                (userEmail == null || bid.getUserEmail().equals(userEmail)) &&
                                (status == null || bid.getStatus().equals(status))
                )
                .collect(Collectors.toList());

        // Convert to linked list
        CustomLinkedList<Bid> bidLinkedList = new CustomLinkedList<>();
        for (Bid bid : matchingBids) {
            bidLinkedList.add(bid);
        }

        // Sort using custom merge sort
        CustomMergeSort<Bid> sorter;
        if (sortBy != null) {
            Comparator<Bid> comparator = getComparatorByCriteria(sortBy);
            sorter = new CustomMergeSort<>(comparator);
        } else {
            // Default sorting by bid amount (highest first)
            sorter = new CustomMergeSort<>(Comparator.comparing(Bid::getBidAmount).reversed());
        }

        sorter.sortLinkedList(bidLinkedList);

        // Convert back to list
        return convertToList(bidLinkedList);
    }

    // Get comparator based on sort criteria
    private Comparator<Bid> getComparatorByCriteria(String criteria) {
        switch (criteria.toLowerCase()) {
            case "amount_asc":
                return Comparator.comparing(Bid::getBidAmount);
            case "amount_desc":
                return Comparator.comparing(Bid::getBidAmount).reversed();
            case "date_asc":
                return Comparator.comparing(Bid::getBiddedAt);
            case "date_desc":
                return Comparator.comparing(Bid::getBiddedAt).reversed();
            case "status_asc":
                return Comparator.comparing(Bid::getStatus);
            case "status_desc":
                return Comparator.comparing(Bid::getStatus).reversed();
            default:
                return Comparator.comparing(Bid::getBidAmount).reversed();
        }
    }

    // Helper method to save bids to JSON file
    private void saveBidsToFile(List<Bid> bids) throws IOException {
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(new File(BIDS_JSON_FILE), bids);
    }

    // Initialize sample data
    public void initializeSampleBids() throws IOException {
        if (getAllBids().isEmpty()) {
            List<Bid> sampleBids = new ArrayList<>();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

            sampleBids.add(new Bid(
                    "user1@example.com",
                    "AUCTION-1",
                    LocalDateTime.now().minusHours(2).format(formatter),
                    15500.00
            ));

            sampleBids.add(new Bid(
                    "user2@example.com",
                    "AUCTION-1",
                    LocalDateTime.now().minusHours(1).format(formatter),
                    16000.00
            ));

            sampleBids.add(new Bid(
                    "user3@example.com",
                    "AUCTION-2",
                    LocalDateTime.now().minusDays(1).format(formatter),
                    26000.00
            ));

            // Set initial statuses
            sampleBids.get(0).setStatus(Bid.STATUS_OUTBID);
            sampleBids.get(1).setStatus(Bid.STATUS_WINNING);
            sampleBids.get(2).setStatus(Bid.STATUS_ACTIVE);

            saveBidsToFile(sampleBids);
        }
    }
}