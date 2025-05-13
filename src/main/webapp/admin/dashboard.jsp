<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Wheels Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(145deg, #0A0E1A 0%, #1A2338 100%);
            color: #E5E7EB;
            overflow-x: hidden;
        }

        .sidebar {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .sidebar:hover {
            width: 280px;
        }

        .sidebar-item {
            position: relative;
            transition: all 0.3s ease;
        }

        .sidebar-item:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
        }

        .sidebar-item.active {
            background: rgba(255, 255, 255, 0.15);
            border-left: 4px solid #FF4D4F;
        }

        .card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .chart-container {
            position: relative;
            height: 240px;
        }

        .highlight {
            color: #FF4D4F;
        }

        .messages-count {
            background: #FF4D4F;
            color: white;
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 9999px;
            animation: pulse 2s infinite;
        }

        .btn-primary {
            background: linear-gradient(90deg, #FF4D4F 0%, #F97316 100%);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(90deg, #F97316 0%, #FF4D4F 100%);
            transform: scale(1.05);
        }

        .input-field {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #E5E7EB;
            transition: all 0.3s ease;
        }

        .input-field:focus {
            border-color: #FF4D4F;
            box-shadow: 0 0 10px rgba(255, 77, 79, 0.2);
        }

        .table-row {
            transition: all 0.3s ease;
        }

        .table-row:hover {
            background: rgba(255, 255, 255, 0.05);
            transform: translateX(5px);
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
        }

        ::-webkit-scrollbar-thumb {
            background: #FF4D4F;
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #F97316;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 50;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 2rem;
            width: 90%;
            max-width: 500px;
            position: relative;
        }

        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            color: #E5E7EB;
            cursor: pointer;
        }
    </style>
</head>
<body class="min-h-screen">
<!-- Sidebar -->
<div class="fixed top-0 left-0 h-full w-64 sidebar z-40">
    <div class="p-6">
        <h1 class="text-2xl font-bold mb-8 flex items-center space-x-2">
            <span class="text-red-500">●</span>
            <span class="text-white">Wheels</span>
        </h1>
        <nav class="space-y-2">
            <a href="dashboard" class="sidebar-item active flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                </svg>
                <span>Dashboard</span>
            </a>
            <a href="bookings" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                </svg>
                <span>Bookings</span>
            </a>
            <a href="units" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7h12a2 2 0 012 2v6a2 2 0 01-2 2H9zm-6 0a2 2 0 01-2-2V9a2 2 0 012-2h2v10H3z"></path>
                </svg>
                <span>Units</span>
            </a>
            <a href="calendar" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
                <span>Calendar</span>
            </a>
            <a href="clients" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
                </svg>
                <span>Clients</span>
            </a>
            <a href="drivers" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
                <span>Drivers</span>
            </a>
            <a href="parcs" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a2 2 0 012-2h2a2 2 0 012 2v5m-4 0h4"></path>
                </svg>
                <span>Parcs</span>
            </a>
            <a href="financials" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.686 1M12 8c-1.11 0-2.08.402-2.686 1M12 8c0-1.105-.895-2-2-2s-2 .895-2 2m0 8c0 1.105.895 2 2 2s2-.895 2-2m0-8v8m4-12h2m-2 0h-2m2 0v2m0-2v-2m0 16h2m-2 0h-2m2 0v-2m0 2v2M6 4H4m2 0h2m-2 0v2m0-2v-2m0 16H4m2 0h2m-2 0v-2m0 2v2"></path>
                </svg>
                <span>Financials</span>
            </a>
            <a href="tracking" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"></path>
                </svg>
                <span>Tracking</span>
            </a>
            <a href="messages" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
                <svg class="w-6 h-6 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
                </svg>
                <span>Messages</span>
                <span class="messages-count">5</span>
            </a>
        </nav>
    </div>
</div>

<!-- Main Content -->
<main class="ml-64 p-8 min-h-screen">
    <!-- Header -->
    <header class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-white">Dashboard</h1>
        <div class="flex items-center space-x-4">
            <button id="addBookingBtn" class="btn-primary text-white px-4 py-2 rounded-lg">Add New Booking</button>
            <button id="checkAvailabilityBtn" class="btn-primary text-white px-4 py-2 rounded-lg">Check Car Availability</button>
            <button class="p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition">
                <svg class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                </svg>
            </button>
            <button class="p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition">
                <svg class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path>
                </svg>
            </button>
            <div class="flex items-center space-x-2">
                <img src="https://scontent.ftun1-2.fna.fbcdn.net/v/t1.6435-1/134373580_1069542116854453_5005427293465681887_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=102&ccb=1-7&_nc_sid=e99d92&_nc_ohc=BIxQt3RbJ04Q7kNvwE7rXch&_nc_oc=AdlsFJYviAGoQMmSo4c-TH87bzC6647_C8FSQhwKU0D-IVjUS4T_5FEpYpYwDkn3-u80nhXEtEsVqXsIuREX-Rsq&_nc_zt=24&_nc_ht=scontent.ftun1-2.fna&_nc_gid=axRam3wmucRfHfEWBMrZBQ&oh=00_AfEIW59jVouvoWL2gO7iBQJLGOwfcB1bT1xHsVMp3UBNxw&oe=683ADCE1" alt="User" class="w-8 h-8 rounded-full border-2 border-red-500">
                <span class="text-white font-medium">Gharsallah islem</span>
                <span class="text-gray-400 text-sm">Admin</span>
            </div>
        </div>
    </header>

    <!-- Key Metrics -->
    <section class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="card p-6">
            <h3 class="text-sm font-medium text-gray-400 mb-2">Total Revenue</h3>
            <p class="text-2xl font-bold text-white">$${totalRevenue}</p>
            <p class="text-xs text-green-400">+2.80% from last week</p>
        </div>
        <div class="card p-6">
            <h3 class="text-sm font-medium text-gray-400 mb-2">New Bookings</h3>
            <p class="text-2xl font-bold text-white">${newBookings}</p>
            <p class="text-xs text-green-400">+1.79% from last week</p>
        </div>
        <div class="card p-6">
            <h3 class="text-sm font-medium text-gray-400 mb-2">Rented Cars</h3>
            <p class="text-2xl font-bold text-white">${rentedCars} Unit</p>
            <p class="text-xs text-green-400">+2.80% from last week</p>
        </div>
        <div class="card p-6">
            <h3 class="text-sm font-medium text-gray-400 mb-2">Available Cars</h3>
            <p class="text-2xl font-bold text-white">${availableCars} Unit</p>
            <p class="text-xs text-green-400">+3.45% from last week</p>
        </div>
    </section>

    <!-- Charts and Widgets -->
    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        <div class="card p-6 col-span-2">
            <h3 class="text-lg font-semibold text-white mb-4">Earnings Summary</h3>
            <div class="chart-container">
                <canvas id="earningsSummaryChart"></canvas>
            </div>
        </div>
        <div class="card p-6">
            <h3 class="text-lg font-semibold text-white mb-4">Rent Status</h3>
            <div class="chart-container">
                <canvas id="rentStatusChart"></canvas>
            </div>
        </div>
    </section>

    <!-- Car Availability and Car Types -->
    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        <div class="card p-6">
            <h3 class="text-lg font-semibold text-white mb-4">Car Availability</h3>
            <form id="checkAvailabilityForm" action="dashboard" method="POST">
                <input type="hidden" name="action" value="checkAvailability">
                <div class="space-y-4">
                    <select name="carType" class="w-full px-4 py-2 rounded-lg input-field" required>
                        <option value="">Select Car Type</option>
                        <c:forEach var="carType" items="${carTypesList}">
                            <option value="${carType}">${carType}</option>
                        </c:forEach>
                    </select>
                    <input type="date" name="checkDate" class="w-full px-4 py-2 rounded-lg input-field" value="2025-04-30" required>
                    <input type="time" name="checkTime" class="w-full px-4 py-2 rounded-lg input-field" value="10:00" required>
                    <button type="submit" class="w-full px-4 py-2 text-white rounded-lg btn-primary">Check</button>
                </div>
            </form>
        </div>
        <div class="card p-6 col-span-2">
            <h3 class="text-lg font-semibold text-white mb-4">Car Types</h3>
            <div class="chart-container">
                <canvas id="carTypesChart"></canvas>
            </div>
        </div>
    </section>

    <!-- Car Availability Results Modal -->
    <div id="checkAvailabilityModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('checkAvailabilityModal')">×</span>
            <h2 class="text-xl font-bold mb-4">Car Availability Results</h2>
            <c:if test="${not empty availableCarsForCheck}">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead>
                        <tr class="text-gray-400">
                            <th class="py-2 px-4">Car ID</th>
                            <th class="py-2 px-4">Model</th>
                            <th class="py-2 px-4">Price/Day</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="car" items="${availableCarsForCheck}">
                            <tr class="table-row border-t border-gray-700">
                                <td class="py-3 px-4">${car.car_id}</td>
                                <td class="py-3 px-4">${car.car_model}</td>
                                <td class="py-3 px-4">${car.price_per_day} $</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            <c:if test="${empty availableCarsForCheck}">
                <p class="text-gray-400">No cars available for the selected criteria.</p>
            </c:if>
        </div>
    </div>

    <!-- Reminders -->
    <section class="card p-6 mb-8">
        <h3 class="text-lg font-semibold text-white mb-4">Reminders</h3>
        <c:if test="${empty reminders}">
            <p class="text-gray-400">No pending reminders found.</p>
        </c:if>
        <div class="space-y-4">
            <c:forEach var="reminder" items="${reminders}">
                <div class="flex items-center space-x-3 p-3 bg-gray-800 rounded-lg">
                    <span class="text-red-500">●</span>
                    <div>
                        <p class="font-medium text-white">${reminder.title}</p>
                        <p class="text-sm text-gray-400">${reminder.description}</p>
                        <p class="text-xs text-gray-500">Due: ${reminder.due_date}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Booking Overview -->
    <section class="card p-6 mb-8">
        <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-white">Booking Overview</h3>
            <div class="flex flex-wrap gap-4">
                <input type="text" id="searchQuery" placeholder="Search client name, car, etc" class="px-4 py-2 rounded-lg input-field w-full md:w-1/3">
                <select id="yearFilter" class="px-4 py-2 rounded-lg input-field">
                    <option value="All">All Years</option>
                    <option value="2025">2025</option>
                    <option value="2024">2024</option>
                    <option value="2023">2023</option>
                </select>
                <select id="statusFilter" class="px-4 py-2 rounded-lg input-field">
                    <option value="All">All Statuses</option>
                    <option value="pending">Pending</option>
                    <option value="confirmed">Confirmed</option>
                    <option value="cancelled">Cancelled</option>
                    <option value="completed">Completed</option>
                </select>
                <select id="clientFilter" class="px-4 py-2 rounded-lg input-field">
                    <option value="">All Clients</option>
                    <c:forEach var="client" items="${clients}">
                        <option value="${client.user_id}">${client.full_name}</option>
                    </c:forEach>
                </select>
                <select id="carFilter" class="px-4 py-2 rounded-lg input-field">
                    <option value="">All Cars</option>
                    <c:forEach var="car" items="${cars}">
                        <option value="${car.car_id}">${car.car_model}</option>
                    </c:forEach>
                </select>
                <select id="driverFilter" class="px-4 py-2 rounded-lg input-field">
                    <option value="">All Drivers</option>
                    <c:forEach var="driver" items="${drivers}">
                        <option value="${driver.user_id}">${driver.full_name}</option>
                    </c:forEach>
                </select>
                <button id="applyFilters" class="px-4 py-2 text-white rounded-lg btn-primary">Apply Filters</button>
            </div>
        </div>
        <c:if test="${empty recentBookings}">
            <p class="text-gray-400">No recent bookings found. Please ensure the database is populated.</p>
        </c:if>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead>
                <tr class="text-gray-400">
                    <th class="py-2 px-4">Booking ID</th>
                    <th class="py-2 px-4">Booking Date</th>
                    <th class="py-2 px-4">Client Name</th>
                    <th class="py-2 px-4">Car Model</th>
                    <th class="py-2 px-4">Plan</th>
                    <th class="py-2 px-4">Date</th>
                    <th class="py-2 px-4">Driver</th>
                    <th class="py-2 px-4">Payment</th>
                    <th class="py-2 px-4">Status</th>
                    <th class="py-2 px-4">Action</th>
                </tr>
                </thead>
                <tbody id="bookingsTableBody">
                <c:forEach var="booking" items="${recentBookings}">
                    <tr class="border-t border-gray-700 table-row">
                        <td class="py-3 px-4 text-white">BK-WS${booking.booking_id}</td>
                        <td class="py-3 px-4 text-white">${booking.booking_date}</td>
                        <td class="py-3 px-4 text-white">${booking.client_name}</td>
                        <td class="py-3 px-4 text-white">${booking.car_model}</td>
                        <td class="py-3 px-4 text-white">${booking.booking_days} Days</td>
                        <td class="py-3 px-4 text-white">${booking.start_date} to ${booking.end_date}</td>
                        <td class="py-3 px-4 text-white">${booking.driver_name}</td>
                        <td class="py-3 px-4 text-white">$${booking.total_cost} <span class="text-xs">${booking.payment_status}</span></td>
                        <td class="py-3 px-4">
                                <span class="px-2 py-1 rounded-full text-xs ${booking.status == 'active' ? 'bg-yellow-600 text-yellow-100' : booking.status == 'completed' ? 'bg-green-600 text-green-100' : 'bg-red-600 text-red-100'}">
                                        ${booking.status}
                                </span>
                        </td>
                        <td class="py-3 px-4">
                            <button class="text-gray-400 hover:text-white">...</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Add Booking Modal -->
    <div id="addBookingModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('addBookingModal')">×</span>
            <h2 class="text-xl font-bold mb-4">Add New Booking</h2>
            <form id="addBookingForm" action="dashboard" method="POST">
                <input type="hidden" name="action" value="addBooking">
                <div class="mb-4">
                    <label class="block text-sm mb-2">Client</label>
                    <select name="clientId" class="input-field w-full px-4 py-2 rounded-lg" required>
                        <option value="">Select Client</option>
                        <c:forEach var="client" items="${allClients}">
                            <option value="${client.user_id}">${client.full_name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-4">
                    <label class="block text-sm mb-2">Car</label>
                    <select name="carId" class="input-field w-full px-4 py-2 rounded-lg" required>
                        <option value="">Select Car</option>
                        <c:forEach var="car" items="${availableCarsList}">
                            <option value="${car.car_id}">${car.car_model}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-4">
                    <label class="block text-sm mb-2">Booking Date</label>
                    <input type="date" name="bookingDate" class="input-field w-full px-4 py-2 rounded-lg" required>
                </div>
                <div class="mb-4">
                    <label class="block text-sm mb-2">Start Date</label>
                    <input type="date" name="startDate" class="input-field w-full px-4 py-2 rounded-lg" required>
                </div>
                <div class="mb-4">
                    <label class="block text-sm mb-2">End Date</label>
                    <input type="date" name="endDate" class="input-field w-full px-4 py-2 rounded-lg" required>
                </div>
                <div class="mb-4">
                    <label class="block text-sm mb-2">Total Cost</label>
                    <input type="number" name="totalCost" step="0.01" class="input-field w-full px-4 py-2 rounded-lg" required>
                </div>
                <div class="mb-4">
                    <label class="block text-sm mb-2">Driver (Optional)</label>
                    <select name="driverId" class="input-field w-full px-4 py-2 rounded-lg">
                        <option value="">No Driver</option>
                        <c:forEach var="driver" items="${allDrivers}">
                            <option value="${driver.user_id}">${driver.full_name}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn-primary text-white px-4 py-2 rounded-lg w-full">Add Booking</button>
            </form>
        </div>
    </div>
</main>

<script>
    Chart.register(window.ChartDataLabels);

    // Earnings Summary Chart
    const earningsSummaryData = {
        labels: [<c:forEach var="entry" items="${earningsSummary}" varStatus="loop">'${entry.month}'<c:if test="${!loop.last}">,</c:if></c:forEach>],
        datasets: [
            {
                label: 'Income',
                data: [<c:forEach var="entry" items="${earningsSummary}" varStatus="loop">${entry.income}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                borderColor: '#FF4D4F',
                backgroundColor: 'rgba(255, 77, 79, 0.2)',
                fill: true,
                tension: 0.4
            },
            {
                label: 'Expense',
                data: [<c:forEach var="entry" items="${earningsSummary}" varStatus="loop">${entry.expense}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                borderColor: '#F97316',
                backgroundColor: 'rgba(249, 115, 22, 0.2)',
                fill: true,
                tension: 0.4
            }
        ]
    };

    new Chart(document.getElementById('earningsSummaryChart'), {
        type: 'line',
        data: earningsSummaryData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { color: '#E5E7EB', callback: value => '$' + value },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' }
                },
                x: {
                    ticks: { color: '#E5E7EB' },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' }
                }
            },
            plugins: {
                legend: { position: 'top', labels: { color: '#E5E7EB' } },
                datalabels: { display: false }
            }
        }
    });

    // Rent Status Chart
    const rentStatusData = {
        labels: ['Hired', 'Pending', 'Cancelled'],
        datasets: [{
            data: [
                ${rentStatus['completed'] != null ? rentStatus['completed'] : 0},
                ${rentStatus['pending'] != null ? rentStatus['pending'] : xa0},
                ${rentStatus['cancelled'] != null ? rentStatus['cancelled'] : 0}
            ],
            backgroundColor: ['#FF4D4F', '#F97316', '#6B7280']
        }]
    };

    new Chart(document.getElementById('rentStatusChart'), {
        type: 'doughnut',
        data: rentStatusData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'right', labels: { color: '#E5E7EB' } },
                datalabels: {
                    color: '#fff',
                    formatter: (value) => value + '%'
                }
            }
        }
    });

    // Car Types Chart
    const carTypesData = {
        labels: ['Sedan', 'SUV', 'Hatchback', 'Convertible', 'Truck', 'Minivan'],
        datasets: [{
            data: [
                ${carTypes['Sedan'] != null ? carTypes['Sedan'] : 0},
                ${carTypes['SUV'] != null ? carTypes['SUV'] : 0},
                ${carTypes['Hatchback'] != null ? carTypes['Hatchback'] : 0},
                ${carTypes['Convertible'] != null ? carTypes['Convertible'] : 0},
                ${carTypes['Truck'] != null ? carTypes['Truck'] : 0},
                ${carTypes['Minivan'] != null ? carTypes['Minivan'] : 0}
            ],
            backgroundColor: '#FF4D4F'
        }]
    };

    new Chart(document.getElementById('carTypesChart'), {
        type: 'bar',
        data: carTypesData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            indexAxis: 'y',
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: { color: '#E5E7EB' },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' }
                },
                y: {
                    ticks: { color: '#E5E7EB' },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' }
                }
            },
            plugins: {
                legend: { display: false },
                datalabels: {
                    color: '#E5E7EB',
                    anchor: 'end',
                    align: 'end',
                    formatter: (value) => value + '%'
                }
            }
        }
    });

    // Modal Functions
    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'flex';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    document.getElementById('addBookingBtn').addEventListener('click', () => openModal('addBookingModal'));

    // Show car availability modal if results are available
    <c:if test="${not empty availableCarsForCheck}">
    openModal('checkAvailabilityModal');
    </c:if>

    // AJAX for Filters and Search
    document.getElementById('applyFilters').addEventListener('click', function() {
        const year = document.getElementById('yearFilter').value;
        const searchQuery = document.getElementById('searchQuery').value;
        const filterStatus = document.getElementById('statusFilter').value;
        const clientId = document.getElementById('clientFilter').value;
        const carId = document.getElementById('carFilter').value;
        const driverId = document.getElementById('driverFilter').value;

        $.ajax({
            url: 'dashboard',
            method: 'GET',
            data: { year, searchQuery, filterStatus, clientId, carId, driverId },
            success: function(response) {
                const parser = new DOMParser();
                const doc = parser.parseFromString(response, 'text/html');
                const newTableBody = doc.querySelector('#bookingsTableBody').innerHTML;
                document.getElementById('bookingsTableBody').innerHTML = newTableBody;
            },
            error: function(err) {
                console.error('Error applying filters:', err);
            }
        });
    });
</script>
</body>
</html>