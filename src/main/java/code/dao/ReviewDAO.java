package code.dao;

import code.model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(int userId, String reviewText, String isGood) {
        String sql = "INSERT INTO reviews(user_id, review_text, is_good) VALUES(?,?,?)";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, reviewText);
            ps.setString(3, isGood);

            int rows = ps.executeUpdate();
            System.out.println("Inserted rows: " + rows); // Debugging
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name, u.image FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id ORDER BY r.created_at DESC";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Review r = new Review();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setReviewText(rs.getString("review_text"));
                r.setIsGood(rs.getString("is_good"));
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
}
