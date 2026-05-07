package com.example.secondcarpurchasesystem.controllers;

import com.example.secondcarpurchasesystem.dto.LoginDTO;
import com.example.secondcarpurchasesystem.models.User;
import com.example.secondcarpurchasesystem.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Register a new user
    @PostMapping("/register")
    public ResponseEntity<User> registerUser(@RequestBody User user) {
        try {
            userService.createUser(user);
            return ResponseEntity.ok(user);
        } catch (IOException e) {
            return ResponseEntity.status(500).build();
        }
    }



    // User login
    @PostMapping("/login")
    public ResponseEntity<User> loginUser(@RequestBody LoginDTO body) {
        try {

            Optional<User> user = userService.login(body.getEmail(), body.getPassword());
            return user.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.status(401).build());
        } catch (IOException e) {
            return ResponseEntity.status(500).build();
        }
    }

    // Get all users
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        try {
            return ResponseEntity.ok(userService.getAllUsers());
        } catch (IOException e) {
            return ResponseEntity.status(500).build();
        }
    }

    // Get user by email
    @GetMapping("/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        try {
            Optional<User> user = userService.getUserByEmail(email);
            return user.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IOException e) {
            return ResponseEntity.status(500).build();
        }
    }

    // Update user
    @PutMapping("/{email}")
    public ResponseEntity<String> updateUser(@PathVariable String email, @RequestBody User updatedUser) {
        try {
            Optional<User> existingUser = userService.getUserByEmail(email);
            if (existingUser.isEmpty()) {
                return ResponseEntity.notFound().build();
            }
            userService.updateUser(email, updatedUser);
            return ResponseEntity.ok("User updated successfully");
        } catch (IOException e) {
            return ResponseEntity.status(500).body("Error updating user");
        }
    }

    // Delete user
    @DeleteMapping("/{email}")
    public ResponseEntity<String> deleteUser(@PathVariable String email) {
        try {
            Optional<User> user = userService.getUserByEmail(email);
            if (user.isEmpty()) {
                return ResponseEntity.notFound().build();
            }
            userService.deleteUser(email);
            return ResponseEntity.ok("User deleted successfully");
        } catch (IOException e) {
            return ResponseEntity.status(500).body("Error deleting user");
        }
    }
}