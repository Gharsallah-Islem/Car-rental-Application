package com.wheels.controller.admin;

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

@WebServlet(name = "BookingsServlet", urlPatterns = {"/bookings"})
public class BookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch filter parameters
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

            // Fetch filtered bookings (you may need to implement this method in DBUtil)
            List<Map<String, Object>> bookings = DBUtil.getFilteredBookings(searchQuery, filterStatus, clientId, carId, driverId);

            // Fetch cars, clients, and drivers for the form dropdowns
            List<Map<String, Object>> cars = DBUtil.getAvailableCars();
            List<Map<String, Object>> clients = DBUtil.getClients();
            List<Map<String, Object>> drivers = DBUtil.getDrivers();

            // Set attributes for JSP
            request.setAttribute("bookings", bookings);
            request.setAttribute("cars", cars);
            request.setAttribute("clients", clients);
            request.setAttribute("drivers", drivers);

            // Disable caching
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // Forward to JSP
            request.getRequestDispatcher("bookings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving bookings data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int carId = Integer.parseInt(request.getParameter("carId"));
                Date bookingDate = Date.valueOf(request.getParameter("bookingDate"));
                Date startDate = Date.valueOf(request.getParameter("startDate"));
                Date endDate = Date.valueOf(request.getParameter("endDate"));
                double totalCost = Double.parseDouble(request.getParameter("totalCost"));
                String driverIdStr = request.getParameter("driverId");
                Integer driverId = driverIdStr != null && !driverIdStr.isEmpty() ? Integer.parseInt(driverIdStr) : null;
                DBUtil.addBooking(userId, carId, bookingDate, startDate, endDate, totalCost, driverId);
            } else if ("update".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                Date startDate = Date.valueOf(request.getParameter("startDate"));
                Date endDate = Date.valueOf(request.getParameter("endDate"));
                double totalCost = Double.parseDouble(request.getParameter("totalCost"));
                String status = request.getParameter("status");
                String paymentStatus = request.getParameter("paymentStatus");
                String driverIdStr = request.getParameter("driverId");
                Integer driverId = driverIdStr != null && !driverIdStr.isEmpty() ? Integer.parseInt(driverIdStr) : null;
                DBUtil.updateBooking(bookingId, startDate, endDate, totalCost, status, paymentStatus, driverId);
            } else if ("cancel".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                DBUtil.cancelBooking(bookingId);
            }

            // Redirect back to bookings page
            response.sendRedirect("bookings");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing booking action: " + e.getMessage(), e);
        }
    }
}