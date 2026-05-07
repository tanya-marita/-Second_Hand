package com.example.secondcarpurchasesystem.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Auction {
    private String id;
    private Car car;
    private double bidStartPrice;
    private String status; // "OPEN" or "CLOSED"
    private String auctionDate;
    private boolean deleteStatus;

    // Constructors
    public Auction() {
        this.id = generateId();
        this.deleteStatus = false;
    }

    public Auction(Car car, double bidStartPrice, String status, String auctionDate) {
        this.id = generateId();
        this.car = car;
        this.bidStartPrice = bidStartPrice;
        this.status = status;
        this.auctionDate = auctionDate;
        this.deleteStatus = false;
    }

    // Helper method to generate ID
    private String generateId() {
        return "AUCTION-" + System.currentTimeMillis();
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public double getBidStartPrice() {
        return bidStartPrice;
    }

    public void setBidStartPrice(double bidStartPrice) {
        this.bidStartPrice = bidStartPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAuctionDate() {
        return auctionDate;
    }

    public void setAuctionDate(String auctionDate) {
        this.auctionDate = auctionDate;
    }

    public boolean isDeleteStatus() {
        return deleteStatus;
    }

    public void setDeleteStatus(boolean deleteStatus) {
        this.deleteStatus = deleteStatus;
    }

    @Override
    public String toString() {
        return "Auction{" +
                "id='" + id + '\'' +
                ", car=" + car +
                ", bidStartPrice=" + bidStartPrice +
                ", status='" + status + '\'' +
                ", auctionDate='" + auctionDate + '\'' +
                ", deleteStatus=" + deleteStatus +
                '}';
    }
}