package com.wheels.DAO;

import com.wheels.DAO.interfaces.IDAOParcs;
import com.wheels.Model.Parc;
import com.wheels.util.DatabaseSingleton;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOParcs implements IDAOParcs {
    private static final DatabaseSingleton dbSingleton = DatabaseSingleton.getInstance();

    @Override
    public List<Parc> getAllParcs() {
        List<Parc> parcs = new ArrayList<>();
        String sql = "SELECT p.parc_id, p.parc_name, p.address, p.city, p.capacity FROM parcs p";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Parc parc = new Parc();
                parc.setParcId(rs.getInt("parc_id"));
                parc.setParcName(rs.getString("parc_name"));
                parc.setAddress(rs.getString("address"));
                parc.setCity(rs.getString("city"));
                parc.setCapacity(rs.getInt("capacity"));
                parcs.add(parc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return parcs;
    }

    @Override
    public void addParc(String parcName, String address, String city, int capacity) {
        String sql = "INSERT INTO parcs (parc_name, address, city, capacity) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, parcName);
            stmt.setString(2, address);
            stmt.setString(3, city);
            stmt.setInt(4, capacity);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateParc(int parcId, String parcName, String address, String city, int capacity) {
        String sql = "UPDATE parcs SET parc_name = ?, address = ?, city = ?, capacity = ? WHERE parc_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, parcName);
            stmt.setString(2, address);
            stmt.setString(3, city);
            stmt.setInt(4, capacity);
            stmt.setInt(5, parcId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteParc(int parcId) {
        String sql = "DELETE FROM parcs WHERE parc_id = ?";
        try (Connection conn = dbSingleton.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, parcId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}