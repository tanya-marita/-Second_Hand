package com.example.secondcarpurchasesystem.services;

import com.example.secondcarpurchasesystem.models.AdminUser;
import com.example.secondcarpurchasesystem.models.RegularUser;
import com.example.secondcarpurchasesystem.models.User;
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
public class UserService {
    private static final String USERS_JSON_FILE = "C:\\Users\\ghdha\\IdeaProjects\\SecondCarPurchaseSystem\\SecondCarPurchaseSystem\\users.json";
    private final ObjectMapper objectMapper = new ObjectMapper();

    // Create a new user
    public void createUser(User user) throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        users.add(user);
        saveUsersToFile(convertToList(users));
    }

    // Read all users
    public List<User> getAllUsers() throws IOException {
        try {
            File file = new File(USERS_JSON_FILE);
            if (!file.exists()) {
                return new ArrayList<>();
            }
            return objectMapper.readValue(file, new TypeReference<List<User>>() {});
        } catch (Exception e) {
            System.out.println(e);
            return new ArrayList<>();
        }
    }

    // Convert regular list to CustomLinkedList
    private CustomLinkedList<User> getAllUsersLinkedList() throws IOException {
        CustomLinkedList<User> linkedList = new CustomLinkedList<>();
        List<User> users = getAllUsers();
        for (User user : users) {
            linkedList.add(user);
        }
        return linkedList;
    }

    // Convert CustomLinkedList back to ArrayList
    private List<User> convertToList(CustomLinkedList<User> linkedList) {
        List<User> list = new ArrayList<>();
        for (int i = 0; i < linkedList.size(); i++) {
            list.add(linkedList.get(i));
        }
        return list;
    }

    // Get user by email
    public Optional<User> getUserByEmail(String email) throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getEmail().equalsIgnoreCase(email)) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    // Update user
    public void updateUser(String email, User updatedUser) throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        List<User> updatedUsers = new ArrayList<>();

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getEmail().equalsIgnoreCase(email)) {
                updatedUsers.add(updatedUser);
            } else {
                updatedUsers.add(user);
            }
        }

        saveUsersToFile(updatedUsers);
    }

    // Delete user
    public void deleteUser(String email) throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        CustomLinkedList<User> filteredUsers = new CustomLinkedList<>();

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (!user.getEmail().equalsIgnoreCase(email)) {
                filteredUsers.add(user);
            }
        }

        saveUsersToFile(convertToList(filteredUsers));
    }

    // Login method
    public Optional<User> login(String email, String password) throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getEmail().equalsIgnoreCase(email) && user.getPassword().equals(password)) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    // Get sorted users by specified criteria
    public List<User> getSortedUsers(String sortBy) throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        CustomMergeSort<User> sorter;

        if (sortBy != null) {
            Comparator<User> comparator = getComparatorByCriteria(sortBy);
            sorter = new CustomMergeSort<>(comparator);
        } else {
            // Default sort by last name
            sorter = new CustomMergeSort<>(Comparator.comparing(User::getLastName));
        }

        sorter.sortLinkedList(users);
        return convertToList(users);
    }

    // Get comparator based on sort criteria
    private Comparator<User> getComparatorByCriteria(String criteria) {
        switch (criteria.toLowerCase()) {
            case "first_name":
                return Comparator.comparing(User::getFirstName);
            case "last_name":
                return Comparator.comparing(User::getLastName);
            case "email":
                return Comparator.comparing(User::getEmail);
            case "address":
                return Comparator.comparing(User::getAddress);
            case "user_type":
                return Comparator.comparing(user -> user.getClass().getSimpleName());
            default:
                return Comparator.comparing(User::getLastName);
        }
    }

    // Search users by name (first or last)
    public List<User> searchUsersByName(String name) throws IOException {
        if (name == null || name.trim().isEmpty()) {
            return getAllUsers();
        }

        String lowerCaseName = name.toLowerCase();
        CustomLinkedList<User> users = getAllUsersLinkedList();
        CustomLinkedList<User> matchingUsers = new CustomLinkedList<>();

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getFirstName().toLowerCase().contains(lowerCaseName) ||
                    user.getLastName().toLowerCase().contains(lowerCaseName)) {
                matchingUsers.add(user);
            }
        }

        // Sort matching users by last name
        CustomMergeSort<User> sorter = new CustomMergeSort<>(Comparator.comparing(User::getLastName));
        sorter.sortLinkedList(matchingUsers);

        return convertToList(matchingUsers);
    }

    // Get all admin users
    public List<User> getAllAdminUsers() throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        CustomLinkedList<User> adminUsers = new CustomLinkedList<>();

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user instanceof AdminUser) {
                adminUsers.add(user);
            }
        }

        return convertToList(adminUsers);
    }

    // Get all regular users
    public List<User> getAllRegularUsers() throws IOException {
        CustomLinkedList<User> users = getAllUsersLinkedList();
        CustomLinkedList<User> regularUsers = new CustomLinkedList<>();

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user instanceof RegularUser) {
                regularUsers.add(user);
            }
        }

        return convertToList(regularUsers);
    }

    // Helper method to save users to JSON file
    private void saveUsersToFile(List<User> users) throws IOException {
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(new File(USERS_JSON_FILE), users);
    }

    // Create sample users (for testing)
    public void initializeSampleUsers() throws IOException {
        if (getAllUsers().isEmpty()) {
            CustomLinkedList<User> sampleUsers = new CustomLinkedList<>();

            sampleUsers.add(new AdminUser(
                    "Admin",
                    "User",
                    "123 Admin St",
                    "admin@secondcar.com",
                    "admin123",
                    "ADM001",
                    "ALL"
            ));

            sampleUsers.add(new RegularUser(
                    "John",
                    "Doe",
                    "456 Main St",
                    "john@example.com",
                    "password123",
                    "DL12345678",
                    "555-123-4567"
            ));

            sampleUsers.add(new RegularUser(
                    "Jane",
                    "Smith",
                    "789 Oak Ave",
                    "jane@example.com",
                    "pass456",
                    "DL87654321",
                    "555-987-6543"
            ));

            sampleUsers.add(new AdminUser(
                    "Sarah",
                    "Johnson",
                    "321 Pine Rd",
                    "sarah@secondcar.com",
                    "admin456",
                    "ADM002",
                    "USERS"
            ));

            saveUsersToFile(convertToList(sampleUsers));
        }
    }
}