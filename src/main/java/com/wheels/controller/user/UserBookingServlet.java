package com.wheels.controller.user;

import com.wheels.DAO.DAOPublicBookings;
import com.wheels.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class UserBookingServlet extends HttpServlet {
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

        try {
            request.setAttribute("bookings", daoPublicBookings.getUserBookings(userId));
            request.getRequestDispatcher("/user/my-bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve bookings.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request.getSession());
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");

        if ("cancel".equals(action) && bookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                boolean success = daoPublicBookings.cancelBooking(bookingId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/my-bookings?success=Booking cancelled successfully.");
                } else {
                    request.setAttribute("error", "Failed to cancel booking or booking is not cancellable.");
                    request.getRequestDispatcher("/user/my-bookings.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid booking ID.");
                request.getRequestDispatcher("/user/my-bookings.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred while cancelling booking.");
                request.getRequestDispatcher("/user/my-bookings.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
        }
    }
}