package com.inventory.controller;

import com.inventory.dao.ProductDAO; // ඔබේ DAO එක Import කරන්න
import java.io.IOException;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteProductServlet") // මෙය අනිවාර්යයෙන්ම එක් කරන්න
public class DeleteProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. URL එකෙන් ID එක ලබා ගන්න
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            
            // 2. Database එකෙන් Delete කරන්න
            ProductDAO dao = new ProductDAO();
            dao.deleteProduct(id);
        }
        
        // 3. නැවත නිෂ්පාදන ලැයිස්තුවට යවන්න (Redirect)
        response.sendRedirect("ProductServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}