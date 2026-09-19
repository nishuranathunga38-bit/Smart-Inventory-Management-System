package com.inventory.model;

import java.util.Date;

public class Product {
    private int id;
    private String name;
    private String category;
    private double price;
    private int stockQuantity;
    private int minStockLevel;
    private Date expiryDate;

    // Constructor
    public Product(int id, String name, String category, double price, int stockQuantity, int minStockLevel, Date expiryDate) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.minStockLevel = minStockLevel;
        this.expiryDate = expiryDate;
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public double getPrice() { return price; }
    public int getStockQuantity() { return stockQuantity; }
    public int getMinStockLevel() { return minStockLevel; }
    public Date getExpiryDate() { return expiryDate; }
}