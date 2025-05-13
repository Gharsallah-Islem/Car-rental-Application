package com.wheels.controller.user;

import com.wheels.DAO.DAOPublicUsers;
import com.wheels.util.DatabaseSingleton;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthServlet extends HttpServlet {
    private DAOPublicUsers daoPublicUsers;

    @Override
    public void init() throws ServletException {
        daoPublicUsers = new DAOPublicUsers();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("signup".equals(action)) {
            handleSignup(request, response);
        } else if ("logout".equals(action)) {
            handleLogout(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = request.getParameter("username"); // Can be username or email
        String password = request.getParameter("password");

        if (identifier != null && password != null) {
            Connection conn = DatabaseSingleton.getInstance().getConnection();
            try {
                String sql = "SELECT user_id, role, password, username FROM users WHERE username = ? OR email = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, identifier);
                stmt.setString(2, identifier);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (BCrypt.checkpw(password, hashedPassword)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", rs.getInt("user_id"));
                        session.setAttribute("role", rs.getString("role"));
                        session.setAttribute("username", rs.getString("username"));
                        response.sendRedirect(request.getContextPath() + "/browse");
                    } else {
                        request.setAttribute("error", "Invalid identifier or password");
                        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid identifier or password");
                    request.getRequestDispatcher("/user/login.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred during login");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            }
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = "client";

        if (username != null && password != null && email != null && fullName != null) {
            Connection conn = DatabaseSingleton.getInstance().getConnection();
            try {
                if (daoPublicUsers.isIdentifierTaken(username, email)) {
                    request.setAttribute("error", "Username or email already taken");
                    request.getRequestDispatcher("/user/signup.jsp").forward(request, response);
                    return;
                }

                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
                String sql = "INSERT INTO users (username, password, email, role, full_name, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                stmt.setString(3, email);
                stmt.setString(4, role);
                stmt.setString(5, fullName);
                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect(request.getContextPath() + "/auth?success=signup");
                } else {
                    request.setAttribute("error", "Signup failed");
                    request.getRequestDispatcher("/user/signup.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred during signup");
                request.getRequestDispatcher("/user/signup.jsp").forward(request, response);
            }
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth");
    }
}