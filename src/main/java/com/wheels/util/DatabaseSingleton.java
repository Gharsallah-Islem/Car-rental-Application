package com.wheels.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseSingleton {
    private static volatile DatabaseSingleton instance;
    private Connection connection;

    private static final String URL = "jdbc:mysql://localhost:3306/wheels_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    private DatabaseSingleton() {
        initializeConnection();
    }

    private void initializeConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Failed to initialize database connection", e);
        }
    }

    public static DatabaseSingleton getInstance() {
        if (instance == null) {
            synchronized (DatabaseSingleton.class) {
                if (instance == null) {
                    instance = new DatabaseSingleton();
                }
            }
        }
        return instance;
    }

    public synchronized Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                initializeConnection();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to re-establish database connection", e);
        }
        return connection;
    }

    // No public closeConnection method; connection is managed internally
}