package com.wheels.DAO.interfaces;

import com.wheels.Model.Car;
import java.util.List;

public interface IDAOUnits {
    List<Car> getAllCars();
    List<Car> getAvailableCars();
    List<Car> getAllCarsForFilter();
    List<String> getCarTypes();
    void addCar(String brand, String model, String carType, int capacity, double pricePerDay, String licensePlate, Integer parcId);
    void updateCar(int carId, String brand, String model, String carType, int capacity, double pricePerDay, String licensePlate, Integer parcId);
    void deleteCar(int carId);
}