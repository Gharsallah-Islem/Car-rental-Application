package com.wheels.util;

import jakarta.servlet.http.HttpSession;

public class SessionUtil {
    public static Integer getUserId(HttpSession session) {
        return (Integer) session.getAttribute("userId");
    }

    public static String getUserName(HttpSession session) {
        return (String) session.getAttribute("userName");
    }

    public static void setUserSession(HttpSession session, Integer userId, String userName) {
        session.setAttribute("userId", userId);
        session.setAttribute("userName", userName);
    }

    public static void invalidateSession(HttpSession session) {
        session.invalidate();
    }
    public static boolean isUserLoggedIn(HttpSession session) {
        return session.getAttribute("userId") != null;
    }
    public static String getUserRole(HttpSession session) {
        return (String) session.getAttribute("userRole");
    }
}