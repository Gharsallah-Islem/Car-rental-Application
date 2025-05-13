<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wheels - Car Rental</title>
    <!-- Bootstrap CSS via CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .card {
            max-width: 500px;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            transition: background-color 0.3s;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
        h1 {
            color: #343a40;
            margin-bottom: 1.5rem;
        }
        p {
            color: #6c757d;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
<div class="card text-center">
    <h1>Welcome to Wheels Car Rental</h1>
    <p>Discover the best cars for your journey. Please log in or sign up to start browsing our fleet.</p>
    <a href="${pageContext.request.contextPath}/auth" class="btn btn-custom">Log In / Sign Up</a>
</div>

<!-- Bootstrap JS and dependencies via CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>