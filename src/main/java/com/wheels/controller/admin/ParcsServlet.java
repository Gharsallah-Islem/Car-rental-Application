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

@WebServlet(name = "ParcsServlet", urlPatterns = {"/parcs"})
public class ParcsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all parcs
            List<Map<String, Object>> parcs = DBUtil.getAllParcs();
            request.setAttribute("parcs", parcs);

            // Forward to JSP
            request.getRequestDispatcher("parcs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving parcs data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String parcName = request.getParameter("parcName");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                DBUtil.addParc(parcName, address, city, capacity);
            } else if ("update".equals(action)) {
                int parcId = Integer.parseInt(request.getParameter("parcId"));
                String parcName = request.getParameter("parcName");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                DBUtil.updateParc(parcId, parcName, address, city, capacity);
            } else if ("delete".equals(action)) {
                int parcId = Integer.parseInt(request.getParameter("parcId"));
                DBUtil.deleteParc(parcId);
            }

            // Redirect back to parcs page
            response.sendRedirect("parcs");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing parc action: " + e.getMessage(), e);
        }
    }
}