package com.example.secondcarpurchasesystem.models;

public class AdminUser extends User {
    private String adminId;
    private String permissions;

    public AdminUser() {
        super();
        setRole("ADMIN");
    }

    public AdminUser(String firstName, String lastName, String address, String email, String password, String adminId, String permissions) {
        super(firstName, lastName, address, email, password, "ADMIN");
        this.adminId = adminId;
        this.permissions = permissions;
    }


    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getPermissions() {
        return permissions;
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions;
    }

    @Override
    public String getDashboardUrl() {
        return "/admin/dashboard";
    }
}