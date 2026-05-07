package com.example.secondcarpurchasesystem.models;

public class RegularUser extends User {
    private String drivingLicenseNumber;
    private String phoneNumber;

    public RegularUser() {
        super();
        setRole("USER");
    }

    public RegularUser(String firstName, String lastName, String address, String email, String password, String drivingLicenseNumber, String phoneNumber) {
        super(firstName, lastName, address, email, password, "USER");
        this.drivingLicenseNumber = drivingLicenseNumber;
        this.phoneNumber = phoneNumber;
    }


    public String getDrivingLicenseNumber() {
        return drivingLicenseNumber;
    }

    public void setDrivingLicenseNumber(String drivingLicenseNumber) {
        this.drivingLicenseNumber = drivingLicenseNumber;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public String getDashboardUrl() {
        return "/user/dashboard";
    }
}