package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOReminders;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOReminders implements IDAOReminders {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Map<String, Object>> getPendingReminders() {
        List<Map<String, Object>> reminders = new ArrayList<>();
        String sql = "SELECT title, description, due_date FROM reminders WHERE status = 'pending'";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> reminder = new HashMap<>();
                reminder.put("title", rs.getString("title"));
                reminder.put("description", rs.getString("description"));
                reminder.put("due_date", rs.getDate("due_date"));
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reminders;
    }
}