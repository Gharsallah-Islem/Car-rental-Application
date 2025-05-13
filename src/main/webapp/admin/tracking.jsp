<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">
  <title>Tracking - Wheels</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
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

    #map {
      height: 400px;
      border-radius: 16px;
      background: #1A2338;
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

    .btn-secondary {
      background: rgba(255, 255, 255, 0.1);
      color: #E5E7EB;
      transition: all 0.3s ease;
    }

    .btn-secondary:hover {
      background: rgba(255, 255, 255, 0.2);
      transform: scale(1.05);
    }

    .input-field, .select-field {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.1);
      color: #E5E7EB;
      transition: all 0.3s ease;
      padding: 0.75rem;
      border-radius: 8px;
      width: 100%;
    }

    .input-field:focus, .select-field:focus {
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

    .form-label {
      font-size: 0.875rem;
      font-weight: 500;
      color: #E5E7EB;
      margin-bottom: 0.5rem;
    }

    .status-badge {
      padding: 0.25rem 0.5rem;
      border-radius: 9999px;
      font-size: 0.75rem;
      text-transform: capitalize;
    }

    .status-active {
      background: rgba(34, 197, 94, 0.2);
      color: #86EFAC;
    }

    .status-idle {
      background: rgba(234, 179, 8, 0.2);
      color: #FDE047;
    }

    .status-offline {
      background: rgba(107, 114, 128, 0.2);
      color: #D1D5DB;
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
      <a href="tracking" class="sidebar-item active flex items-center space-x-3 p-3 rounded-lg">
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
    <h1 class="text-3xl font-bold text-white mb-4 md:mb-0 flex items-center space-x-2">
      <span>Tracking</span>
      <span class="text-sm font-medium bg-gray-700 px-2 py-1 rounded-full">Beta</span>
    </h1>
    <div class="flex items-center space-x-4">
      <button class="p-2 rounded-full bg-gray-700 hover:bg-gray-600 transition">
        <svg class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
        </svg>
      </button>
      <button class="p-2 rounded-full bg-gray-700 hover:bg-gray-600 transition">
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

  <!-- Map Section -->
  <section class="card p-6 mb-8">
    <h3 class="text-lg font-semibold text-white mb-4">Live Car Locations</h3>
    <div id="map"></div>
  </section>

  <!-- Filter Tracking History -->
  <section class="card p-6 mb-8">
    <h3 class="text-lg font-semibold text-white mb-4">Filter Tracking History</h3>
    <form action="tracking" method="get" class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div>
        <label class="form-label">Car</label>
        <select name="carId" class="select-field">
          <option value="">All Cars</option>
          <c:forEach var="car" items="${cars}">
            <option value="${car.car_id}" ${car.car_id == selectedCarId ? 'selected' : ''}>${car.car_model}</option>
          </c:forEach>
        </select>
      </div>
      <div>
        <label class="form-label">Start Date</label>
        <input type="date" name="startDate" value="${selectedStartDate}" class="input-field" required>
      </div>
      <div>
        <label class="form-label">End Date</label>
        <input type="date" name="endDate" value="${selectedEndDate}" class="input-field" required>
      </div>
      <div class="flex items-end">
        <button type="submit" class="btn-primary text-white w-full px-4 py-2 rounded-lg">Filter</button>
      </div>
    </form>
  </section>

  <!-- Add Tracking Record -->
  <section class="card p-6 mb-8">
    <h3 class="text-lg font-semibold text-white mb-4">Add New Tracking Record</h3>
    <form action="tracking" method="post" class="grid grid-cols-1 md:grid-cols-5 gap-4">
      <input type="hidden" name="action" value="add">
      <div>
        <label class="form-label">Car</label>
        <select name="carId" class="select-field" required>
          <option value="">Select Car</option>
          <c:forEach var="car" items="${cars}">
            <option value="${car.car_id}">${car.car_model}</option>
          </c:forEach>
        </select>
      </div>
      <div>
        <label class="form-label">Latitude</label>
        <input type="number" step="0.000001" name="latitude" class="input-field" required placeholder="e.g., 40.7128">
      </div>
      <div>
        <label class="form-label">Longitude</label>
        <input type="number" step="0.000001" name="longitude" class="input-field" required placeholder="e.g., -74.0060">
      </div>
      <div>
        <label class="form-label">Status</label>
        <select name="status" class="select-field" required>
          <option value="active">Active</option>
          <option value="idle">Idle</option>
          <option value="offline">Offline</option>
        </select>
      </div>
      <div class="flex items-end">
        <button type="submit" class="btn-primary text-white w-full px-4 py-2 rounded-lg">Add Record</button>
      </div>
    </form>
    <c:if test="${not empty message}">
      <p class="text-green-400 mt-2">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
      <p class="text-red-400 mt-2">${error}</p>
    </c:if>
  </section>

  <!-- Tracking History Table -->
  <section class="card p-6 mb-8">
    <h3 class="text-lg font-semibold text-white mb-4">Tracking History</h3>
    <c:if test="${empty trackingHistory}">
      <p class="text-gray-400">Apply a filter to view tracking history, or view all records below.</p>
    </c:if>
    <c:if test="${not empty trackingHistory}">
      <div class="overflow-x-auto">
        <table class="w-full text-left">
          <thead>
          <tr>
            <th>Car</th>
            <th>License Plate</th>
            <th>Latitude</th>
            <th>Longitude</th>
            <th>Timestamp</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="tracking" items="${trackingHistory}">
            <tr class="border-t border-gray-700 table-row">
              <td class="text-white">${tracking.car_model}</td>
              <td class="text-white">${tracking.license_plate}</td>
              <td class="text-white">${tracking.latitude}</td>
              <td class="text-white">${tracking.longitude}</td>
              <td class="text-white"><fmt:formatDate value="${tracking.timestamp}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
              <td>
                                <span class="status-badge ${tracking.status == 'active' ? 'status-active' : tracking.status == 'idle' ? 'status-idle' : 'status-offline'}">
                                    ${tracking.status}
                                </span>
              </td>
              <td>
                <a href="tracking?action=delete&trackingId=${tracking.tracking_id}" class="text-red-400 hover:text-red-300 font-medium" onclick="return confirm('Are you sure you want to delete this tracking record?')">Delete</a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>
  </section>

  <!-- All Tracking Records -->
  <section class="card p-6 mb-8">
    <h3 class="text-lg font-semibold text-white mb-4">All Tracking Records</h3>
    <c:if test="${empty trackingData}">
      <p class="text-gray-400">No tracking records found.</p>
    </c:if>
    <c:if test="${not empty trackingData}">
      <div class="overflow-x-auto">
        <table class="w-full text-left">
          <thead>
          <tr>
            <th>Car</th>
            <th>License Plate</th>
            <th>Latitude</th>
            <th>Longitude</th>
            <th>Timestamp</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="tracking" items="${trackingData}">
            <tr class="border-t border-gray-700 table-row">
              <td class="text-white">${tracking.car_model}</td>
              <td class="text-white">${tracking.license_plate}</td>
              <td class="text-white">${tracking.latitude}</td>
              <td class="text-white">${tracking.longitude}</td>
              <td class="text-white"><fmt:formatDate value="${tracking.timestamp}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
              <td>
                                <span class="status-badge ${tracking.status == 'active' ? 'status-active' : tracking.status == 'idle' ? 'status-idle' : 'status-offline'}">
                                    ${tracking.status}
                                </span>
              </td>
              <td>
                <a href="tracking?action=delete&trackingId=${tracking.tracking_id}" class="text-red-400 hover:text-red-300 font-medium" onclick="return confirm('Are you sure you want to delete this tracking record?')">Delete</a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>
  </section>
</main>

<script>
  // Initialize the map
  var map = L.map('map', {
    zoomControl: true
  }).setView([40.7128, -74.0060], 10); // Default center (New York)

  // Add default OpenStreetMap tiles (natural colors)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19
  }).addTo(map);

  // Customize zoom controls to match the dark theme
  map.zoomControl.setPosition('topright');
  var zoomControl = document.getElementsByClassName('leaflet-control-zoom')[0];
  if (zoomControl) {
    zoomControl.style.background = 'rgba(255, 255, 255, 0.1)';
    zoomControl.style.backdropFilter = 'blur(5px)';
    zoomControl.style.border = '1px solid rgba(255, 255, 255, 0.1)';
    zoomControl.style.borderRadius = '8px';
  }

  // Add markers for each car's latest location
  var trackingData = [
    <c:forEach var="tracking" items="${trackingData}" varStatus="loop">
    {
      car_model: "${tracking.car_model}",
      license_plate: "${tracking.license_plate}",
      latitude: ${tracking.latitude},
      longitude: ${tracking.longitude},
      status: "${tracking.status}",
      timestamp: "<fmt:formatDate value='${tracking.timestamp}' pattern='yyyy-MM-dd HH:mm:ss'/>"
    }${loop.last ? '' : ','}
    </c:forEach>
  ];

  // Keep track of unique cars to show only the latest location
  var latestLocations = {};
  trackingData.forEach(function(tracking) {
    var key = tracking.car_model + tracking.license_plate;
    if (!latestLocations[key] || new Date(tracking.timestamp) > new Date(latestLocations[key].timestamp)) {
      latestLocations[key] = tracking;
    }
  });

  // Add markers to the map
  Object.values(latestLocations).forEach(function(tracking) {
    var markerColor = tracking.status === 'active' ? '#86EFAC' : tracking.status === 'idle' ? '#FDE047' : '#D1D5DB';
    var marker = L.circleMarker([tracking.latitude, tracking.longitude], {
      radius: 8,
      fillColor: markerColor,
      color: '#fff',
      weight: 2,
      opacity: 1,
      fillOpacity: 0.8
    }).addTo(map);

    marker.bindPopup(`
            <div style="background: rgba(0, 0, 0, 0.8); color: #E5E7EB; padding: 8px; border-radius: 8px;">
                <b style="color: #FF4D4F;">${tracking.car_model}</b><br>
                <span style="color: #A0AEC0;">License Plate:</span> ${tracking.license_plate}<br>
                <span style="color: #A0AEC0;">Status:</span> <span style="color: ${markerColor}">${tracking.status}</span><br>
                <span style="color: #A0AEC0;">Last Updated:</span> ${tracking.timestamp}
            </div>
        `);
  });

  // Adjust map bounds to fit all markers
  if (Object.keys(latestLocations).length > 0) {
    var latlngs = Object.values(latestLocations).map(function(tracking) {
      return [tracking.latitude, tracking.longitude];
    });
    var bounds = L.latLngBounds(latlngs);
    map.fitBounds(bounds, { padding: [50, 50] });
  }
</script>
</body>
</html>