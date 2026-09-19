package com.inventory.controller;

import com.inventory.dao.UserDAO;
import java.io.IOException;

// මෙතැනදී javax වෙනුවට jakarta පාවිච්චි කළ යුතුය
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uname = request.getParameter("username");
        String pword = request.getParameter("password");
        
        UserDAO userDao = new UserDAO();
        String role = userDao.authenticateUser(uname, pword);
        
        if (role != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", uname);
            session.setAttribute("role", role);
            
            response.sendRedirect("index.jsp");
        } else {
            response.sendRedirect("login.jsp?error=Invalid Credentials");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}