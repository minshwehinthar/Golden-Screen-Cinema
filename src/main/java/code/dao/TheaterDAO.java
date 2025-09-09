package code.dao;

import code.model.Theater;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TheaterDAO {

    public List<Theater> getAllTheaters() {
        List<Theater> list = new ArrayList<>();
        String sql = "SELECT * FROM theaters ORDER BY id";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Theater t = new Theater();
                t.setId(rs.getInt("id"));
                t.setName(rs.getString("name"));
                t.setLocation(rs.getString("location"));
                t.setSeatTotal(rs.getInt("seat_total"));
                t.setContact(rs.getString("contact"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Theater getTheaterById(int theaterId) {
        Theater theater = null;
        String sql = "SELECT * FROM theaters WHERE id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, theaterId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                theater = new Theater();
                theater.setId(rs.getInt("id"));
                theater.setName(rs.getString("name"));
                theater.setLocation(rs.getString("location"));
                theater.setSeatTotal(rs.getInt("seat_total"));
                theater.setContact(rs.getString("contact"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return theater;
    }

}
