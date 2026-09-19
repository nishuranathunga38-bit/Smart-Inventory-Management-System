package com.inventory.controller;

import com.inventory.dao.ProductDAO;
import com.inventory.model.Product;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AIDashboardServlet", urlPatterns = {"/AIDashboardServlet"})
public class AIDashboardServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Product> allProducts = productDAO.getAllProducts();
        List<Product> lowStockProducts = new ArrayList<>();
        List<Product> expiringProducts = new ArrayList<>();
        List<String> aiRecommendations = new ArrayList<>(); // AI Logic එක සඳහා
        
        Date today = new Date();
        long thirtyDaysInMs = 30L * 24 * 60 * 60 * 1000;

        if (allProducts != null) {
            for (Product p : allProducts) {
                // 1. Low Stock Detection
                if (p.getStockQuantity() <= p.getMinStockLevel()) {
                    lowStockProducts.add(p);
                    aiRecommendations.add("Urgent: " + p.getName() + " is running low! Restock recommended.");
                }
                
                // 2. Expiry Detection
                if (p.getExpiryDate() != null) {
                    long diff = p.getExpiryDate().getTime() - today.getTime();
                    if (diff > 0 && diff <= thirtyDaysInMs) {
                        expiringProducts.add(p);
                        aiRecommendations.add("Action: " + p.getName() + " expiring soon. Consider a discount promotion.");
                    }
                }
            }
        }
        
        // AI Logic එකේ සාරාංශයක් නැත්නම් තත්ත්වය Stable බව පැවසීම
        if (aiRecommendations.isEmpty()) {
            aiRecommendations.add("All systems stable. No immediate restock or expiry actions required.");
        }
        
        request.setAttribute("lowStock", lowStockProducts);
        request.setAttribute("expiring", expiringProducts);
        request.setAttribute("aiRecommendations", aiRecommendations); // අලුත් AI Insight එක
        
        request.getRequestDispatcher("ai-dashboard.jsp").forward(request, response);
    }
}