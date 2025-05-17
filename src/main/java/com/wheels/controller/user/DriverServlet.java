package com.wheels.controller.user;

import com.wheels.DAO.DAOPublicBookings;
import com.wheels.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class DriverServlet extends HttpServlet {
    private DAOPublicBookings daoPublicBookings;

    @Override
    public void init() throws ServletException {
        daoPublicBookings = new DAOPublicBookings();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request.getSession());
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        if (!"driver".equals(SessionUtil.getUserRole(request.getSession()))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            request.setAttribute("bookings", daoPublicBookings.getDriverBookings(userId));
            request.getRequestDispatcher("/user/driver-bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve driver bookings.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request.getSession());
        if (userId == null || !"driver".equals(SessionUtil.getUserRole(request.getSession()))) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                boolean success = false;
                if ("accept".equals(action)) {
                    success = daoPublicBookings.acceptBooking(bookingId);
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/driver?success=Booking accepted successfully.");
                    } else {
                        request.setAttribute("error", "Failed to accept booking or booking is not in pending status.");
                    }
                } else if ("complete".equals(action)) {
                    success = daoPublicBookings.completeBooking(bookingId);
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/driver?success=Booking completed successfully.");
                    } else {
                        request.setAttribute("error", "Failed to complete booking or booking is not in active status.");
                    }
                }

                if (!success) {
                    request.setAttribute("bookings", daoPublicBookings.getDriverBookings(userId));
                    request.getRequestDispatcher("/user/driver-bookings.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid booking ID.");
                try {
                    request.setAttribute("bookings", daoPublicBookings.getDriverBookings(userId));
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }
                request.getRequestDispatcher("/user/driver-bookings.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred while processing the request.");
                try {
                    request.setAttribute("bookings", daoPublicBookings.getDriverBookings(userId));
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }
                request.getRequestDispatcher("/user/driver-bookings.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/driver");
        }
    }
}