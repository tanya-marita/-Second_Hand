package com.example.secondcarpurchasesystem.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Car {
    private String id;
    private String engineNumber;
    private String chassisNumber;
    private int manufacturedYear;
    private String brand;
    private String manufacturedCountry;
    private String registrationNumber;
    private boolean deleteStatus;
    private String imageUrl;

    // Constructors
    public Car() {
        this.id = generateId();
        this.deleteStatus = false;
    }

    public Car(String engineNumber, String chassisNumber, int manufacturedYear,
               String brand, String manufacturedCountry, String registrationNumber,
               String imageUrl) {
        this.id = generateId();
        this.engineNumber = engineNumber;
        this.chassisNumber = chassisNumber;
        this.manufacturedYear = manufacturedYear;
        this.brand = brand;
        this.manufacturedCountry = manufacturedCountry;
        this.registrationNumber = registrationNumber;
        this.imageUrl = imageUrl;
        this.deleteStatus = false;
    }

    // Helper method to generate ID
    private String generateId() {
        return "CAR-" + System.currentTimeMillis();
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEngineNumber() {
        return engineNumber;
    }

    public void setEngineNumber(String engineNumber) {
        this.engineNumber = engineNumber;
    }

    public String getChassisNumber() {
        return chassisNumber;
    }

    public void setChassisNumber(String chassisNumber) {
        this.chassisNumber = chassisNumber;
    }

    public int getManufacturedYear() {
        return manufacturedYear;
    }

    public void setManufacturedYear(int manufacturedYear) {
        this.manufacturedYear = manufacturedYear;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getManufacturedCountry() {
        return manufacturedCountry;
    }

    public void setManufacturedCountry(String manufacturedCountry) {
        this.manufacturedCountry = manufacturedCountry;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public boolean isDeleteStatus() {
        return deleteStatus;
    }

    public void setDeleteStatus(boolean deleteStatus) {
        this.deleteStatus = deleteStatus;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Car{" +
                "id='" + id + '\'' +
                ", engineNumber='" + engineNumber + '\'' +
                ", chassisNumber='" + chassisNumber + '\'' +
                ", manufacturedYear=" + manufacturedYear +
                ", brand='" + brand + '\'' +
                ", manufacturedCountry='" + manufacturedCountry + '\'' +
                ", registrationNumber='" + registrationNumber + '\'' +
                ", deleteStatus=" + deleteStatus +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}