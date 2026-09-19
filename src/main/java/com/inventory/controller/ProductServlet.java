package com.inventory.controller;

import com.inventory.dao.ProductDAO;
import com.inventory.model.Product;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. දත්ත සමුදායෙන් භාණ්ඩ ලැයිස්තුව ලබා ගැනීම
        List<Product> productList = productDAO.getAllProducts();
        
        // 2. JSP වෙත දත්ත යැවීම (දැන් product-management.jsp වෙත යොමු කෙරේ)
        request.setAttribute("products", productList);
        request.getRequestDispatcher("product-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // අක්ෂර කේතන ගැටලු වැළැක්වීමට
        request.setCharacterEncoding("UTF-8");
        
        try {
            // පෝරමයෙන් ලැබෙන දත්ත ලබා ගැනීම
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stock_quantity"));
            int minStockLevel = Integer.parseInt(request.getParameter("min_stock_level"));
            
            String expiryDateStr = request.getParameter("expiry_date");
            Date expiryDate = null;
            if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                try {
                    expiryDate = new SimpleDateFormat("yyyy-MM-dd").parse(expiryDateStr);
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            // නව Product object එකක් සාදා Database එකට ඇතුළත් කිරීම
            Product newProduct = new Product(0, name, category, price, stockQuantity, minStockLevel, expiryDate);
            productDAO.addProduct(newProduct);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // ඇතුළත් කිරීමෙන් පසු නැවත doGet වෙත යැවීම (Refresh)
        response.sendRedirect("ProductServlet");
    }
}