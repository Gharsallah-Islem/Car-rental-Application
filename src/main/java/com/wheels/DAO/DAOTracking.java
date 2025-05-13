package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOTracking;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOTracking implements IDAOTracking {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Map<String, Object>> getAllTrackingData() {
        List<Map<String, Object>> trackingData = new ArrayList<>();
        String sql = "SELECT t.tracking_id, t.car_id, t.latitude, t.longitude, t.timestamp, t.status, " +
                "c.brand, c.model, c.license_plate " +
                "FROM tracking t " +
                "JOIN cars c ON t.car_id = c.car_id " +
                "ORDER BY t.timestamp DESC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> tracking = new HashMap<>();
                tracking.put("tracking_id", rs.getInt("tracking_id"));
                tracking.put("car_id", rs.getInt("car_id"));
                tracking.put("latitude", rs.getDouble("latitude"));
                tracking.put("longitude", rs.getDouble("longitude"));
                tracking.put("timestamp", rs.getTimestamp("timestamp"));
                tracking.put("status", rs.getString("status"));
                tracking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                tracking.put("license_plate", rs.getString("license_plate"));
                trackingData.add(tracking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trackingData;
    }

    @Override
    public Map<String, Object> getLatestLocationForCar(int carId) {
        Map<String, Object> location = new HashMap<>();
        String sql = "SELECT t.latitude, t.longitude, t.timestamp, t.status, " +
                "c.brand, c.model, c.license_plate " +
                "FROM tracking t " +
                "JOIN cars c ON t.car_id = c.car_id " +
                "WHERE t.car_id = ? " +
                "ORDER BY t.timestamp DESC LIMIT 1";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                location.put("car_id", carId);
                location.put("latitude", rs.getDouble("latitude"));
                location.put("longitude", rs.getDouble("longitude"));
                location.put("timestamp", rs.getTimestamp("timestamp"));
                location.put("status", rs.getString("status"));
                location.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                location.put("license_plate", rs.getString("license_plate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return location;
    }

    @Override
    public List<Map<String, Object>> getTrackingHistoryForCar(int carId, java.sql.Date startDate, java.sql.Date endDate) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT t.tracking_id, t.latitude, t.longitude, t.timestamp, t.status, " +
                "c.brand, c.model, c.license_plate " +
                "FROM tracking t " +
                "JOIN cars c ON t.car_id = c.car_id " +
                "WHERE t.car_id = ? AND t.timestamp BETWEEN ? AND ? " +
                "ORDER BY t.timestamp ASC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setDate(2, startDate);
            stmt.setDate(3, endDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> tracking = new HashMap<>();
                tracking.put("tracking_id", rs.getInt("tracking_id"));
                tracking.put("car_id", carId);
                tracking.put("latitude", rs.getDouble("latitude"));
                tracking.put("longitude", rs.getDouble("longitude"));
                tracking.put("timestamp", rs.getTimestamp("timestamp"));
                tracking.put("status", rs.getString("status"));
                tracking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                tracking.put("license_plate", rs.getString("license_plate"));
                history.add(tracking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return history;
    }

    @Override
    public void addTrackingRecord(int carId, double latitude, double longitude, String status) {
        String sql = "INSERT INTO tracking (car_id, latitude, longitude, timestamp, status) VALUES (?, ?, ?, NOW(), ?)";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setDouble(2, latitude);
            stmt.setDouble(3, longitude);
            stmt.setString(4, status);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteTrackingRecord(int trackingId) {
        String sql = "DELETE FROM tracking WHERE tracking_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, trackingId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}