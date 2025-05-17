<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wheels.util.SessionUtil" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Wheels Car Rental - Premier luxury car rentals with seamless booking and worldwide service.">
    <meta name="keywords" content="luxury car rental, premium vehicles, car hire, Wheels rental, travel in style">
    <meta name="author" content="Wheels Car Rental">
    <title>Wheels - Premier Luxury Car Rentals</title>
    <!-- Google Fonts: Inter and Playfair Display -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- GSAP for animations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
    <!-- Swiper JS for sliders -->
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- jQuery for AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root {
            --primary-white: #ffffff;
            --accent-red: #b91c1c;
            --soft-gray: #f7f7f7;
            --charcoal-gray: #1a1a1a;
            --gold-accent: #d4af37;
            --shadow-soft: 0 8px 20px rgba(0, 0, 0, 0.1);
            --shadow-hover: 0 12px 30px rgba(0, 0, 0, 0.15);
        }
        body {
            font-family: 'Inter', sans-serif;
            color: var(--charcoal-gray);
            line-height: 1.7;
            overflow-x: hidden;
            background: var(--primary-white);
        }
        h1, h2, h3 {
            font-family: 'Playfair Display', serif;
        }
        .hero-section {
            position: relative;
            height: 90vh;
            min-height: 700px;
            background: url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=2070&auto=format&fit=crop') no-repeat center center/cover;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to bottom, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.7));
            z-index: 1;
        }
        .navbar {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: var(--shadow-soft);
        }
        .btn-red {
            background: linear-gradient(90deg, var(--accent-red), #ef4444);
            color: var(--primary-white);
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-red:hover {
            background: linear-gradient(90deg, #991b1b, #dc2626);
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(185, 28, 28, 0.3);
        }
        .btn-gold {
            background: linear-gradient(90deg, var(--gold-accent), #b89729);
            color: var(--charcoal-gray);
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-gold:hover {
            background: linear-gradient(90deg, #b89729, var(--gold-accent));
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(212, 175, 55, 0.3);
        }
        .input-focus {
            transition: all 0.3s ease;
            border: 1px solid var(--soft-gray);
            border-radius: 10px;
            background: var(--primary-white);
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .input-focus:focus {
            border-color: var(--accent-red);
            box-shadow: 0 0 0 4px rgba(185, 28, 28, 0.1);
            outline: none;
        }
        .car-card {
            flex: 0 0 360px;
            background: linear-gradient(145deg, #ffffff, #f0f0f0);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow-soft);
            transition: transform 0.4s ease, box-shadow 0.4s ease;
            transform: perspective(1000px) rotateY(0deg);
        }
        .car-card:hover {
            transform: perspective(1000px) rotateY(5deg) translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2), 0 0 20px rgba(185, 28, 28, 0.3);
        }
        .car-card img {
            width: 100%;
            height: 240px;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .car-card:hover img {
            transform: scale(1.05);
        }
        .car-card .details {
            padding: 20px;
            text-align: center;
            background: #ffffff;
        }
        .car-card .price {
            font-size: 24px;
            font-weight: 700;
            color: var(--accent-red);
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }
        .car-card .actions {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 0 20px 20px;
            background: #ffffff;
        }
        .car-card .actions a {
            flex: 1;
            text-align: center;
        }
        .car-card .actions a:hover {
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        .section-bg {
            background: var(--soft-gray);
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 20px;
        }
        .pagination-dot {
            width: 14px;
            height: 14px;
            background: #d1d5db;
            border-radius: 50%;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.3s ease;
        }
        .pagination-dot.active {
            background: var(--accent-red);
            transform: scale(1.2);
        }
        .pagination-dot:hover {
            background: var(--accent-red);
            transform: scale(1.1);
        }
        .loading {
            text-align: center;
            font-size: 1.2rem;
            color: var(--charcoal-gray);
            padding: 20px;
        }
        .feature-card {
            background: var(--primary-white);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }
        .swiper-slide {
            opacity: 0.5;
            transition: opacity 0.3s ease;
        }
        .swiper-slide-active {
            opacity: 1;
        }
        @media (max-width: 640px) {
            .hero-section {
                height: 80vh;
                min-height: 600px;
            }
            .btn-red, .btn-gold {
                width: 100%;
                font-size: 14px;
                padding: 10px 20px;
            }
            .grid-cols-5 {
                grid-template-columns: 1fr;
            }
            .car-card {
                flex: 0 0 300px;
            }
            .car-card img {
                height: 200px;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar fixed top-0 left-0 w-full z-50 py-4">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
            <div class="flex items-center space-x-12">
                <a href="${pageContext.request.contextPath}/" class="text-3xl font-bold text-[var(--accent-red)] flex items-center group">
                    <i class="fas fa-car-side mr-3 transition-transform group-hover:scale-110"></i>Wheels
                </a>
                <div class="hidden md:flex space-x-10">
                    <a href="${pageContext.request.contextPath}/" class="text-[var(--charcoal-gray)] hover:text-[var(--accent-red)] text-base font-medium transition-all duration-300 py-2">Home</a>
                    <a href="${pageContext.request.contextPath}/browse" class="text-[var(--charcoal-gray)] hover:text-[var(--accent-red)] text-base font-medium transition-all duration-300 py-2">Vehicles</a>
                    <a href="#" class="text-[var(--charcoal-gray)] hover:text-[var(--accent-red)] text-base font-medium transition-all duration-300 py-2">Destinations</a>
                    <a href="#" class="text-[var(--charcoal-gray)] hover:text-[var(--accent-red)] text-base font-medium transition-all duration-300 py-2">Support</a>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <%
                    Integer userId = SessionUtil.getUserId(session);
                    String userName = SessionUtil.getUserName(session);
                    if (userId != null && userName != null) {
                %>
                <span class="text-[var(--charcoal-gray)] text-sm font-medium hidden md:inline-block mr-4">Welcome, <%= userName %>!</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-red font-semibold text-sm py-2 px-5 transition-transform hover:scale-105" aria-label="Sign out">Sign Out</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/auth" class="btn-red font-semibold text-sm py-2 px-5 transition-transform hover:scale-105" aria-label="Sign in">Sign In</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="hero-section">
    <div class="hero-overlay"></div>
    <div class="relative z-10 text-center max-w-5xl mx-auto px-4">
        <h1 class="text-5xl md:text-6xl font-bold text-[var(--primary-white)] mb-6 leading-tight tracking-tight drop-shadow-lg">Luxury in Every Journey</h1>
        <p class="text-lg md:text-xl text-[var(--primary-white)] mb-8 max-w-2xl mx-auto opacity-90 drop-shadow-md">Experience the ultimate in luxury car rentals with Wheels—crafted for those who demand the best.</p>
        <div class="flex justify-center space-x-4">
            <a href="#book-now" class="btn-red font-semibold text-lg py-3 px-8 hover:shadow-lg transform transition duration-300" aria-label="Book a car now">Reserve Now</a>
            <a href="${pageContext.request.contextPath}/browse" class="btn-gold font-semibold text-lg py-3 px-8 hover:shadow-lg transform transition duration-300" aria-label="Explore our fleet">Explore Fleet</a>
        </div>
    </div>
</div>

<!-- Booking Widget -->
<div id="book-now" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 -mt-20 relative z-10">
    <div class="bg-[var(--primary-white)] p-8 rounded-2xl shadow-xl border border-[var(--soft-gray)]">
        <h2 class="text-3xl md:text-4xl font-bold text-[var(--charcoal-gray)] mb-6 text-center">Plan Your Journey</h2>
        <form action="${pageContext.request.contextPath}/browse" method="get" class="grid grid-cols-1 md:grid-cols-5 gap-4" role="form" aria-label="Car booking form">
            <div>
                <label for="location" class="block text-sm font-medium text-[var(--charcoal-gray)] mb-2">Pick-up Location</label>
                <input type="text" id="location" name="location" class="input-focus p-3 w-full" placeholder="City or Airport" list="location-options" aria-label="Select location">
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
                <label for="pickUpDate" class="block text-sm font-medium text-[var(--charcoal-gray)] mb-2">Pick-up Date</label>
                <input type="date" id="pickUpDate" name="pickUpDate" required class="input-focus p-3 w-full" value="<%= LocalDate.now().plusDays(1).toString() %>" min="<%= LocalDate.now().plusDays(1).toString() %>" aria-label="Select pick-up date">
            </div>
            <div>
                <label for="dropOffDate" class="block text-sm font-medium text-[var(--charcoal-gray)] mb-2">Drop-off Date</label>
                <input type="date" id="dropOffDate" name="dropOffDate" required class="input-focus p-3 w-full" value="<%= LocalDate.now().plusDays(2).toString() %>" min="<%= LocalDate.now().plusDays(2).toString() %>" aria-label="Select drop-off date">
            </div>
            <div>
                <label for="carType" class="block text-sm font-medium text-[var(--charcoal-gray)] mb-2">Car Type</label>
                <select id="carType" name="carType" class="input-focus p-3 w-full" aria-label="Select car type">
                    <option value="">All Types</option>
                    <option value="Sedan">Sedan</option>
                    <option value="SUV">SUV</option>
                    <option value="Hatchback">Hatchback</option>
                    <option value="Convertible">Convertible</option>
                    <option value="Truck">Truck</option>
                    <option value="Minivan">Minivan</option>
                </select>
            </div>
            <div class="flex items-end">
                <button type="submit" class="btn-red font-semibold text-base p-3 w-full rounded-lg hover:shadow-lg" aria-label="Search for cars">Search Vehicles</button>
            </div>
        </form>
    </div>
</div>

<!-- Best Rentals for This Month -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <h2 class="text-3xl md:text-4xl font-bold text-[var(--charcoal-gray)] mb-8 text-center">Featured Rentals This Month</h2>
    <div id="car-container" class="flex flex-row overflow-x-auto gap-5">
        <div class="loading">Loading featured cars...</div>
    </div>
    <div id="pagination" class="pagination"></div>
    <div class="text-center mt-8">
        <a href="${pageContext.request.contextPath}/browse" class="btn-gold font-semibold text-base py-3 px-8 rounded-lg hover:shadow-lg" aria-label="View all cars">View All Vehicles</a>
    </div>
</div>

<!-- Why Choose Us -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 section-bg">
    <h2 class="text-3xl md:text-4xl font-bold text-[var(--charcoal-gray)] mb-8 text-center">Why Choose Wheels?</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="feature-card p-6 text-center">
            <i class="fas fa-star text-3xl text-[var(--accent-red)] mb-4"></i>
            <h3 class="text-xl font-semibold text-[var(--charcoal-gray)] mb-2">Unmatched Quality</h3>
            <p class="text-[var(--charcoal-gray)] text-sm">Premium vehicles maintained to the highest standards for your comfort.</p>
        </div>
        <div class="feature-card p-6 text-center">
            <i class="fas fa-globe text-3xl text-[var(--accent-red)] mb-4"></i>
            <h3 class="text-xl font-semibold text-[var(--charcoal-gray)] mb-2">Global Reach</h3>
            <p class="text-[var(--charcoal-gray)] text-sm">Access luxury rentals in over 75 locations worldwide with ease.</p>
        </div>
        <div class="feature-card p-6 text-center">
            <i class="fas fa-headset text-3xl text-[var(--accent-red)] mb-4"></i>
            <h3 class="text-xl font-semibold text-[var(--charcoal-gray)] mb-2">24/7 Support</h3>
            <p class="text-[var(--charcoal-gray)] text-sm">Our dedicated team is here to assist you anytime, anywhere.</p>
        </div>
    </div>
</div>

<!-- Testimonials -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <h2 class="text-3xl md:text-4xl font-bold text-[var(--charcoal-gray)] mb-8 text-center">What Our Clients Say</h2>
    <div class="swiper-container-testimonials">
        <div class="swiper-wrapper">
            <div class="swiper-slide">
                <div class="bg-[var(--primary-white)] p-6 rounded-2xl shadow-lg text-center border border-[var(--soft-gray)]">
                    <p class="text-[var(--charcoal-gray)] mb-4 italic">"Wheels made my trip unforgettable with their seamless service and stunning cars."</p>
                    <h3 class="text-lg font-semibold text-[var(--charcoal-gray)]">Emma S., Traveler</h3>
                    <div class="text-[var(--gold-accent)] mt-2">★★★★★</div>
                </div>
            </div>
            <div class="swiper-slide">
                <div class="bg-[var(--primary-white)] p-6 rounded-2xl shadow-lg text-center border border-[var(--soft-gray)]">
                    <p class="text-[var(--charcoal-gray)] mb-4 italic">"The best rental experience I’ve ever had—professional and luxurious."</p>
                    <h3 class="text-lg font-semibold text-[var(--charcoal-gray)]">James R., Entrepreneur</h3>
                    <div class="text-[var(--gold-accent)] mt-2">★★★★★</div>
                </div>
            </div>
            <div class="swiper-slide">
                <div class="bg-[var(--primary-white)] p-6 rounded-2xl shadow-lg text-center border border-[var(--soft-gray)]">
                    <p class="text-[var(--charcoal-gray)] mb-4 italic">"From booking to return, everything was perfect. Highly recommend Wheels!"</p>
                    <h3 class="text-lg font-semibold text-[var(--charcoal-gray)]">Sophia M., Executive</h3>
                    <div class="text-[var(--gold-accent)] mt-2">★★★★★</div>
                </div>
            </div>
        </div>
        <div class="swiper-pagination-testimonials mt-6"></div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-[var(--charcoal-gray)] text-[var(--primary-white)] py-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
                <a href="${pageContext.request.contextPath}/" class="text-2xl font-bold text-[var(--accent-red)] flex items-center mb-4">
                    <i class="fas fa-car-side mr-3"></i>Wheels
                </a>
                <p class="text-sm text-[var(--soft-gray)] opacity-80">Redefining luxury travel since 2020.</p>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Explore</h3>
                <ul class="space-y-2">
                    <li><a href="${pageContext.request.contextPath}/" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/browse" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">Vehicles</a></li>
                    <li><a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">Destinations</a></li>
                    <li><a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">Support</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Support</h3>
                <ul class="space-y-2">
                    <li><a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">FAQ</a></li>
                    <li><a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">Privacy Policy</a></li>
                    <li><a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-sm transition-colors duration-300">Terms</a></li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold mb-4">Connect</h3>
                <div class="flex space-x-4">
                    <a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-xl transition-colors duration-300" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-xl transition-colors duration-300" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-xl transition-colors duration-300" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-[var(--soft-gray)] hover:text-[var(--accent-red)] text-xl transition-colors duration-300" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
        <div class="mt-8 text-center">
            <p class="text-sm text-[var(--soft-gray)] opacity-80">© 2025 Wheels Car Rental. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- JavaScript for Interactivity -->
<script>
    // GSAP Scroll Animations
    gsap.from('.navbar', { y: -50, opacity: 0, duration: 1, ease: 'power3.out' });
    gsap.from('.hero-section h1', { opacity: 0, y: 40, duration: 1, delay: 0.3, ease: 'power3.out' });
    gsap.from('.hero-section p', { opacity: 0, y: 30, duration: 1, delay: 0.5, ease: 'power3.out' });
    gsap.from('.hero-section .btn-red', { opacity: 0, scale: 0.9, duration: 1, delay: 0.7, ease: 'power3.out' });
    gsap.from('.hero-section .btn-gold', { opacity: 0, scale: 0.9, duration: 1, delay: 0.9, ease: 'power3.out' });
    gsap.from('#book-now', { opacity: 0, y: 50, duration: 1, ease: 'power3.out', scrollTrigger: { trigger: '#book-now', start: 'top 80%' } });
    gsap.from('.section-bg h2', { opacity: 0, y: 40, duration: 1, ease: 'power3.out', scrollTrigger: { trigger: '.section-bg', start: 'top 80%' } });
    gsap.from('.feature-card', { opacity: 0, y: 50, duration: 1, stagger: 0.2, ease: 'power3.out', scrollTrigger: { trigger: '.feature-card', start: 'top 85%' } });
    gsap.from('.swiper-container-testimonials', { opacity: 0, y: 50, duration: 1, ease: 'power3.out', scrollTrigger: { trigger: '.swiper-container-testimonials', start: 'top 80%' } });
    gsap.from('footer', { opacity: 0, y: 50, duration: 1, ease: 'power3.out', scrollTrigger: { trigger: 'footer', start: 'top 85%' } });

    // Load Featured Cars via AJAX with Horizontal Scroll, Pagination, and Auto-Scroll
    $(document).ready(function() {
        $.ajax({
            url: '${pageContext.request.contextPath}/featured',
            method: 'GET',
            success: function(data) {
                console.log('Received data:', data);
                $('#car-container').html(data);
                console.log('DOM updated, car-container content:', $('#car-container').html());

                // Pagination Setup
                const cards = $('.car-card');
                const totalCards = cards.length;
                const cardsPerPage = 3;
                const totalPages = Math.ceil(totalCards / cardsPerPage);
                let currentPage = 1;

                // Create pagination dots
                for (let i = 1; i <= totalPages; i++) {
                    $('#pagination').append(`<div class="pagination-dot ${i == 1 ? 'active' : ''}" data-page="${i}"></div>`);
                }

                // Show cards for the current page
                function showPage(page) {
                    cards.each(function() {
                        const cardPage = parseInt($(this).data('page'));
                        if (cardPage === page) {
                            $(this).css('display', 'block');
                        } else {
                            $(this).css('display', 'none');
                        }
                    });

                    // Scroll to the start of the current page
                    const container = $('#car-container')[0];
                    const cardWidth = 360 + 20; // Card width (360px) + gap (20px)
                    const scrollPosition = (page - 1) * cardWidth * cardsPerPage;
                    container.scrollTo({
                        left: scrollPosition,
                        behavior: 'smooth'
                    });

                    $('.pagination-dot').removeClass('active');
                    $(`.pagination-dot[data-page="${page}"]`).addClass('active');
                    currentPage = page;

                    // GSAP animation for visible cards
                    const visibleCards = cards.filter(function() {
                        return parseInt($(this).data('page')) === page;
                    });
                    gsap.from(visibleCards, { opacity: 0, x: 50, duration: 0.5, stagger: 0.1, ease: 'power3.out' });
                }

                // Initial page
                showPage(1);

                // Pagination dot click handler
                $('.pagination-dot').on('click', function() {
                    const page = parseInt($(this).data('page'));
                    showPage(page);
                    // Reset auto-scroll timer
                    clearInterval(autoScrollInterval);
                    autoScrollInterval = setInterval(autoScroll, 2000);
                });

                // Auto-scroll every 2 seconds
                let autoScrollInterval = setInterval(autoScroll, 2000);

                function autoScroll() {
                    currentPage = currentPage >= totalPages ? 1 : currentPage + 1;
                    showPage(currentPage);
                }

                // Pause auto-scroll on hover
                $('#car-container').on('mouseenter', function() {
                    clearInterval(autoScrollInterval);
                }).on('mouseleave', function() {
                    autoScrollInterval = setInterval(autoScroll, 2000);
                });
            },
            error: function(xhr, status, error) {
                console.log('AJAX Error: ', status, error);
                console.log('Response: ', xhr.responseText);
                $('#car-container').html('<p class="text-[var(--charcoal-gray)] text-center text-lg">Error loading featured cars. Check server logs.</p>');
            }
        });
    });

    // Swiper for Testimonials
    const swiperTestimonials = new Swiper('.swiper-container-testimonials', {
        slidesPerView: 1,
        spaceBetween: 20,
        pagination: {
            el: '.swiper-pagination-testimonials',
            clickable: true,
        },
        autoplay: {
            delay: 4000,
            disableOnInteraction: false,
        },
        loop: true,
        breakpoints: {
            640: { slidesPerView: 2 },
            1024: { slidesPerView: 3 },
        },
    });
</script>
</body>
</html>