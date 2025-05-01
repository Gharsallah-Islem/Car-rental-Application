package com.wheels.controller;

import com.wheels.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "CalendarServlet", urlPatterns = {"/calendar"})
public class CalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get the current year and month, or use parameters if provided
            String yearStr = request.getParameter("year");
            String monthStr = request.getParameter("month");

            LocalDate today = LocalDate.now();
            int year = yearStr != null ? Integer.parseInt(yearStr) : today.getYear();
            int month = monthStr != null ? Integer.parseInt(monthStr) : today.getMonthValue();

            // Adjust year if month is out of bounds (e.g., month = 0 or 13)
            if (month < 1) {
                month = 12;
                year--;
            } else if (month > 12) {
                month = 1;
                year++;
            }

            // Calculate the start and end dates of the month
            YearMonth yearMonth = YearMonth.of(year, month);
            LocalDate startOfMonth = yearMonth.atDay(1);
            LocalDate endOfMonth = yearMonth.atEndOfMonth();

            // Convert to java.sql.Date for DBUtil
            Date startDate = Date.valueOf(startOfMonth);
            Date endDate = Date.valueOf(endOfMonth);

            // Get filter parameters
            Integer carId = request.getParameter("carId") != null && !request.getParameter("carId").isEmpty() ?
                    Integer.parseInt(request.getParameter("carId")) : null;
            Integer clientId = request.getParameter("clientId") != null && !request.getParameter("clientId").isEmpty() ?
                    Integer.parseInt(request.getParameter("clientId")) : null;
            Integer driverId = request.getParameter("driverId") != null && !request.getParameter("driverId").isEmpty() ?
                    Integer.parseInt(request.getParameter("driverId")) : null;

            // Fetch bookings for the month with filters
            List<Map<String, Object>> bookings = DBUtil.getBookingsForCalendar(startDate, endDate, carId, clientId, driverId);

            // Fetch filter options
            List<Map<String, Object>> cars = DBUtil.getAllCarsForFilter();
            List<Map<String, Object>> clients = DBUtil.getAllClientsForFilter();
            List<Map<String, Object>> drivers = DBUtil.getAllDriversForFilter();

            // Prepare bookings data for FullCalendar
            String eventsJson = bookings.stream()
                    .map(booking -> {
                        String status = (String) booking.get("status");
                        String color;
                        switch (status.toLowerCase()) {
                            case "confirmed":
                                color = "#28a745"; // Green
                                break;
                            case "pending":
                                color = "#ffc107"; // Yellow
                                break;
                            case "cancelled":
                                color = "#dc3545"; // Red
                                break;
                            default:
                                color = "#007bff"; // Blue
                        }
                        return String.format(
                                "{ \"id\": \"%s\", \"title\": \"%s (%s)\", \"start\": \"%s\", \"end\": \"%s\", \"color\": \"%s\", " +
                                        "\"extendedProps\": { \"client\": \"%s\", \"driver\": \"%s\", \"status\": \"%s\" } }",
                                booking.get("booking_id"),
                                booking.get("car_model"),
                                booking.get("client_name"),
                                booking.get("start_date"),
                                booking.get("end_date"),
                                color,
                                booking.get("client_name"),
                                booking.get("driver_name"),
                                booking.get("status")
                        );
                    })
                    .collect(Collectors.joining(",", "[", "]"));

            // Log the data for debugging
            System.out.println("CalendarServlet: Bookings for " + year + "-" + month + ": " + bookings);

            // Pass data to JSP
            request.setAttribute("year", year);
            request.setAttribute("month", month);
            request.setAttribute("bookings", bookings);
            request.setAttribute("cars", cars);
            request.setAttribute("clients", clients);
            request.setAttribute("drivers", drivers);
            request.setAttribute("eventsJson", eventsJson);
            request.setAttribute("selectedCarId", carId);
            request.setAttribute("selectedClientId", clientId);
            request.setAttribute("selectedDriverId", driverId);

            // Forward to JSP
            request.getRequestDispatcher("calendar.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving calendar data: " + e.getMessage(), e);
        }
    }
}