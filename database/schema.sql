-- Wheels Car Rental Application Database Schema
-- This file contains the database structure for the Wheels application

CREATE DATABASE IF NOT EXISTS wheels_db;
USE wheels_db;

-- Users table (for both clients and drivers)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role ENUM('client', 'driver', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Parcs table (parking locations)
CREATE TABLE parcs (
    parc_id INT AUTO_INCREMENT PRIMARY KEY,
    parc_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    capacity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Cars table (vehicle inventory)
CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    car_type ENUM('Sedan', 'SUV', 'Hatchback', 'Convertible', 'Truck', 'Minivan') NOT NULL,
    capacity INT NOT NULL,
    price_per_day DECIMAL(10, 2) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    parc_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parc_id) REFERENCES parcs(parc_id) ON DELETE SET NULL
);

-- Bookings table (rental reservations)
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    driver_id INT NULL,
    booking_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_cost DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'active', 'completed', 'cancelled') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Financials table (financial transactions)
CREATE TABLE financials (
    financial_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NULL,
    type ENUM('income', 'expense') NOT NULL,
    category VARCHAR(100),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL
);

-- Reminders table (system reminders)
CREATE TABLE reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'dismissed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample data for demonstration
INSERT INTO parcs (parc_name, address, city, capacity) VALUES
('Downtown Parking', '123 Main Street', 'Tunis', 50),
('Airport Parking', 'Tunis-Carthage Airport', 'Tunis', 100),
('Mall Parking', '456 Shopping Center', 'Sousse', 30);

INSERT INTO users (full_name, email, phone, password, role) VALUES
('John Doe', 'john.doe@example.com', '+216 12 345 678', 'hashed_password', 'client'),
('Jane Smith', 'jane.smith@example.com', '+216 98 765 432', 'hashed_password', 'client'),
('Ahmed Ben Ali', 'ahmed.benali@example.com', '+216 55 444 333', 'hashed_password', 'driver'),
('Admin User', 'admin@wheels.com', '+216 11 111 111', 'admin_password', 'admin');

INSERT INTO cars (brand, model, car_type, capacity, price_per_day, license_plate, parc_id) VALUES
('Toyota', 'Corolla', 'Sedan', 5, 45.00, 'TUN-123-456', 1),
('Honda', 'CR-V', 'SUV', 7, 65.00, 'TUN-789-012', 1),
('Ford', 'Fiesta', 'Hatchback', 5, 40.00, 'TUN-345-678', 2),
('BMW', 'X5', 'SUV', 7, 120.00, 'TUN-901-234', 3),
('Mercedes', 'C-Class', 'Sedan', 5, 95.00, 'TUN-567-890', 1);

-- Indexes for better performance
CREATE INDEX idx_bookings_dates ON bookings(start_date, end_date);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_cars_availability ON cars(availability);
CREATE INDEX idx_financials_date ON financials(transaction_date);
CREATE INDEX idx_users_role ON users(role);