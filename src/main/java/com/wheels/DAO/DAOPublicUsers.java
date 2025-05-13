package com.wheels.DAO;

import com.wheels.util.DatabaseSingleton;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DAOPublicUsers {
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
}