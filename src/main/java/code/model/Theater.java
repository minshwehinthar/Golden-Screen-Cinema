package code.model;

public class Theater {
    private int id;
    private String name;
    private String location;
    private int seatTotal;
    private String contact;

    public Theater() {}

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public int getSeatTotal() { return seatTotal; }
    public void setSeatTotal(int seatTotal) { this.seatTotal = seatTotal; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
}
