package com.inventory.controller;

import com.inventory.dao.ProductDAO;
import com.inventory.model.Product;
import java.io.IOException;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. URL එකෙන් ID එක ලබා ගන්න
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            ProductDAO dao = new ProductDAO();
            
            // 2. ID එකට අදාළ Product එක ලබා ගන්න
            Product product = dao.getProductById(id);
            
            // 3. එම දත්ත JSP එකට යවන්න
            request.setAttribute("product", product);
            request.getRequestDispatcher("edit-product.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // පෝරමයෙන් එන දත්ත යාවත්කාලීන කිරීම (Update)
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock_quantity"));
        
        Product updatedProduct = new Product(id, name, category, price, stock, 0, null);
        ProductDAO dao = new ProductDAO();
        dao.updateProduct(updatedProduct);
        
        // නැවත ප්‍රධාන ලැයිස්තුවට යන්න
        response.sendRedirect("ProductServlet");
    }
}