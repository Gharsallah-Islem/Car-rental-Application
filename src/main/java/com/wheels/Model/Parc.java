package com.wheels.Model;

import java.time.LocalDateTime;

public class Parc {
    private int parcId;
    private String parcName;
    private String address;
    private String city;
    private int capacity;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public int getParcId() {
        return parcId;
    }

    public void setParcId(int parcId) {
        this.parcId = parcId;
    }

    public String getParcName() {
        return parcName;
    }

    public void setParcName(String parcName) {
        this.parcName = parcName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }
}