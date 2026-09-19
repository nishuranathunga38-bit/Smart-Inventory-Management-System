package com.inventory.dao;

import com.inventory.config.DBConnection;
import com.inventory.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // 1. සියලුම භාණ්ඩ ලබා ගැනීම
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(new Product(
                    rs.getInt("id"), rs.getString("name"), rs.getString("category"),
                    rs.getDouble("price"), rs.getInt("stock_quantity"),
                    rs.getInt("min_stock_level"), rs.getDate("expiry_date")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return products;
    }

    // 2. භාණ්ඩයක් ඇතුළත් කිරීම
    public boolean addProduct(Product product) {
        String query = "INSERT INTO products (name, category, price, stock_quantity, min_stock_level, expiry_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getCategory());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getMinStockLevel());
            if (product.getExpiryDate() != null) ps.setDate(6, new java.sql.Date(product.getExpiryDate().getTime()));
            else ps.setNull(6, Types.DATE);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 3. ID එක මගින් භාණ්ඩයක් සෙවීම (Edit සඳහා අවශ්‍යයි)
    public Product getProductById(int id) {
        String query = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Product(rs.getInt("id"), rs.getString("name"), rs.getString("category"),
                            rs.getDouble("price"), rs.getInt("stock_quantity"),
                            rs.getInt("min_stock_level"), rs.getDate("expiry_date"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. භාණ්ඩයක් Delete කිරීම
    public boolean deleteProduct(int id) {
        String query = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 5. භාණ්ඩයක් Update කිරීම
    public boolean updateProduct(Product product) {
        String query = "UPDATE products SET name=?, category=?, price=?, stock_quantity=?, min_stock_level=?, expiry_date=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getCategory());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getMinStockLevel());
            if (product.getExpiryDate() != null) ps.setDate(6, new java.sql.Date(product.getExpiryDate().getTime()));
            else ps.setNull(6, Types.DATE);
            ps.setInt(7, product.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}