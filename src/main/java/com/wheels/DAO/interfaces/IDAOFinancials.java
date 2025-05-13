package com.wheels.DAO.interfaces;

import com.wheels.Model.Financial;
import java.util.List;

public interface IDAOFinancials {
    List<Financial> getAllFinancialTransactions();
    void addFinancialTransaction(Integer bookingId, String type, String category, double amount, java.sql.Date transactionDate, String description, String status);
    void updateFinancialTransaction(int financialId, Integer bookingId, String type, String category, double amount, java.sql.Date transactionDate, String description, String status);
    void deleteFinancialTransaction(int financialId);
}