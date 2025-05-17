package com.wheels.controller.user;

import com.wheels.DAO.DAOPublicBookings;
import com.wheels.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class BookingServlet extends HttpServlet {
    private DAOPublicBookings daoPublicBookings;

    @Override
    public void init() throws ServletException {
        daoPublicBookings = new DAOPublicBookings();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String carId = request.getParameter("carId");
        if (carId == null || carId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }
        request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request.getSession());
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        String carId = request.getParameter("carId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // Validate inputs
        if (carId == null || startDateStr == null || endDateStr == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
            return;
        }

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate startDate = LocalDate.parse(startDateStr, formatter);
            LocalDate endDate = LocalDate.parse(endDateStr, formatter);

            // Validate dates
            if (startDate.isBefore(LocalDate.now().plusDays(1)) || endDate.isBefore(startDate.plusDays(1))) {
                request.setAttribute("error", "Invalid date range. Pick-up date must be tomorrow or later, and drop-off date must be at least one day after pick-up date.");
                request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
                return;
            }

            int carIdInt = Integer.parseInt(carId);

            // Check car availability
            boolean isAvailable = daoPublicBookings.isCarAvailable(carIdInt, startDate, endDate);
            if (!isAvailable) {
                request.setAttribute("error", "Car is not available for the selected dates.");
                request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
                return;
            }

            // Calculate total cost
            double pricePerDay = daoPublicBookings.getCarPricePerDay(carIdInt);
            long days = ChronoUnit.DAYS.between(startDate, endDate);
            double totalCost = pricePerDay * days;

            // Create booking
            LocalDate bookingDate = LocalDate.now();
            boolean success = daoPublicBookings.createBooking(userId, carIdInt, bookingDate, startDate, endDate, totalCost);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/my-bookings?success=Booking created successfully.");
            } else {
                request.setAttribute("error", "Failed to create booking. Please try again.");
                request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "A database error occurred while creating the booking. Please try again.");
            request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid car ID. Please try again.");
            request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid date format. Please try again.");
            request.getRequestDispatcher("/user/booking-form.jsp").forward(request, response);
        }
    }
}