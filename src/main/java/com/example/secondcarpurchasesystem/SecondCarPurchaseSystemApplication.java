package com.example.secondcarpurchasesystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;


@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class SecondCarPurchaseSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(SecondCarPurchaseSystemApplication.class, args);
    }

}
