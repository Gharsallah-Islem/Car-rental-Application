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
  <title>Financials - Wheels</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.min.js"></script>
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
      height: 250px;
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

    .summary-widget {
      background: linear-gradient(135deg, #FF4D4F, #F97316);
      color: white;
      border-radius: 16px;
      padding: 1.5rem;
      position: relative;
      overflow: hidden;
    }

    .summary-widget::before {
      content: '';
      position: absolute;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255, 255, 255, 0.2), transparent);
      transform: rotate(45deg);
    }

    .status-badge {
      padding: 0.25rem 0.5rem;
      border-radius: 9999px;
      font-size: 0.75rem;
      text-transform: capitalize;
    }

    .status-completed {
      background: rgba(34, 197, 94, 0.2);
      color: #86EFAC;
    }

    .status-pending {
      background: rgba(234, 179, 8, 0.2);
      color: #FDE047;
    }

    @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.1); }
      100% { transform: scale(1); }
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
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
      <a href="financials" class="sidebar-item active flex items-center space-x-3 p-3 rounded-lg">
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
    <h1 class="text-3xl font-bold text-white mb-4 md:mb-0 flex items-center space-x-2">
      <span>Financials</span>
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
        <img src="https://via.placeholder.com/32" alt="User" class="w-8 h-8 rounded-full">
        <span class="text-white font-medium">Abram Schieffer</span>
        <span class="text-gray-400 text-sm">Admin</span>
      </div>
    </div>
  </header>

  <!-- Key Metrics and Summary Widget -->
  <section class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
    <div class="card p-6">
      <h3 class="text-sm font-medium text-gray-400 mb-2">Total Revenue</h3>
      <p class="text-2xl font-bold text-white">$<fmt:formatNumber value="${totalRevenue}" type="number"/></p>
      <p class="text-xs text-green-400">+2.80% from last month</p>
    </div>
    <div class="card p-6">
      <h3 class="text-sm font-medium text-gray-400 mb-2">Total Expenses</h3>
      <p class="text-2xl font-bold text-white">$<fmt:formatNumber value="${totalExpenses}" type="number"/></p>
      <p class="text-xs text-red-400">+1.50% from last month</p>
    </div>
    <div class="card p-6">
      <h3 class="text-sm font-medium text-gray-400 mb-2">Profit Margin</h3>
      <p class="text-2xl font-bold text-white">$<fmt:formatNumber value="${profitMargin}" type="number"/></p>
      <p class="text-xs text-green-400">+3.20% from last month</p>
    </div>
    <div class="summary-widget">
      <h3 class="text-lg font-semibold mb-2">Financial Health</h3>
      <p class="text-3xl font-bold">$<fmt:formatNumber value="${profitMargin}" type="number"/></p>
      <p class="text-sm opacity-80">Net Profit This Year</p>
      <div class="mt-4">
        <button class="text-white text-sm underline hover:opacity-80 transition">View Report</button>
      </div>
    </div>
  </section>

  <!-- Earnings Summary Chart -->
  <section class="card p-6 mb-8">
    <div class="flex justify-between items-center mb-4">
      <h3 class="text-lg font-semibold text-white">Earnings Summary</h3>
      <select class="select-field text-sm">
        <option>2025</option>
        <option>2024</option>
        <option>2023</option>
      </select>
    </div>
    <div class="chart-container">
      <canvas id="financialChart"></canvas>
    </div>
  </section>

  <!-- Transactions Table -->
  <section class="card p-6 mb-8">
    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
      <h3 class="text-lg font-semibold text-white">Transactions</h3>
      <div class="flex flex-wrap gap-2 w-full md:w-auto">
        <select class="select-field text-sm">
          <option>This Year</option>
          <option>Last Year</option>
        </select>
        <input type="text" placeholder="Search transaction ID, client, etc" class="input-field text-sm">
        <select class="select-field text-sm">
          <option>Filter by Type</option>
          <option>Income</option>
          <option>Expense</option>
        </select>
        <button class="btn-primary text-white px-4 py-2 rounded-lg text-sm" onclick="openAddModal()">Add Transaction</button>
      </div>
    </div>
    <c:if test="${empty transactions}">
      <p class="text-gray-400">No transactions found.</p>
    </c:if>
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead>
        <tr>
          <th>Transaction ID</th>
          <th>Booking</th>
          <th>Type</th>
          <th>Category</th>
          <th>Amount</th>
          <th>Date</th>
          <th>Description</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="transaction" items="${transactions}">
          <tr class="border-t border-gray-700 table-row">
            <td class="text-white">TR-WS${transaction.financial_id}</td>
            <td class="text-white">
              <c:choose>
                <c:when test="${not empty transaction.booking_id}">
                  #${transaction.booking_id} (${transaction.car_model}, ${transaction.client_name})
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td class="text-white">${transaction.type}</td>
            <td class="text-white">${transaction.category}</td>
            <td class="text-white">$<fmt:formatNumber value="${transaction.amount}" type="number" minFractionDigits="2"/></td>
            <td class="text-white">${transaction.transaction_date}</td>
            <td class="text-white">${transaction.description != null ? transaction.description : '-'}</td>
            <td>
                            <span class="status-badge ${transaction.status == 'completed' ? 'status-completed' : 'status-pending'}">
                                ${transaction.status}
                            </span>
            </td>
            <td class="space-x-2">
              <button class="text-blue-400 hover:text-blue-300 font-medium" onclick="editTransaction('${transaction.financial_id}', '${transaction.booking_id}', '${transaction.type}', '${transaction.category}', '${transaction.amount}', '${transaction.transaction_date}', '${transaction.description}', '${transaction.status}')">Edit</button>
              <a href="financials?action=delete&financialId=${transaction.financial_id}" class="text-red-400 hover:text-red-300 font-medium" onclick="return confirm('Are you sure you want to delete this transaction?')">Delete</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </section>

  <!-- Add Transaction Modal -->
  <div class="modal" id="addTransactionModal">
    <div class="modal-content">
      <span class="close-btn" onclick="closeAddModal()">×</span>
      <h5 class="text-xl font-bold text-white mb-6" id="addTransactionModalLabel">Add Transaction</h5>
      <form id="addTransactionForm" action="financials" method="post">
        <input type="hidden" name="action" value="add">
        <div class="mb-5">
          <label class="form-label">Booking (Optional)</label>
          <select name="bookingId" class="select-field">
            <option value="">None</option>
            <c:forEach var="booking" items="${bookings}">
              <option value="${booking.booking_id}">#${booking.booking_id} (${booking.car_model}, ${booking.client_name})</option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-5">
          <label class="form-label">Type</label>
          <select name="type" class="select-field" required>
            <option value="income">Income</option>
            <option value="expense">Expense</option>
          </select>
        </div>
        <div class="mb-5">
          <label class="form-label">Category</label>
          <input type="text" name="category" class="input-field" required>
        </div>
        <div class="mb-5">
          <label class="form-label">Amount</label>
          <input type="number" name="amount" step="0.01" class="input-field" required>
        </div>
        <div class="mb-5">
          <label class="form-label">Date</label>
          <input type="date" name="transactionDate" class="input-field" required>
        </div>
        <div class="mb-5">
          <label class="form-label">Description (Optional)</label>
          <textarea name="description" class="input-field"></textarea>
        </div>
        <div class="mb-6">
          <label class="form-label">Status</label>
          <select name="status" class="select-field" required>
            <option value="pending">Pending</option>
            <option value="completed">Completed</option>
          </select>
        </div>
        <div class="flex justify-end space-x-3">
          <button type="button" class="btn-secondary px-4 py-2 rounded-lg" onclick="closeAddModal()">Cancel</button>
          <button type="submit" class="btn-primary px-4 py-2 rounded-lg">Add Transaction</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Edit Transaction Modal -->
  <div class="modal" id="editTransactionModal">
    <div class="modal-content">
      <span class="close-btn" onclick="closeEditModal()">×</span>
      <h5 class="text-xl font-bold text-white mb-6" id="editTransactionModalLabel">Edit Transaction</h5>
      <form id="editTransactionForm" action="financials" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="financialId" id="editFinancialId">
        <div class="mb-5">
          <label class="form-label">Booking (Optional)</label>
          <select name="bookingId" id="editBookingId" class="select-field">
            <option value="">None</option>
            <c:forEach var="booking" items="${bookings}">
              <option value="${booking.booking_id}">#${booking.booking_id} (${booking.car_model}, ${booking.client_name})</option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-5">
          <label class="form-label">Type</label>
          <select name="type" id="editType" class="select-field" required>
            <option value="income">Income</option>
            <option value="expense">Expense</option>
          </select>
        </div>
        <div class="mb-5">
          <label class="form-label">Category</label>
          <input type="text" name="category" id="editCategory" class="input-field" required>
        </div>
        <div class="mb-5">
          <label class="form-label">Amount</label>
          <input type="number" name="amount" id="editAmount" step="0.01" class="input-field" required>
        </div>
        <div class="mb-5">
          <label class="form-label">Date</label>
          <input type="date" name="transactionDate" id="editTransactionDate" class="input-field" required>
        </div>
        <div class="mb-5">
          <label class="form-label">Description (Optional)</label>
          <textarea name="description" id="editDescription" class="input-field"></textarea>
        </div>
        <div class="mb-6">
          <label class="form-label">Status</label>
          <select name="status" id="editStatus" class="select-field" required>
            <option value="pending">Pending</option>
            <option value="completed">Completed</option>
          </select>
        </div>
        <div class="flex justify-end space-x-3">
          <button type="button" class="btn-secondary px-4 py-2 rounded-lg" onclick="closeEditModal()">Cancel</button>
          <button type="submit" class="btn-primary px-4 py-2 rounded-lg">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</main>

<script>
  Chart.register(window.ChartDataLabels);

  // Earnings Summary Chart with enhanced styling
  const earningsSummaryData = {
    labels: [],
    datasets: [
      {
        label: 'Income',
        data: [],
        borderColor: '#86EFAC',
        backgroundColor: 'rgba(34, 197, 94, 0.2)',
        fill: true,
        pointBackgroundColor: '#86EFAC',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: '#86EFAC',
        tension: 0.4
      },
      {
        label: 'Expense',
        data: [],
        borderColor: '#FF4D4F',
        backgroundColor: 'rgba(255, 77, 79, 0.2)',
        fill: true,
        pointBackgroundColor: '#FF4D4F',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: '#FF4D4F',
        tension: 0.4
      }
    ]
  };

  <c:forEach var="entry" items="${financialSummary}">
  earningsSummaryData.labels.push("${entry.month}");
  earningsSummaryData.datasets[0].data.push(${entry.income});
  earningsSummaryData.datasets[1].data.push(${entry.expense});
  </c:forEach>

  new Chart(document.getElementById('financialChart'), {
    type: 'line',
    data: earningsSummaryData,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: value => '$' + value,
            color: '#A0AEC0'
          },
          grid: {
            borderColor: 'rgba(255, 255, 255, 0.1)',
            borderDash: [5, 5],
            color: 'rgba(255, 255, 255, 0.1)'
          }
        },
        x: {
          ticks: { color: '#A0AEC0' },
          grid: { display: false }
        }
      },
      plugins: {
        legend: {
          position: 'top',
          labels: {
            font: { size: 12 },
            color: '#E5E7EB'
          }
        },
        datalabels: { display: false },
        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          titleFont: { size: 14 },
          bodyFont: { size: 12 },
          callbacks: {
            label: (context) => {
              return `${context.dataset.label}: $${context.parsed.y}`;
            }
          }
        }
      },
      interaction: {
        mode: 'nearest',
        intersect: false
      }
    }
  });

  // Modal Functions
  function openAddModal() {
    const modal = document.getElementById('addTransactionModal');
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);
  }

  function closeAddModal() {
    const modal = document.getElementById('addTransactionModal');
    modal.classList.remove('show');
    setTimeout(() => modal.style.display = 'none', 300);
  }

  function editTransaction(financialId, bookingId, type, category, amount, transactionDate, description, status) {
    document.getElementById('editFinancialId').value = financialId;
    document.getElementById('editBookingId').value = bookingId || '';
    document.getElementById('editType').value = type;
    document.getElementById('editCategory').value = category;
    document.getElementById('editAmount').value = amount;
    document.getElementById('editTransactionDate').value = transactionDate;
    document.getElementById('editDescription').value = description || '';
    document.getElementById('editStatus').value = status;
    const modal = document.getElementById('editTransactionModal');
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);
  }

  function closeEditModal() {
    const modal = document.getElementById('editTransactionModal');
    modal.classList.remove('show');
    setTimeout(() => modal.style.display = 'none', 300);
  }

  window.onclick = function(event) {
    const addModal = document.getElementById('addTransactionModal');
    const editModal = document.getElementById('editTransactionModal');
    if (event.target === addModal) {
      closeAddModal();
    }
    if (event.target === editModal) {
      closeEditModal();
    }
  };
</script>
</body>
</html>