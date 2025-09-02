package code.model;

import java.time.LocalDateTime;

public class Review {
    private int id;
    private int userId;
    private String reviewText;
    private String isGood;
    private LocalDateTime createdAt;
    private String userName; // For display
    private String userImage; // For display

    // Getters & setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }
    public String getIsGood() { return isGood; }
    public void setIsGood(String isGood) { this.isGood = isGood; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserImage() { return userImage; }
    public void setUserImage(String userImage) { this.userImage = userImage; }
}
