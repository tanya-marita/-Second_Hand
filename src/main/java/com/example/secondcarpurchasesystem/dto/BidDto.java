package com.example.secondcarpurchasesystem.dto;

import com.example.secondcarpurchasesystem.models.Auction;
import com.example.secondcarpurchasesystem.models.Car;
import com.example.secondcarpurchasesystem.models.User;

public class BidDto {
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Auction getAuction() {
        return auction;
    }

    public void setAuction(Auction auction) {
        this.auction = auction;
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

    private String id;
    private User user;

    private Auction auction;

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    private Car car;

    private double bidAmount;

    private String status;

}