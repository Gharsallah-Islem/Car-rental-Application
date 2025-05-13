<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Wheels - Login</title>
</head>
<body>
<h1>Login</h1>
<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<p style="color:red;"><%= error %></p>
<%
    }
%>
<form action="${pageContext.request.contextPath}/auth" method="post">
    <input type="hidden" name="action" value="login">
    <div>
        <label>Username or Email:</label>
        <input type="text" name="username" required>
    </div>
    <div>
        <label>Password:</label>
        <input type="password" name="password" required>
    </div>
    <div>
        <input type="submit" value="Login">
    </div>
</form>
<p>Don't have an account? <a href="${pageContext.request.contextPath}/user/signup.jsp">Sign Up</a></p>
</body>
</html>