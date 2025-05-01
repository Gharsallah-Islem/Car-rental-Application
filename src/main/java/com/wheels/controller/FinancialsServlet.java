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

@WebServlet(name = "FinancialsServlet", urlPatterns = {"/financials"})
public class FinancialsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int totalRevenue = DBUtil.getTotalRevenue();
            int totalExpenses = DBUtil.getTotalExpenses();
            int profitMargin = DBUtil.getProfitMargin();
            List<Map<String, Object>> financialSummary = DBUtil.getEarningsSummary();
            List<Map<String, Object>> transactions = DBUtil.getAllFinancialTransactions();
            List<Map<String, Object>> bookings = DBUtil.getAllBookings();

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalExpenses", totalExpenses);
            request.setAttribute("profitMargin", profitMargin);
            request.setAttribute("financialSummary", financialSummary);
            request.setAttribute("transactions", transactions);
            request.setAttribute("bookings", bookings);

            request.getRequestDispatcher("financials.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving financial data: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                Integer bookingId = request.getParameter("bookingId").isEmpty() ? null : Integer.parseInt(request.getParameter("bookingId"));
                String type = request.getParameter("type");
                String category = request.getParameter("category");
                double amount = Double.parseDouble(request.getParameter("amount"));
                Date transactionDate = Date.valueOf(request.getParameter("transactionDate"));
                String description = request.getParameter("description");
                String status = request.getParameter("status");
                DBUtil.addFinancialTransaction(bookingId, type, category, amount, transactionDate, description, status);
            } else if ("update".equals(action)) {
                int financialId = Integer.parseInt(request.getParameter("financialId"));
                Integer bookingId = request.getParameter("bookingId").isEmpty() ? null : Integer.parseInt(request.getParameter("bookingId"));
                String type = request.getParameter("type");
                String category = request.getParameter("category");
                double amount = Double.parseDouble(request.getParameter("amount"));
                Date transactionDate = Date.valueOf(request.getParameter("transactionDate"));
                String description = request.getParameter("description");
                String status = request.getParameter("status");
                DBUtil.updateFinancialTransaction(financialId, bookingId, type, category, amount, transactionDate, description, status);
            } else if ("delete".equals(action)) {
                int financialId = Integer.parseInt(request.getParameter("financialId"));
                DBUtil.deleteFinancialTransaction(financialId);
            }

            response.sendRedirect("financials");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing financial action: " + e.getMessage(), e);
        }
    }
}