package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAODrivers;
import com.wheels.Model.User;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAODrivers implements IDAODrivers {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<User> getAllDrivers() {
        List<User> drivers = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, phone, created_at FROM users WHERE role = 'driver' ORDER BY created_at DESC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User driver = new User();
                driver.setUserId(rs.getInt("user_id"));
                driver.setFullName(rs.getString("full_name"));
                driver.setEmail(rs.getString("email"));
                driver.setPhone(rs.getString("phone"));
                driver.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                drivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drivers;
    }

    @Override
    public List<User> getAllDriversForFilter() {
        List<User> drivers = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE role = 'driver' ORDER BY full_name";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User driver = new User();
                driver.setUserId(rs.getInt("user_id"));
                driver.setFullName(rs.getString("full_name"));
                drivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drivers;
    }

    @Override
    public void addDriver(String fullName, String email, String phone, String password) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role) VALUES (?, ?, ?, ?, 'driver')";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, com.wheels.util.DBUtil.hashPassword(password));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateDriver(int userId, String fullName, String email, String phone) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ? AND role = 'driver'";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setInt(4, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean hasActiveDriverBookings(int userId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE driver_id = ? AND status NOT IN ('cancelled', 'completed')";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void deleteDriver(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ? AND role = 'driver'";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}