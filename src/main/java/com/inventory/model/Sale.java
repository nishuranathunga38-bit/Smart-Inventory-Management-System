package com.inventory.model;

import java.util.Date;

public class Sale {
    private int id;
    private int productId;
    private String productName; // UI එකේ පෙන්වීමට පහසු වීමට
    private int quantity;
    private double totalPrice;
    private Date saleDate;

    // Constructors
    public Sale() {}

    public Sale(int productId, int quantity, double totalPrice) {
        this.productId = productId;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public Date getSaleDate() { return saleDate; }
    public void setSaleDate(Date saleDate) { this.saleDate = saleDate; }
}