package com.wheels.controller;

import com.wheels.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ClientsServlet", urlPatterns = {"/clients"})
public class ClientsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all clients
            List<Map<String, Object>> clients = DBUtil.getAllClients();

            request.setAttribute("clients", clients);

            // Forward to JSP
            request.getRequestDispatcher("clients.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving clients data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password"); // Should be hashed in production
                DBUtil.addClient(fullName, email, phone, password);
            } else if ("update".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                DBUtil.updateClient(userId, fullName, email, phone);
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                if (DBUtil.hasActiveBookings(userId)) {
                    request.setAttribute("errorMessage", "Cannot delete client with active bookings.");
                    List<Map<String, Object>> clients = DBUtil.getAllClients();
                    request.setAttribute("clients", clients);
                    request.getRequestDispatcher("clients.jsp").forward(request, response);
                    return;
                }
                DBUtil.deleteClient(userId);
            }

            // Redirect back to clients page
            response.sendRedirect("clients");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing client action: " + e.getMessage(), e);
        }
    }
}