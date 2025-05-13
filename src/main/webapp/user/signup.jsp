<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Wheels - Sign Up</title>
</head>
<body>
<h1>Sign Up</h1>
<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<p style="color:red;"><%= error %></p>
<%
    }
%>
<form action="${pageContext.request.contextPath}/auth" method="post">
    <input type="hidden" name="action" value="signup">
    <div>
        <label>Username:</label>
        <input type="text" name="username" required>
    </div>
    <div>
        <label>Password:</label>
        <input type="password" name="password" required>
    </div>
    <div>
        <label>Email:</label>
        <input type="email" name="email" required>
    </div>
    <div>
        <label>Full Name:</label>
        <input type="text" name="fullName" required>
    </div>
    <div>
        <input type="submit" value="Sign Up">
    </div>
</form>
<p>Already have an account? <a href="${pageContext.request.contextPath}/auth">Login</a></p>
</body>
</html>