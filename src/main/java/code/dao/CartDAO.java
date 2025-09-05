package code.dao;

import code.model.CartItem;
import code.model.FoodItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // Add item to cart using foodId directly
    public void addToCart(int userId, int foodId, int quantity) {
        String sqlCheck = "SELECT id, quantity FROM cart WHERE user_id=? AND food_id=?";
        String sqlInsert = "INSERT INTO cart(user_id, food_id, quantity) VALUES(?,?,?)";
        String sqlUpdate = "UPDATE cart SET quantity=? WHERE id=?";

        try(Connection con = MyConnection.getConnection()){
            PreparedStatement psCheck = con.prepareStatement(sqlCheck);
            psCheck.setInt(1, userId);
            psCheck.setInt(2, foodId);
            ResultSet rs = psCheck.executeQuery();

            if(rs.next()){
                int id = rs.getInt("id");
                int oldQty = rs.getInt("quantity");
                PreparedStatement psUpdate = con.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, oldQty + quantity);
                psUpdate.setInt(2, id);
                psUpdate.executeUpdate();
            } else {
                PreparedStatement psInsert = con.prepareStatement(sqlInsert);
                psInsert.setInt(1, userId);
                psInsert.setInt(2, foodId);
                psInsert.setInt(3, quantity);
                psInsert.executeUpdate();
            }
        } catch(Exception e){
            e.printStackTrace();
        }
    }

    // Get all cart items for user
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.id as cart_id, c.quantity, f.* " +
                     "FROM cart c JOIN food_items f ON c.food_id = f.id " +
                     "WHERE c.user_id = ?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem c = new CartItem();
                c.setId(rs.getInt("cart_id"));
                c.setUserId(userId);

                FoodItem f = new FoodItem();
                f.setId(rs.getInt("id"));
                f.setName(rs.getString("name"));
                f.setPrice(rs.getDouble("price"));
                f.setImage(rs.getString("image"));
                f.setDescription(rs.getString("description"));

                c.setFood(f);
                c.setQuantity(rs.getInt("quantity"));
                list.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update quantity
    public boolean updateQuantity(int cartId, int quantity) {
        String sql = "UPDATE cart SET quantity=? WHERE id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Remove item
    public boolean removeItem(int cartId) {
        String sql = "DELETE FROM cart WHERE id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Clear cart after order
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
