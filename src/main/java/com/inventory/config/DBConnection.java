package com.inventory.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // මෙතැන Port එක 3306 ලෙස නිවැරදි කර ඇත
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_inventory", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}