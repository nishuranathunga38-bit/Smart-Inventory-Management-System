package com.inventory.controller;

import com.inventory.dao.ProductDAO;
import java.io.IOException;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ProductListServlet")
public class ProductListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("products", new ProductDAO().getAllProducts());
        request.getRequestDispatcher("product-management.jsp").forward(request, response);
    }
}