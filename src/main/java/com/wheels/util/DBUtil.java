package com.wheels.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// For password hashing (simple example; use BCrypt in production)
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class DBUtil {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    public static Connection getConnection() throws SQLException {
        return dbSingleton.getConnection();
    }

    // Password hashing method (simple SHA-256 for demonstration; use BCrypt in production)
    private static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password; // Fallback (not secure)
        }
    }

    // Check if an email is unique (used for Clients and Drivers)
    public static boolean isEmailUnique(String email, Integer excludeUserId) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND (user_id != ? OR ? IS NULL)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            if (excludeUserId != null) {
                stmt.setInt(2, excludeUserId);
                stmt.setInt(3, excludeUserId);
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Dashboard Metrics
    public static int getTotalRevenue() {
        String sql = "SELECT SUM(amount) FROM financials WHERE type = 'income' AND status = 'completed'";
        try (Connection conn = getConnection();
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

    public static int getTotalExpenses() {
        String sql = "SELECT SUM(amount) FROM financials WHERE type = 'expense' AND status = 'completed'";
        try (Connection conn = getConnection();
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

    public static int getProfitMargin() {
        int revenue = getTotalRevenue();
        int expenses = getTotalExpenses();
        return revenue - expenses;
    }

    public static int countNewBookingsLastWeek() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        try (Connection conn = getConnection();
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

    public static int countRentedCars() {
        String sql = "SELECT COUNT(*) FROM cars WHERE availability = FALSE OR availability IS NULL";
        try (Connection conn = getConnection();
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

    public static int countAvailableCars() {
        String sql = "SELECT COUNT(*) FROM cars WHERE availability = TRUE";
        try (Connection conn = getConnection();
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

    // Charts Data
    public static List<Map<String, Object>> getEarningsSummary() {
        List<Map<String, Object>> summary = new ArrayList<>();
        String sql = "SELECT MONTHNAME(transaction_date) as month, type, SUM(amount) as total " +
                "FROM financials " +
                "WHERE YEAR(transaction_date) = YEAR(CURDATE()) " +
                "GROUP BY MONTH(transaction_date), type " +
                "ORDER BY MONTH(transaction_date)";
        try (Connection conn = getConnection();
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

    public static Map<String, Integer> getRentStatus() {
        Map<String, Integer> rentStatus = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM bookings GROUP BY status";
        try (Connection conn = getConnection();
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

    public static Map<String, Integer> getCarTypeDistribution() {
        Map<String, Integer> carTypes = new HashMap<>();
        String sql = "SELECT car_type, COUNT(*) as count FROM cars GROUP BY car_type";
        try (Connection conn = getConnection();
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

    // Financials Management
    public static List<Map<String, Object>> getAllFinancialTransactions() {
        List<Map<String, Object>> transactions = new ArrayList<>();
        String sql = "SELECT f.financial_id, f.booking_id, f.type, f.category, f.amount, f.transaction_date, f.description, f.status, " +
                "b.total_cost as booking_cost, u.full_name as client_name, c.brand, c.model " +
                "FROM financials f " +
                "LEFT JOIN bookings b ON f.booking_id = b.booking_id " +
                "LEFT JOIN users u ON b.user_id = u.user_id " +
                "LEFT JOIN cars c ON b.car_id = c.car_id " +
                "ORDER BY f.transaction_date DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> transaction = new HashMap<>();
                transaction.put("financial_id", rs.getInt("financial_id"));
                transaction.put("booking_id", rs.getObject("booking_id"));
                transaction.put("type", rs.getString("type"));
                transaction.put("category", rs.getString("category"));
                transaction.put("amount", rs.getDouble("amount"));
                transaction.put("transaction_date", rs.getDate("transaction_date"));
                transaction.put("description", rs.getString("description"));
                transaction.put("status", rs.getString("status"));
                transaction.put("booking_cost", rs.getObject("booking_cost"));
                transaction.put("client_name", rs.getString("client_name"));
                transaction.put("car_model", rs.getString("brand") != null ? rs.getString("brand") + " " + rs.getString("model") : null);
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching financial transactions: " + e.getMessage());
        }
        return transactions;
    }

    public static void addFinancialTransaction(Integer bookingId, String type, String category, double amount, java.sql.Date transactionDate, String description, String status) {
        String sql = "INSERT INTO financials (booking_id, type, category, amount, transaction_date, description, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (bookingId != null) {
                stmt.setInt(1, bookingId);
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, type);
            stmt.setString(3, category);
            stmt.setDouble(4, amount);
            stmt.setDate(5, transactionDate);
            stmt.setString(6, description);
            stmt.setString(7, status);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding financial transaction: " + e.getMessage());
        }
    }

    public static void updateFinancialTransaction(int financialId, Integer bookingId, String type, String category, double amount, java.sql.Date transactionDate, String description, String status) {
        String sql = "UPDATE financials SET booking_id = ?, type = ?, category = ?, amount = ?, transaction_date = ?, description = ?, status = ? WHERE financial_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (bookingId != null) {
                stmt.setInt(1, bookingId);
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, type);
            stmt.setString(3, category);
            stmt.setDouble(4, amount);
            stmt.setDate(5, transactionDate);
            stmt.setString(6, description);
            stmt.setString(7, status);
            stmt.setInt(8, financialId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating financial transaction: " + e.getMessage());
        }
    }

    public static void deleteFinancialTransaction(int financialId) {
        String sql = "DELETE FROM financials WHERE financial_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, financialId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting financial transaction: " + e.getMessage());
        }
    }

    // Recent Bookings (with Search and Filter Support)
    public static List<Map<String, Object>> getRecentBookings(String year, String searchQuery, String filterStatus, Integer clientId, Integer carId, Integer driverId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.booking_date, b.start_date, b.end_date, b.total_cost, b.status, b.payment_status, " +
                        "u.full_name as client_name, c.brand, c.model, d.full_name as driver_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN cars c ON b.car_id = c.car_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        // Apply year filter
        if (year != null && !year.isEmpty() && !year.equals("All")) {
            sql.append(" AND YEAR(b.booking_date) = ?");
            params.add(Integer.parseInt(year));
        }

        // Apply search query (client name or car model)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR CONCAT(c.brand, ' ', c.model) LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Apply status filter
        if (filterStatus != null && !filterStatus.equals("All")) {
            sql.append(" AND b.status = ?");
            params.add(filterStatus);
        }

        // Apply client filter
        if (clientId != null) {
            sql.append(" AND b.user_id = ?");
            params.add(clientId);
        }

        // Apply car filter
        if (carId != null) {
            sql.append(" AND b.car_id = ?");
            params.add(carId);
        }

        // Apply driver filter
        if (driverId != null) {
            sql.append(" AND b.driver_id = ?");
            params.add(driverId);
        }

        sql.append(" ORDER BY b.created_at DESC LIMIT 5");

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("booking_date", rs.getDate("booking_date"));
                booking.put("client_name", rs.getString("client_name"));
                booking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                java.sql.Date startDate = rs.getDate("start_date");
                java.sql.Date endDate = rs.getDate("end_date");
                booking.put("start_date", startDate);
                booking.put("end_date", endDate);
                if (startDate != null && endDate != null) {
                    long days = ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate());
                    booking.put("booking_days", days);
                } else {
                    booking.put("booking_days", 0L);
                }
                booking.put("total_cost", rs.getDouble("total_cost"));
                booking.put("status", rs.getString("status"));
                booking.put("payment_status", rs.getString("payment_status"));
                booking.put("driver_name", rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // Reminders
    public static List<Map<String, Object>> getPendingReminders() {
        List<Map<String, Object>> reminders = new ArrayList<>();
        String sql = "SELECT title, description, due_date FROM reminders WHERE status = 'pending'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> reminder = new HashMap<>();
                reminder.put("title", rs.getString("title"));
                reminder.put("description", rs.getString("description"));
                reminder.put("due_date", rs.getDate("due_date"));
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reminders;
    }

    // Parcs Management
    public static List<Map<String, Object>> getAllParcs() {
        List<Map<String, Object>> parcs = new ArrayList<>();
        String sql = "SELECT p.parc_id, p.parc_name, p.address, p.city, p.capacity, " +
                "COUNT(c.car_id) as car_count " +
                "FROM parcs p " +
                "LEFT JOIN cars c ON p.parc_id = c.parc_id " +
                "GROUP BY p.parc_id";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> parc = new HashMap<>();
                parc.put("parc_id", rs.getInt("parc_id"));
                parc.put("parc_name", rs.getString("parc_name"));
                parc.put("address", rs.getString("address"));
                parc.put("city", rs.getString("city"));
                parc.put("capacity", rs.getInt("capacity"));
                parc.put("car_count", rs.getInt("car_count"));
                parcs.add(parc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return parcs;
    }

    public static void addParc(String parcName, String address, String city, int capacity) {
        String sql = "INSERT INTO parcs (parc_name, address, city, capacity) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, parcName);
            stmt.setString(2, address);
            stmt.setString(3, city);
            stmt.setInt(4, capacity);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void updateParc(int parcId, String parcName, String address, String city, int capacity) {
        String sql = "UPDATE parcs SET parc_name = ?, address = ?, city = ?, capacity = ? WHERE parc_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, parcName);
            stmt.setString(2, address);
            stmt.setString(3, city);
            stmt.setInt(4, capacity);
            stmt.setInt(5, parcId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void deleteParc(int parcId) {
        String sql = "DELETE FROM parcs WHERE parc_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, parcId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Bookings Management
    public static List<Map<String, Object>> getAllBookings() {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.booking_date, b.start_date, b.end_date, b.total_cost, b.status, b.payment_status, " +
                "u.full_name as client_name, c.brand, c.model, p.parc_name, d.full_name as driver_name " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.user_id " +
                "JOIN cars c ON b.car_id = c.car_id " +
                "LEFT JOIN parcs p ON c.parc_id = p.parc_id " +
                "LEFT JOIN users d ON b.driver_id = d.user_id " +
                "ORDER BY b.created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("booking_date", rs.getDate("booking_date"));
                booking.put("client_name", rs.getString("client_name"));
                booking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                booking.put("parc_name", rs.getString("parc_name") != null ? rs.getString("parc_name") : "-");
                java.sql.Date startDate = rs.getDate("start_date");
                java.sql.Date endDate = rs.getDate("end_date");
                booking.put("start_date", startDate);
                booking.put("end_date", endDate);
                if (startDate != null && endDate != null) {
                    long days = ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate());
                    booking.put("booking_days", days);
                } else {
                    booking.put("booking_days", 0L);
                }
                booking.put("total_cost", rs.getDouble("total_cost"));
                booking.put("status", rs.getString("status"));
                booking.put("payment_status", rs.getString("payment_status"));
                booking.put("driver_name", rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // Car Availability Check
    public static List<Map<String, Object>> checkCarAvailability(String carType, java.sql.Date checkDate, String checkTime) {
        List<Map<String, Object>> availableCars = new ArrayList<>();
        String sql = "SELECT c.car_id, c.brand, c.model, c.price_per_day " +
                "FROM cars c " +
                "LEFT JOIN bookings b ON c.car_id = b.car_id " +
                "AND (b.start_date <= ? AND b.end_date >= ? AND b.status NOT IN ('cancelled')) " +
                "WHERE c.car_type = ? " +
                "AND c.availability = TRUE " +
                "AND (b.booking_id IS NULL OR b.status = 'cancelled')";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            java.sql.Timestamp checkDateTime = java.sql.Timestamp.valueOf(checkDate.toString() + " " + checkTime + ":00");
            stmt.setTimestamp(1, checkDateTime);
            stmt.setTimestamp(2, checkDateTime);
            stmt.setString(3, carType);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                car.put("price_per_day", rs.getDouble("price_per_day"));
                availableCars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableCars;
    }

    public static List<Map<String, Object>> getAvailableCars() {
        List<Map<String, Object>> cars = new ArrayList<>();
        String sql = "SELECT car_id, brand, model FROM cars WHERE availability = TRUE";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    public static List<Map<String, Object>> getClients() {
        List<Map<String, Object>> clients = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE role = 'client'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> client = new HashMap<>();
                client.put("user_id", rs.getInt("user_id"));
                client.put("full_name", rs.getString("full_name"));
                clients.add(client);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clients;
    }

    public static List<Map<String, Object>> getDrivers() {
        List<Map<String, Object>> drivers = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE role = 'driver'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> driver = new HashMap<>();
                driver.put("user_id", rs.getInt("user_id"));
                driver.put("full_name", rs.getString("full_name"));
                drivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drivers;
    }

    public static List<Map<String, Object>> getAllCarsForFilter() {
        List<Map<String, Object>> cars = new ArrayList<>();
        String sql = "SELECT car_id, brand, model FROM cars ORDER BY brand, model";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    public static List<Map<String, Object>> getAllClientsForFilter() {
        List<Map<String, Object>> clients = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE role = 'client' ORDER BY full_name";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> client = new HashMap<>();
                client.put("user_id", rs.getInt("user_id"));
                client.put("full_name", rs.getString("full_name"));
                clients.add(client);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clients;
    }

    public static List<Map<String, Object>> getAllDriversForFilter() {
        List<Map<String, Object>> drivers = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE role = 'driver' ORDER BY full_name";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> driver = new HashMap<>();
                driver.put("user_id", rs.getInt("user_id"));
                driver.put("full_name", rs.getString("full_name"));
                drivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drivers;
    }

    public static List<String> getCarTypes() {
        List<String> carTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT car_type FROM cars ORDER BY car_type";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                carTypes.add(rs.getString("car_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carTypes;
    }

    public static void addBooking(int userId, int carId, java.sql.Date bookingDate, java.sql.Date startDate, java.sql.Date endDate, double totalCost, Integer driverId) {
        String sql = "INSERT INTO bookings (user_id, car_id, booking_date, start_date, end_date, total_cost, status, payment_status, driver_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'pending', 'pending', ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, carId);
            stmt.setDate(3, bookingDate);
            stmt.setDate(4, startDate);
            stmt.setDate(5, endDate);
            stmt.setDouble(6, totalCost);
            if (driverId != null) {
                stmt.setInt(7, driverId);
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }
            stmt.executeUpdate();

            String updateCarSql = "UPDATE cars SET availability = FALSE WHERE car_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateCarSql)) {
                updateStmt.setInt(1, carId);
                updateStmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void updateBooking(int bookingId, java.sql.Date startDate, java.sql.Date endDate, double totalCost, String status, String paymentStatus, Integer driverId) {
        String sql = "UPDATE bookings SET start_date = ?, end_date = ?, total_cost = ?, status = ?, payment_status = ?, driver_id = ? WHERE booking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            stmt.setDouble(3, totalCost);
            stmt.setString(4, status);
            stmt.setString(5, paymentStatus);
            if (driverId != null) {
                stmt.setInt(6, driverId);
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }
            stmt.setInt(7, bookingId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void cancelBooking(int bookingId) {
        String getCarSql = "SELECT car_id FROM bookings WHERE booking_id = ?";
        int carId = -1;
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getCarSql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                carId = rs.getInt("car_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql = "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();

            if (carId != -1) {
                String updateCarSql = "UPDATE cars SET availability = TRUE WHERE car_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateCarSql)) {
                    updateStmt.setInt(1, carId);
                    updateStmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Calendar Support
    public static List<Map<String, Object>> getBookingsForCalendar(java.sql.Date startDate, java.sql.Date endDate, Integer carId, Integer clientId, Integer driverId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.start_date, b.end_date, b.status, " +
                        "u.full_name as client_name, c.brand, c.model, d.full_name as driver_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN cars c ON b.car_id = c.car_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE b.start_date <= ? AND b.end_date >= ?"
        );

        // Add filters to the WHERE clause
        List<Object> params = new ArrayList<>();
        params.add(endDate);
        params.add(startDate);

        if (carId != null) {
            sql.append(" AND b.car_id = ?");
            params.add(carId);
        }
        if (clientId != null) {
            sql.append(" AND b.user_id = ?");
            params.add(clientId);
        }
        if (driverId != null) {
            sql.append(" AND b.driver_id = ?");
            params.add(driverId);
        }

        sql.append(" ORDER BY b.start_date");

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("start_date", rs.getDate("start_date"));
                booking.put("end_date", rs.getDate("end_date"));
                booking.put("status", rs.getString("status"));
                booking.put("client_name", rs.getString("client_name"));
                booking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                booking.put("driver_name", rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching bookings for calendar: " + e.getMessage());
        }
        return bookings;
    }

    // Units (Cars) Management
    public static List<Map<String, Object>> getAllCars() {
        List<Map<String, Object>> cars = new ArrayList<>();
        String sql = "SELECT c.car_id, c.brand, c.model, c.car_type, c.capacity, c.price_per_day, c.license_plate, c.availability, c.created_at, p.parc_name " +
                "FROM cars c " +
                "LEFT JOIN parcs p ON c.parc_id = p.parc_id";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("brand", rs.getString("brand"));
                car.put("model", rs.getString("model"));
                car.put("car_type", rs.getString("car_type"));
                car.put("capacity", rs.getInt("capacity"));
                car.put("price_per_day", rs.getDouble("price_per_day"));
                car.put("license_plate", rs.getString("license_plate"));
                car.put("availability", rs.getBoolean("availability"));
                car.put("created_at", rs.getTimestamp("created_at"));
                car.put("parc_name", rs.getString("parc_name") != null ? rs.getString("parc_name") : "-");
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    public static void addCar(String brand, String model, String carType, int capacity, double pricePerDay, String licensePlate, Integer parcId) {
        String sql = "INSERT INTO cars (brand, model, car_type, capacity, price_per_day, license_plate, availability, parc_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, TRUE, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, brand);
            stmt.setString(2, model);
            stmt.setString(3, carType);
            stmt.setInt(4, capacity);
            stmt.setDouble(5, pricePerDay);
            stmt.setString(6, licensePlate);
            if (parcId != null) {
                stmt.setInt(7, parcId);
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void updateCar(int carId, String brand, String model, String carType, int capacity, double pricePerDay, String licensePlate, Integer parcId) {
        String sql = "UPDATE cars SET brand = ?, model = ?, car_type = ?, capacity = ?, price_per_day = ?, license_plate = ?, parc_id = ? WHERE car_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, brand);
            stmt.setString(2, model);
            stmt.setString(3, carType);
            stmt.setInt(4, capacity);
            stmt.setDouble(5, pricePerDay);
            stmt.setString(6, licensePlate);
            if (parcId != null) {
                stmt.setInt(7, parcId);
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }
            stmt.setInt(8, carId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void deleteCar(int carId) {
        String sql = "DELETE FROM cars WHERE car_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Clients Management
    public static List<Map<String, Object>> getAllClients() {
        List<Map<String, Object>> clients = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, phone, created_at " +
                "FROM users " +
                "WHERE role = 'client' " +
                "ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> client = new HashMap<>();
                client.put("user_id", rs.getInt("user_id"));
                client.put("full_name", rs.getString("full_name"));
                client.put("email", rs.getString("email"));
                client.put("phone", rs.getString("phone"));
                client.put("created_at", rs.getTimestamp("created_at"));
                clients.add(client);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clients;
    }

    public static void addClient(String fullName, String email, String phone, String password) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role) " +
                "VALUES (?, ?, ?, ?, 'client')";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, hashPassword(password));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding client: " + e.getMessage());
        }
    }

    public static void updateClient(int userId, String fullName, String email, String phone) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ? AND role = 'client'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setInt(4, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating client: " + e.getMessage());
        }
    }

    public static boolean hasActiveBookings(int userId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE user_id = ? AND status NOT IN ('cancelled', 'completed')";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void deleteClient(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ? AND role = 'client'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting client: " + e.getMessage());
        }
    }

    // Drivers Management
    public static List<Map<String, Object>> getAllDrivers() {
        List<Map<String, Object>> drivers = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, phone, created_at " +
                "FROM users WHERE role = 'driver' " +
                "ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> driver = new HashMap<>();
                driver.put("user_id", rs.getInt("user_id"));
                driver.put("full_name", rs.getString("full_name"));
                driver.put("email", rs.getString("email") != null ? rs.getString("email") : "-");
                driver.put("phone", rs.getString("phone") != null ? rs.getString("phone") : "-");
                driver.put("created_at", rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at") : "-");
                drivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching drivers: " + e.getMessage());
        }
        return drivers;
    }

    public static void addDriver(String fullName, String email, String phone, String password) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role) " +
                "VALUES (?, ?, ?, ?, 'driver')";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, hashPassword(password));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding driver: " + e.getMessage());
        }
    }

    public static void updateDriver(int userId, String fullName, String email, String phone) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ? AND role = 'driver'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setInt(4, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating driver: " + e.getMessage());
        }
    }

    public static boolean hasActiveDriverBookings(int userId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE driver_id = ? AND status NOT IN ('cancelled', 'completed')";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void deleteDriver(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ? AND role = 'driver'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting driver: " + e.getMessage());
        }
    }

    // Tracking Management
    public static List<Map<String, Object>> getAllTrackingData() {
        List<Map<String, Object>> trackingData = new ArrayList<>();
        String sql = "SELECT t.tracking_id, t.car_id, t.latitude, t.longitude, t.timestamp, t.status, " +
                "c.brand, c.model, c.license_plate " +
                "FROM tracking t " +
                "JOIN cars c ON t.car_id = c.car_id " +
                "ORDER BY t.timestamp DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> tracking = new HashMap<>();
                tracking.put("tracking_id", rs.getInt("tracking_id"));
                tracking.put("car_id", rs.getInt("car_id"));
                tracking.put("latitude", rs.getDouble("latitude"));
                tracking.put("longitude", rs.getDouble("longitude"));
                tracking.put("timestamp", rs.getTimestamp("timestamp"));
                tracking.put("status", rs.getString("status"));
                tracking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                tracking.put("license_plate", rs.getString("license_plate"));
                trackingData.add(tracking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching tracking data: " + e.getMessage());
        }
        return trackingData;
    }

    public static Map<String, Object> getLatestLocationForCar(int carId) {
        Map<String, Object> location = new HashMap<>();
        String sql = "SELECT t.latitude, t.longitude, t.timestamp, t.status, " +
                "c.brand, c.model, c.license_plate " +
                "FROM tracking t " +
                "JOIN cars c ON t.car_id = c.car_id " +
                "WHERE t.car_id = ? " +
                "ORDER BY t.timestamp DESC LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                location.put("car_id", carId);
                location.put("latitude", rs.getDouble("latitude"));
                location.put("longitude", rs.getDouble("longitude"));
                location.put("timestamp", rs.getTimestamp("timestamp"));
                location.put("status", rs.getString("status"));
                location.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                location.put("license_plate", rs.getString("license_plate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching latest location for car: " + e.getMessage());
        }
        return location;
    }

    public static List<Map<String, Object>> getTrackingHistoryForCar(int carId, java.sql.Date startDate, java.sql.Date endDate) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT t.tracking_id, t.latitude, t.longitude, t.timestamp, t.status, " +
                "c.brand, c.model, c.license_plate " +
                "FROM tracking t " +
                "JOIN cars c ON t.car_id = c.car_id " +
                "WHERE t.car_id = ? AND t.timestamp BETWEEN ? AND ? " +
                "ORDER BY t.timestamp ASC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setDate(2, startDate);
            stmt.setDate(3, endDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> tracking = new HashMap<>();
                tracking.put("tracking_id", rs.getInt("tracking_id"));
                tracking.put("car_id", carId);
                tracking.put("latitude", rs.getDouble("latitude"));
                tracking.put("longitude", rs.getDouble("longitude"));
                tracking.put("timestamp", rs.getTimestamp("timestamp"));
                tracking.put("status", rs.getString("status"));
                tracking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                tracking.put("license_plate", rs.getString("license_plate"));
                history.add(tracking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching tracking history for car: " + e.getMessage());
        }
        return history;
    }

    public static void addTrackingRecord(int carId, double latitude, double longitude, String status) {
        String sql = "INSERT INTO tracking (car_id, latitude, longitude, timestamp, status) VALUES (?, ?, ?, NOW(), ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setDouble(2, latitude);
            stmt.setDouble(3, longitude);
            stmt.setString(4, status);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding tracking record: " + e.getMessage());
        }
    }

    public static void deleteTrackingRecord(int trackingId) {
        String sql = "DELETE FROM tracking WHERE tracking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, trackingId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting tracking record: " + e.getMessage());
        }
    }

    // Messages Management
    public static List<Map<String, Object>> getAllMessages() {
        List<Map<String, Object>> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.sender_id, m.receiver_id, m.message_text, m.sent_at, m.read_status, " +
                "s.full_name as sender_name, r.full_name as receiver_name " +
                "FROM messages m " +
                "JOIN users s ON m.sender_id = s.user_id " +
                "JOIN users r ON m.receiver_id = r.user_id " +
                "ORDER BY m.sent_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> message = new HashMap<>();
                message.put("message_id", rs.getInt("message_id"));
                message.put("sender_id", rs.getInt("sender_id"));
                message.put("receiver_id", rs.getInt("receiver_id"));
                message.put("message_text", rs.getString("message_text"));
                message.put("sent_at", rs.getTimestamp("sent_at"));
                message.put("read_status", rs.getBoolean("read_status"));
                message.put("sender_name", rs.getString("sender_name"));
                message.put("receiver_name", rs.getString("receiver_name"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching messages: " + e.getMessage());
        }
        return messages;
    }

    public static List<Map<String, Object>> getConversationBetweenUsers(int userId1, int userId2) {
        List<Map<String, Object>> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.sender_id, m.receiver_id, m.message_text, m.sent_at, m.read_status, " +
                "s.full_name as sender_name, r.full_name as receiver_name " +
                "FROM messages m " +
                "JOIN users s ON m.sender_id = s.user_id " +
                "JOIN users r ON m.receiver_id = r.user_id " +
                "WHERE (m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?) " +
                "ORDER BY m.sent_at ASC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId1);
            stmt.setInt(2, userId2);
            stmt.setInt(3, userId2);
            stmt.setInt(4, userId1);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> message = new HashMap<>();
                message.put("message_id", rs.getInt("message_id"));
                message.put("sender_id", rs.getInt("sender_id"));
                message.put("receiver_id", rs.getInt("receiver_id"));
                message.put("message_text", rs.getString("message_text"));
                message.put("sent_at", rs.getTimestamp("sent_at"));
                message.put("read_status", rs.getBoolean("read_status"));
                message.put("sender_name", rs.getString("sender_name"));
                message.put("receiver_name", rs.getString("receiver_name"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching conversation: " + e.getMessage());
        }
        return messages;
    }

    public static void sendMessage(int senderId, int receiverId, String messageText) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message_text, sent_at, read_status) " +
                "VALUES (?, ?, ?, NOW(), 0)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.setString(3, messageText);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error sending message: " + e.getMessage());
        }
    }

    public static void markMessagesAsRead(int senderId, int receiverId) {
        String sql = "UPDATE messages SET read_status = 1 " +
                "WHERE sender_id = ? AND receiver_id = ? AND read_status = 0";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error marking messages as read: " + e.getMessage());
        }
    }

    public static void deleteMessage(int messageId) {
        String sql = "DELETE FROM messages WHERE message_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, messageId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting message: " + e.getMessage());
        }
    }

    public static int countUnreadMessages(int receiverId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND read_status = 0";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, receiverId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error counting unread messages: " + e.getMessage());
        }
        return 0;
    }
    public static List<Map<String, Object>> getFilteredBookings(String searchQuery, String filterStatus, Integer clientId, Integer carId, Integer driverId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id, b.booking_date, b.start_date, b.end_date, b.total_cost, b.status, b.payment_status, " +
                        "u.full_name as client_name, c.brand, c.model, d.full_name as driver_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN cars c ON b.car_id = c.car_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        // Apply search query filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR CONCAT(c.brand, ' ', c.model) LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Apply status filter
        if (filterStatus != null && !filterStatus.equalsIgnoreCase("All")) {
            sql.append(" AND b.status = ?");
            params.add(filterStatus);
        }

        // Apply client filter
        if (clientId != null) {
            sql.append(" AND b.user_id = ?");
            params.add(clientId);
        }

        // Apply car filter
        if (carId != null) {
            sql.append(" AND b.car_id = ?");
            params.add(carId);
        }

        // Apply driver filter
        if (driverId != null) {
            sql.append(" AND b.driver_id = ?");
            params.add(driverId);
        }

        sql.append(" ORDER BY b.created_at DESC");

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("booking_date", rs.getDate("booking_date"));
                booking.put("start_date", rs.getDate("start_date"));
                booking.put("end_date", rs.getDate("end_date"));
                booking.put("total_cost", rs.getDouble("total_cost"));
                booking.put("status", rs.getString("status"));
                booking.put("payment_status", rs.getString("payment_status"));
                booking.put("client_name", rs.getString("client_name"));
                booking.put("car_model", rs.getString("brand") + " " + rs.getString("model"));
                booking.put("driver_name", rs.getString("driver_name") != null ? rs.getString("driver_name") : "-");
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching filtered bookings: " + e.getMessage());
        }

        return bookings;
    }}