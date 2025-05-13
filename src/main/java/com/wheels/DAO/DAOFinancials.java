package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOFinancials;
import com.wheels.Model.Financial;
import com.wheels.Model.FinancialType;
import com.wheels.Model.Status;
import com.wheels.util.DatabaseSingleton;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOFinancials implements IDAOFinancials {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Financial> getAllFinancialTransactions() {
        List<Financial> transactions = new ArrayList<>();
        String sql = "SELECT financial_id, booking_id, type, category, amount, transaction_date, description, status FROM financials ORDER BY transaction_date DESC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Financial financial = new Financial();
                financial.setFinancialId(rs.getInt("financial_id"));
                financial.setBookingId(rs.getObject("booking_id") != null ? rs.getInt("booking_id") : null);
                financial.setType(FinancialType.valueOf(rs.getString("type")));
                financial.setCategory(rs.getString("category"));
                financial.setAmount(BigDecimal.valueOf(rs.getDouble("amount")));
                financial.setTransactionDate(rs.getDate("transaction_date").toLocalDate());
                financial.setDescription(rs.getString("description"));
                financial.setStatus(Status.valueOf(rs.getString("status")));
                transactions.add(financial);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    @Override
    public void addFinancialTransaction(Integer bookingId, String type, String category, double amount, java.sql.Date transactionDate, String description, String status) {
        String sql = "INSERT INTO financials (booking_id, type, category, amount, transaction_date, description, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbSingleton.getConnection();
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
        }
    }

    @Override
    public void updateFinancialTransaction(int financialId, Integer bookingId, String type, String category, double amount, java.sql.Date transactionDate, String description, String status) {
        String sql = "UPDATE financials SET booking_id = ?, type = ?, category = ?, amount = ?, transaction_date = ?, description = ?, status = ? WHERE financial_id = ?";
        try (Connection conn = dbSingleton.getConnection();
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
        }
    }

    @Override
    public void deleteFinancialTransaction(int financialId) {
        String sql = "DELETE FROM financials WHERE financial_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, financialId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}