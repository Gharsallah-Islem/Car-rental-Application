<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>Calendar - Wheels</title>
  <!-- FullCalendar CSS -->
  <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.css" rel="stylesheet">
  <!-- Bootstrap CSS for modal -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Tailwind CSS -->
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <!-- Inter Font -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(145deg, #0A0E1A 0%, #1A2338 100%);
      color: #E5E7EB;
      overflow-x: hidden;
      margin: 0;
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

    .icon-btn {
      background: rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;
    }

    .icon-btn:hover {
      background: rgba(255, 255, 255, 0.2);
      transform: scale(1.05);
    }

    .form-label {
      font-size: 0.875rem;
      font-weight: 500;
      color: #E5E7EB;
      margin-bottom: 0.5rem;
    }

    .form-select {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.1);
      color: #E5E7EB;
      transition: all 0.3s ease;
      padding: 0.75rem;
      border-radius: 8px;
      width: 100%;
    }

    .form-select:focus {
      border-color: #FF4D4F;
      box-shadow: 0 0 10px rgba(255, 77, 79, 0.2);
      outline: none;
    }

    .modal {
      backdrop-filter: blur(5px);
      background: rgba(0, 0, 0, 0.7);
    }

    .modal-content {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 16px;
      color: #E5E7EB;
      animation: slideIn 0.3s ease-out;
    }

    @keyframes slideIn {
      from { transform: translateY(-50px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }

    .modal-header {
      background: linear-gradient(90deg, #FF4D4F, #F97316);
      color: white;
      border-top-left-radius: 16px;
      border-top-right-radius: 16px;
      border-bottom: none;
    }

    .modal-body p {
      margin-bottom: 0.75rem;
    }

    .modal-body strong {
      color: #A0AEC0;
    }

    .fc-daygrid-day {
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 4px;
    }

    .fc-daygrid-day:hover {
      background: rgba(255, 255, 255, 0.05);
    }

    .fc-daygrid-day-number {
      color: #E5E7EB;
    }

    .fc-daygrid-day-top {
      padding: 4px;
    }

    .fc-daygrid-day.fc-day-today {
      background: rgba(255, 77, 79, 0.2);
    }

    .fc-daygrid-day.fc-day-past .fc-daygrid-day-number {
      color: #6B7280;
    }

    .fc-event {
      border: none !important;
      font-size: 12px !important;
      padding: 2px 5px !important;
      border-radius: 3px !important;
      cursor: pointer;
      background: linear-gradient(90deg, #FF4D4F, #F97316) !important;
      color: white !important;
      transition: transform 0.2s ease;
    }

    .fc-event:hover {
      transform: scale(1.05);
    }

    .fc-button {
      background: linear-gradient(90deg, #FF4D4F, #F97316) !important;
      border: none !important;
      color: white !important;
      border-radius: 0.375rem !important;
      transition: background 0.3s ease, transform 0.1s ease !important;
    }

    .fc-button:hover {
      background: linear-gradient(90deg, #F97316, #FF4D4F) !important;
      transform: scale(1.05) !important;
    }

    .fc-button:focus {
      outline: none !important;
      box-shadow: 0 0 0 3px rgba(255, 77, 79, 0.2) !important;
    }

    .fc .fc-daygrid-day-frame {
      min-height: 100px !important;
    }

    .fc .fc-col-header-cell-cushion {
      color: #E5E7EB;
      font-weight: 600;
    }

    .fc .fc-daygrid-body {
      background: rgba(255, 255, 255, 0.02);
    }

    .fc .fc-scrollgrid {
      border-color: rgba(255, 255, 255, 0.1) !important;
    }

    .beta-badge {
      background: rgba(255, 255, 255, 0.1);
      color: #A0AEC0;
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
      .fc .fc-daygrid-day-frame {
        min-height: 60px !important;
      }

      .fc-event {
        font-size: 10px !important;
        padding: 1px 3px !important;
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
      <a href="calendar" class="sidebar-item active flex items-center space-x-3 p-3 rounded-lg">
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
    <h1 class="text-3xl font-bold text-white flex items-center space-x-2">
      <span>Calendar</span>
      <span class="text-sm font-medium beta-badge px-2 py-1 rounded-full">Beta</span>
    </h1>
    <div class="flex items-center space-x-4">
      <button class="p-2 rounded-full icon-btn">
        <svg class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
        </svg>
      </button>
      <button class="p-2 rounded-full icon-btn">
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

  <!-- Filters -->
  <section class="card p-6 mb-8">
    <div class="flex justify-between items-center mb-4">
      <h3 class="text-lg font-semibold text-white">Filter Bookings</h3>
    </div>
    <form id="filterForm" method="get" action="calendar" class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <input type="hidden" name="year" value="${year}">
      <input type="hidden" name="month" value="${month}">
      <div>
        <label for="carId" class="form-label">Car</label>
        <select name="carId" id="carId" class="form-select" onchange="this.form.submit()">
          <option value="">All Cars</option>
          <c:forEach var="car" items="${cars}">
            <option value="${car.car_id}" <c:if test="${selectedCarId == car.car_id}">selected</c:if>>${car.car_model}</option>
          </c:forEach>
        </select>
      </div>
      <div>
        <label for="clientId" class="form-label">Client</label>
        <select name="clientId" id="clientId" class="form-select" onchange="this.form.submit()">
          <option value="">All Clients</option>
          <c:forEach var="client" items="${clients}">
            <option value="${client.user_id}" <c:if test="${selectedClientId == client.user_id}">selected</c:if>>${client.full_name}</option>
          </c:forEach>
        </select>
      </div>
      <div>
        <label for="driverId" class="form-label">Driver</label>
        <select name="driverId" id="driverId" class="form-select" onchange="this.form.submit()">
          <option value="">All Drivers</option>
          <c:forEach var="driver" items="${drivers}">
            <option value="${driver.user_id}" <c:if test="${selectedDriverId == driver.user_id}">selected</c:if>>${driver.full_name}</option>
          </c:forEach>
        </select>
      </div>
    </form>
  </section>

  <!-- Calendar -->
  <section class="card p-6">
    <div id="calendar"></div>
  </section>
</main>

<!-- Modal for Booking Details -->
<div class="modal fade fixed top-0 left-0 hidden w-full h-full outline-none overflow-x-hidden overflow-y-auto" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
  <div class="modal-dialog relative w-auto pointer-events-none max-w-lg mx-auto">
    <div class="modal-content border-none shadow-lg relative flex flex-col w-full pointer-events-auto">
      <div class="modal-header flex items-center justify-between p-4">
        <h5 class="text-lg font-semibold text-white" id="bookingModalLabel">Booking Details</h5>
        <button type="button" class="text-white hover:text-gray-200 transition" data-bs-dismiss="modal">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
      <div class="modal-body p-6">
        <p><strong>Car:</strong> <span id="modalCar"></span></p>
        <p><strong>Client:</strong> <span id="modalClient"></span></p>
        <p><strong>Driver:</strong> <span id="modalDriver"></span></p>
        <p><strong>Start Date:</strong> <span id="modalStart"></span></p>
        <p><strong>End Date:</strong> <span id="modalEnd"></span></p>
        <p><strong>Status:</strong> <span id="modalStatus"></span></p>
      </div>
      <div class="modal-footer flex justify-end space-x-2 p-4">
        <button type="button" class="btn-secondary px-4 py-2 rounded-lg" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn-primary px-4 py-2 rounded-lg" onclick="editBooking()">Edit</button>
      </div>
    </div>
  </div>
</div>

<!-- FullCalendar JS -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.js"></script>
<!-- Bootstrap JS for modal -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    // Ensure eventsJson is properly formatted as a JavaScript array
    var events = [];
    try {
      events = JSON.parse('${eventsJson != null ? eventsJson : "[]"}');
      console.log('Parsed Events:', events); // Debugging: Log the events to the console
    } catch (e) {
      console.error('Error parsing eventsJson:', e);
      events = [];
    }

    // Ensure month and year are valid, fallback to current date if not
    var year = parseInt('${year}', 10);
    var month = parseInt('${month}', 10);
    var today = new Date();

    if (isNaN(year) || isNaN(month) || month < 1 || month > 12) {
      year = today.getFullYear();
      month = today.getMonth() + 1; // JavaScript months are 0-based, so add 1
    }

    // Pad the month with a leading zero if necessary
    var paddedMonth = month < 10 ? '0' + month : month;
    var initialDate = year + '-' + paddedMonth + '-01';
    console.log('Initial Date:', initialDate); // Debugging: Log the initial date

    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      initialDate: initialDate,
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      events: events,
      eventClick: function(info) {
        // Ensure event properties exist before accessing
        var eventId = info.event.id || 'Unknown';
        var eventTitle = info.event.title || 'Unknown';
        var eventClient = info.event.extendedProps && info.event.extendedProps.client ? info.event.extendedProps.client : 'Unknown';
        var eventDriver = info.event.extendedProps && info.event.extendedProps.driver ? info.event.extendedProps.driver : 'Unknown';
        var eventStart = info.event.start ? info.event.start.toISOString().split('T')[0] : 'Unknown';
        var eventEnd = info.event.end ? info.event.end.toISOString().split('T')[0] : eventStart;
        var eventStatus = info.event.extendedProps && info.event.extendedProps.status ? info.event.extendedProps.status : 'Unknown';

        document.getElementById('bookingModalLabel').innerText = 'Booking #' + eventId;
        document.getElementById('modalCar').innerText = eventTitle.split(' (')[0];
        document.getElementById('modalClient').innerText = eventClient;
        document.getElementById('modalDriver').innerText = eventDriver;
        document.getElementById('modalStart').innerText = eventStart;
        document.getElementById('modalEnd').innerText = eventEnd;
        document.getElementById('modalStatus').innerText = eventStatus;

        var modal = new bootstrap.Modal(document.getElementById('bookingModal'));
        modal.show();
      },
      eventMouseEnter: function(info) {
        // Ensure event properties exist before accessing
        var eventTitle = info.event.title || 'Unknown';
        var eventClient = info.event.extendedProps && info.event.extendedProps.client ? info.event.extendedProps.client : 'Unknown';
        var eventDriver = info.event.extendedProps && info.event.extendedProps.driver ? info.event.extendedProps.driver : 'Unknown';
        var eventStatus = info.event.extendedProps && info.event.extendedProps.status ? info.event.extendedProps.status : 'Unknown';

        info.el.setAttribute('title',
                'Car: ' + eventTitle.split(' (')[0] + '\n' +
                'Client: ' + eventClient + '\n' +
                'Driver: ' + eventDriver + '\n' +
                'Status: ' + eventStatus
        );
      },
      eventMouseLeave: function(info) {
        info.el.removeAttribute('title');
      },
      eventDidMount: function(info) {
        console.log('Event Rendered:', info.event); // Debugging: Log each rendered event
      }
    });

    calendar.render();
  });

  function editBooking() {
    alert('Edit functionality to be implemented.');
    // You can redirect to an edit page or open a form here
  }
</script>
</body>
</html>