package code.model;

import java.util.Date;

public class FoodOrderItem {
    private int id;
    private int foodOrderId;
    private int foodId;
    private int quantity;
    private int price;
    private Date createdAt;
    private Date updatedAt;

    public FoodOrderItem() {}
    public FoodOrderItem(int foodId, int quantity, int price) {
        this.foodId = foodId;
        this.quantity = quantity;
        this.price = price;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getFoodOrderId() { return foodOrderId; }
    public void setFoodOrderId(int foodOrderId) { this.foodOrderId = foodOrderId; }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public int getLineTotal() { return quantity * price; }
}
