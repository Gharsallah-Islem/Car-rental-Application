package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOPublicUsers;
import com.wheels.util.DatabaseSingleton;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class DAOPublicUsers implements IDAOPublicUsers {
    public boolean validateUser(String identifier, String password) {
        Connection conn = DatabaseSingleton.getInstance().getConnection();
        try {
            String sql = "SELECT COUNT(*) FROM users WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, identifier);
            stmt.setString(2, identifier);
            stmt.setString(3, password); // This will be replaced with BCrypt check in AuthServlet
            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createUser(String username, String password, String email, String fullName) {
        Connection conn = DatabaseSingleton.getInstance().getConnection();
        try {
            if (isIdentifierTaken(username, email)) {
                return false; // Username or email already exists
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            String sql = "INSERT INTO users (username, password, email, role, full_name, created_at) VALUES (?, ?, ?, 'client', ?, NOW())";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            stmt.setString(3, email);
            stmt.setString(4, fullName);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isIdentifierTaken(String username, String email) {
        Connection conn = DatabaseSingleton.getInstance().getConnection();
        try {
            String sql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Map<String, Object> getUserDetails(int userId) throws SQLException {
        Connection conn = DatabaseSingleton.getInstance().getConnection();
        Map<String, Object> user = new HashMap<>();
        try {
            String sql = "SELECT full_name, email, phone, profile_picture FROM users WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user.put("full_name", rs.getString("full_name"));
                user.put("email", rs.getString("email"));
                user.put("phone", rs.getString("phone"));
                user.put("profile_picture", rs.getString("profile_picture"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return user;
    }

    @Override
    public boolean updateUserProfile(int userId, String fullName, String email, String phone, String profilePicturePath) throws SQLException {
        Connection conn = DatabaseSingleton.getInstance().getConnection();
        try {
            String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, profile_picture = ? WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, profilePicturePath);
            stmt.setInt(5, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
}