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

@WebServlet(name = "UnitsServlet", urlPatterns = {"/units"})
public class UnitsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all cars and parcs
            List<Map<String, Object>> cars = DBUtil.getAllCars();
            List<Map<String, Object>> parcs = DBUtil.getAllParcs();

            request.setAttribute("cars", cars);
            request.setAttribute("parcs", parcs);

            // Forward to JSP
            request.getRequestDispatcher("units.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving cars data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String brand = request.getParameter("brand");
                String model = request.getParameter("model");
                String carType = request.getParameter("carType");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
                String licensePlate = request.getParameter("licensePlate");
                String parcIdStr = request.getParameter("parcId");
                Integer parcId = parcIdStr != null && !parcIdStr.isEmpty() ? Integer.parseInt(parcIdStr) : null;
                DBUtil.addCar(brand, model, carType, capacity, pricePerDay, licensePlate, parcId);
            } else if ("update".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                String brand = request.getParameter("brand");
                String model = request.getParameter("model");
                String carType = request.getParameter("carType");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
                String licensePlate = request.getParameter("licensePlate");
                String parcIdStr = request.getParameter("parcId");
                Integer parcId = parcIdStr != null && !parcIdStr.isEmpty() ? Integer.parseInt(parcIdStr) : null;
                DBUtil.updateCar(carId, brand, model, carType, capacity, pricePerDay, licensePlate, parcId);
            } else if ("delete".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                DBUtil.deleteCar(carId);
            }

            // Redirect back to units page
            response.sendRedirect("units");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing car action: " + e.getMessage(), e);
        }
    }
}