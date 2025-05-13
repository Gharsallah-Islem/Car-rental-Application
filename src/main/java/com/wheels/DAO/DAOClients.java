package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOClients;
import com.wheels.Model.User;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOClients implements IDAOClients {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<User> getAllClients() {
        List<User> clients = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, phone, created_at FROM users WHERE role = 'client' ORDER BY created_at DESC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User client = new User();
                client.setUserId(rs.getInt("user_id"));
                client.setFullName(rs.getString("full_name"));
                client.setEmail(rs.getString("email"));
                client.setPhone(rs.getString("phone"));
                client.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                clients.add(client);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clients;
    }

    @Override
    public List<User> getAllClientsForFilter() {
        List<User> clients = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE role = 'client' ORDER BY full_name";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User client = new User();
                client.setUserId(rs.getInt("user_id"));
                client.setFullName(rs.getString("full_name"));
                clients.add(client);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clients;
    }

    @Override
    public void addClient(String fullName, String email, String phone, String password) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role) VALUES (?, ?, ?, ?, 'client')";
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
    public void updateClient(int userId, String fullName, String email, String phone) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ? AND role = 'client'";
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
    public boolean hasActiveBookings(int userId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE user_id = ? AND status NOT IN ('cancelled', 'completed')";
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
    public void deleteClient(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ? AND role = 'client'";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}