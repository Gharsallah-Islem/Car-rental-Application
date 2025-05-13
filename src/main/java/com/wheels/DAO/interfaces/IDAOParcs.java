package com.wheels.DAO.interfaces;

import com.wheels.Model.Parc;
import java.util.List;

public interface IDAOParcs {
    List<Parc> getAllParcs();
    void addParc(String parcName, String address, String city, int capacity);
    void updateParc(int parcId, String parcName, String address, String city, int capacity);
    void deleteParc(int parcId);
}