<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wheels.util.SessionUtil" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wheels - My Profile</title>
    <!-- Google Fonts: Inter and Playfair Display -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- GSAP for animations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        :root {
            --primary-red: #b91c1c;
            --secondary-red: #ef4444;
            --charcoal-gray: #1a1a1a;
            --white: #ffffff;
            --gray-50: #f9fafb;
            --gray-200: #e5e7eb;
            --gray-700: #2d3748;
            --shadow-lg: 0 15px 40px rgba(0, 0, 0, 0.2);
            --gold-accent: #d4af37;
        }
        body {
            font-family: 'Inter', sans-serif;
            color: var(--gray-700);
            line-height: 1.7;
            background: var(--gray-50);
        }
        h1, h2, h3 {
            font-family: 'Playfair Display', serif;
        }
        .btn-red {
            background: linear-gradient(90deg, var(--primary-red), var(--secondary-red));
            color: var(--white);
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-red:hover {
            background: linear-gradient(90deg, #991b1b, #dc2626);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(185, 28, 28, 0.4);
        }
        .btn-gold {
            background: linear-gradient(90deg, var(--gold-accent), #b89729);
            color: var(--charcoal-gray);
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-gold:hover {
            background: linear-gradient(90deg, #b89729, var(--gold-accent));
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.4);
        }
        .input-focus {
            transition: all 0.3s ease;
            border: 2px solid var(--gray-200);
            border-radius: 10px;
            background: var(--white);
        }
        .input-focus:focus {
            border-color: var(--primary-red);
            box-shadow: 0 0 0 5px rgba(185, 28, 28, 0.15);
            outline: none;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="bg-white shadow-lg fixed w-full z-50 border-b border-gray-200 backdrop-blur-md">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-20 items-center">
            <div class="flex items-center space-x-12">
                <a href="${pageContext.request.contextPath}/" class="text-3xl font-extrabold text-[var(--primary-red)] flex items-center group">
                    <i class="fas fa-car-side mr-3 transition-transform group-hover:scale-110"></i>Wheels
                </a>
                <div class="hidden md:flex space-x-8">
                    <a href="${pageContext.request.contextPath}/" class="text-[var(--charcoal-gray)] hover:text-[var(--primary-red)] text-base font-medium transition-all duration-300 py-2 border-b-2 border-transparent hover:border-[var(--primary-red)]">Home</a>
                    <a href="${pageContext.request.contextPath}/browse" class="text-[var(--charcoal-gray)] hover:text-[var(--primary-red)] text-base font-medium transition-all duration-300 py-2 border-b-2 border-transparent hover:border-[var(--primary-red)]">Vehicles</a>
                    <a href="${pageContext.request.contextPath}/my-bookings" class="text-[var(--charcoal-gray)] hover:text-[var(--primary-red)] text-base font-medium transition-all duration-300 py-2 border-b-2 border-transparent hover:border-[var(--primary-red)]">My Bookings</a>
                    <a href="${pageContext.request.contextPath}/profile" class="text-[var(--primary-red)] text-base font-medium transition-all duration-300 py-2 border-b-2 border-[var(--primary-red)]">Profile</a>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <%
                    Integer userId = SessionUtil.getUserId(session);
                    String userName = SessionUtil.getUserName(session);
                    if (userId != null && userName != null) {
                %>
                <span class="text-[var(--charcoal-gray)] text-sm font-medium hidden md:inline-block mr-4">Welcome, <%= userName %>!</span>
                <a href="${pageContext.request.contextPath}/auth?logout=true" class="btn-red text-white font-semibold text-sm py-2 px-5 rounded-lg transition-transform hover:scale-105" aria-label="Sign out">Sign Out</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/auth" class="btn-red text-white font-semibold text-sm py-2 px-5 rounded-lg transition-transform hover:scale-105" aria-label="Sign in">Sign In</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-28">
    <h1 class="text-4xl md:text-5xl font-bold text-[var(--charcoal-gray)] mb-10">My Profile</h1>
    <%
        if (userId == null) {
    %>
    <p class="text-[var(--charcoal-gray)] text-lg">Please <a href="${pageContext.request.contextPath}/auth" class="text-[var(--primary-red)] hover:underline">sign in</a> to view your profile.</p>
    <% } else { %>
    <%
        Map<String, Object> user = (Map<String, Object>) request.getAttribute("user");
        String success = request.getParameter("success");
        String error = (String) request.getAttribute("error");
        if (success != null) {
    %>
    <p class="text-green-600 text-lg mb-4"><%= success %></p>
    <% } else if (error != null) { %>
    <p class="text-red-500 text-lg mb-4"><%= error %></p>
    <% } %>
    <div class="bg-white shadow-lg rounded-xl p-8">
        <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="space-y-6">
            <div>
                <label for="fullName" class="block text-sm font-medium text-[var(--charcoal-gray)]">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="input-focus p-3 w-full" value="<%= user != null ? user.get("full_name") : "" %>" required aria-label="Enter full name">
            </div>
            <div>
                <label for="email" class="block text-sm font-medium text-[var(--charcoal-gray)]">Email</label>
                <input type="email" id="email" name="email" class="input-focus p-3 w-full" value="<%= user != null ? user.get("email") : "" %>" required aria-label="Enter email">
            </div>
            <div>
                <label for="phone" class="block text-sm font-medium text-[var(--charcoal-gray)]">Phone Number</label>
                <input type="tel" id="phone" name="phone" class="input-focus p-3 w-full" value="<%= user != null ? user.get("phone") : "" %>" aria-label="Enter phone number">
            </div>
            <div>
                <label for="profilePicture" class="block text-sm font-medium text-[var(--charcoal-gray)]">Profile Picture</label>
                <input type="file" id="profilePicture" name="profilePicture" class="input-focus p-3 w-full" accept="image/*" aria-label="Upload profile picture">
                <% if (user != null && user.get("profile_picture") != null) { %>
                <p class="text-sm text-gray-500 mt-2">Current: <a href="<%= user.get("profile_picture") %>" target="_blank" class="text-[var(--primary-red)] hover:underline">View</a></p>
                <% } %>
            </div>
            <div class="flex space-x-4">
                <button type="submit" name="action" value="update" class="btn-red font-semibold text-base py-2 px-6 rounded-lg">Update Profile</button>
                <a href="${pageContext.request.contextPath}/my-bookings" class="btn-gold font-semibold text-base py-2 px-6 rounded-lg">Back to Bookings</a>
            </div>
        </form>
    </div>
    <% } %>
</div>

<!-- Footer -->
<footer class="bg-[var(--charcoal-gray)] text-white py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10">
            <div>
                <a href="${pageContext.request.contextPath}/" class="text-3xl font-extrabold text-[var(--primary-red)] flex items-center mb-4">
                    <i class="fas fa-car-side mr-3"></i>Wheels
                </a>
                <p class="text-sm text-gray-400 opacity-80">Elevate your journey with luxury car rentals tailored to your needs.</p>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Explore</h3>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/browse" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300">Vehicles</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300">Locations</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300" id="contact-toggle">Contact Us</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Support</h3>
                <ul class="space-y-2">
                    <li><a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300">FAQ</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300">Privacy Policy</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-sm transition-colors duration-300">Terms</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Connect</h3>
                <div class="flex space-x-5">
                    <a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-xl transition-colors duration-300" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-xl transition-colors duration-300" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-xl transition-colors duration-300" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-gray-400 hover:text-[var(--primary-red)] text-xl transition-colors duration-300" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
        <div class="mt-12 text-center">
            <p class="text-sm text-gray-500 opacity-80">© 2025 Wheels Car Rental. All rights reserved.</p>
        </div>
    </div>
    <!-- Contact Overlay -->
    <div id="contact-overlay" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50">
        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-white p-6 rounded-xl w-full max-w-md shadow-2xl">
            <h3 class="text-2xl font-bold text-[var(--charcoal-gray)] mb-4">Get in Touch</h3>
            <form action="#" method="post" class="space-y-4">
                <input type="text" placeholder="Your Name" class="input-focus p-3 w-full" required>
                <input type="email" placeholder="Your Email" class="input-focus p-3 w-full" required>
                <textarea placeholder="Your Message" class="input-focus p-3 w-full h-24" required></textarea>
                <button type="submit" class="btn-red text-white font-semibold text-base py-2 px-6 w-full rounded-lg hover:shadow-lg">Send Message</button>
            </form>
            <button id="close-overlay" class="absolute top-4 right-4 text-gray-500 hover:text-[var(--primary-red)] text-2xl">×</button>
        </div>
    </div>
</footer>

<!-- JavaScript for Interactivity -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        // GSAP Animations
        gsap.from('nav', { y: -100, opacity: 0, duration: 1.2, ease: 'power3.out' });

        // Contact Overlay
        document.getElementById('contact-toggle').addEventListener('click', () => {
            document.getElementById('contact-overlay').classList.remove('hidden');
            gsap.from('#contact-overlay', { opacity: 0, duration: 0.5, ease: 'power2.out' });
        });
        document.getElementById('close-overlay').addEventListener('click', () => {
            gsap.to('#contact-overlay', { opacity: 0, duration: 0.5, ease: 'power2.out', onComplete: () => {
                    document.getElementById('contact-overlay').classList.add('hidden');
                }});
        });
    });
</script>
</body>
</html>