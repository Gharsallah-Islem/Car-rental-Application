package com.wheels.DAO.interfaces;

import java.sql.SQLException;
import java.util.Map;

public interface IDAOPublicUsers {
    Map<String, Object> getUserDetails(int userId) throws SQLException;
    boolean updateUserProfile(int userId, String fullName, String email, String phone, String profilePicturePath) throws SQLException;
}