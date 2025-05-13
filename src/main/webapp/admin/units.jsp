<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Wheels - Manage Units</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
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

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #E5E7EB;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.05);
        }

        .input-field, .form-select {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #E5E7EB;
            transition: all 0.3s ease;
            padding: 0.75rem;
            border-radius: 8px;
            width: 100%;
        }

        .input-field:focus, .form-select:focus {
            border-color: #FF4D4F;
            box-shadow: 0 0 10px rgba(255, 77, 79, 0.2);
            outline: none;
        }

        .table-row {
            transition: all 0.3s ease;
        }

        .table-row:hover {
            background: rgba(255, 255, 255, 0.05);
            transform: translateX(5px);
        }

        th {
            background: rgba(255, 255, 255, 0.05);
            color: #A0AEC0;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem;
        }

        td {
            padding: 1rem;
            font-size: 0.875rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
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
            max-width: 600px;
            position: relative;
            transform: scale(0.95);
            transition: transform 0.3s ease;
        }

        .modal.show .modal-content {
            transform: scale(1);
        }

        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            color: #E5E7EB;
            cursor: pointer;
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #E5E7EB;
            margin-bottom: 0.5rem;
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

        @media (max-width: 640px) {
            th, td {
                padding: 0.75rem;
                font-size: 0.75rem;
            }

            .modal-content {
                padding: 1rem;
                max-width: 90%;
            }
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
            <a href="dashboard" class="sidebar-item flex items-center space-x-3 p-3 rounded-lg">
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
            <a href="units" class="sidebar-item active flex items-center space-x-3 p-3 rounded-lg">
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
    <header class="flex flex-col md:flex-row justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-white mb-4 md:mb-0">Manage Units</h1>
        <div class="flex items-center space-x-4">
            <button onclick="openModal('add')" class="btn-primary text-white px-4 py-2 rounded-lg">Add Car</button>
        </div>
    </header>

    <!-- Cars Table -->
    <section class="card p-6">
        <c:if test="${empty cars}">
            <p class="text-gray-400">No cars found. Add a new car to get started.</p>
        </c:if>
        <c:if test="${not empty cars}">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                    <tr>
                        <th>Car ID</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Type</th>
                        <th>Capacity</th>
                        <th>Price/Day</th>
                        <th>License Plate</th>
                        <th>Parc</th>
                        <th>Availability</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="car" items="${cars}">
                        <tr class="border-t border-gray-700 table-row">
                            <td class="text-white">CR-WS${car.car_id}</td>
                            <td class="text-white">${car.brand}</td>
                            <td class="text-white">${car.model}</td>
                            <td class="text-white">${car.car_type}</td>
                            <td class="text-white">${car.capacity}</td>
                            <td class="text-white">$${car.price_per_day}</td>
                            <td class="text-white">${car.license_plate}</td>
                            <td class="text-white">${car.parc_name}</td>
                            <td>
                                <span class="status-badge ${car.availability ? 'bg-green-600 text-green-100' : 'bg-red-600 text-red-100'}">
                                        ${car.availability ? 'Available' : 'Rented'}
                                </span>
                            </td>
                            <td class="text-white"><fmt:formatDate value="${car.created_at}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <td class="space-x-2">
                                <button onclick="openModal('edit', ${car.car_id}, '${car.brand}', '${car.model}', '${car.car_type}', ${car.capacity}, ${car.price_per_day}, '${car.license_plate}', '${car.parc_name != '-' ? car.parc_name : ''}')" class="text-blue-400 hover:text-blue-300 font-medium">Edit</button>
                                <form action="units" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="carId" value="${car.car_id}">
                                    <button type="submit" class="text-red-400 hover:text-red-300 font-medium" onclick="return confirm('Are you sure you want to delete this car?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </section>
</main>

<!-- Modal for Add/Edit Car -->
<div id="carModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">×</span>
        <h2 id="modalTitle" class="text-xl font-bold text-white mb-6"></h2>
        <form id="carForm" action="units" method="post">
            <input type="hidden" name="action" id="modalAction">
            <input type="hidden" name="carId" id="carId">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                <div>
                    <label class="form-label">Brand</label>
                    <input type="text" name="brand" id="brand" class="input-field" required>
                </div>
                <div>
                    <label class="form-label">Model</label>
                    <input type="text" name="model" id="model" class="input-field" required>
                </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                <div>
                    <label class="form-label">Car Type</label>
                    <select name="carType" id="carType" class="form-select" required>
                        <option value="">Select Type</option>
                        <option value="Sedan">Sedan</option>
                        <option value="SUV">SUV</option>
                        <option value="Hatchback">Hatchback</option>
                        <option value="Convertible">Convertible</option>
                        <option value="Truck">Truck</option>
                        <option value="Minivan">Minivan</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Capacity</label>
                    <input type="number" name="capacity" id="capacity" class="input-field" required min="1">
                </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                <div>
                    <label class="form-label">Price/Day ($)</label>
                    <input type="number" name="pricePerDay" id="pricePerDay" class="input-field" step="0.01" required min="0">
                </div>
                <div>
                    <label class="form-label">License Plate</label>
                    <input type="text" name="licensePlate" id="licensePlate" class="input-field" required>
                </div>
            </div>
            <div class="mb-6">
                <label class="form-label">Parc (Optional)</label>
                <select name="parcId" id="parcId" class="form-select">
                    <option value="">No Parc</option>
                    <c:forEach var="parc" items="${parcs}">
                        <option value="${parc.parc_id}">${parc.parc_name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex justify-end space-x-3">
                <button type="button" onclick="closeModal()" class="btn-secondary px-4 py-2 rounded-lg">Cancel</button>
                <button type="submit" class="btn-primary px-4 py-2 rounded-lg">Save</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(action, carId = '', brand = '', model = '', carType = '', capacity = '', pricePerDay = '', licensePlate = '', parcName = '') {
        const modal = document.getElementById('carModal');
        const modalTitle = document.getElementById('modalTitle');
        const modalAction = document.getElementById('modalAction');
        const carIdField = document.getElementById('carId');
        const brandField = document.getElementById('brand');
        const modelField = document.getElementById('model');
        const carTypeField = document.getElementById('carType');
        const capacityField = document.getElementById('capacity');
        const pricePerDayField = document.getElementById('pricePerDay');
        const licensePlateField = document.getElementById('licensePlate');
        const parcIdField = document.getElementById('parcId');

        if (action === 'add') {
            modalTitle.textContent = 'Add New Car';
            modalAction.value = 'add';
            carIdField.value = '';
            brandField.value = '';
            modelField.value = '';
            carTypeField.value = '';
            capacityField.value = '';
            pricePerDayField.value = '';
            licensePlateField.value = '';
            parcIdField.value = '';
        } else if (action === 'edit') {
            modalTitle.textContent = 'Edit Car';
            modalAction.value = 'update';
            carIdField.value = carId;
            brandField.value = brand;
            modelField.value = model;
            carTypeField.value = carType;
            capacityField.value = capacity;
            pricePerDayField.value = pricePerDay;
            licensePlateField.value = licensePlate;
            parcIdField.value = parcName ? Array.from(parcIdField.options).find(opt => opt.text === parcName)?.value || '' : '';
        }

        modal.style.display = 'flex';
        setTimeout(() => modal.classList.add('show'), 10);
    }

    function closeModal() {
        const modal = document.getElementById('carModal');
        modal.classList.remove('show');
        setTimeout(() => modal.style.display = 'none', 300);
    }

    window.onclick = function(event) {
        const modal = document.getElementById('carModal');
        if (event.target === modal) {
            closeModal();
        }
    };
</script>
</body>
</html>