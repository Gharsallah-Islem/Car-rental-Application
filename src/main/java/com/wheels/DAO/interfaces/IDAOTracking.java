package com.wheels.DAO.interfaces;

import java.util.List;
import java.util.Map;

public interface IDAOTracking {
    List<java.util.Map<String, Object>> getAllTrackingData();
    Map<String, Object> getLatestLocationForCar(int carId);
    List<java.util.Map<String, Object>> getTrackingHistoryForCar(int carId, java.sql.Date startDate, java.sql.Date endDate);
    void addTrackingRecord(int carId, double latitude, double longitude, String status);
    void deleteTrackingRecord(int trackingId);
}