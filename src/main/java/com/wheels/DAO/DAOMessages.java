package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOMessages;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOMessages implements IDAOMessages {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Map<String, Object>> getAllMessages() {
        List<Map<String, Object>> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.sender_id, m.receiver_id, m.message_text, m.sent_at, m.read_status, " +
                "s.full_name as sender_name, r.full_name as receiver_name " +
                "FROM messages m " +
                "JOIN users s ON m.sender_id = s.user_id " +
                "JOIN users r ON m.receiver_id = r.user_id " +
                "ORDER BY m.sent_at DESC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> message = new HashMap<>();
                message.put("message_id", rs.getInt("message_id"));
                message.put("sender_id", rs.getInt("sender_id"));
                message.put("receiver_id", rs.getInt("receiver_id"));
                message.put("message_text", rs.getString("message_text"));
                message.put("sent_at", rs.getTimestamp("sent_at"));
                message.put("read_status", rs.getBoolean("read_status"));
                message.put("sender_name", rs.getString("sender_name"));
                message.put("receiver_name", rs.getString("receiver_name"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    @Override
    public List<Map<String, Object>> getConversationBetweenUsers(int userId1, int userId2) {
        List<Map<String, Object>> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.sender_id, m.receiver_id, m.message_text, m.sent_at, m.read_status, " +
                "s.full_name as sender_name, r.full_name as receiver_name " +
                "FROM messages m " +
                "JOIN users s ON m.sender_id = s.user_id " +
                "JOIN users r ON m.receiver_id = r.user_id " +
                "WHERE (m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?) " +
                "ORDER BY m.sent_at ASC";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId1);
            stmt.setInt(2, userId2);
            stmt.setInt(3, userId2);
            stmt.setInt(4, userId1);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> message = new HashMap<>();
                message.put("message_id", rs.getInt("message_id"));
                message.put("sender_id", rs.getInt("sender_id"));
                message.put("receiver_id", rs.getInt("receiver_id"));
                message.put("message_text", rs.getString("message_text"));
                message.put("sent_at", rs.getTimestamp("sent_at"));
                message.put("read_status", rs.getBoolean("read_status"));
                message.put("sender_name", rs.getString("sender_name"));
                message.put("receiver_name", rs.getString("receiver_name"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    @Override
    public void sendMessage(int senderId, int receiverId, String messageText) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message_text, sent_at, read_status) VALUES (?, ?, ?, NOW(), 0)";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.setString(3, messageText);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void markMessagesAsRead(int senderId, int receiverId) {
        String sql = "UPDATE messages SET read_status = 1 WHERE sender_id = ? AND receiver_id = ? AND read_status = 0";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMessage(int messageId) {
        String sql = "DELETE FROM messages WHERE message_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, messageId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int countUnreadMessages(int receiverId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND read_status = 0";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, receiverId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}