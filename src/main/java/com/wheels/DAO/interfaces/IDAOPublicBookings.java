package com.wheels.DAO.interfaces;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface IDAOPublicBookings {
    boolean createBooking(int userId, int carId, LocalDate bookingDate, LocalDate startDate, LocalDate endDate, double totalCost) throws SQLException;
    boolean isCarAvailable(int carId, LocalDate startDate, LocalDate endDate) throws SQLException;
    double getCarPricePerDay(int carId) throws SQLException;
    List<Map<String, Object>> getUserBookings(int userId) throws SQLException;
    boolean cancelBooking(int bookingId) throws SQLException;
    List<Map<String, Object>> getDriverBookings(int driverId) throws SQLException;
    boolean acceptBooking(int bookingId) throws SQLException;
    boolean completeBooking(int bookingId) throws SQLException;
}