<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.repository.RatingRepository" %>

<%
    CheatSheet cs = (CheatSheet) request.getAttribute("cheatsheet");

    Double avgObj = (Double) request.getAttribute("avg");
    double avg = (avgObj != null) ? avgObj : 0;

    int fullStars = (int) avg;
    
    // category name ကို သေချာသိမ်းထားပါ
    String categoryName = (cs != null && cs.getCategory() != null && !cs.getCategory().isEmpty()) 
                          ? cs.getCategory() : "All";
    
    // ✅ ADD THIS - User ရဲ့ rating ကိုယူရန်
    Integer userId = (Integer) session.getAttribute("userId");
    int userRating = 0;
    int ratingCount = 0;
    
    if (cs != null && userId != null) {
        try {
            RatingRepository ratingRepo = new RatingRepository();
            userRating = ratingRepo.getUserRating(userId, cs.getId());
            ratingCount = ratingRepo.getRatingCount(cs.getId());
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Cheatsheet Rating</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

    body{
        font-family: Arial;
        margin: 40px;
        background: #0f172a;
        color: white;
    }

    .box{
        padding: 25px;
        border-radius: 15px;
        width: 600px;
        margin: auto;
        background: #1e293b;
        box-shadow: 0 10px 25px rgba(0,0,0,0.3);
    }

    h2{
        margin-bottom: 15px;
        color: #38bdf8;
    }

    p{
        line-height: 1.7;
        color: #cbd5e1;
        white-space: pre-wrap;
    }

    hr{
        border: none;
        border-top: 1px solid #334155;
        margin: 20px 0;
    }

    select, button{
        padding: 10px;
        margin-top: 10px;
        border-radius: 8px;
        border: none;
    }

    select{
        width: 180px;
    }

    button{
        background: #38bdf8;
        color: white;
        cursor: pointer;
        font-weight: bold;
    }

    button:hover{
        background: #0ea5e9;
    }

    .stars{
        font-size: 24px;
        margin: 10px 0;
    }

    .avg{
        font-size: 20px;
        color: #facc15;
    }

    .back-btn{
        display: inline-block;
        margin-top: 20px;
        padding: 10px 18px;
        background: #334155;
        color: white;
        text-decoration: none;
        border-radius: 8px;
    }

    .back-btn:hover{
        background: #475569;
    }
    
    select[name="rating"] {
        font-family: 'Arial', 'FontAwesome', sans-serif;
        font-size: 18px;
        padding: 5px;
        margin: 10px 0;
    }

    select[name="rating"] option {
        color: #ffcc00;
        background-color: white;
    }
    
    /* ✅ ADD THIS - User rating display style */
    .user-rating {
        background: #0f172a;
        padding: 10px 15px;
        border-radius: 10px;
        margin: 15px 0;
        font-size: 14px;
    }
    
    .user-rating i.fa-solid.fa-star {
        color: #facc15;
    }
    
    .user-rating i.fa-regular.fa-star {
        color: #475569;
    }
    
    .rating-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
    }
    
    .rating-count {
        font-size: 14px;
        color: #94a3b8;
    }

</style>

</head>

<body>

<div class="box">

<%
    if(cs == null) {
%>

    <h2 style="color:red;">No Cheatsheet Data Found</h2>

<%
    } else {
%>

    <!-- TITLE -->
    <h2>
        <i class="fa-solid fa-book"></i>
        <%= cs.getTitle() %>
    </h2>

    <!-- CONTENT -->
    <p><%= cs.getContent() %></p>

    <hr>

    <!-- AVG RATING with COUNT -->
    <div class="rating-info">
        <h3 class="avg">
            <i class="fa-solid fa-star" style="color: gold;"></i>
            Average Rating: <%= String.format("%.1f", avg) %> / 5
        </h3>
        <div class="rating-count">
            <i class="fa-regular fa-comment"></i> <%= ratingCount %> <%= ratingCount == 1 ? "rating" : "ratings" %>
        </div>
    </div>

    <!-- STAR DISPLAY -->
    <div class="stars">
        <% for(int i = 1; i <= 5; i++) { %>
            <% if(i <= fullStars) { %>
                <i class="fa-solid fa-star" style="color: gold;"></i>
            <% } else { %>
                <i class="fa-regular fa-star" style="color: #94a3b8;"></i>
            <% } %>
        <% } %>
    </div>

    <!-- ✅ ADD THIS - User's Rating Display -->
    <% if (userRating > 0) { %>
        <div class="user-rating">
            <i class="fa-solid fa-circle-check" style="color: #22c55e;"></i>
            <strong>Your rating:</strong>
            <% for(int i = 1; i <= 5; i++) { %>
                <% if(i <= userRating) { %>
                    <i class="fa-solid fa-star" style="color: #facc15;"></i>
                <% } else { %>
                    <i class="fa-regular fa-star" style="color: #475569;"></i>
                <% } %>
            <% } %>
            (<%= userRating %>/5)
        </div>
    <% } else { %>
        <div class="user-rating">
            <i class="fa-regular fa-star"></i>
            <strong>You haven't rated this yet</strong> - Use the form below to rate!
        </div>
    <% } %>

    <hr>

    <!-- RATING FORM -->
    <form action="rate" method="post">
        <input type="hidden" name="category" value="<%= categoryName %>">
        <input type="hidden" name="cheatsheetId" value="<%= cs.getId() %>">
        <input type="hidden" name="userId" value="<%= (session.getAttribute("userId") != null ? session.getAttribute("userId") : "") %>">

        <label>
            <i class="fa-solid fa-star"></i>
            Give Rating:
        </label>
        <br>
        <select name="rating" required>
            <option value="1">&#9733;</option>
            <option value="2">&#9733;&#9733;</option>
            <option value="3">&#9733;&#9733;&#9733;</option>
            <option value="4">&#9733;&#9733;&#9733;&#9733;</option>
            <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733;</option>
        </select>
        <br>
        <button type="submit">
            <i class="fa-solid fa-paper-plane"></i>
            Submit Rating
        </button>
    </form>

    <!-- BACK BUTTON -->
    <a href="userAllCheat?name=<%= categoryName %>" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back
    </a>

<%
    }
%>

</div>

</body>
</html>