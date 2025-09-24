# 🚗 Wheels Car Rental Application

A comprehensive car rental management system built with Java EE, providing a complete solution for managing vehicle rentals, bookings, clients, and financial transactions.

## 📸 Application Screenshots

![Wheels Dashboard](https://github.com/user-attachments/assets/873f56f6-ad22-4a82-8820-4b659f5177fa)
*Modern dashboard with real-time metrics, interactive charts, and comprehensive vehicle rental management*

## 🌟 Features

### 📊 Dashboard & Analytics
- **Real-time Metrics**: Track total revenue, expenses, profit margins, and booking statistics
- **Interactive Charts**: Visual representation of earnings, rental status, and car type distribution
- **Revenue Management**: Monitor income and expense tracking with detailed financial analytics

### 🚙 Vehicle Management (Units)
- **Car Inventory**: Complete car fleet management with detailed specifications
- **Vehicle Types**: Support for Sedan, SUV, Hatchback, Convertible, Truck, and Minivan
- **Availability Tracking**: Real-time availability status and pricing management
- **Parc Management**: Organize vehicles by parking locations with capacity management

### 📅 Booking System
- **Comprehensive Booking Management**: Create, update, and cancel reservations
- **Advanced Search & Filtering**: Filter by client, car, driver, status, and date ranges
- **Calendar Integration**: Visual calendar view for booking management
- **Driver Assignment**: Optional driver assignment for bookings
- **Status Tracking**: Pending, active, completed, and cancelled booking states

### 👥 Client & Driver Management
- **Client Database**: Complete customer information management
- **Driver Management**: Professional driver profiles and assignment system
- **Contact Management**: Email and phone contact information tracking
- **User Role Management**: Separate management for clients and drivers

### 💰 Financial Management
- **Transaction Tracking**: Detailed financial transaction management
- **Income & Expense Categories**: Organized financial record keeping
- **Payment Status**: Track pending and completed payments
- **Financial Reports**: Comprehensive financial analytics and reporting

### 🗺️ Tracking System
- **Real-time Tracking**: GPS tracking integration for rental vehicles (Beta)
- **Location Management**: Monitor vehicle locations and routes
- **Fleet Monitoring**: Comprehensive fleet tracking capabilities

### 📬 Messaging & Reminders
- **Internal Messaging**: Communication system for staff and management
- **Smart Reminders**: Automated reminders for due dates and important tasks
- **Notification System**: Stay updated with pending actions and alerts

## 🛠️ Technology Stack

- **Backend**: Java 11, Jakarta EE 10
- **Web Framework**: Java Servlets, JSP (Java Server Pages)
- **Database**: MySQL 8.0
- **Frontend**: HTML5, CSS3, JavaScript, Tailwind CSS
- **Charts**: Chart.js for data visualization
- **Build Tool**: Apache Maven 3.x
- **Application Server**: Compatible with Jakarta EE servers (Tomcat 10+, GlassFish, etc.)

## 📋 Prerequisites

Before setting up the Wheels Car Rental Application, ensure you have:

- **Java Development Kit (JDK) 11 or higher**
- **Apache Maven 3.6+**
- **MySQL Server 8.0+**
- **Apache Tomcat 10+ or any Jakarta EE compatible server**
- **Git** (for cloning the repository)

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Gharsallah-Islem/Car-rental-Application.git
cd Car-rental-Application
```

### 2. Database Setup

#### Create Database
```sql
CREATE DATABASE wheels_db;
USE wheels_db;
```

#### Create Tables
The application uses the following main tables:
- `users` - Store client and driver information
- `cars` - Vehicle inventory management
- `bookings` - Rental bookings and reservations
- `parcs` - Parking location management
- `financials` - Financial transactions and records
- `reminders` - System reminders and notifications

#### Configure Database Connection
Update the database connection settings in:
```java
// src/main/java/com/wheels/util/DatabaseSingleton.java
private static final String URL = "jdbc:mysql://localhost:3306/wheels_db?useSSL=false&serverTimezone=UTC";
private static final String USER = "your_username";
private static final String PASSWORD = "your_password";
```

### 3. Build the Application
```bash
mvn clean compile
mvn package
```

### 4. Deploy to Application Server
1. Copy the generated `wheels-app.war` file from the `target` directory
2. Deploy to your Jakarta EE application server (Tomcat 10+, GlassFish, etc.)
3. Start the application server

### 5. Access the Application
Open your web browser and navigate to:
```
http://localhost:8080/wheels-app
```

## 📱 Usage Guide

### Getting Started
1. **Dashboard**: Start with the main dashboard to get an overview of your rental business
2. **Vehicle Management**: Add your car fleet through the "Units" section
3. **Parcs Management**: Set up parking locations for better organization
4. **Client Management**: Register clients who will rent vehicles
5. **Driver Management**: Add professional drivers (optional service)
6. **Booking System**: Create and manage rental reservations
7. **Financial Tracking**: Monitor income, expenses, and overall profitability

### Key Workflows
- **New Rental**: Units → Clients → Bookings → Financial Tracking
- **Fleet Management**: Parcs → Units → Availability Management
- **Financial Management**: Bookings → Financial Transactions → Reports

## 📁 Project Structure

```
Car-rental-Application/
├── src/main/
│   ├── java/com/wheels/
│   │   ├── controller/          # Servlet controllers
│   │   │   ├── DashboardServlet.java
│   │   │   ├── BookingsServlet.java
│   │   │   ├── UnitsServlet.java
│   │   │   ├── ClientsServlet.java
│   │   │   ├── DriversServlet.java
│   │   │   ├── FinancialsServlet.java
│   │   │   ├── ParcsServlet.java
│   │   │   ├── CalendarServlet.java
│   │   │   ├── TrackingServlet.java
│   │   │   └── MessagesServlet.java
│   │   └── util/                # Utility classes
│   │       ├── DBUtil.java      # Database operations
│   │       └── DatabaseSingleton.java
│   └── webapp/                  # Web resources
│       ├── WEB-INF/
│       │   └── web.xml          # Web application configuration
│       ├── dashboard.jsp        # Main dashboard
│       ├── bookings.jsp         # Booking management
│       ├── units.jsp            # Vehicle management
│       ├── clients.jsp          # Client management
│       ├── drivers.jsp          # Driver management
│       ├── financials.jsp       # Financial management
│       ├── parcs.jsp           # Parking management
│       ├── calendar.jsp         # Calendar view
│       ├── tracking.jsp         # Vehicle tracking
│       └── messages.jsp         # Messaging system
├── pom.xml                      # Maven configuration
└── README.md                    # This file
```

## 🎨 User Interface

The application features a modern, responsive design with:
- **Dark Theme**: Professional dark blue gradient background
- **Responsive Layout**: Works on desktop, tablet, and mobile devices
- **Interactive Charts**: Real-time data visualization
- **Intuitive Navigation**: Clean sidebar navigation with icons
- **Modal Forms**: Easy-to-use forms for data entry and editing

## 🔧 Configuration

### Database Configuration
- Default database: `wheels_db`
- Connection pooling with singleton pattern
- MySQL JDBC driver for database connectivity

### Application Server
- Compatible with Jakarta EE 10
- Requires servlet container supporting Servlet API 6.0
- Recommended: Apache Tomcat 10+ or Eclipse GlassFish 7+

## 🤝 Contributing

We welcome contributions to improve the Wheels Car Rental Application! Here's how you can contribute:

1. **Fork the Repository**
2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make Your Changes**
4. **Test Your Changes**
   ```bash
   mvn clean test
   mvn package
   ```
5. **Commit Your Changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
6. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

### Development Guidelines
- Follow Java naming conventions
- Add comments for complex business logic
- Test your changes thoroughly
- Update documentation as needed
- Ensure responsive design for UI changes

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Gharsallah Islem**
- GitHub: [@Gharsallah-Islem](https://github.com/Gharsallah-Islem)

## 🙏 Acknowledgments

- Jakarta EE community for the excellent web framework
- Chart.js for beautiful data visualization
- Tailwind CSS for modern responsive design
- MySQL for reliable database management

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/Gharsallah-Islem/Car-rental-Application/issues) page
2. Create a new issue with detailed information
3. Contact the maintainer through GitHub

---

⭐ **If you find this project useful, please consider giving it a star!** ⭐