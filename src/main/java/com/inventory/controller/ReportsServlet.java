package com.inventory.controller;

import com.inventory.config.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReportsServlet", urlPatterns = {"/ReportsServlet"})
public class ReportsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Charts වලට අවශ්‍ය Data Lists
        List<String> dates = new ArrayList<>();
        List<Double> salesAmount = new ArrayList<>();
        
        List<String> productNames = new ArrayList<>();
        List<Integer> productQuantities = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Sales Trend & Revenue Analysis සඳහා දත්ත (පසුගිය දින 7)
            String trendSQL = "SELECT DATE(sale_date) as sdate, SUM(total_price) as total FROM sales GROUP BY DATE(sale_date) ORDER BY sdate ASC LIMIT 7";
            try (PreparedStatement ps = conn.prepareStatement(trendSQL); ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    dates.add(rs.getString("sdate"));
                    salesAmount.add(rs.getDouble("total"));
                }
            }
            
            // 2. Product Performance සඳහා දත්ත (වැඩිපුරම විකුණන ලද භාණ්ඩ 5)
            String prodSQL = "SELECT p.name, SUM(s.quantity) as total_qty FROM sales s JOIN products p ON s.product_id = p.id GROUP BY s.product_id ORDER BY total_qty DESC LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(prodSQL); ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    productNames.add(rs.getString("name"));
                    productQuantities.add(rs.getInt("total_qty"));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Request Attributes විදිහට දත්ත JSP එකට යැවීම
        request.setAttribute("dates", dates);
        request.setAttribute("salesAmount", salesAmount);
        request.setAttribute("productNames", productNames);
        request.setAttribute("productQuantities", productQuantities);

        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }
}