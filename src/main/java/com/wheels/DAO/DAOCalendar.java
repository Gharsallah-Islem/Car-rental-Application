package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOCalendar;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOCalendar implements IDAOCalendar {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Map<String, Object>> getBookingsForCalendar(java.sql.Date startDate, java.sql.Date endDate, Integer carId, Integer clientId, Integer driverId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.start_date, b.end_date, b.status, " +
                        "u.full_name as client_name, c.brand, c.model, d.full_name as driver_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN cars c ON b.car_id = c.car_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE b.start_date <= ? AND b.end_date >= ?"
        );

        List<Object> params = new ArrayList<>();
        params.add(endDate);
        params.add(startDate);

        if (carId != null) {
            sql.append(" AND b.car_id = ?");
            params.add(carId);
        }
        if (clientId != null) {
            sql.append(" AND b.user_id = ?");
            params.add(clientId);
        }
        if (driverId != null) {
            sql.append(" AND b.driver_id = ?");
            params.add(driverId);
        }

        sql.append(" ORDER BY b.start_date");

        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("start_date", rs.getDate("start_date"));
                booking.put("end_date", rs.getDate("end_date"));
                booking.put("status", rs.getString("status"));
                booking.put("client_name", rs.getString("client_name"));
                booking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                booking.put("driver_name", rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}