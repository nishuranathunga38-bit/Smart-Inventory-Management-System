package com.inventory.controller;

import java.io.IOException;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // දැනට තියෙන Session එක ලබා ගැනීම
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate(); // Session එක සම්පූර්ණයෙන්ම මකා දැමීම (Logout කිරීම)
        }
        
        // පරිශීලකයා නැවත login.jsp පිටුවට හරවා යැවීම
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}