package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Comment;

public class CommentRepository {
    
    // Add comment (with parent_comment_id support)
    public boolean addComment(Comment comment) throws Exception {
        String sql = "INSERT INTO comments(user_id, cheatsheet_id, comment, parent_comment_id) VALUES(?,?,?,?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, comment.getUserId());
            ps.setInt(2, comment.getCheatsheetId());
            ps.setString(3, comment.getContent());
            
            if (comment.getParentCommentId() != null && comment.getParentCommentId() > 0) {
                ps.setInt(4, comment.getParentCommentId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // Get FLAT list of comments (for building tree in frontend/backend)
    public List<Comment> getCommentsByCheatsheetId(int cheatsheetId) throws Exception {
        List<Comment> comments = new ArrayList<>();
        
        String sql = "SELECT c.*, u.username as user_name FROM comments c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "WHERE c.cheatsheet_id = ? " +
                     "ORDER BY c.created_at ASC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, cheatsheetId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setCheatsheetId(rs.getInt("cheatsheet_id"));
                comment.setContent(rs.getString("comment"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comment.setUserName(rs.getString("user_name"));
                
                int parentId = rs.getInt("parent_comment_id");
                if (rs.wasNull()) {
                    comment.setParentCommentId(null);
                } else {
                    comment.setParentCommentId(parentId);
                }
                
                comments.add(comment);
            }
        }
        return comments;
    }
    
    // Get comments as TREE structure (for admin panel)
    public List<Comment> getCommentsTreeByCheatsheetId(int cheatsheetId) throws Exception {
        List<Comment> flatList = getCommentsByCheatsheetId(cheatsheetId);
        return buildCommentTree(flatList);
    }
    
    // Build tree structure from flat list
    public List<Comment> buildCommentTree(List<Comment> flatList) {
        Map<Integer, Comment> commentMap = new HashMap<>();
        List<Comment> topLevelComments = new ArrayList<>();
        
        // First, put all comments into map
        for (Comment comment : flatList) {
            commentMap.put(comment.getId(), comment);
            comment.setReplies(new ArrayList<>());
        }
        
        // Then build parent-child relationships
        for (Comment comment : flatList) {
            if (comment.getParentCommentId() == null) {
                topLevelComments.add(comment);
            } else {
                Comment parent = commentMap.get(comment.getParentCommentId());
                if (parent != null) {
                    parent.getReplies().add(comment);
                } else {
                    topLevelComments.add(comment);
                }
            }
        }
        
        return topLevelComments;
    }
    
    // Get all comments for admin (all cheatsheets)
    public List<Comment> getAllCommentsForAdmin() throws Exception {
        List<Comment> comments = new ArrayList<>();
        
        String sql = "SELECT c.*, u.username as user_name FROM comments c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "ORDER BY c.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setCheatsheetId(rs.getInt("cheatsheet_id"));
                comment.setContent(rs.getString("comment"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comment.setUserName(rs.getString("user_name"));
                
                int parentId = rs.getInt("parent_comment_id");
                if (rs.wasNull()) {
                    comment.setParentCommentId(null);
                } else {
                    comment.setParentCommentId(parentId);
                }
                
                comments.add(comment);
            }
        }
        return comments;
    }
    
    // Delete comment and its replies
    public boolean deleteComment(int commentId) throws Exception {
        String sql = "DELETE FROM comments WHERE id = ? OR parent_comment_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, commentId);
            ps.setInt(2, commentId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Get comment count
    public int getCommentCount(int cheatsheetId) throws Exception {
        String sql = "SELECT COUNT(*) FROM comments WHERE cheatsheet_id = ?";
        
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
}