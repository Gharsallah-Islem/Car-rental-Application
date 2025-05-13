package com.wheels.DAO.interfaces;

import com.wheels.Model.User;
import java.util.List;

public interface IDAOClients {
    List<User> getAllClients();
    List<User> getAllClientsForFilter();
    void addClient(String fullName, String email, String phone, String password);
    void updateClient(int userId, String fullName, String email, String phone);
    boolean hasActiveBookings(int userId);
    void deleteClient(int userId);
}