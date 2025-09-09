package code.dao;

import code.model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // Add a review
    public boolean addReview(int userId, int theaterId, String reviewText, String isGood, int rating) {
        String sql = "INSERT INTO reviews(user_id, theater_id, review_text, is_good, rating, created_at) VALUES (?,?,?,?,?,NOW())";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, theaterId);
            ps.setString(3, reviewText);
            ps.setString(4, isGood);
            ps.setInt(5, rating);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all reviews for a theater
    public List<Review> getReviewsByTheater(int theaterId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name, u.image FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.theater_id = ? ORDER BY r.created_at DESC";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, theaterId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review r = new Review();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setTheaterId(rs.getInt("theater_id"));
                r.setReviewText(rs.getString("review_text"));
                r.setIsGood(rs.getString("is_good"));
                r.setRating(rs.getInt("rating"));
                r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                r.setUserName(rs.getString("name"));
                r.setUserImage(rs.getString("image"));
                reviews.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }
    
 // Inside ReviewDAO.java
    public boolean deleteReviewById(int reviewId, int userId) {
        String sql = "DELETE FROM reviews WHERE id = ? AND user_id = ?"; // Only owner can delete
        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reviewId);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
