package com.wheels.DAO.interfaces;

import java.util.List;

public interface IDAOReminders {
    List<java.util.Map<String, Object>> getPendingReminders();
}