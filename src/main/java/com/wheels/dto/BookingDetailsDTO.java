package com.wheels.dto;

import java.sql.Date;

public class BookingDetailsDTO {
    private int bookingId;
    private Date bookingDate;
    private Date startDate;
    private Date endDate;
    private long bookingDays;
    private double totalCost;
    private String status;
    private String paymentStatus;
    private String clientName;
    private String carModel;
    private String parcName;
    private String driverName;

    // Constructor
    public BookingDetailsDTO(int bookingId, Date bookingDate, Date startDate, Date endDate, long bookingDays,
                             double totalCost, String status, String paymentStatus, String clientName,
                             String carModel, String parcName, String driverName) {
        this.bookingId = bookingId;
        this.bookingDate = bookingDate;
        this.startDate = startDate;
        this.endDate = endDate;
        this.bookingDays = bookingDays;
        this.totalCost = totalCost;
        this.status = status;
        this.paymentStatus = paymentStatus;
        this.clientName = clientName;
        this.carModel = carModel;
        this.parcName = parcName;
        this.driverName = driverName;
    }

    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public long getBookingDays() {
        return bookingDays;
    }

    public void setBookingDays(long bookingDays) {
        this.bookingDays = bookingDays;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getParcName() {
        return parcName;
    }

    public void setParcName(String parcName) {
        this.parcName = parcName;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }
}