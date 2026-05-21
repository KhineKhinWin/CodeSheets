package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Rating;

public class RatingRepository {
	
	public boolean addRating(Rating r) throws Exception {
	    String sql = "INSERT INTO ratings(user_id, cheatsheet_id, rating_value) VALUES(?,?,?)";

	    System.out.println("=== DEBUG: addRating called ===");
	    System.out.println("userId: " + r.getUserId());
	    System.out.println("cheatsheetId: " + r.getCheatsheetId());
	    System.out.println("ratingValue: " + r.getRatingValue());

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        System.out.println("Connection: " + con);  // null ထွက်ရင် connection ပြဿနာ

	        ps.setInt(1, r.getUserId());
	        ps.setInt(2, r.getCheatsheetId());
	        ps.setInt(3, r.getRatingValue());

	        int row = ps.executeUpdate();
	        System.out.println("Rows inserted: " + row);
	        return row > 0;
	    } catch (Exception e) {
	        e.printStackTrace();  // Console မှာ error အပြည့်အစုံကြည့်
	        throw e;
	    }
	}
	
	public boolean updateRating(Rating rating) throws Exception {

	    String sql = "UPDATE ratings SET rating_value=? WHERE user_id=? AND cheatsheet_id=?";

	    try(Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, rating.getRatingValue());
	        ps.setInt(2, rating.getUserId());
	        ps.setInt(3, rating.getCheatsheetId());

	        return ps.executeUpdate() > 0;
	    }
	}
	
	public boolean hasUserRated(int userId, int cheatsheetId) throws Exception {

	    String sql = "SELECT * FROM ratings WHERE user_id=? AND cheatsheet_id=?";

	    try(Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, userId);
	        ps.setInt(2, cheatsheetId);

	        ResultSet rs = ps.executeQuery();

	        return rs.next();
	    }
	}
	
	public double getAverageRating(int cheatsheetId) throws Exception {

	    String sql = "SELECT AVG(rating_value) AS avgRating FROM ratings WHERE cheatsheet_id=?";

	    try(Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, cheatsheetId);

	        ResultSet rs = ps.executeQuery();

	        if(rs.next()) {
	            return rs.getDouble("avgRating");
	        }
	    }

	    return 0;
	}
	
	// Rating count ရယူရန်
	public int getRatingCount(int cheatsheetId) throws Exception {
	    String sql = "SELECT COUNT(*) FROM ratings WHERE cheatsheet_id = ?";
	    
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setInt(1, cheatsheetId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }
	    return 0;
	}

	// User ရဲ့ rating ကိုယူရန်
	public int getUserRating(int userId, int cheatsheetId) throws Exception {
	    String sql = "SELECT rating_value FROM ratings WHERE user_id = ? AND cheatsheet_id = ?";
	    
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ps.setInt(2, cheatsheetId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt("rating_value");
	        }
	    }
	    return 0;
	}
	public int getTotalRatingCount() throws Exception {
	    String sql = "SELECT COUNT(*) FROM ratings";
	    
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        
	        if (rs.next()) {
	            int count = rs.getInt(1);
	            System.out.println("=== DEBUG: getTotalRatingCount() = " + count);
	            return count;
	        }
	    } catch (Exception e) {
	        System.out.println("=== ERROR in getTotalRatingCount: " + e.getMessage());
	        e.printStackTrace();
	    }
	    return 0;
	}
}
