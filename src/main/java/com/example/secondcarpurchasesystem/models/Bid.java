package com.example.secondcarpurchasesystem.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Bid {
    private String id;
    private String userEmail;
    private String auctionId;
    private String biddedAt;
    private double bidAmount;
    private String status; // "ACTIVE", "OUTBID", "WINNING", "LOST"
    private boolean deleteStatus;

    // Status constants
    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_OUTBID = "OUTBID";
    public static final String STATUS_WINNING = "WINNING";
    public static final String STATUS_LOST = "LOST";

    // Constructors
    public Bid() {
        this.id = generateId();
        this.status = STATUS_ACTIVE;
        this.deleteStatus = false;
    }

    public Bid(String userEmail, String auctionId, String biddedAt, double bidAmount) {
        this();
        this.userEmail = userEmail;
        this.auctionId = auctionId;
        this.biddedAt = biddedAt;
        this.bidAmount = bidAmount;
    }

    // Helper method to generate ID
    private String generateId() {
        return "BID-" + System.currentTimeMillis() + "-" + (int)(Math.random() * 1000);
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(String auctionId) {
        this.auctionId = auctionId;
    }

    public String getBiddedAt() {
        return biddedAt;
    }

    public void setBiddedAt(String biddedAt) {
        this.biddedAt = biddedAt;
    }

    public double getBidAmount() {
        return bidAmount;
    }

    public void setBidAmount(double bidAmount) {
        this.bidAmount = bidAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isDeleteStatus() {
        return deleteStatus;
    }

    public void setDeleteStatus(boolean deleteStatus) {
        this.deleteStatus = deleteStatus;
    }

    @Override
    public String toString() {
        return "Bid{" +
                "id='" + id + '\'' +
                ", userEmail='" + userEmail + '\'' +
                ", auctionId='" + auctionId + '\'' +
                ", biddedAt='" + biddedAt + '\'' +
                ", bidAmount=" + bidAmount +
                ", status='" + status + '\'' +
                ", deleteStatus=" + deleteStatus +
                '}';
    }
}