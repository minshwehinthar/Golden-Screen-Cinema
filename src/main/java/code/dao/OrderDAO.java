package code.dao;

import code.model.Order;
import code.model.OrderItem;
import code.model.FoodItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // Place order
    public boolean placeOrder(Order order) {
        String sqlOrder = "INSERT INTO orders(user_id, theater_id, total_amount, payment_method, status, created_at) VALUES(?,?,?,?,?,NOW())";
        String sqlItem = "INSERT INTO order_items(order_id, food_id, quantity, price) VALUES(?,?,?,?)";

        try (Connection con = MyConnection.getConnection()) {
            con.setAutoCommit(false);

            // Insert order
            PreparedStatement psOrder = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setInt(2, order.getTheaterId());
            psOrder.setDouble(3, order.getTotalAmount());
            psOrder.setString(4, order.getPaymentMethod());
            psOrder.setString(5, order.getStatus());
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);
            order.setId(orderId); // Important: set ID so redirect works

            // Insert order items
            for (OrderItem item : order.getItems()) {
                PreparedStatement psItem = con.prepareStatement(sqlItem);
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getFood().getId());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getPrice());
                psItem.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get order by ID
    public Order getOrderById(int orderId) {
        String sqlOrder = "SELECT * FROM orders WHERE id=?";
        String sqlItems = "SELECT oi.*, f.name, f.price, f.image FROM order_items oi JOIN food_items f ON oi.food_id = f.id WHERE oi.order_id=?";

        try (Connection con = MyConnection.getConnection()) {
            PreparedStatement psOrder = con.prepareStatement(sqlOrder);
            psOrder.setInt(1, orderId);
            ResultSet rsOrder = psOrder.executeQuery();

            if (rsOrder.next()) {
                Order order = new Order();
                order.setId(orderId);
                order.setUserId(rsOrder.getInt("user_id"));
                order.setTheaterId(rsOrder.getInt("theater_id"));
                order.setTotalAmount(rsOrder.getDouble("total_amount"));
                order.setPaymentMethod(rsOrder.getString("payment_method"));
                order.setStatus(rsOrder.getString("status"));
                order.setCreatedAt(rsOrder.getTimestamp("created_at"));
                order.setUpdatedAt(rsOrder.getTimestamp("updated_at"));

                // Load items
                PreparedStatement psItems = con.prepareStatement(sqlItems);
                psItems.setInt(1, orderId);
                ResultSet rsItems = psItems.executeQuery();
                List<OrderItem> items = new ArrayList<>();
                while (rsItems.next()) {
                    OrderItem item = new OrderItem();
                    FoodItem f = new FoodItem();
                    f.setId(rsItems.getInt("food_id"));
                    f.setName(rsItems.getString("name"));
                    f.setPrice(rsItems.getDouble("price"));
                    f.setImage(rsItems.getString("image"));
                    item.setFood(f);
                    item.setQuantity(rsItems.getInt("quantity"));
                    item.setPrice(rsItems.getDouble("price"));
                    items.add(item);
                }
                order.setItems(items);

                return order;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

 // Admin: get pending orders (waiting for confirmation)
 // Admin pending orders (status = 'pending' or 'picked')
    public List<Order> getPendingOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status='pending' ORDER BY created_at DESC";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTheaterId(rs.getInt("theater_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Completed orders (history)
    public List<Order> getCompletedOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status='completed' ORDER BY updated_at DESC";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTheaterId(rs.getInt("theater_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Confirm order
    public boolean confirmOrder(int orderId) {
        String sql = "UPDATE orders SET status='completed', updated_at=NOW() WHERE id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
