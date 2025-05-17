package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOPublicBookings;
import com.wheels.util.DatabaseSingleton;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOPublicBookings implements IDAOPublicBookings {

    @Override
    public boolean createBooking(int userId, int carId, LocalDate bookingDate, LocalDate startDate, LocalDate endDate, double totalCost) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, car_id, booking_date, start_date, end_date, total_cost, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, carId);
            pstmt.setDate(3, java.sql.Date.valueOf(bookingDate));
            pstmt.setDate(4, java.sql.Date.valueOf(startDate));
            pstmt.setDate(5, java.sql.Date.valueOf(endDate));
            pstmt.setDouble(6, totalCost);
            pstmt.setString(7, "pending");
            pstmt.setString(8, "pending");
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    @Override
    public boolean isCarAvailable(int carId, LocalDate startDate, LocalDate endDate) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE car_id = ? AND status NOT IN ('cancelled', 'completed') " +
                "AND ((start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?))";
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, carId);
            pstmt.setDate(2, java.sql.Date.valueOf(endDate));
            pstmt.setDate(3, java.sql.Date.valueOf(startDate));
            pstmt.setDate(4, java.sql.Date.valueOf(endDate));
            pstmt.setDate(5, java.sql.Date.valueOf(startDate));
            pstmt.setDate(6, java.sql.Date.valueOf(startDate));
            pstmt.setDate(7, java.sql.Date.valueOf(endDate));
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0; // If count is 0, the car is available
            }
            return true; // Default to available if no bookings found
        }
    }

    @Override
    public double getCarPricePerDay(int carId) throws SQLException {
        String sql = "SELECT price_per_day FROM cars WHERE car_id = ?";
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, carId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("price_per_day");
            }
            throw new SQLException("Car not found with ID: " + carId);
        }
    }

    @Override
    public List<Map<String, Object>> getUserBookings(int userId) throws SQLException {
        String sql = "SELECT b.booking_id, c.model, b.start_date, b.end_date, b.total_cost, b.status " +
                "FROM bookings b " +
                "JOIN cars c ON b.car_id = c.car_id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.start_date DESC";
        List<Map<String, Object>> bookings = new ArrayList<>();
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("model", rs.getString("model"));
                booking.put("start_date", rs.getDate("start_date").toString());
                booking.put("end_date", rs.getDate("end_date").toString());
                booking.put("total_cost", rs.getDouble("total_cost"));
                booking.put("status", rs.getString("status"));
                bookings.add(booking);
            }
        }
        return bookings;
    }

    @Override
    public boolean cancelBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ? AND status IN ('pending', 'active')";
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bookingId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    @Override
    public List<Map<String, Object>> getDriverBookings(int driverId) throws SQLException {
        String sql = "SELECT b.booking_id, c.model, u.full_name AS customer_name, b.start_date, b.end_date, b.status " +
                "FROM bookings b " +
                "JOIN cars c ON b.car_id = c.car_id " +
                "JOIN users u ON b.user_id = u.user_id " +
                "WHERE b.driver_id = ? " +
                "ORDER BY b.start_date DESC";
        List<Map<String, Object>> bookings = new ArrayList<>();
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, driverId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("model", rs.getString("model"));
                booking.put("customer_name", rs.getString("customer_name"));
                booking.put("start_date", rs.getDate("start_date").toString());
                booking.put("end_date", rs.getDate("end_date").toString());
                booking.put("status", rs.getString("status"));
                bookings.add(booking);
            }
        }
        return bookings;
    }

    @Override
    public boolean acceptBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'active' WHERE booking_id = ? AND status = 'pending'";
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bookingId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    @Override
    public boolean completeBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'completed' WHERE booking_id = ? AND status = 'active'";
        try (Connection conn = DatabaseSingleton.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bookingId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}