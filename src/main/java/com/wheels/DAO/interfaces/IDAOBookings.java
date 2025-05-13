package com.wheels.DAO.interfaces;

import com.wheels.dto.BookingDetailsDTO;
import com.wheels.Model.Booking;
import java.util.List;

public interface IDAOBookings {
    List<Booking> getAllBookings();
    List<BookingDetailsDTO> getRecentBookings(String year, String searchQuery, String filterStatus, Integer clientId, Integer carId, Integer driverId);
    List<BookingDetailsDTO> getFilteredBookings(String searchQuery, String filterStatus, Integer clientId, Integer carId, Integer driverId);
    List<java.util.Map<String, Object>> checkCarAvailability(String carType, java.sql.Date checkDate, String checkTime);
    void addBooking(int userId, int carId, java.sql.Date bookingDate, java.sql.Date startDate, java.sql.Date endDate, double totalCost, Integer driverId);
    void updateBooking(int bookingId, java.sql.Date startDate, java.sql.Date endDate, double totalCost, String status, String paymentStatus, Integer driverId);
    void cancelBooking(int bookingId);
}