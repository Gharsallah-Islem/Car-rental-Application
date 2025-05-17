package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOPublicCars;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOPublicCars implements IDAOPublicCars {
    private final Connection connection;

    public DAOPublicCars() {
        this.connection = DatabaseSingleton.getInstance().getConnection();
    }

    @Override
    public List<Map<String, Object>> getAvailableCars(String location, String carType, LocalDate pickUpDate, LocalDate dropOffDate) {
        List<Map<String, Object>> cars = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT c.car_id, c.model, c.brand, c.car_type, c.capacity, c.price_per_day, c.license_plate, c.availability, c.image_url, p.city " +
                        "FROM cars c " +
                        "LEFT JOIN parcs p ON c.parc_id = p.parc_id " +
                        "WHERE c.availability = 1"
        );

        List<Object> params = new ArrayList<>();

        if (location != null && !location.isEmpty()) {
            query.append(" AND p.city = ?");
            params.add(location);
        }
        if (carType != null && !carType.isEmpty()) {
            query.append(" AND c.car_type = ?");
            params.add(carType);
        }
        if (pickUpDate != null && dropOffDate != null) {
            query.append(
                    " AND c.car_id NOT IN (" +
                            "SELECT b.car_id FROM bookings b " +
                            "WHERE (b.start_date <= ? AND b.end_date >= ?) " +
                            "AND b.status NOT IN ('cancelled', 'completed', 'returned')" +
                            ")"
            );
            params.add(java.sql.Date.valueOf(dropOffDate));
            params.add(java.sql.Date.valueOf(pickUpDate));
        }

        try (PreparedStatement stmt = connection.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("model", rs.getString("model"));
                car.put("brand", rs.getString("brand"));
                car.put("car_type", rs.getString("car_type"));
                car.put("capacity", rs.getInt("capacity"));
                car.put("price_per_day", rs.getBigDecimal("price_per_day"));
                car.put("license_plate", rs.getString("license_plate"));
                car.put("availability", rs.getBoolean("availability"));
                car.put("image_url", rs.getString("image_url"));
                car.put("city", rs.getString("city"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    @Override
    public Map<String, Object> getCarDetails(int carId) {
        Map<String, Object> car = null;
        String query =
                "SELECT c.car_id, c.model, c.brand, c.car_type, c.capacity, c.price_per_day, c.license_plate, c.availability, c.image_url, p.city, p.parc_name " +
                        "FROM cars c " +
                        "LEFT JOIN parcs p ON c.parc_id = p.parc_id " +
                        "WHERE c.car_id = ? AND c.availability = 1";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, carId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("model", rs.getString("model"));
                car.put("brand", rs.getString("brand"));
                car.put("car_type", rs.getString("car_type"));
                car.put("capacity", rs.getInt("capacity"));
                car.put("price_per_day", rs.getBigDecimal("price_per_day"));
                car.put("license_plate", rs.getString("license_plate"));
                car.put("availability", rs.getBoolean("availability"));
                car.put("image_url", rs.getString("image_url"));
                car.put("city", rs.getString("city"));
                car.put("parc_name", rs.getString("parc_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return car;
    }

    @Override
    public List<String> getCarFeatures(int carId) {
        List<String> features = new ArrayList<>();
        String query = "SELECT feature_name FROM car_features WHERE car_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, carId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                features.add(rs.getString("feature_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return features;
    }

    @Override
    public List<String> getDistinctLocations() {
        List<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT city FROM parcs";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                locations.add(rs.getString("city"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }

    @Override
    public List<String> getDistinctCarTypes() {
        List<String> carTypes = new ArrayList<>();
        String query = "SELECT DISTINCT car_type FROM cars WHERE availability = 1";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                carTypes.add(rs.getString("car_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carTypes;
    }

    public List<Map<String, Object>> getRandomAvailableCars(int limit) {
        List<Map<String, Object>> cars = new ArrayList<>();
        String query =
                "SELECT c.car_id, c.model, c.brand, c.car_type, c.capacity, c.price_per_day, c.license_plate, c.availability, c.image_url, p.city " +
                        "FROM cars c " +
                        "LEFT JOIN parcs p ON c.parc_id = p.parc_id " +
                        "WHERE c.availability = 1 " +
                        "ORDER BY RAND() " +
                        "LIMIT ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> car = new HashMap<>();
                car.put("car_id", rs.getInt("car_id"));
                car.put("model", rs.getString("model"));
                car.put("brand", rs.getString("brand"));
                car.put("car_type", rs.getString("car_type"));
                car.put("capacity", rs.getInt("capacity"));
                car.put("price_per_day", rs.getBigDecimal("price_per_day"));
                car.put("license_plate", rs.getString("license_plate"));
                car.put("availability", rs.getBoolean("availability"));
                car.put("image_url", rs.getString("image_url"));
                car.put("city", rs.getString("city"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }
}