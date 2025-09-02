package code.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import code.model.Food;

public class FoodDAO {
	public boolean addFood(Food food) {
        String sql = "INSERT INTO foods (name, description, price, category, quantity, image) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, food.getName());
            ps.setString(2, food.getDescription());
            ps.setInt(3, food.getPrice());
            ps.setString(4, food.getCategory()); // must be 'snack' or 'drink'
            ps.setInt(5, food.getQuantity());
            ps.setString(6, food.getImage());

            int rows = ps.executeUpdate();
            return rows > 0; // ✅ true if insert success

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
