package com.example.secondcarpurchasesystem.services;

import com.example.secondcarpurchasesystem.models.Advertisement;
import com.example.secondcarpurchasesystem.datastructures.CustomLinkedList;
import com.example.secondcarpurchasesystem.datastructures.CustomMergeSort;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

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

@Service
public class AdvertisementService {
    private final ObjectMapper objectMapper = new ObjectMapper();
    private static final String ADS_JSON_FILE = "C:\\Users\\ghdha\\IdeaProjects\\SecondCarPurchaseSystem\\SecondCarPurchaseSystem\\ads.json";

    // Create a new advertisement
    public Advertisement createAdvertisement(Advertisement advertisement) throws IOException {
        CustomLinkedList<Advertisement> ads = getAllAdsLinkedList();
        ads.add(advertisement);
        saveAdsToFile(convertToList(ads));
        return advertisement;
    }

    // Get all active advertisements
    public List<Advertisement> getAllActiveAds() throws IOException {
        return getAllAds().stream()
                .filter(ad -> !ad.isDeleteStatus())
                .collect(Collectors.toList());
    }

    // Get all advertisements including deleted ones (for admin purposes)
    public List<Advertisement> getAllAds() throws IOException {
        File file = new File(ADS_JSON_FILE);
        if (!file.exists()) {
            return new ArrayList<>();
        }
        return objectMapper.readValue(file, new TypeReference<List<Advertisement>>() {});
    }

    // Convert list to CustomLinkedList
    private CustomLinkedList<Advertisement> getAllAdsLinkedList() throws IOException {
        CustomLinkedList<Advertisement> linkedList = new CustomLinkedList<>();
        List<Advertisement> ads = getAllAds();
        for (Advertisement ad : ads) {
            linkedList.add(ad);
        }
        return linkedList;
    }

    // Convert CustomLinkedList to ArrayList
    private List<Advertisement> convertToList(CustomLinkedList<Advertisement> linkedList) {
        List<Advertisement> list = new ArrayList<>();
        for (int i = 0; i < linkedList.size(); i++) {
            list.add(linkedList.get(i));
        }
        return list;
    }

    // Get advertisement by ID
    public Optional<Advertisement> getAdById(String id) throws IOException {
        return getAllAds().stream()
                .filter(ad -> ad.getId().equals(id))
                .findFirst();
    }

    // Update advertisement
    public Advertisement updateAd(String id, Advertisement updatedAd) throws IOException {
        List<Advertisement> ads = getAllAds();
        ads = ads.stream()
                .map(ad -> ad.getId().equals(id) ? updatedAd : ad)
                .collect(Collectors.toList());
        saveAdsToFile(ads);
        return updatedAd;
    }

    // Soft delete advertisement (mark as deleted)
    public boolean softDeleteAd(String id) throws IOException {
        List<Advertisement> ads = getAllAds();
        Optional<Advertisement> adToDelete = ads.stream()
                .filter(ad -> ad.getId().equals(id))
                .findFirst();

        if (adToDelete.isPresent()) {
            adToDelete.get().setDeleteStatus(true);
            saveAdsToFile(ads);
            return true;
        }
        return false;
    }

    // Hard delete advertisement (remove from file)
    public boolean hardDeleteAd(String id) throws IOException {
        List<Advertisement> ads = getAllAds();
        boolean removed = ads.removeIf(ad -> ad.getId().equals(id));
        if (removed) {
            saveAdsToFile(ads);
        }
        return removed;
    }

    // Search advertisements with sorting using MergeSort
    public List<Advertisement> searchAds(String title, String sortBy) throws IOException {
        // Get active ads that match criteria
        List<Advertisement> matchingAds = getAllActiveAds().stream()
                .filter(ad ->
                        (title == null || ad.getTitle().toLowerCase().contains(title.toLowerCase()))
                )
                .collect(Collectors.toList());

        // Convert to linked list
        CustomLinkedList<Advertisement> adLinkedList = new CustomLinkedList<>();
        for (Advertisement ad : matchingAds) {
            adLinkedList.add(ad);
        }

        // Sort using custom merge sort
        CustomMergeSort<Advertisement> sorter;
        if (sortBy != null) {
            Comparator<Advertisement> comparator = getComparatorByCriteria(sortBy);
            sorter = new CustomMergeSort<>(comparator);
        } else {
            // Default sorting by title (A-Z)
            sorter = new CustomMergeSort<>(Comparator.comparing(Advertisement::getTitle));
        }

        sorter.sortLinkedList(adLinkedList);

        // Convert back to list
        return convertToList(adLinkedList);
    }

    // Get comparator based on sort criteria
    private Comparator<Advertisement> getComparatorByCriteria(String criteria) {
        switch (criteria.toLowerCase()) {
            case "title_asc":
                return Comparator.comparing(Advertisement::getTitle);
            case "title_desc":
                return Comparator.comparing(Advertisement::getTitle).reversed();
            case "date_asc":  // Assuming you might add creation date later
                return Comparator.comparing(Advertisement::getId); // Using ID as proxy for creation date
            case "date_desc":
                return Comparator.comparing(Advertisement::getId).reversed();
            default:
                return Comparator.comparing(Advertisement::getTitle);
        }
    }

    // Check if title exists
    public boolean titleExists(String title) throws IOException {
        return getAllAds().stream()
                .anyMatch(ad -> ad.getTitle().equalsIgnoreCase(title));
    }

    // Helper method to save ads to JSON file
    private void saveAdsToFile(List<Advertisement> ads) throws IOException {
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(new File(ADS_JSON_FILE), ads);
    }

    // Initialize sample data
    public void initializeSampleAds() throws IOException {
        if (getAllAds().isEmpty()) {
            List<Advertisement> sampleAds = new ArrayList<>();

            sampleAds.add(new Advertisement(
                    "Summer Car Sale",
                    "Huge discounts on all models this summer! Limited time offer.",
                    "/uploads/summer-sale.jpg"
            ));

            sampleAds.add(new Advertisement(
                    "New Electric Vehicles",
                    "Check out our latest lineup of eco-friendly electric vehicles.",
                    "/uploads/ev-showcase.jpg"
            ));

            sampleAds.add(new Advertisement(
                    "Winter Maintenance Special",
                    "Get your car ready for winter with our special maintenance package.",
                    "/uploads/winter-maintenance.jpg"
            ));

            saveAdsToFile(sampleAds);
        }
    }
}