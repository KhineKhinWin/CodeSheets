package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Category;
import com.cheatsheet.model.CheatSheet;

public class CheatsheetRepository {

    // ======================
    // COUNT ALL CHEATSHEETS
    // ======================
	public int countCheatsheets() throws Exception {
	    // is_public = 1 ဖြစ်ပြီး status ကလည်း PUBLIC ဖြစ်တဲ့ကောင်ကိုပဲ ရေတွက်မယ်
	    String sql = "SELECT COUNT(*) FROM cheatsheets " +
	                 "WHERE delete_flag = 0 AND is_public = 1 AND status = 'PUBLIC'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) return rs.getInt(1);
	    }
	    return 0;
	}

    // ======================
    // GET BY USER ID (My Cheats အတွက်)
    // ======================
    public List<CheatSheet> getCheatsByUserId(int userId) throws Exception {
        List<CheatSheet> list = new ArrayList<>();
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.user_id=? AND cs.delete_flag=0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CheatSheet c = new CheatSheet();
                mapResultSetToCheatSheet(rs, c);
                list.add(c);
            }
        }
        return list;
    }

    // ======================
    // GET BY CATEGORY (is_public=1 ထည့်ထားသည်)
    // ======================
    public List<CheatSheet> getCheatSheetsByCategory(String category) {
        List<CheatSheet> list = new ArrayList<>();
        
        // ✅ SQL ကို Public ဖြစ်တဲ့ data ပဲပြအောင် တင်းကျပ်လိုက်ပါ
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE c.name = ? " +
                     "AND cs.delete_flag = 0 " +
                     "AND cs.is_public = 1 " + // Public ဖြစ်ရမယ်
                     "AND cs.status = 'PUBLIC'"; // Status ကလည်း PUBLIC ဖြစ်ရမယ်

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, category.trim());
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CheatSheet c = new CheatSheet();
                mapResultSetToCheatSheet(rs, c);
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // ======================
    // GET ALL CHEATSHEETS (is_public=1 ထည့်ထားသည်)
    // ======================
    public List<CheatSheet> getAllCheatSheets() {
        List<CheatSheet> list = new ArrayList<>();
        // ဒီမှာ is_public = 1 ပါရပါမယ်
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.delete_flag = 0 AND cs.is_public = 1"; 

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CheatSheet s = new CheatSheet();
                mapResultSetToCheatSheet(rs, s);
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Helper Method
    private void mapResultSetToCheatSheet(ResultSet rs, CheatSheet sheet) throws Exception {
        sheet.setId(rs.getInt("id"));
        sheet.setTitle(rs.getString("title"));
        sheet.setContent(rs.getString("content"));
        sheet.setExampleCode(rs.getString("example_code")); 
        sheet.setCategory(rs.getString("category"));  // ❌ ဒီမှာ category column မရှိ
        try { sheet.setCategoryId(rs.getInt("category_id")); } catch(Exception e){}
    }

    public CheatSheet findById(int id) {
        CheatSheet s = null;
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.id=? AND cs.delete_flag=0";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new CheatSheet();
                mapResultSetToCheatSheet(rs, s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return s;
    }

    public void updateSheet(int id, String title, int categoryId, String content, String status) {
        // status က "PUBLIC" ဖြစ်မှ ၁ ဖြစ်မယ်၊ ကျန်တာ ၀ ဖြစ်မယ်
        int isPublic = (status != null && status.equalsIgnoreCase("PUBLIC")) ? 1 : 0;

        String sql = "UPDATE cheatsheets SET title=?, category_id=?, content=?, status=?, is_public=? WHERE id=?";

        try (Connection con = com.cheatsheet.config.DBConnection.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setInt(2, categoryId);
            ps.setString(3, content);
            ps.setString(4, status);
            ps.setInt(5, isPublic);
            ps.setInt(6, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    
 // ✅ Example code ပါတဲ့ Update Method (အသစ်ထည့်)
    public void updateSheetWithExample(int id, String title, int categoryId, 
                                       String content, String exampleCode, String status) {
        
        int isPublic = (status != null && status.equalsIgnoreCase("PUBLIC")) ? 1 : 0;

        String sql = "UPDATE cheatsheets SET title=?, category_id=?, content=?, example_code=?, status=?, is_public=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setInt(2, categoryId);
            ps.setString(3, content);
            ps.setString(4, exampleCode);  // ✅ example_code
            ps.setString(5, status);
            ps.setInt(6, isPublic);
            ps.setInt(7, id);
            ps.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
    

    // ==========================================
    // CREATE METHOD (Admin ရော User ရော အဆင်ပြေအောင် ညှိထားသည်)
    // ==========================================
    public void createCheatSheet(String title, int categoryId, String content, String exampleCode, int userId, String status) {
        // status က null ဖြစ်နေရင် (သို့) အလွတ်ဖြစ်နေရင် "PUBLIC" လို့ သတ်မှတ်ပေးလိုက်မယ်
        if (status == null || status.isEmpty()) {
            status = "PUBLIC";
        }
        
        int isPublic = status.equalsIgnoreCase("PUBLIC") ? 1 : 0;
        
        String sql = "INSERT INTO cheatsheets(title, category_id, content,example_code, user_id, status, is_public, delete_flag) " +
                     "VALUES(?,?,?,?,?,?,?,0)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setInt(2, categoryId);
            ps.setString(3, content);
            ps.setString(4, exampleCode); 
            ps.setInt(5, userId);
            ps.setString(6, status);
            ps.setInt(7, isPublic);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM categories";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<CheatSheet> getMyCheats(int userId) {
        List<CheatSheet> list = new ArrayList<>();
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id=c.id " +
                     "WHERE cs.user_id=? AND cs.delete_flag=0 ORDER BY cs.id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CheatSheet c = new CheatSheet();
                mapResultSetToCheatSheet(rs, c);
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public List<CheatSheet> getAllCheatSheetsForAdmin() {
        List<CheatSheet> list = new ArrayList<>();
        // ဒီမှာ is_public = 1 ဆိုတာကို ဖြုတ်ထားပါ။ delete_flag = 0 တစ်ခုပဲ စစ်ပါ
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.delete_flag = 0 " + 
                     "ORDER BY cs.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CheatSheet s = new CheatSheet();
                mapResultSetToCheatSheet(rs, s);
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public List<CheatSheet> search(String keyword) {
        List<CheatSheet> list = new ArrayList<>();
        
        String sql = "SELECT cs.*, c.name AS category FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE (cs.title LIKE ? OR cs.content LIKE ? OR c.name LIKE ?) " +
                     "AND cs.delete_flag = 0 " +
                     "AND cs.is_public = 1 " +
                     "AND cs.status = 'PUBLIC' " +
                     "ORDER BY cs.id DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);  // ✅ ဒါအရေးကြီးတယ်
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                CheatSheet cs = new CheatSheet();
                cs.setId(rs.getInt("id"));
                cs.setTitle(rs.getString("title"));
                cs.setContent(rs.getString("content"));
                cs.setExampleCode(rs.getString("example_code"));
                cs.setCategory(rs.getString("category"));
                cs.setCategoryId(rs.getInt("category_id"));
                cs.setUserId(rs.getInt("user_id"));
                cs.setStatus(rs.getString("status"));
                cs.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(cs);
            }
            
        } catch(Exception e){
            e.printStackTrace();
        }
        
        return list;
    }
    public int getPublicCheatCount() {
        int count = 0;
        // is_public = 1 ဖြစ်တဲ့ Public စာတွေကိုပဲ ရေတွက်မဲ့ SQL
        String sql = "SELECT COUNT(*) FROM cheatsheets WHERE delete_flag = 0 AND is_public = 1";
        
        try (Connection con = com.cheatsheet.config.DBConnection.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
 // ✅ Cheat Sheet ကို Soft Delete လုပ်ရန် (delete_flag ကို 1 ပြောင်းမည်)
    public void deleteCheatSheet(int id) {
        String sql = "UPDATE cheatsheets SET delete_flag = 1 WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            System.out.println("DEBUG: Deleted Sheet ID - " + id);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
        
    public CheatSheet getCheatsheetById(int id) throws Exception {
        // ✅ JOIN နဲ့ category name ကို ယူပါ
        String sql = "SELECT cs.*, c.name AS category_name FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.id = ? AND cs.delete_flag = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                CheatSheet cs = new CheatSheet();
                cs.setId(rs.getInt("id"));
                cs.setTitle(rs.getString("title"));
                cs.setContent(rs.getString("content"));
                cs.setCategory(rs.getString("category_name"));  // ✅ category_name ကို သုံးပါ
                cs.setCategoryId(rs.getInt("category_id"));     // ✅ category_id ကိုလည်း ထည့်ပါ
                cs.setUserId(rs.getInt("user_id"));
                cs.setCreatedAt(rs.getTimestamp("created_at"));
                return cs;
            }
        }
        return null;
    }
    public List<CheatSheet> getCheatSheetsByCategoryId(int categoryId) {

        List<CheatSheet> list = new ArrayList<>();

        String sql = "SELECT cs.*, c.name AS category " +
                     "FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.category_id = ? " +
                     "AND cs.delete_flag = 0 " +
                     "AND cs.is_public = 1 " +
                     "AND cs.status = 'PUBLIC'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                CheatSheet c = new CheatSheet();
                mapResultSetToCheatSheet(rs, c);
                list.add(c);
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
    
 // ✅ ဒီ method ကို CheatsheetRepository.java ထဲမှာ ထည့်ပါ
    public CheatSheet getCheatsheetByIdWithExample(int id) throws Exception {
        String sql = "SELECT cs.*, c.name AS category_name FROM cheatsheets cs " +
                     "LEFT JOIN categories c ON cs.category_id = c.id " +
                     "WHERE cs.id = ? AND cs.delete_flag = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                CheatSheet cs = new CheatSheet();
                cs.setId(rs.getInt("id"));
                cs.setTitle(rs.getString("title"));
                cs.setContent(rs.getString("content"));
                cs.setExampleCode(rs.getString("example_code"));
                cs.setCategory(rs.getString("category_name"));
                cs.setCategoryId(rs.getInt("category_id"));
                cs.setUserId(rs.getInt("user_id"));
                cs.setCreatedAt(rs.getTimestamp("created_at"));
                cs.setStatus(rs.getString("status"));
                return cs;
            }
        }
        return null;
    }
}