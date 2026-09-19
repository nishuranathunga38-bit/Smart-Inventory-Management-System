package com.inventory.dao;

import com.inventory.config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AIEngine {

    // AI Feature 1: Smart Restock Prediction & Quantity
    public String predictRestock(int productId) {
        String suggestion = "";
        try (Connection conn = DBConnection.getConnection()) {
            
            // පසුගිය දින 30 තුල දෛනික සාමාන්‍ය විකුණුම් ප්‍රමාණය සෙවීම
            String query = "SELECT AVG(quantity_sold) as avg_sales FROM sales WHERE product_id = ? AND sale_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            // වත්මන් තොග ප්‍රමාණය සෙවීම
            String stockQuery = "SELECT stock_quantity, name FROM products WHERE id = ?";
            PreparedStatement ps2 = conn.prepareStatement(stockQuery);
            ps2.setInt(1, productId);
            ResultSet rs2 = ps2.executeQuery();

            if (rs.next() && rs2.next()) {
                double avgDailySales = rs.getDouble("avg_sales");
                int currentStock = rs2.getInt("stock_quantity");
                String name = rs2.getString("name");

                if (avgDailySales > 0) {
                    double daysLeft = currentStock / avgDailySales;
                    if (daysLeft <= 5) { 
                        int recommendedOrder = (int) (avgDailySales * 30); 
                        suggestion = name + " may run out within " + String.format("%.1f", daysLeft) + " days. Recommended restock quantity: " + recommendedOrder + " units.";
                    } else {
                        suggestion = name + " stock is sufficient for " + String.format("%.1f", daysLeft) + " days.";
                    }
                } else {
                    suggestion = "Not enough sales data for " + name + " to predict.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return suggestion;
    }

    // AI Feature 2: Fast & Slow Moving Product Analysis
    public List<String> analyzeProductMovement() {
        List<String> insights = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            
            // වැඩිම අලෙවියක් ඇති භාණ්ඩ
            String fastQuery = "SELECT p.name, SUM(s.quantity_sold) as total FROM sales s JOIN products p ON s.product_id = p.id GROUP BY p.id ORDER BY total DESC LIMIT 3";
            Statement st = conn.createStatement();
            ResultSet rs1 = st.executeQuery(fastQuery);
            while(rs1.next()) {
                insights.add("[FAST MOVING] " + rs1.getString("name") + " is selling fast!");
            }

            // දින 45කින් කිසිසේත්ම අලෙවි නොවූ භාණ්ඩ
            String deadStockQuery = "SELECT name FROM products WHERE id NOT IN (SELECT DISTINCT product_id FROM sales WHERE sale_date >= DATE_SUB(NOW(), INTERVAL 45 DAY))";
            ResultSet rs2 = st.executeQuery(deadStockQuery);
            while(rs2.next()) {
                insights.add("[DEAD STOCK] " + rs2.getString("name") + " has not sold for 45 days.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return insights;
    }

    // AI Feature 3: Sales Trend Analysis
    public List<String> analyzeSalesTrends() {
        List<String> trends = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String trendQuery = "SELECT " +
                                "SUM(CASE WHEN DAYOFWEEK(sale_date) IN (1, 7) THEN total_price ELSE 0 END) as weekend_sales, " +
                                "SUM(CASE WHEN DAYOFWEEK(sale_date) NOT IN (1, 7) THEN total_price ELSE 0 END) as weekday_sales " +
                                "FROM sales WHERE sale_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(trendQuery);
            if (rs.next()) {
                double weekendSales = rs.getDouble("weekend_sales");
                double weekdaySales = rs.getDouble("weekday_sales");
                
                double avgWeekend = weekendSales / 8;
                double avgWeekday = weekdaySales / 22;

                if (avgWeekend > avgWeekday) {
                    trends.add("[TREND PREDICTION] Sales increase significantly during weekends. Increase beverage stock before weekends.");
                } else {
                    trends.add("[TREND PREDICTION] Sales are steady throughout the weekdays.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trends;
    }

    // AI Feature 4: Intelligent Alerts
    public List<String> generateIntelligentAlerts() {
        List<String> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            Statement st = conn.createStatement();

            // Overstock Alert
            String overstockQuery = "SELECT name, stock_quantity FROM products WHERE stock_quantity > 500";
            ResultSet rs1 = st.executeQuery(overstockQuery);
            while (rs1.next()) {
                alerts.add("[AI ALERT - OVERSTOCK] " + rs1.getString("name") + " has high stock (" + rs1.getInt("stock_quantity") + " units).");
            }

            // Low Stock Alert
            String lowStockQuery = "SELECT name, stock_quantity, min_stock_level FROM products WHERE stock_quantity <= min_stock_level";
            ResultSet rs2 = st.executeQuery(lowStockQuery);
            while (rs2.next()) {
                alerts.add("[AI ALERT - LOW STOCK] " + rs2.getString("name") + " is below minimum stock level. Current: " + rs2.getInt("stock_quantity") + " units.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return alerts;
    }
}