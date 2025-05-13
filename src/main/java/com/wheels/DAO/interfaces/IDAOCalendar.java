package com.wheels.DAO.interfaces;

import java.util.List;

public interface IDAOCalendar {
    List<java.util.Map<String, Object>> getBookingsForCalendar(java.sql.Date startDate, java.sql.Date endDate, Integer carId, Integer clientId, Integer driverId);
}