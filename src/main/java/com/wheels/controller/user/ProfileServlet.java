package com.wheels.controller.user;

import com.wheels.DAO.DAOPublicUsers;
import com.wheels.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

public class ProfileServlet extends HttpServlet {
    private DAOPublicUsers daoPublicUsers;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        daoPublicUsers = new DAOPublicUsers();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request.getSession());
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        try {
            Map<String, Object> user = daoPublicUsers.getUserDetails(userId);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve profile details.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request.getSession());
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            Part profilePicturePart = request.getPart("profilePicture");
            String profilePicturePath = null;

            // Handle profile picture upload
            if (profilePicturePart != null && profilePicturePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + profilePicturePart.getSubmittedFileName();
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                profilePicturePath = UPLOAD_DIR + "/" + fileName;
                profilePicturePart.write(uploadPath + File.separator + fileName);
            }

            try {
                boolean success = daoPublicUsers.updateUserProfile(userId, fullName, email, phone, profilePicturePath);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/profile?success=Profile updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update profile. Please try again.");
                    request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred while updating profile.");
                request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}