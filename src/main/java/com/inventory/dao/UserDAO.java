package com.inventory.dao;

import com.inventory.config.DBConnection;
import java.sql.*;

public class UserDAO {
    
    public String authenticateUser(String username, String password) {
        String role = null;
        String query = "SELECT role FROM users WHERE username = ? AND password = ?";
        
        // 1. පරිශීලකයා Form එකේ ඇතුලත් කල දත්ත NetBeans Output එකේ පෙන්වීම
        System.out.println("====== LOGIN ATTEMPT ======");
        System.out.println("Entered Username: [" + username + "]");
        System.out.println("Entered Password: [" + password + "]");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            if (conn == null) {
                System.out.println("DATABASE ERROR: DBConnection.getConnection() returned NULL!");
            } else {
                System.out.println("Database Connection Successful.");
            }
            
            ps.setString(1, username);
            ps.setString(2, password); 
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                role = rs.getString("role"); 
                System.out.println("DATABASE MATCH FOUND! User Role: " + role);
            } else {
                System.out.println("DATABASE MATCH FAILED: No user found with this Username and Password.");
            }
            System.out.println("===========================");
            
        } catch (Exception e) {
            System.out.println("CRITICAL EXCEPTION IN USERDAO:");
            e.printStackTrace();
        }
        return role;
    }
}