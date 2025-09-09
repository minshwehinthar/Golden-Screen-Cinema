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
            order.setId(orderId);

            // Insert order items
            if (order.getItems() != null) {
                for (OrderItem item : order.getItems()) {
                    PreparedStatement psItem = con.prepareStatement(sqlItem);
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getFood().getId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getPrice());
                    psItem.executeUpdate();
                }
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
                Order order = extractOrder(rsOrder);

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
                order.setItems(items != null ? items : new ArrayList<>());
                return order;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Admin: get pending orders
    public List<Order> getPendingOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status='pending' ORDER BY created_at DESC";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = extractOrder(rs);
                o.setItems(new ArrayList<>()); // ensure not null
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin: get completed orders (history)
    public List<Order> getCompletedOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status='completed' ORDER BY updated_at DESC";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = extractOrder(rs);
                o.setItems(new ArrayList<>()); // ensure not null
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin confirm order (move to history)
    public boolean confirmOrder(int orderId){
        try(Connection con = MyConnection.getConnection()){
            con.setAutoCommit(false);

            // Get full order
            Order o = getOrderById(orderId);
            if(o == null) return false;

            // Insert into order_history
            String sqlHistory = "INSERT INTO order_history(order_id,user_id,theater_id,total_amount,payment_method) VALUES (?,?,?,?,?)";
            PreparedStatement psHistory = con.prepareStatement(sqlHistory, Statement.RETURN_GENERATED_KEYS);
            psHistory.setInt(1, o.getId());
            psHistory.setInt(2, o.getUserId());
            psHistory.setInt(3, o.getTheaterId());
            psHistory.setDouble(4, o.getTotalAmount());
            psHistory.setString(5, o.getPaymentMethod());
            psHistory.executeUpdate();

            ResultSet rs = psHistory.getGeneratedKeys();
            int historyId = 0;
            if(rs.next()) historyId = rs.getInt(1);

            // Move items
            if(o.getItems() != null){
                for(OrderItem item : o.getItems()){
                    String sqlItem = "INSERT INTO order_items_history(order_history_id,food_id,quantity,price) VALUES (?,?,?,?)";
                    PreparedStatement psItem = con.prepareStatement(sqlItem);
                    psItem.setInt(1, historyId);
                    psItem.setInt(2, item.getFood().getId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getPrice());
                    psItem.executeUpdate();
                }
            }

            // Delete from active orders
            PreparedStatement psDelItems = con.prepareStatement("DELETE FROM order_items WHERE order_id=?");
            psDelItems.setInt(1, orderId);
            psDelItems.executeUpdate();

            PreparedStatement psDelOrder = con.prepareStatement("DELETE FROM orders WHERE id=?");
            psDelOrder.setInt(1, orderId);
            psDelOrder.executeUpdate();

            con.commit();
            return true;

        } catch(Exception e){ 
            e.printStackTrace(); 
        }
        return false;
    }
    
 // Mark order as completed (only update status)
    public boolean completeOrder(int orderId) {
        String sql = "UPDATE orders SET status='completed', updated_at=NOW() WHERE id=?";
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

 // Get all orders (pending + completed)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sqlOrders = "SELECT * FROM orders ORDER BY created_at DESC";
        String sqlItems = "SELECT oi.*, f.name, f.price, f.image " +
                          "FROM order_items oi " +
                          "JOIN food_items f ON oi.food_id = f.id " +
                          "WHERE oi.order_id=?";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement psOrders = con.prepareStatement(sqlOrders);
             ResultSet rsOrders = psOrders.executeQuery()) {

            while (rsOrders.next()) {
                Order order = extractOrder(rsOrders);

                // Load items
                PreparedStatement psItems = con.prepareStatement(sqlItems);
                psItems.setInt(1, order.getId());
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

                list.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    


    

    // Helper: extract Order from ResultSet
    private Order extractOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setTheaterId(rs.getInt("theater_id"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setStatus(rs.getString("status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setUpdatedAt(rs.getTimestamp("updated_at"));
        o.setItems(new ArrayList<>()); // always initialize
        return o;
    }
    
    

}
