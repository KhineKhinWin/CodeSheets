package com.cheatsheet.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Comment {
    private int id;
    private int userId;
    private int cheatsheetId;
    private String content;
    private Timestamp createdAt;
    private Integer parentCommentId;
    private String userName;
    private List<Comment> replies;
    
    public Comment() {
        this.replies = new ArrayList<>();
    }
    
    public Comment(int userId, int cheatsheetId, String content, Integer parentCommentId) {
        this.userId = userId;
        this.cheatsheetId = cheatsheetId;
        this.content = content;
        this.parentCommentId = parentCommentId;
        this.replies = new ArrayList<>();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getCheatsheetId() { return cheatsheetId; }
    public void setCheatsheetId(int cheatsheetId) { this.cheatsheetId = cheatsheetId; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Integer getParentCommentId() { return parentCommentId; }
    public void setParentCommentId(Integer parentCommentId) { this.parentCommentId = parentCommentId; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public List<Comment> getReplies() { return replies; }
    public void setReplies(List<Comment> replies) { this.replies = replies; }
    
    public void addReply(Comment reply) {
        this.replies.add(reply);
    }
}