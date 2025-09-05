package code.dao;

import code.model.FoodItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodDAO {

    // Get all food items
    public List<FoodItem> getAllFoods() {
        List<FoodItem> list = new ArrayList<>();
        String sql = "SELECT * FROM food_items ORDER BY id DESC";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                FoodItem f = new FoodItem();
                f.setId(rs.getInt("id"));
                f.setName(rs.getString("name"));
                f.setPrice(rs.getDouble("price"));
                f.setImage(rs.getString("image"));
                f.setDescription(rs.getString("description"));
                list.add(f);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get single food item
    public FoodItem getFoodById(int id) {
        FoodItem food = null;
        String sql = "SELECT * FROM food_items WHERE id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                food = new FoodItem();
                food.setId(rs.getInt("id"));
                food.setName(rs.getString("name"));
                food.setPrice(rs.getDouble("price"));
                food.setImage(rs.getString("image"));
                food.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return food;
    }


    // Admin: add new food
    public boolean addFood(FoodItem f) {
        String sql = "INSERT INTO food_items(name, price, image, description) VALUES(?,?,?,?)";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, f.getName());
            ps.setDouble(2, f.getPrice());
            ps.setString(3, f.getImage());
            ps.setString(4, f.getDescription());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
