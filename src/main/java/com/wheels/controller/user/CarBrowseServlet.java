package com.wheels.controller.user;

import com.wheels.DAO.interfaces.IDAOPublicCars;
import com.wheels.DAO.DAOPublicCars;
import com.wheels.util.DatabaseSingleton;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class CarBrowseServlet extends HttpServlet {
    private IDAOPublicCars daoPublicCars;

    @Override
    public void init() throws ServletException {
        daoPublicCars = new DAOPublicCars();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/browse".equals(path)) {
            String location = request.getParameter("location");
            String carType = request.getParameter("carType");
            String pickUpDateStr = request.getParameter("pickUpDate");
            String dropOffDateStr = request.getParameter("dropOffDate");

            LocalDate pickUpDate = pickUpDateStr != null ? LocalDate.parse(pickUpDateStr) : null;
            LocalDate dropOffDate = dropOffDateStr != null ? LocalDate.parse(dropOffDateStr) : null;

            List<Map<String, Object>> cars = daoPublicCars.getAvailableCars(location, carType, pickUpDate, dropOffDate);
            request.setAttribute("cars", cars);

            List<String> locations = daoPublicCars.getDistinctLocations();
            List<String> carTypes = daoPublicCars.getDistinctCarTypes();
            request.setAttribute("locations", locations);
            request.setAttribute("carTypes", carTypes);

            request.getRequestDispatcher("/user/car-details.jsp").forward(request, response);
        } else if ("/car-details".equals(path)) {
            String carIdStr = request.getParameter("carId");
            if (carIdStr != null) {
                int carId = Integer.parseInt(carIdStr);
                Map<String, Object> car = daoPublicCars.getCarDetails(carId);
                List<String> features = daoPublicCars.getCarFeatures(carId);
                request.setAttribute("car", car);
                request.setAttribute("features", features);
                request.getRequestDispatcher("/user/car-details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Car ID is required");
            }
        } else if ("/featured".equals(path)) {
            List<Map<String, Object>> featuredCars = daoPublicCars.getRandomAvailableCars(6);
            response.setContentType("text/html");
            String contextPath = request.getContextPath();
            try (PrintWriter out = response.getWriter()) {
                out.println("<div id='car-container' style='display: flex; flex-direction: row; overflow-x: auto; gap: 20px; padding: 20px; scroll-snap-type: x mandatory; -webkit-overflow-scrolling: touch; scrollbar-width: none; -ms-overflow-style: none;'>");
                out.println("<style>#car-container::-webkit-scrollbar { display: none; }</style>");
                if (featuredCars != null && !featuredCars.isEmpty()) {
                    int index = 0;
                    for (Map<String, Object> car : featuredCars) {
                        int pageNum = (index / 3) + 1;
                        out.println("<div class='car-card' data-page='" + pageNum + "' style='flex: 0 0 360px; background: linear-gradient(145deg, #ffffff, #f0f0f0); border-radius: 20px; overflow: hidden; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15); position: relative; transition: transform 0.4s ease, box-shadow 0.4s ease; transform: perspective(1000px) rotateY(0deg); display: none; scroll-snap-align: start;'>");
                        // Image with reflective effect
                        out.println("<div style='position: relative; width: 100%; height: 240px;'>");
                        out.println("<img src='" + (car.get("image_url") != null ? car.get("image_url") : "https://via.placeholder.com/360x240") + "' alt='" + car.get("brand") + " " + car.get("model") + "' style='width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s ease;'>");
                        out.println("<div style='position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(to bottom, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.6));'></div>");
                        out.println("<div style='position: absolute; bottom: 0; left: 0; width: 100%; height: 30%; background: linear-gradient(to top, rgba(255, 255, 255, 0.2), transparent);'></div>");
                        // Featured badge
                        out.println("<span style='position: absolute; top: 20px; right: 20px; background: linear-gradient(90deg, #d4af37, #b89729); color: #2c2c2c; padding: 8px 16px; border-radius: 20px; font-size: 12px; font-weight: 600; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);'>Featured</span>");
                        out.println("</div>");
                        // Details section
                        out.println("<div class='details' style='padding: 20px; text-align: center; background: #ffffff;'>");
                        out.println("<h3 style='font-family: \"Playfair Display\", serif; font-size: 26px; font-weight: 700; color: #1a1a1a; margin-bottom: 8px; text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);'>" + car.get("brand") + " " + car.get("model") + "</h3>");
                        out.println("<p style='color: #666666; font-size: 14px; margin-bottom: 12px;'>" + car.get("car_type") + " | " + car.get("city") + "</p>");
                        out.println("<p class='price' style='font-size: 24px; font-weight: 700; color: #a91b0d; margin-bottom: 16px; text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);'>$" + car.get("price_per_day") + "<span style='font-size: 14px; font-weight: 400; color: #666666;'>/day</span></p>");
                        out.println("</div>");
                        // Actions section
                        out.println("<div class='actions' style='display: flex; justify-content: space-between; gap: 12px; padding: 0 20px 20px; background: #ffffff;'>");
                        out.println("<a href='" + contextPath + "/car-details?carId=" + car.get("car_id") + "' style='flex: 1; background: linear-gradient(90deg, #d4af37, #b89729); color: #2c2c2c; padding: 10px 16px; border-radius: 10px; font-weight: 600; text-decoration: none; font-size: 14px; text-align: center; transition: background 0.3s ease, box-shadow 0.3s ease;'>Details</a>");
                        out.println("<a href='" + contextPath + "/book?carId=" + car.get("car_id") + "' style='flex: 1; background: linear-gradient(90deg, #a91b0d, #d32f2f); color: #ffffff; padding: 10px 16px; border-radius: 10px; font-weight: 600; text-decoration: none; font-size: 14px; text-align: center; transition: background 0.3s ease, box-shadow 0.3s ease;'>Book Now</a>");
                        out.println("</div>");
                        out.println("</div>");
                        index++;
                    }
                } else {
                    out.println("<p style='color: #1a1a1a; text-align: center; font-size: 18px;'>No featured cars available this month.</p>");
                }
                out.println("</div>");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}