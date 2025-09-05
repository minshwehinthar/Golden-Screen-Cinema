package code.model;

public class FoodItem {
    private int id;
    private String name;
    private String image;
    private double price;
    private String description; // optional

    public FoodItem() {}

    public FoodItem(String name, String image, double price) {
        this.name = name;
        this.image = image;
        this.price = price;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
