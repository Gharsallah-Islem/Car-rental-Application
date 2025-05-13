package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAODashboard;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAODashboard implements IDAODashboard {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public int getTotalRevenue() {
        String sql = "SELECT SUM(amount) FROM financials WHERE type = 'income' AND status = 'completed'";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getTotalExpenses() {
        String sql = "SELECT SUM(amount) FROM financials WHERE type = 'expense' AND status = 'completed'";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getProfitMargin() {
        int revenue = getTotalRevenue();
        int expenses = getTotalExpenses();
        return revenue - expenses;
    }

    @Override
    public int countNewBookingsLastWeek() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countRentedCars() {
        String sql = "SELECT COUNT(*) FROM cars WHERE availability = FALSE OR availability IS NULL";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countAvailableCars() {
        String sql = "SELECT COUNT(*) FROM cars WHERE availability = TRUE";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Map<String, Object>> getEarningsSummary() {
        List<Map<String, Object>> summary = new ArrayList<>();
        String sql = "SELECT MONTHNAME(transaction_date) as month, type, SUM(amount) as total " +
                "FROM financials " +
                "WHERE YEAR(transaction_date) = YEAR(CURDATE()) " +
                "GROUP BY MONTH(transaction_date), type " +
                "ORDER BY MONTH(transaction_date)";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            Map<String, Map<String, Integer>> monthlyData = new HashMap<>();
            while (rs.next()) {
                String month = rs.getString("month");
                String type = rs.getString("type");
                int total = rs.getInt("total");
                monthlyData.computeIfAbsent(month, k -> new HashMap<>()).put(type, total);
            }
            String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
            for (String month : months) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("month", month.substring(0, 3));
                entry.put("income", monthlyData.getOrDefault(month, new HashMap<>()).getOrDefault("income", 0));
                entry.put("expense", monthlyData.getOrDefault(month, new HashMap<>()).getOrDefault("expense", 0));
                summary.add(entry);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }

    @Override
    public Map<String, Integer> getRentStatus() {
        Map<String, Integer> rentStatus = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM bookings GROUP BY status";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            int total = 0;
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                rentStatus.put(status, count);
                total += count;
            }
            final int finalTotal = total;
            rentStatus.replaceAll((k, v) -> finalTotal > 0 ? (v * 100 / finalTotal) : 0);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rentStatus;
    }

    @Override
    public Map<String, Integer> getCarTypeDistribution() {
        Map<String, Integer> carTypes = new HashMap<>();
        String sql = "SELECT car_type, COUNT(*) as count FROM cars GROUP BY car_type";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            int total = 0;
            while (rs.next()) {
                String type = rs.getString("car_type");
                int count = rs.getInt("count");
                carTypes.put(type, count);
                total += count;
            }
            final int finalTotal = total;
            carTypes.replaceAll((k, v) -> finalTotal > 0 ? (v * 100 / finalTotal) : 0);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carTypes;
    }
}