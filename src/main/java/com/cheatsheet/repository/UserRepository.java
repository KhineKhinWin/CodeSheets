package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;
import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.model.User;

public class UserRepository {
    Connection con;

    // =========================
    // REGISTER
    // =========================
    public int register(User u) throws Exception {
        int result = 0;
        con = DBConnection.getConnection();

        String sql = "INSERT INTO users(username, email, password, role, delete_flag) VALUES(?,?,?,?,0)";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, u.getUsername());
        ps.setString(2, u.getEmail());
        ps.setString(3, u.getPassword());
        ps.setString(4, u.getRole());

        result = ps.executeUpdate();
        return result;
    }

    // =========================
    // LOGIN
    // =========================
    public User login(String email, String password) throws Exception {
        Connection con = DBConnection.getConnection();
        
        String sql = "SELECT * FROM users WHERE email=? AND password=? AND (delete_flag=0 OR delete_flag IS NULL)";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, password);
        
        System.out.println("Login attempt for: " + email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setRole(rs.getString("role"));
            
            System.out.println("Login Success: " + u.getUsername() + " as " + u.getRole());
            return u;
        } else {
            System.out.println("Login Failed: Incorrect email or password for " + email);
        }
        return null;
    }

    // =========================
    // GET USER BY ID (NEW METHOD)
    // =========================
    public User getUserById(int id) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM users WHERE id=? AND (delete_flag=0 OR delete_flag IS NULL)";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setRole(rs.getString("role"));
            return u;
        }
        return null;
    }

    // =========================
    // GET USER BY USERNAME (NEW METHOD)
    // =========================
    public User getUserByUsername(String username) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM users WHERE username=? AND (delete_flag=0 OR delete_flag IS NULL)";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setRole(rs.getString("role"));
            return u;
        }
        return null;
    }

    // =========================
    // GET USER BY EMAIL (NEW METHOD)
    // =========================
    public User getUserByEmail(String email) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM users WHERE email=? AND (delete_flag=0 OR delete_flag IS NULL)";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setRole(rs.getString("role"));
            return u;
        }
        return null;
    }

    // =========================
    // UPDATE USER PROFILE (username, email) - NEW METHOD
    // =========================
    public boolean updateUser(User user) throws Exception {
        con = DBConnection.getConnection();
        String sql = "UPDATE users SET username=?, email=? WHERE id=?";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getEmail());
        ps.setInt(3, user.getId());
        
        int result = ps.executeUpdate();
        return result > 0;
    }

    // =========================
    // VERIFY CURRENT PASSWORD (NEW METHOD)
    // =========================
    public boolean verifyPassword(int userId, String currentPassword) throws Exception {
        con = DBConnection.getConnection();
        String sql = "SELECT password FROM users WHERE id=?";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            String storedPassword = rs.getString("password");
            return storedPassword.equals(currentPassword);
        }
        return false;
    }

    // =========================
    // UPDATE PASSWORD (NEW METHOD)
    // =========================
    public boolean updatePassword(int userId, String newPassword) throws Exception {
        con = DBConnection.getConnection();
        String sql = "UPDATE users SET password=? WHERE id=?";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, newPassword);
        ps.setInt(2, userId);
        
        int result = ps.executeUpdate();
        return result > 0;
    }

    // =========================
    // GET ALL USERS (ACTIVE ONLY)
    // =========================
    public List<User> getAllUsers() throws Exception {
        List<User> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();

        String sql = "SELECT * FROM users WHERE (delete_flag=0 OR delete_flag IS NULL) AND role='user'"; 

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setRole(rs.getString("role"));
            list.add(u);
        }
        return list;
    }

    // =========================
    // GET ALL USERS FOR ADMIN (INCLUDING ADMINS)
    // =========================
    public List<User> getAllUsersForAdmin() throws Exception {
        List<User> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();

        String sql = "SELECT * FROM users WHERE delete_flag=0 OR delete_flag IS NULL ORDER BY id DESC"; 

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setRole(rs.getString("role"));
            list.add(u);
        }
        return list;
    }

    // =========================
    // DELETE USER (SOFT DELETE)
    // =========================
    public int deleteUser(int id) throws Exception {
        con = DBConnection.getConnection();
        String sql = "UPDATE users SET delete_flag=1 WHERE id=?"; 

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        return ps.executeUpdate();
    }

    // =========================
    // COUNT USERS (ACTIVE ONLY)
    // =========================
    public int countUsers() throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) FROM users WHERE delete_flag = 0 OR delete_flag IS NULL";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            return rs.getInt(1);
        }
        return 0;
    }
    
    // =========================
    // GET ALL CHEAT SHEETS
    // =========================
    public List<CheatSheet> getAllCheatSheets() {
        List<CheatSheet> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM cheatsheets";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                CheatSheet c = new CheatSheet();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setCategory(rs.getString("category"));
                c.setContent(rs.getString("content"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // CHECK IF EMAIL EXISTS
    // =========================
    public boolean isEmailExists(String email) {
        boolean exists = false;
        String sql = "SELECT id FROM users WHERE email = ? AND (delete_flag=0 OR delete_flag IS NULL)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }

    // =========================
    // CHECK IF USERNAME EXISTS (NEW METHOD)
    // =========================
    public boolean isUsernameExists(String username) {
        boolean exists = false;
        String sql = "SELECT id FROM users WHERE username = ? AND (delete_flag=0 OR delete_flag IS NULL)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
}