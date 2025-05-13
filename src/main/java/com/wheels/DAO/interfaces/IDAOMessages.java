package com.wheels.DAO.interfaces;

import java.util.List;

public interface IDAOMessages {
    List<java.util.Map<String, Object>> getAllMessages();
    List<java.util.Map<String, Object>> getConversationBetweenUsers(int userId1, int userId2);
    void sendMessage(int senderId, int receiverId, String messageText);
    void markMessagesAsRead(int senderId, int receiverId);
    void deleteMessage(int messageId);
    int countUnreadMessages(int receiverId);
}