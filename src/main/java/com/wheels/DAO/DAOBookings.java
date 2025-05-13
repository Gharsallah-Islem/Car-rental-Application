package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOBookings;
import com.wheels.Model.*;
import com.wheels.dto.BookingDetailsDTO;
import com.wheels.util.DatabaseSingleton;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOBookings implements IDAOBookings {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.user_id, b.car_id, b.booking_date, b.start_date, b.end_date, b.total_cost, b.status, b.payment_status, b.driver_id, b.created_at " +
                "FROM bookings b ORDER BY b.created_at DESC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setCarId(rs.getInt("car_id"));
                booking.setBookingDate(rs.getDate("booking_date").toLocalDate());
                booking.setStartDate(rs.getDate("start_date").toLocalDate());
                booking.setEndDate(rs.getDate("end_date").toLocalDate());
                booking.setTotalCost(BigDecimal.valueOf(rs.getDouble("total_cost")));
                booking.setStatus(BookingStatus.valueOf(rs.getString("status")));
                booking.setPaymentStatus(PaymentStatus.valueOf(rs.getString("payment_status")));
                booking.setDriverId(rs.getObject("driver_id") != null ? rs.getInt("driver_id") : null);
                booking.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    @Override
    public List<BookingDetailsDTO> getRecentBookings(String year, String searchQuery, String filterStatus, Integer clientId, Integer carId, Integer driverId) {
        List<BookingDetailsDTO> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.booking_date, b.start_date, b.end_date, b.total_cost, b.status, b.payment_status, " +
                        "u.full_name as client_name, c.brand, c.model, d.full_name as driver_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN cars c ON b.car_id = c.car_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (year != null && !year.isEmpty() && !year.equals("All")) {
            sql.append(" AND YEAR(b.booking_date) = ?");
            params.add(Integer.parseInt(year));
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR CONCAT(c.brand, ' ', c.model) LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (filterStatus != null && !filterStatus.equals("All")) {
            sql.append(" AND b.status = ?");
            params.add(filterStatus);
        }

        if (clientId != null) {
            sql.append(" AND b.user_id = ?");
            params.add(clientId);
        }

        if (carId != null) {
            sql.append(" AND b.car_id = ?");
            params.add(carId);
        }

        if (driverId != null) {
            sql.append(" AND b.driver_id = ?");
            params.add(driverId);
        }

        sql.append(" ORDER BY b.created_at DESC LIMIT 5");

        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Date startDate = rs.getDate("start_date");
                Date endDate = rs.getDate("end_date");
                long bookingDays = (startDate != null && endDate != null) ?
                        ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate()) : 0;
                BookingDetailsDTO booking = new BookingDetailsDTO(
                        rs.getInt("booking_id"),
                        rs.getDate("booking_date"),
                        startDate,
                        endDate,
                        bookingDays,
                        rs.getDouble("total_cost"),
                        rs.getString("status"),
                        rs.getString("payment_status"),
                        rs.getString("client_name"),
                        rs.getString("brand") + " " + rs.getString("model"),
                        rs.getString("parc_name") != null ? rs.getString("parc_name") : "-",
                        rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    @Override
    public List<BookingDetailsDTO> getFilteredBookings(String searchQuery, String filterStatus, Integer clientId, Integer carId, Integer driverId) {
        List<BookingDetailsDTO> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.booking_date, b.start_date, b.end_date, b.total_cost, b.status, b.payment_status, " +
                        "u.full_name as client_name, c.brand, c.model, d.full_name as driver_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN cars c ON b.car_id = c.car_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR CONCAT(c.brand, ' ', c.model) LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (filterStatus != null && !filterStatus.equalsIgnoreCase("All")) {
            sql.append(" AND b.status = ?");
            params.add(filterStatus);
        }

        if (clientId != null) {
            sql.append(" AND b.user_id = ?");
            params.add(clientId);
        }

        if (carId != null) {
            sql.append(" AND b.car_id = ?");
            params.add(carId);
        }

        if (driverId != null) {
            sql.append(" AND b.driver_id = ?");
            params.add(driverId);
        }

        sql.append(" ORDER BY b.created_at DESC");

        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Date startDate = rs.getDate("start_date");
                Date endDate = rs.getDate("end_date");
                long bookingDays = (startDate != null && endDate != null) ?
                        ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate()) : 0;
                BookingDetailsDTO booking = new BookingDetailsDTO(
                        rs.getInt("booking_id"),
                        rs.getDate("booking_date"),
                        startDate,
                        endDate,
                        bookingDays,
                        rs.getDouble("total_cost"),
                        rs.getString("status"),
                        rs.getString("payment_status"),
                        rs.getString("client_name"),
                        rs.getString("brand") + " " + rs.getString("model"),
                        rs.getString("parc_name") != null ? rs.getString("parc_name") : "-",
                        rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    @Override
    public List<Map<String, Object>> checkCarAvailability(String carType, java.sql.Date checkDate, String checkTime) {
        List<Map<String, Object>> availableCars = new ArrayList<>();
        String sql = "SELECT c.car_id, c.brand, c.model, c.price_per_day " +
                "FROM cars c " +
                "LEFT JOIN bookings b ON c.car_id = b.car_id " +
                "AND (b.start_date <= ? AND b.end_date >= ? AND b.status NOT IN ('cancelled')) " +
                "WHERE c.car_type = ? " +
                "AND c.availability = TRUE " +
                "AND (b.booking_id IS NULL OR b.status = 'cancelled')";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            java.sql.Timestamp checkDateTime = java.sql.Timestamp.valueOf(checkDate.toString() + " " + checkTime + ":00");
            stmt.setTimestamp(1, checkDateTime);
            stmt.setTimestamp(2, checkDateTime);
            stmt.setString(3, carType);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                car.put("price_per_day", rs.getDouble("price_per_day"));
                availableCars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableCars;
    }

    @Override
    public void addBooking(int userId, int carId, java.sql.Date bookingDate, java.sql.Date startDate, java.sql.Date endDate, double totalCost, Integer driverId) {
        String sql = "INSERT INTO bookings (user_id, car_id, booking_date, start_date, end_date, total_cost, status, payment_status, driver_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'pending', 'pending', ?)";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, carId);
            stmt.setDate(3, bookingDate);
            stmt.setDate(4, startDate);
            stmt.setDate(5, endDate);
            stmt.setDouble(6, totalCost);
            if (driverId != null) {
                stmt.setInt(7, driverId);
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }
            stmt.executeUpdate();

            String updateCarSql = "UPDATE cars SET availability = FALSE WHERE car_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateCarSql)) {
                updateStmt.setInt(1, carId);
                updateStmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateBooking(int bookingId, java.sql.Date startDate, java.sql.Date endDate, double totalCost, String status, String paymentStatus, Integer driverId) {
        String sql = "UPDATE bookings SET start_date = ?, end_date = ?, total_cost = ?, status = ?, payment_status = ?, driver_id = ? WHERE booking_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            stmt.setDouble(3, totalCost);
            stmt.setString(4, status);
            stmt.setString(5, paymentStatus);
            if (driverId != null) {
                stmt.setInt(6, driverId);
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }
            stmt.setInt(7, bookingId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void cancelBooking(int bookingId) {
        String getCarSql = "SELECT car_id FROM bookings WHERE booking_id = ?";
        int carId = -1;
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(getCarSql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                carId = rs.getInt("car_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql = "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();

            if (carId != -1) {
                String updateCarSql = "UPDATE cars SET availability = TRUE WHERE car_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateCarSql)) {
                    updateStmt.setInt(1, carId);
                    updateStmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}