package com.wheels.controller;

import com.wheels.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "MessagesServlet", urlPatterns = {"/messages"})
public class MessagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all messages, users for dropdowns, and unread message count for the sidebar
            List<Map<String, Object>> messages = DBUtil.getAllMessages();
            List<Map<String, Object>> clients = DBUtil.getAllClientsForFilter();
            List<Map<String, Object>> drivers = DBUtil.getAllDriversForFilter();
            int unreadMessages = DBUtil.countUnreadMessages(1); // Assuming user_id 1 for admin

            // Check if a conversation is being viewed
            String senderIdParam = request.getParameter("senderId");
            String receiverIdParam = request.getParameter("receiverId");
            if (senderIdParam != null && receiverIdParam != null) {
                int senderId = Integer.parseInt(senderIdParam);
                int receiverId = Integer.parseInt(receiverIdParam);
                List<Map<String, Object>> conversation = DBUtil.getConversationBetweenUsers(senderId, receiverId);
                request.setAttribute("conversation", conversation);
                request.setAttribute("selectedSenderId", senderId);
                request.setAttribute("selectedReceiverId", receiverId);
                // Mark messages as read when viewed (from sender to receiver)
                DBUtil.markMessagesAsRead(senderId, receiverId);
            }

            request.setAttribute("messages", messages);
            request.setAttribute("clients", clients);
            request.setAttribute("drivers", drivers);
            request.setAttribute("unreadMessages", unreadMessages);

            request.getRequestDispatcher("messages.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving messages: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("send".equals(action)) {
                int senderId = Integer.parseInt(request.getParameter("senderId"));
                int receiverId = Integer.parseInt(request.getParameter("receiverId"));
                String messageText = request.getParameter("messageText");
                DBUtil.sendMessage(senderId, receiverId, messageText);
            } else if ("delete".equals(action)) {
                int messageId = Integer.parseInt(request.getParameter("messageId"));
                DBUtil.deleteMessage(messageId);
            }

            response.sendRedirect("messages");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing message action: " + e.getMessage(), e);
        }
    }
}