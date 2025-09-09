package code.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import code.model.OrderHistory;
import code.model.OrderItemHistory;

public class OrderHistoryDAO {
    private Connection conn;

    public OrderHistoryDAO(Connection conn) {
        this.conn = conn;
    }

    // Fetch all order history with items
    public List<OrderHistory> getAllOrderHistory() throws SQLException {
        List<OrderHistory> orders = new ArrayList<>();

        String sql = "SELECT * FROM order_history ORDER BY completed_at DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            OrderHistory order = new OrderHistory();
            order.setId(rs.getInt("id"));
            order.setOrderId(rs.getInt("order_id"));
            order.setUserId(rs.getInt("user_id"));
            order.setTheaterId(rs.getInt("theater_id"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setCompletedAt(rs.getTimestamp("completed_at"));

            // Get items for this order
            order.setItems(getOrderItemsByOrderHistoryId(order.getId()));

            orders.add(order);
        }
        rs.close();
        ps.close();

        return orders;
    }

    // Fetch order items by order history id
    private List<OrderItemHistory> getOrderItemsByOrderHistoryId(int orderHistoryId) throws SQLException {
        List<OrderItemHistory> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items_history WHERE order_history_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderHistoryId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            OrderItemHistory item = new OrderItemHistory();
            item.setId(rs.getInt("id"));
            item.setOrderHistoryId(rs.getInt("order_history_id"));
            item.setFoodId(rs.getInt("food_id"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(rs.getDouble("price"));
            items.add(item);
        }
        rs.close();
        ps.close();

        return items;
    }
}
