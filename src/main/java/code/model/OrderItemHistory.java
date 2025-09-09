package code.model;

public class OrderItemHistory {
    private int id;
    private int orderHistoryId;
    private int foodId;
    private int quantity;
    private double price;

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderHistoryId() { return orderHistoryId; }
    public void setOrderHistoryId(int orderHistoryId) { this.orderHistoryId = orderHistoryId; }
    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
