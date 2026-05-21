package com.cheatsheet.model;

public class Rating {

    private int id;
    private int userId;
    private int cheatsheetId;
    private int ratingValue;

    public Rating() {}

    // 👉 FOR INSERT / UPDATE (USE THIS)
    public Rating(int userId, int cheatsheetId, int ratingValue) {
        this.userId = userId;
        this.cheatsheetId = cheatsheetId;
        this.ratingValue = ratingValue;
    }

    // 👉 OPTIONAL: FOR DB FETCH (id ပါတဲ့ case)
    public Rating(int id, int userId, int cheatsheetId, int ratingValue) {
        this.id = id;
        this.userId = userId;
        this.cheatsheetId = cheatsheetId;
        this.ratingValue = ratingValue;
    }

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

    public int getRatingValue() { 
        return ratingValue; 
    }

    public void setRatingValue(int ratingValue) { 
        this.ratingValue = ratingValue; 
    }
}