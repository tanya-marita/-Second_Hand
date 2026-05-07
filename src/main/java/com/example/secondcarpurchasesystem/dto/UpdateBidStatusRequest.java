package com.example.secondcarpurchasesystem.dto;

public class UpdateBidStatusRequest {
    private String auctionId;
    private String winningBidId;

    // Getters and Setters
    public String getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(String auctionId) {
        this.auctionId = auctionId;
    }

    public String getWinningBidId() {
        return winningBidId;
    }

    public void setWinningBidId(String winningBidId) {
        this.winningBidId = winningBidId;
    }
}