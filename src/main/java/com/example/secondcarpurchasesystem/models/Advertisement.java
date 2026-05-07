package com.example.secondcarpurchasesystem.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Advertisement {
    private String id;
    private String title;
    private String description;
    private String imageUrl;
    private boolean deleteStatus;

    // Constructors
    public Advertisement() {
        this.id = generateId();
        this.deleteStatus = false;
    }

    public Advertisement(String title, String description, String imageUrl) {
        this.id = generateId();
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.deleteStatus = false;
    }

    // Helper method to generate ID
    private String generateId() {
        return "ADV-" + System.currentTimeMillis();
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isDeleteStatus() {
        return deleteStatus;
    }

    public void setDeleteStatus(boolean deleteStatus) {
        this.deleteStatus = deleteStatus;
    }

    @Override
    public String toString() {
        return "Advertisement{" +
                "id='" + id + '\'' +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", deleteStatus=" + deleteStatus +
                '}';
    }
}