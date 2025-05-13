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

@WebServlet(name = "TrackingServlet", urlPatterns = {"/tracking"})
public class TrackingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all tracking data and cars for the JSP
            List<Map<String, Object>> trackingData = DBUtil.getAllTrackingData();
            List<Map<String, Object>> cars = DBUtil.getAllCarsForFilter();

            request.setAttribute("trackingData", trackingData);
            request.setAttribute("cars", cars);

            // Check if filtering by car and date range
            String carIdParam = request.getParameter("carId");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");

            if (carIdParam != null && !carIdParam.isEmpty() && startDateParam != null && endDateParam != null) {
                int carId = Integer.parseInt(carIdParam);
                Date startDate = Date.valueOf(startDateParam);
                Date endDate = Date.valueOf(endDateParam);
                List<Map<String, Object>> trackingHistory = DBUtil.getTrackingHistoryForCar(carId, startDate, endDate);
                request.setAttribute("trackingHistory", trackingHistory);
                request.setAttribute("selectedCarId", carId);
                request.setAttribute("selectedStartDate", startDateParam);
                request.setAttribute("selectedEndDate", endDateParam);
            }

            request.getRequestDispatcher("tracking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving tracking data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                double latitude = Double.parseDouble(request.getParameter("latitude"));
                double longitude = Double.parseDouble(request.getParameter("longitude"));
                String status = request.getParameter("status");
                DBUtil.addTrackingRecord(carId, latitude, longitude, status);
            } else if ("delete".equals(action)) {
                int trackingId = Integer.parseInt(request.getParameter("trackingId"));
                DBUtil.deleteTrackingRecord(trackingId);
            }

            response.sendRedirect("tracking");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing tracking action: " + e.getMessage(), e);
        }
    }
}