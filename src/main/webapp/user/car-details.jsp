<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.wheels.util.SessionUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Wheels Car Rental - Discover our premium car catalog with detailed views and easy booking.">
    <meta name="keywords" content="luxury car rental, premium vehicles, car catalog, vehicle details, Wheels rental">
    <meta name="author" content="Wheels Car Rental">
    <title>Wheels - Premium Car Catalog</title>
    <!-- Google Fonts: Inter and Playfair Display -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- GSAP for animations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        :root {
            --primary-red: #b91c1c;
            --secondary-red: #ef4444;
            --charcoal-gray: #1a1a1a;
            --metallic-silver: #d1d5db;
            --white: #ffffff;
            --gray-50: #f9fafb;
            --gray-200: #e5e7eb;
            --gray-700: #2d3748;
            --gradient-bg: linear-gradient(135deg, #2a2a2a, #3a3a3a);
            --shadow-lg: 0 15px 40px rgba(0, 0, 0, 0.2);
            --gold-accent: #d4af37;
        }
        body {
            font-family: 'Inter', sans-serif;
            color: var(--gray-700);
            line-height: 1.7;
            overflow-x: hidden;
            background: var(--gray-50);
        }
        h1, h2, h3 {
            font-family: 'Playfair Display', serif;
        }
        .card-shadow {
            box-shadow: var(--shadow-lg);
            transition: transform 0.4s ease, box-shadow 0.4s ease;
        }
        .card-shadow:hover {
            transform: translateY(-8px) perspective(1000px) rotateY(5deg);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25), 0 0 15px rgba(185, 28, 28, 0.3);
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
        .availability-badge {
            background: #10b981;
            color: var(--white);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .filter-sidebar {
            position: sticky;
            top: 120px;
            z-index: 50;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease;
        }
        .filter-sidebar.collapsed {
            transform: translateX(-100%);
        }
        .car-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
        }
        .carousel-inner {
            position: relative;
            width: 100%;
            height: 450px;
            overflow: hidden;
            border-radius: 15px;
        }
        .carousel-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 0.5s ease;
            background-size: cover;
            background-position: center;
        }
        .carousel-slide.active {
            opacity: 1;
        }
        .carousel-thumbnails {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            justify-content: center;
        }
        .carousel-thumbnails img {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            opacity: 0.6;
            transition: opacity 0.3s ease, transform 0.3s ease;
        }
        .carousel-thumbnails img.active {
            opacity: 1;
            transform: scale(1.1);
            border: 2px solid var(--primary-red);
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }
        .pagination-btn {
            background: var(--gray-200);
            color: var(--charcoal-gray);
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .pagination-btn.active, .pagination-btn:hover {
            background: var(--primary-red);
            color: var(--white);
        }
        @media (max-width: 640px) {
            .filter-sidebar { position: relative; top: 0; margin: 20px 0; transform: translateX(0); }
            .filter-sidebar.collapsed { transform: translateX(0); }
            .car-grid { grid-template-columns: 1fr; }
            .carousel-inner { height: 300px; }
            .carousel-thumbnails img { width: 60px; height: 40px; }
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
                    <a href="#" class="text-[var(--charcoal-gray)] hover:text-[var(--primary-red)] text-base font-medium transition-all duration-300 py-2 border-b-2 border-transparent hover:border-[var(--primary-red)]">Locations</a>
                    <a href="#" class="text-[var(--charcoal-gray)] hover:text-[var(--primary-red)] text-base font-medium transition-all duration-300 py-2 border-b-2 border-transparent hover:border-[var(--primary-red)]">Contact</a>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <%
                    Integer userId = SessionUtil.getUserId(session);
                    String userName = SessionUtil.getUserName(session);
                    if (userId != null && userName != null) {
                %>
                <span class="text-[var(--charcoal-gray)] text-sm font-medium hidden md:inline-block mr-4">Welcome, <%= userName %>!</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-red text-white font-semibold text-sm py-2 px-5 rounded-lg transition-transform hover:scale-105" aria-label="Sign out">Sign Out</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/auth" class="btn-red text-white font-semibold text-sm py-2 px-5 rounded-lg transition-transform hover:scale-105" aria-label="Sign in">Sign In</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-28">
    <%
        Map<String, Object> car = (Map<String, Object>) request.getAttribute("car");
        if (car != null) {
            List<String> features = (List<String>) request.getAttribute("features");
    %>
    <!-- Car Details Section -->
    <div class="relative bg-[var(--charcoal-gray)] rounded-2xl overflow-hidden mb-12">
        <div class="absolute inset-0 bg-cover bg-center opacity-30" style="background-image: url('<%= car.get("image_url") != null ? car.get("image_url") : "https://via.placeholder.com/500x400" %>'); filter: blur(10px);"></div>
        <div class="relative z-10 p-8 md:p-12 grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
                <div class="carousel-inner">
                    <div class="carousel-slide active" style="background-image: url('<%= car.get("image_url") != null ? car.get("image_url") : "https://via.placeholder.com/500x400" %>');"></div>
                    <div class="carousel-slide" style="background-image: url('https://via.placeholder.com/500x400?text=Side+View');"></div>
                    <div class="carousel-slide" style="background-image: url('https://via.placeholder.com/500x400?text=Rear+View');"></div>
                </div>
                <button class="absolute left-4 top-1/2 transform -translate-y-1/2 text-white text-2xl bg-[var(--charcoal-gray)] bg-opacity-70 rounded-full w-10 h-10 flex items-center justify-center hover:bg-opacity-90 transition-all" id="prev-slide"><i class="fas fa-chevron-left"></i></button>
                <button class="absolute right-4 top-1/2 transform -translate-y-1/2 text-white text-2xl bg-[var(--charcoal-gray)] bg-opacity-70 rounded-full w-10 h-10 flex items-center justify-center hover:bg-opacity-90 transition-all" id="next-slide"><i class="fas fa-chevron-right"></i></button>
                <div class="carousel-thumbnails">
                    <img src="<%= car.get("image_url") != null ? car.get("image_url") : "https://via.placeholder.com/500x400" %>" class="active" data-slide="0">
                    <img src="https://via.placeholder.com/500x400?text=Side+View" data-slide="1">
                    <img src="https://via.placeholder.com/500x400?text=Rear+View" data-slide="2">
                </div>
            </div>
            <div class="bg-white bg-opacity-95 backdrop-blur-lg p-6 rounded-xl shadow-lg">
                <h2 class="text-3xl md:text-4xl font-bold text-[var(--charcoal-gray)] mb-4"><%= car.get("brand") %> <%= car.get("model") %></h2>
                <div class="space-y-4 text-[var(--gray-700)]">
                    <p><span class="font-semibold">Type:</span> <%= car.get("car_type") %></p>
                    <p><span class="font-semibold">Capacity:</span> <%= car.get("capacity") %> passengers</p>
                    <p><span class="font-semibold">Price:</span> $<%= car.get("price_per_day") %>/day</p>
                    <p><span class="font-semibold">License Plate:</span> <%= car.get("license_plate") %></p>
                    <p><span class="font-semibold">Location:</span> <%= car.get("parc_name") %>, <%= car.get("city") %></p>
                    <p><span class="font-semibold">Availability:</span> <span class="availability-badge">Available</span></p>
                </div>
                <h3 class="text-xl font-semibold text-[var(--charcoal-gray)] mt-6 mb-3">Key Features:</h3>
                <ul class="list-disc list-inside text-[var(--gray-700)] space-y-2">
                    <% for (String feature : features) { %>
                    <li><%= feature %></li>
                    <% } %>
                </ul>
                <div class="mt-6 flex space-x-4">
                    <a href="${pageContext.request.contextPath}/book?carId=<%= car.get("car_id") %>" class="btn-red font-semibold text-base py-2 px-6 rounded-lg" aria-label="Book <%= car.get("model") %>">Book Now</a>
                    <a href="${pageContext.request.contextPath}/browse" class="btn-gold font-semibold text-base py-2 px-6 rounded-lg" aria-label="Back to catalog">Back to Catalog</a>
                </div>
            </div>
        </div>
    </div>
    <% } else { %>
    <h1 class="text-4xl md:text-5xl font-bold text-[var(--charcoal-gray)] mb-10">Explore Our Fleet</h1>
    <div class="flex flex-col md:flex-row gap-8">
        <!-- Filter Sidebar -->
        <div class="filter-sidebar w-full md:w-1/4" id="filter-sidebar">
            <h2 class="text-2xl font-bold text-[var(--charcoal-gray)] mb-6">Refine Your Search</h2>
            <button id="toggle-filter" class="md:hidden btn-red text-white font-semibold text-sm py-2 px-4 rounded-lg mb-4">Toggle Filters</button>
            <form action="${pageContext.request.contextPath}/browse" method="get" id="filter-form" class="space-y-6" role="form" aria-label="Car filter form">
                <div>
                    <label for="location" class="block text-sm font-medium text-[var(--charcoal-gray)]">Location</label>
                    <input type="text" id="location" name="location" class="input-focus p-3 w-full" placeholder="Enter city or airport" list="location-options" aria-label="Select location">
                    <datalist id="location-options">
                        <option value="New York">
                        <option value="Los Angeles">
                        <option value="Chicago">
                        <option value="Ben Arous">
                        <option value="Texas City">
                        <option value="Jandouba">
                    </datalist>
                </div>
                <div>
                    <label for="pickUpDate" class="block text-sm font-medium text-[var(--charcoal-gray)]">Pick-up Date</label>
                    <input type="date" id="pickUpDate" name="pickUpDate" class="input-focus p-3 w-full" value="<%= request.getParameter("pickUpDate") != null ? request.getParameter("pickUpDate") : LocalDate.now().plusDays(1).toString() %>" min="<%= LocalDate.now().plusDays(1).toString() %>" aria-label="Select pick-up date">
                </div>
                <div>
                    <label for="dropOffDate" class="block text-sm font-medium text-[var(--charcoal-gray)]">Drop-off Date</label>
                    <input type="date" id="dropOffDate" name="dropOffDate" class="input-focus p-3 w-full" value="<%= request.getParameter("dropOffDate") != null ? request.getParameter("dropOffDate") : LocalDate.now().plusDays(2).toString() %>" min="<%= LocalDate.now().plusDays(2).toString() %>" aria-label="Select drop-off date">
                </div>
                <div>
                    <label for="carType" class="block text-sm font-medium text-[var(--charcoal-gray)]">Car Type</label>
                    <select id="carType" name="carType" class="input-focus p-3 w-full" aria-label="Select car type">
                        <option value="">All Types</option>
                        <%
                            List<String> carTypes = (List<String>) request.getAttribute("carTypes");
                            for (String type : carTypes) {
                        %>
                        <option value="<%= type %>" <%= type.equals(request.getParameter("carType")) ? "selected" : "" %>><%= type %></option>
                        <% } %>
                    </select>
                </div>
                <input type="hidden" name="page" id="page-input" value="1">
                <button type="submit" class="btn-red text-white font-semibold text-base py-2 px-6 w-full rounded-lg hover:shadow-2xl" aria-label="Filter cars">Apply Filters</button>
            </form>
        </div>
        <!-- Car Catalog -->
        <div class="w-full md:w-3/4 mt-0">
            <%
                List<Map<String, Object>> cars = (List<Map<String, Object>>) request.getAttribute("cars");
                if (cars != null && !cars.isEmpty()) {
                    int pageSize = 6;
                    int currentPage = 1;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        try {
                            currentPage = Integer.parseInt(pageParam);
                        } catch (NumberFormatException e) {
                            currentPage = 1;
                        }
                    }
                    int totalCars = cars.size();
                    int totalPages = (int) Math.ceil((double) totalCars / pageSize);
                    int startIndex = (currentPage - 1) * pageSize;
                    int endIndex = Math.min(startIndex + pageSize, totalCars);
                    List<Map<String, Object>> carsToDisplay = cars.subList(startIndex, endIndex);
            %>
            <div class="car-grid">
                <% for (Map<String, Object> carItem : carsToDisplay) { %>
                <div class="bg-white card-shadow rounded-xl overflow-hidden group">
                    <div class="relative">
                        <img src="<%= carItem.get("image_url") != null ? carItem.get("image_url") : "https://via.placeholder.com/320x200" %>" alt="<%= carItem.get("model") %>" class="w-full h-56 object-cover transition-transform duration-300 group-hover:scale-105">
                        <div class="absolute top-4 left-4 bg-[var(--primary-red)] text-white px-3 py-1 rounded-full text-sm font-medium">Available</div>
                        <div class="absolute inset-0 bg-gradient-to-t from-black to-transparent opacity-0 group-hover:opacity-50 transition-opacity duration-300"></div>
                    </div>
                    <div class="p-6">
                        <h3 class="text-xl font-semibold text-[var(--charcoal-gray)] mb-2"><%= carItem.get("brand") %> <%= carItem.get("model") %></h3>
                        <p class="text-[var(--gray-700)] text-sm">Type: <%= carItem.get("car_type") %></p>
                        <p class="text-[var(--gray-700)] text-sm">Location: <%= carItem.get("city") %></p>
                        <p class="text-[var(--charcoal-gray)] font-medium mt-2">$<%= carItem.get("price_per_day") %>/day</p>
                        <div class="mt-4 flex space-x-3 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                            <a href="${pageContext.request.contextPath}/car-details?carId=<%= carItem.get("car_id") %>" class="bg-[var(--charcoal-gray)] text-white font-semibold text-sm py-2 px-4 rounded-lg hover:bg-opacity-90 transition-colors duration-300" aria-label="View details of <%= carItem.get("model") %>">View Details</a>
                            <a href="${pageContext.request.contextPath}/book?carId=<%= carItem.get("car_id") %>" class="btn-red text-white font-semibold text-sm py-2 px-4 rounded-lg hover:shadow-md transition-colors duration-300" aria-label="Book <%= carItem.get("model") %>">Book Now</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <!-- Pagination -->
            <br><br>
            <div class="pagination">
                <% for (int i = 1; i <= totalPages; i++) { %>
                <button class="pagination-btn <%= i == currentPage ? "active" : "" %>" data-page="<%= i %>"><%= i %></button>
                <% } %>
            </div>
            <% } else { %>
            <p class="text-[var(--charcoal-gray)] text-center text-xl col-span-full">No vehicles match your search. Try adjusting your filters.</p>
            <% } %>
        </div>
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
    // Ensure DOM is fully loaded before running scripts
    document.addEventListener('DOMContentLoaded', () => {
        // Carousel Navigation (only if car details section exists)
        const prevSlideBtn = document.getElementById('prev-slide');
        const nextSlideBtn = document.getElementById('next-slide');
        if (prevSlideBtn && nextSlideBtn) {
            let currentSlide = 0;
            const slides = document.querySelectorAll('.carousel-slide');
            const thumbnails = document.querySelectorAll('.carousel-thumbnails img');
            const totalSlides = slides.length;

            function showSlide(index) {
                slides.forEach(slide => slide.classList.remove('active'));
                thumbnails.forEach(thumb => thumb.classList.remove('active'));
                slides[index].classList.add('active');
                thumbnails[index].classList.add('active');
                currentSlide = index;
            }

            prevSlideBtn.addEventListener('click', () => {
                showSlide((currentSlide - 1 + totalSlides) % totalSlides);
            });

            nextSlideBtn.addEventListener('click', () => {
                showSlide((currentSlide + 1) % totalSlides);
            });

            thumbnails.forEach((thumb, index) => {
                thumb.addEventListener('click', () => {
                    showSlide(index);
                });
            });

            // GSAP Animations for Carousel
            gsap.from('.carousel-inner', { opacity: 0, scale: 0.95, duration: 1, ease: 'power3.out' });
            gsap.from('.carousel-thumbnails img', { opacity: 0, y: 20, duration: 0.8, stagger: 0.2, ease: 'power3.out' });
        }

        // Filter Toggle
        const toggleFilterBtn = document.getElementById('toggle-filter');
        if (toggleFilterBtn) {
            toggleFilterBtn.addEventListener('click', () => {
                const sidebar = document.getElementById('filter-sidebar');
                sidebar.classList.toggle('collapsed');
            });
        }

        // Live Filter
        const filterForm = document.getElementById('filter-form');
        if (filterForm) {
            filterForm.addEventListener('change', () => {
                document.getElementById('page-input').value = 1;
                filterForm.submit();
            });
        }

        // Pagination
        const paginationButtons = document.querySelectorAll('.pagination-btn');
        if (paginationButtons) {
            paginationButtons.forEach(button => {
                button.addEventListener('click', () => {
                    console.log('Pagination button clicked:', button.getAttribute('data-page')); // Debug log
                    const page = button.getAttribute('data-page');
                    document.getElementById('page-input').value = page;
                    filterForm.submit();
                });
            });
        } else {
            console.log('No pagination buttons found.'); // Debug log
        }

        // GSAP Animations
        gsap.from('nav', { y: -100, opacity: 0, duration: 1.2, ease: 'power3.out' });
        gsap.from('.card-shadow', { opacity: 0, y: 60, duration: 1, stagger: 0.3, ease: 'power3.out', scrollTrigger: { trigger: '.car-grid' } });

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