package com.wheels.DAO.interfaces;

public interface IDAODashboard {
    int getTotalRevenue();
    int getTotalExpenses();
    int getProfitMargin();
    int countNewBookingsLastWeek();
    int countRentedCars();
    int countAvailableCars();
    java.util.List<java.util.Map<String, Object>> getEarningsSummary();
    java.util.Map<String, Integer> getRentStatus();
    java.util.Map<String, Integer> getCarTypeDistribution();
}