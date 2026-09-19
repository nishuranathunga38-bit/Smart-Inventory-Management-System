package com.inventory.dao;

import com.inventory.config.DBConnection;
import com.inventory.model.Sale;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {
    
    // නිවැරදි කරන ලද ඩේටාබේස් කනෙක්ෂන් එක (DBConnection පාවිච්චි කර ඇත)
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // 1. אලුත් විකුණුමක් ඇතුළත් කිරීම සහ Stock එක අඩු කිරීම
    public boolean recordSale(Sale sale) {
        String insertSaleSQL = "INSERT INTO sales (product_id, quantity, total_price) VALUES (?, ?, ?)";
        String updateStockSQL = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Transactions ආරම්භ කිරීම

            // විකුණුම ඇතුළත් කිරීම
            try (PreparedStatement psSale = conn.prepareStatement(insertSaleSQL)) {
                psSale.setInt(1, sale.getProductId());
                psSale.setInt(2, sale.getQuantity());
                psSale.setDouble(3, sale.getTotalPrice());
                psSale.executeUpdate();
            }

            // තොගය අඩු කිරීම
            try (PreparedStatement psStock = conn.prepareStatement(updateStockSQL)) {
                psStock.setInt(1, sale.getQuantity());
                psStock.setInt(2, sale.getProductId());
                int rowsAffected = psStock.executeUpdate();
                
                if (rowsAffected == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit(); // ඔක්කොම හරි නම් Database එකට Save කරනවා
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. සිදුකල සියලුම විකුණුම් ලැයිස්තුව ලබාගැනීම
    public List<Sale> getAllSales() {
        List<Sale> salesList = new ArrayList<>();
        String sql = "SELECT s.*, p.name AS product_name FROM sales s JOIN products p ON s.product_id = p.id ORDER BY s.sale_date DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Sale sale = new Sale();
                sale.setId(rs.getInt("id"));
                sale.setProductId(rs.getInt("product_id"));
                sale.setProductName(rs.getString("product_name"));
                sale.setQuantity(rs.getInt("quantity"));
                sale.setTotalPrice(rs.getDouble("total_price"));
                sale.setSaleDate(rs.getTimestamp("sale_date"));
                salesList.add(sale);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return salesList;
    }
}