package com.wheels.controller.admin;

import com.wheels.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@WebServlet(name = "DriversServlet", urlPatterns = {"/drivers"})
public class DriversServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all drivers using getAllDrivers() to include email, phone, and created_at
            List<Map<String, Object>> drivers = DBUtil.getAllDrivers();

            // Log the data being passed to JSP
            System.out.println("DriversServlet: Data being passed to drivers.jsp: " + drivers);

            request.setAttribute("drivers", drivers);

            // Forward to JSP
            request.getRequestDispatcher("drivers.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving drivers data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String fullName = request.getParameter("fullName").trim();
                String email = request.getParameter("email").trim();
                String phone = request.getParameter("phone").trim();
                String password = request.getParameter("password");

                // Validation
                if (fullName.isEmpty() || email.isEmpty() || phone.isEmpty() || password.isEmpty()) {
                    throw new IllegalArgumentException("All fields are required.");
                }
                if (!EMAIL_PATTERN.matcher(email).matches()) {
                    throw new IllegalArgumentException("Invalid email format.");
                }
                if (!DBUtil.isEmailUnique(email, null)) {
                    throw new IllegalArgumentException("Email already exists.");
                }
                if (password.length() < 6) {
                    throw new IllegalArgumentException("Password must be at least 6 characters long.");
                }

                DBUtil.addDriver(fullName, email, phone, password);
            } else if ("update".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String fullName = request.getParameter("fullName").trim();
                String email = request.getParameter("email").trim();
                String phone = request.getParameter("phone").trim();

                // Validation
                if (fullName.isEmpty() || email.isEmpty() || phone.isEmpty()) {
                    throw new IllegalArgumentException("All fields are required.");
                }
                if (!EMAIL_PATTERN.matcher(email).matches()) {
                    throw new IllegalArgumentException("Invalid email format.");
                }
                if (!DBUtil.isEmailUnique(email, userId)) {
                    throw new IllegalArgumentException("Email already exists.");
                }

                DBUtil.updateDriver(userId, fullName, email, phone);
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                DBUtil.deleteDriver(userId);
            }

            // Redirect back to drivers page
            response.sendRedirect("drivers");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            // Use getAllDrivers() to fetch the full driver data for display
            List<Map<String, Object>> drivers = DBUtil.getAllDrivers();
            request.setAttribute("drivers", drivers);
            request.getRequestDispatcher("drivers.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing driver action: " + e.getMessage(), e);
        }
    }
}