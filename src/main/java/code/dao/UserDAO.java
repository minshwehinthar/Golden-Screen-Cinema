package code.dao;

import code.model.User;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Register new user
    public boolean register(User user) {
        String sql = "INSERT INTO users (name, email, phone, password, birth_date, gender, image, role, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setDate(5, user.getBirthDate() != null ? Date.valueOf(user.getBirthDate()) : null);
            ps.setString(6, user.getGender());
            ps.setString(7, user.getImage());
            ps.setString(8, user.getRole() != null ? user.getRole() : "user"); // default role
            ps.setString(9, user.getStatus() != null ? user.getStatus() : "active"); // default status

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Login user
    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email=? AND password=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update last login
    public void updateLastLogin(int userId, LocalDateTime lastLogin) {
        String sql = "UPDATE users SET last_login=? WHERE id=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(lastLogin));
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update status (active/inactive)
    public boolean updateStatus(String email, String status) {
        String sql = "UPDATE users SET status=? WHERE email=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get user by ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractUser(rs);
            }

        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Get all users (admin use)
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(extractUser(rs));
            }

        } catch (Exception e) { e.printStackTrace(); }
        return users;
    }

    // Update full user
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name=?, email=?, phone=?, password=?, birth_date=?, gender=?, image=?, role=?, status=?, updated_at=NOW() WHERE id=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setDate(5, user.getBirthDate() != null ? Date.valueOf(user.getBirthDate()) : null);
            ps.setString(6, user.getGender());
            ps.setString(7, user.getImage());
            ps.setString(8, user.getRole() != null ? user.getRole() : "user");
            ps.setString(9, user.getStatus() != null ? user.getStatus() : "active");
            ps.setInt(10, user.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Update single field (name, email, phone, birth_date, etc.)
    public boolean updateField(int id, String field, String value) {
        String sql = "UPDATE users SET " + field + "=? WHERE id=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, value);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    
    public boolean checkPassword(int userId, String password) {
        String sql = "SELECT id FROM users WHERE id=? AND password=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // update password
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password=?, updated_at=NOW() WHERE id=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    // Delete user
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Check if email exists
    public boolean existsByEmail(String email) {
        String sql = "SELECT id FROM users WHERE email=?";
        try (Connection conn = new MyConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Utility: extract User from ResultSet
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role") != null ? rs.getString("role") : "user");
        if (rs.getDate("birth_date") != null) user.setBirthDate(rs.getDate("birth_date").toLocalDate());
        user.setGender(rs.getString("gender"));
        user.setImage(rs.getString("image"));
        user.setStatus(rs.getString("status") != null ? rs.getString("status") : "active");
        if (rs.getTimestamp("last_login") != null) user.setLastLogin(rs.getTimestamp("last_login"));
        if (rs.getTimestamp("created_at") != null) user.setCreatedAt(rs.getTimestamp("created_at"));
        if (rs.getTimestamp("updated_at") != null) user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
    
    public List<User> getAllUsers1() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setPassword(rs.getString("password"));
                u.setBirthDate(rs.getDate("birth_date") != null ? rs.getDate("birth_date").toLocalDate() : null);
                u.setGender(rs.getString("gender"));
                u.setImage(rs.getString("image"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setLastLogin(rs.getTimestamp("last_login"));
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    private Connection getConnection() {
		// TODO Auto-generated method stub
		return null;
	}

	// Get single user by ID
    public User getUserById1(int id) {
        User u = null;
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setPassword(rs.getString("password"));
                u.setBirthDate(rs.getDate("birth_date") != null ? rs.getDate("birth_date").toLocalDate() : null);
                u.setGender(rs.getString("gender"));
                u.setImage(rs.getString("image"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setLastLogin(rs.getTimestamp("last_login"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }
    
 // Get multiple users by IDs
    public List<User> getUsersByIds(List<Integer> ids) {
        List<User> list = new ArrayList<>();
        if(ids == null || ids.isEmpty()) return list;

        StringBuilder sb = new StringBuilder();
        for(int i=0;i<ids.size();i++) {
            sb.append("?");
            if(i < ids.size()-1) sb.append(",");
        }

        try (Connection con = MyConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE id IN (" + sb.toString() + ")";
            PreparedStatement ps = con.prepareStatement(sql);
            for(int i=0;i<ids.size();i++) ps.setInt(i+1, ids.get(i));
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setImage(rs.getString("image"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public boolean createUser(User user) {
        boolean success = false;
        String sql = "INSERT INTO users(name, email, phone, role, password, birth_date, gender, image, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = MyConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getPassword());

            LocalDate bd = user.getBirthDate();
            if (bd != null) {
                ps.setDate(6, Date.valueOf(bd));
            } else {
                ps.setDate(6, null);
            }

            ps.setString(7, user.getGender());
            ps.setString(8, user.getImage());
            ps.setString(9, user.getStatus() != null ? user.getStatus() : "active");

            success = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }
    
}
