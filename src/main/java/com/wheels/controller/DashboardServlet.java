package com.wheels.controller;

import com.wheels.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch Dashboard Metrics
            int totalRevenue = DBUtil.getTotalRevenue();
            int newBookings = DBUtil.countNewBookingsLastWeek();
            int rentedCars = DBUtil.countRentedCars();
            int availableCars = DBUtil.countAvailableCars();

            // Fetch Charts Data
            List<Map<String, Object>> earningsSummary = DBUtil.getEarningsSummary();
            Map<String, Integer> rentStatus = DBUtil.getRentStatus();
            Map<String, Integer> carTypes = DBUtil.getCarTypeDistribution();
            List<Map<String, Object>> reminders = DBUtil.getPendingReminders();

            // Fetch Filter Options
            List<String> carTypesList = DBUtil.getCarTypes();
            List<Map<String, Object>> clients = DBUtil.getAllClientsForFilter();
            List<Map<String, Object>> cars = DBUtil.getAllCarsForFilter();
            List<Map<String, Object>> drivers = DBUtil.getAllDriversForFilter();
            List<Map<String, Object>> availableCarsList = DBUtil.getAvailableCars();
            List<Map<String, Object>> allClients = DBUtil.getClients();
            List<Map<String, Object>> allDrivers = DBUtil.getDrivers();

            // Fetch Filtered Bookings (default to recent bookings if no filters applied)
            String year = request.getParameter("year");
            String searchQuery = request.getParameter("searchQuery");
            String filterStatus = request.getParameter("filterStatus");

            // Safely parse filter parameters, handling empty strings
            Integer clientId = null;
            String clientIdParam = request.getParameter("clientId");
            if (clientIdParam != null && !clientIdParam.trim().isEmpty()) {
                clientId = Integer.parseInt(clientIdParam);
            }

            Integer carId = null;
            String carIdParam = request.getParameter("carId");
            if (carIdParam != null && !carIdParam.trim().isEmpty()) {
                carId = Integer.parseInt(carIdParam);
            }

            Integer driverId = null;
            String driverIdParam = request.getParameter("driverId");
            if (driverIdParam != null && !driverIdParam.trim().isEmpty()) {
                driverId = Integer.parseInt(driverIdParam);
            }

            List<Map<String, Object>> recentBookings = DBUtil.getRecentBookings(year, searchQuery, filterStatus, clientId, carId, driverId);

            // Set attributes for JSP
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("newBookings", newBookings);
            request.setAttribute("rentedCars", rentedCars);
            request.setAttribute("availableCars", availableCars);
            request.setAttribute("earningsSummary", earningsSummary);
            request.setAttribute("rentStatus", rentStatus);
            request.setAttribute("carTypes", carTypes);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("reminders", reminders);
            request.setAttribute("carTypesList", carTypesList);
            request.setAttribute("clients", clients);
            request.setAttribute("cars", cars);
            request.setAttribute("drivers", drivers);
            request.setAttribute("availableCarsList", availableCarsList);
            request.setAttribute("allClients", allClients);
            request.setAttribute("allDrivers", allDrivers);

            // Disable caching
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // Forward to JSP
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving dashboard data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("checkAvailability".equals(action)) {
                // Handle Car Availability Check
                String carType = request.getParameter("carType");
                String checkDateStr = request.getParameter("checkDate");
                String checkTime = request.getParameter("checkTime");

                Date checkDate = Date.valueOf(checkDateStr);
                List<Map<String, Object>> availableCarsForCheck = DBUtil.checkCarAvailability(carType, checkDate, checkTime);

                request.setAttribute("availableCarsForCheck", availableCarsForCheck);
                doGet(request, response); // Reload the page with results
            } else if ("addBooking".equals(action)) {
                // Handle Add Booking
                int userId = Integer.parseInt(request.getParameter("clientId"));
                int carId = Integer.parseInt(request.getParameter("carId"));
                Date bookingDate = Date.valueOf(request.getParameter("bookingDate"));
                Date startDate = Date.valueOf(request.getParameter("startDate"));
                Date endDate = Date.valueOf(request.getParameter("endDate"));
                double totalCost = Double.parseDouble(request.getParameter("totalCost"));
                String driverIdStr = request.getParameter("driverId");
                Integer driverId = (driverIdStr != null && !driverIdStr.isEmpty()) ? Integer.parseInt(driverIdStr) : null;

                DBUtil.addBooking(userId, carId, bookingDate, startDate, endDate, totalCost, driverId);
                response.sendRedirect("dashboard"); // Redirect to refresh the page
            } else {
                doGet(request, response); // Default to GET behavior
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing POST request: " + e.getMessage(), e);
        }
    }
}