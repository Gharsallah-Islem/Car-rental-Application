package com.wheels.DAO.interfaces;

import com.wheels.Model.User;
import java.util.List;

public interface IDAODrivers {
    List<User> getAllDrivers();
    List<User> getAllDriversForFilter();
    void addDriver(String fullName, String email, String phone, String password);
    void updateDriver(int userId, String fullName, String email, String phone);
    boolean hasActiveDriverBookings(int userId);
    void deleteDriver(int userId);
}