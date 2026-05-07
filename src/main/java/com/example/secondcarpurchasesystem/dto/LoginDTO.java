package com.example.secondcarpurchasesystem.dto;

public class LoginDTO {
    private String email;
    private String password;

    public String getEmail() {
        return email;
    }
    //setter of email
    public void setEmail(String email) {
        this.email = email;

    }

    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }

    public LoginDTO() {
    }
    
}