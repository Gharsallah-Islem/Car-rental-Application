package com.wheels.DAO.interfaces;

import java.util.List;
import java.util.Map;
import java.time.LocalDate;

public interface IDAOPublicCars {
    List<Map<String, Object>> getAvailableCars(String location, String carType, LocalDate pickUpDate, LocalDate dropOffDate);
    Map<String, Object> getCarDetails(int carId);
    List<String> getCarFeatures(int carId);
    List<String> getDistinctLocations();
    List<String> getDistinctCarTypes();
    List<Map<String, Object>> getRandomAvailableCars(int limit);
}