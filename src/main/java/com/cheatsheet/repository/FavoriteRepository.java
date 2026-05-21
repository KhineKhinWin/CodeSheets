package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.cheatsheet.model.Favorite;

public class FavoriteRepository {
    
    // Database Configuration (သင့်စနစ်အတိုင်း ပြန်ပြင်ပေးပါ)
    private final String DB_URL = "jdbc:mysql://localhost:3306/cheatsheet_db";
    private final String DB_USER = "root";
    private final String DB_PASS = "your_password";

    // Database Connection ရယူရန် Helper Method
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    /**
     * ၁။ User တစ်ဦးက Cheatsheet တစ်ခုကို Favorite ပေးထားခြင်း ရှိ/မရှိ စစ်ဆေးရန်
     */
    public boolean isFavoriteExists(int userId, int cheatsheetId) {
        String query = "SELECT id FROM favorites WHERE user_id = ? AND cheatsheet_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, cheatsheetId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next(); // ရှိရင် true, မရှိရင် false
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ၂။ Favorite အသစ် ထည့်ရန် (Add to Favorite)
     */
    public boolean addFavorite(int userId, int cheatsheetId) {
        String query = "INSERT INTO favorites (user_id, cheatsheet_id, created_at) VALUES (?, ?, NOW())";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, cheatsheetId);
            
            return pstmt.executeUpdate() > 0; // Insert အောင်မြင်ရင် true
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ၃။ Favorite ပြန်ဖြုတ်ရန် (Remove from Favorite)
     */
    public boolean removeFavorite(int userId, int cheatsheetId) {
        String query = "DELETE FROM favorites WHERE user_id = ? AND cheatsheet_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, cheatsheetId);
            
            return pstmt.executeUpdate() > 0; // Delete အောင်မြင်ရင် true
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ၄။ User တစ်ယောက်ချင်းစီအလိုက် Favorite လုပ်ထားသမျှ စာရင်းကို ဆွဲထုတ်ရန်
     */
    public List<Favorite> getFavoritesByUserId(int userId) {
        List<Favorite> favList = new ArrayList<>();
        String query = "SELECT * FROM favorites WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Favorite fav = new Favorite(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("cheatsheet_id"),
                        rs.getTimestamp("created_at")
                    );
                    favList.add(fav);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return favList;
    }
}