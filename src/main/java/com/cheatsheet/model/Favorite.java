package com.cheatsheet.model;

import java.sql.Timestamp;

public class Favorite {
    private int id;
    private int userId;
    private int cheatsheetId;
    private Timestamp createdAt;

    // Default Constructor
    public Favorite() {
    }

    // Parameterized Constructor (Data အသစ်ထည့်တဲ့အခါ သုံးရန်)
    public Favorite(int userId, int cheatsheetId) {
        this.userId = userId;
        this.cheatsheetId = cheatsheetId;
    }

    // Full Parameterized Constructor (Database ကနေ Data ပြန်ထုတ်တဲ့အခါ သုံးရန်)
    public Favorite(int id, int userId, int cheatsheetId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.cheatsheetId = cheatsheetId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCheatsheetId() {
        return cheatsheetId;
    }

    public void setCheatsheetId(int cheatsheetId) {
        this.cheatsheetId = cheatsheetId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Debugging လုပ်တဲ့အခါ Data ကြည့်ရလွယ်အောင် toString() ထည့်ပေးထားပါတယ်
    @Override
    public String toString() {
        return "Favorite [id=" + id + ", userId=" + userId + ", cheatsheetId=" + cheatsheetId + ", createdAt=" + createdAt + "]";
    }
}