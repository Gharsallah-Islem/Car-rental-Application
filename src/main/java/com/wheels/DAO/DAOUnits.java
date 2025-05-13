package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOUnits;
import com.wheels.Model.Car;
import com.wheels.Model.CarType;
import com.wheels.util.DatabaseSingleton;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOUnits implements IDAOUnits {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT car_id, brand, model, car_type, capacity, price_per_day, license_plate, availability, created_at, parc_id FROM cars";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setCarType(CarType.valueOf(rs.getString("car_type")));
                car.setCapacity(rs.getInt("capacity"));
                car.setPricePerDay(BigDecimal.valueOf(rs.getDouble("price_per_day")));
                car.setLicensePlate(rs.getString("license_plate"));
                car.setAvailability(rs.getBoolean("availability"));
                car.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                car.setParcId(rs.getObject("parc_id") != null ? rs.getInt("parc_id") : null);
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    @Override
    public List<Car> getAvailableCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT car_id, brand, model, car_type, capacity, price_per_day, license_plate, availability, created_at, parc_id FROM cars WHERE availability = TRUE";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setCarType(CarType.valueOf(rs.getString("car_type")));
                car.setCapacity(rs.getInt("capacity"));
                car.setPricePerDay(BigDecimal.valueOf(rs.getDouble("price_per_day")));
                car.setLicensePlate(rs.getString("license_plate"));
                car.setAvailability(rs.getBoolean("availability"));
                car.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                car.setParcId(rs.getObject("parc_id") != null ? rs.getInt("parc_id") : null);
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    @Override
    public List<Car> getAllCarsForFilter() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT car_id, brand, model FROM cars ORDER BY brand, model";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    @Override
    public List<String> getCarTypes() {
        List<String> carTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT car_type FROM cars ORDER BY car_type";
        try (Connection conn = dbSingleton.getConnection();
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

    @Override
    public void addCar(String brand, String model, String carType, int capacity, double pricePerDay, String licensePlate, Integer parcId) {
        String sql = "INSERT INTO cars (brand, model, car_type, capacity, price_per_day, license_plate, availability, parc_id) VALUES (?, ?, ?, ?, ?, ?, TRUE, ?)";
        try (Connection conn = dbSingleton.getConnection();
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

    @Override
    public void updateCar(int carId, String brand, String model, String carType, int capacity, double pricePerDay, String licensePlate, Integer parcId) {
        String sql = "UPDATE cars SET brand = ?, model = ?, car_type = ?, capacity = ?, price_per_day = ?, license_plate = ?, parc_id = ? WHERE car_id = ?";
        try (Connection conn = dbSingleton.getConnection();
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

    @Override
    public void deleteCar(int carId) {
        String sql = "DELETE FROM cars WHERE car_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}