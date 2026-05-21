<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="com.cheatsheet.repository.RatingRepository" %>

<%!
    public String escapeHtml(String str) {
        if(str == null) return "";
        return str.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");
    }
%>

<%
    User user = (User) session.getAttribute("loginUser");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    List<CheatSheet> list = (List<CheatSheet>) request.getAttribute("sheets");
    if(list == null) list = new ArrayList<>();
    
    String keyword = request.getParameter("keyword");
    if(keyword == null) keyword = "";
    
    RatingRepository ratingRepo = new RatingRepository();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search: <%= keyword %> | CheatSheets</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
        min-height: 100vh;
        color: #f1f5f9;
    }

    .header {
        background: #1e293b;
        padding: 15px 10%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #334155;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .logo {
        font-size: 28px;
        font-weight: bold;
        color: white;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .logo span { color: #38bdf8; }

    .search-bar {
        flex: 1;
        display: flex;
        justify-content: center;
        margin-left: -180px;
    }
    .search-bar input {
        width: 450px;
        padding: 10px 18px;
        border: 1px solid #334155;
        outline: none;
        background: #0f172a;
        color: white;
        border-radius: 50px 0 0 50px;
        font-size: 14px;
    }
    .search-bar button {
        padding: 10px 18px;
        border: none;
        background: #38bdf8;
        color: #0f172a;
        border-radius: 0 50px 50px 0;
        cursor: pointer;
        font-weight: bold;
    }

    .sub-nav {
        background: #0f172a;
        padding: 0 10%;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .nav-links { display: flex; align-items: center; }
    .nav-links a {
        color: #94a3b8;
        text-decoration: none;
        padding: 12px 18px;
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        font-weight: 500;
    }
    .nav-links a:hover, .nav-links a.active { color: #38bdf8; }
    .logout a {
        color: #ef4444;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .dropdown { position: relative; }
    .dropdown-content {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        width: 240px;
        background: #1e293b;
        border-radius: 10px;
        overflow: hidden;
        z-index: 999;
        border: 1px solid #334155;
    }
    .dropdown-content a {
        padding: 10px 16px;
        border-bottom: 1px solid #334155;
        color: #cbd5e1;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }
    .dropdown-content a:hover { background: #0f172a; color: #38bdf8; }
    .dropdown:hover .dropdown-content { display: block; }

    .main-content { padding: 20px 10% 50px 10%; }
    .page-title {
        text-align: center;
        font-size: 32px;
        margin-bottom: 20px;
        background: linear-gradient(135deg, #38bdf8, #818cf8);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }
    .search-info { text-align: center; color: #94a3b8; margin-bottom: 30px; }

    .stats-bar {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 12px 20px;
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
    }
    .stats-count {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #cbd5e1;
        font-size: 13px;
    }
    .stats-count i { font-size: 18px; color: #38bdf8; }
    .stats-count span { font-size: 20px; font-weight: bold; color: #38bdf8; }

    .card-container {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 25px;
    }
    @media (max-width: 1000px) { .card-container { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 650px) { .card-container { grid-template-columns: 1fr; } .main-content { padding: 20px 5%; } }

    .card {
        background: #ffffff;
        border-radius: 24px;
        overflow: hidden;
        transition: all 0.35s ease;
        border: none;
        display: flex;
        flex-direction: column;
        position: relative;
        box-shadow: 0 10px 30px -5px rgba(0,0,0,0.15);
    }
    .card:hover { transform: translateY(-8px); box-shadow: 0 25px 40px -12px rgba(0,0,0,0.25); }

    .card-cover {
        height: 160px;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .cover-programming { background: linear-gradient(135deg, #667eea, #764ba2); }
    .cover-software { background: linear-gradient(135deg, #f093fb, #f5576c); }
    .cover-design { background: linear-gradient(135deg, #4facfe, #00f2fe); }
    .cover-data-science { background: linear-gradient(135deg, #43e97b, #38f9d7); }
    .cover-languages { background: linear-gradient(135deg, #fa709a, #fee140); }
    .cover-education { background: linear-gradient(135deg, #a18cd1, #fbc2eb); }
    .cover-default { background: linear-gradient(135deg, #38bdf8, #0ea5e9); }

    .card-cover-icon {
        width: 70px;
        height: 70px;
        background: rgba(255,255,255,0.25);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32px;
        color: white;
        backdrop-filter: blur(8px);
    }

    .card-badge {
        position: absolute;
        top: 15px;
        right: 15px;
        background: rgba(0,0,0,0.6);
        backdrop-filter: blur(5px);
        color: #facc15;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 600;
    }

    .card-content { padding: 20px; background: white; }
    .card-title {
        font-size: 18px;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 10px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .card-description {
        color: #64748b;
        font-size: 13px;
        line-height: 1.5;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin-bottom: 15px;
    }

    .code-preview {
        background: #f1f5f9;
        border-radius: 12px;
        padding: 12px;
        margin-bottom: 15px;
        border-left: 3px solid #22c55e;
    }
    .code-preview-label {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #22c55e;
        font-size: 10px;
        font-weight: 700;
        margin-bottom: 6px;
        text-transform: uppercase;
    }
    .code-preview-text {
        color: #334155;
        font-family: monospace;
        font-size: 11px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .rating-row {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 15px;
    }
    .rating-stars { display: inline-flex; gap: 3px; }
    .rating-stars i { font-size: 12px; }
    .rating-stars i.fa-solid.fa-star { color: #facc15; }
    .rating-stars i.fa-regular.fa-star { color: #cbd5e1; }
    .rating-value { font-size: 13px; font-weight: 600; color: #facc15; }
    .rating-count { font-size: 11px; color: #94a3b8; }

    .comment-preview-card {
        margin-top: 12px;
        padding: 8px 12px;
        background: #f1f5f9;
        border-radius: 10px;
        font-size: 11px;
        color: #64748b;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .comment-preview-card i { color: #38bdf8; }

    .btn-view {
        width: 100%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        padding: 10px 16px;
        background: #0f172a;
        color: white;
        border: none;
        border-radius: 14px;
        cursor: pointer;
        font-size: 12px;
        font-weight: 600;
        margin-top: 10px;
        transition: all 0.3s ease;
    }
    .btn-view:hover { background: #38bdf8; color: #0f172a; transform: translateY(-2px); }

    .empty {
        text-align: center;
        padding: 60px 20px;
        background: #1e293b;
        border-radius: 20px;
        grid-column: 1 / -1;
    }

    /* MODAL STYLES */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.85);
        backdrop-filter: blur(5px);
    }
    .modal-content {
        background: #1e293b;
        margin: 5% auto;
        padding: 0;
        width: 550px;
        max-width: 90%;
        border-radius: 20px;
        border: 1px solid rgba(56,189,248,0.3);
        animation: modalFadeIn 0.3s ease;
        max-height: 85vh;
        overflow-y: auto;
    }
    @keyframes modalFadeIn {
        from { opacity: 0; transform: scale(0.95); }
        to { opacity: 1; transform: scale(1); }
    }
    .modal-header {
        padding: 18px 22px;
        background: linear-gradient(135deg, #0f172a, #1e293b);
        border-bottom: 1px solid #334155;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
    }
    .modal-header h3 { color: #38bdf8; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
    .close-modal { color: #94a3b8; font-size: 26px; cursor: pointer; }
    .close-modal:hover { color: #ef4444; }

    .modal-body { padding: 22px; }

    .desc-box {
        background: #0f172a;
        padding: 18px;
        border-radius: 12px;
        margin-bottom: 18px;
        border-left: 4px solid #38bdf8;
    }
    .code-box {
        background: #0a0a0f;
        padding: 18px;
        border-radius: 12px;
        margin-bottom: 18px;
        border-left: 4px solid #22c55e;
    }
    .code-box pre { color: #86efac; font-family: monospace; font-size: 13px; white-space: pre-wrap; }

    .copy-btn {
        background: #38bdf8;
        color: #0f172a;
        border: none;
        padding: 10px 20px;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 15px;
    }

    .modal-rating-section {
        margin-top: 20px;
        padding-top: 15px;
        border-top: 1px solid #334155;
        }
        .modal-rating-title { color: #facc15; font-size: 14px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .star-dropdown {
        padding: 8px 12px;
        border-radius: 8px;
        border: 1px solid #334155;
        background: #0f172a;
        color: #facc15;
        cursor: pointer;
    }
    .rating-submit-btn {
        background: #facc15;
        color: #0f172a;
        border: none;
        padding: 8px 16px;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
    }
    .rating-submit-btn:hover { background: #eab308; }
        
  .star-dropdown {
    padding: 8px 12px;
    border-radius: 8px;
    border: 1px solid #334155;
    background: #0f172a;
    color: #facc15;
    cursor: pointer;
    font-family: 'Font Awesome 6 Free', 'Segoe UI', monospace;
    font-weight: 900;
    font-size: 14px;
}

.star-dropdown option {
    background: #1e293b;
    color: #facc15;
    font-family: 'Font Awesome 6 Free', 'Segoe UI', sans-serif;
    font-weight: 900;
    padding: 8px;
}
    }
   .rating-submit-btn {
        background: #facc15;
        color: #0f172a;
        border: none;
        padding: 8px 16px;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
    }

    .modal-comment-section {
        margin-top: 20px;
        padding-top: 15px;
        border-top: 1px solid #334155;
    }
    .modal-comment-title { color: #38bdf8; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .modal-comment-section textarea {
        width: 100%;
        padding: 10px;
        border-radius: 10px;
        border: 1px solid #334155;
        background: #0f172a;
        color: white;
        resize: vertical;
    }
    .comment-post-btn {
        background: #22c55e;
        color: white;
        border: none;
        padding: 8px 20px;
        border-radius: 8px;
        margin-top: 10px;
        cursor: pointer;
    }

    .modal-comment-list-section {
        margin-top: 20px;
        padding-top: 15px;
        border-top: 1px solid #334155;
    }
    .modal-comment-list-section h4 { color: #38bdf8; margin-bottom: 12px; }

    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-track { background: #0f172a; border-radius: 10px; }
    ::-webkit-scrollbar-thumb { background: #38bdf8; border-radius: 10px; }
</style>

</head>

<body>


<header class="header">
    <a href="homepage" class="logo"><i class="fa-solid fa-code"></i> Cheat<span>Sheets</span></a>
    <form action="searchCheatsheet" method="get" class="search-bar">
        <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search cheat sheets...">
        <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
    </form>
</header>

<nav class="sub-nav">
    <div class="nav-links">
        <a href="homepage"><i class="fa-solid fa-house"></i> Home</a>
        <div class="dropdown">
            <a href="#" class="active"><i class="fa-solid fa-book"></i> Cheat Sheets</a>
            <div class="dropdown-content">
                <a href="userAllCheat?name=Programming">Programming</a>
                <a href="userAllCheat?name=Software">Software</a>
                <a href="userAllCheat?name=Design">Design</a>
                <a href="userAllCheat?name=Data Science">Data Science</a>
                <a href="userAllCheat?name=Languages">Languages</a>
                <a href="userAllCheat?name=Education">Education</a>
            </div>
        </div>
        <a href="create_cheat"><i class="fa-solid fa-pen-to-square"></i> Create</a>
        <a href="myCheats"><i class="fa-solid fa-user"></i> My Cheats</a>
        <a href="help.jsp"><i class="fa-solid fa-circle-question"></i> Help</a>
    </div>
    <div class="logout"><a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></div>
</nav>

<div class="main-content">
    <h1 class="page-title"><i class="fa-solid fa-magnifying-glass"></i> Search Results</h1>
    <div class="search-info">Found <strong><%= list.size() %></strong> result(s) for "<%= keyword %>"</div>

    <div class="stats-bar">
        <div class="stats-count"><i class="fa-solid fa-book-open"></i><div><span><%= list.size() %></span> Cheat Sheets Found</div></div>
        <div class="stats-count"><i class="fa-solid fa-search"></i><div>Keyword: <strong style="color:#38bdf8"><%= keyword %></strong></div></div>
    </div>

    <div class="card-container">
        <% if(list.size() > 0){
            for(CheatSheet c : list){
                double avgRating = 0;
                int ratingCount = 0;
                try {
                    avgRating = ratingRepo.getAverageRating(c.getId());
                    ratingCount = ratingRepo.getRatingCount(c.getId());
                } catch(Exception e) { e.printStackTrace(); }
                
                String safeExampleCode = "";
                if(c.getExampleCode() != null) {
                    safeExampleCode = c.getExampleCode()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r");
                }
                
                String coverClass = "cover-default";
                if(c.getCategory() != null) {
                    switch(c.getCategory()) {
                        case "Programming": coverClass = "cover-programming"; break;
                        case "Software": coverClass = "cover-software"; break;
                        case "Design": coverClass = "cover-design"; break;
                        case "Data Science": coverClass = "cover-data-science"; break;
                        case "Languages": coverClass = "cover-languages"; break;
                        case "Education": coverClass = "cover-education"; break;
                    }
                }
                int fullStars = (int) Math.round(avgRating);
        %>
            <div class="card">
                <div class="card-cover <%= coverClass %>">
                    <div class="card-cover-icon"><i class="fa-solid fa-file-code"></i></div>
                    <div class="card-badge"><i class="fa-solid fa-tag"></i> <%= c.getCategory() != null ? c.getCategory() : "General" %></div>
                </div>
                <div class="card-content">
                    <h3 class="card-title"><%= c.getTitle() %></h3>
                    <p class="card-description"><%= c.getContent().length() > 100 ? c.getContent().substring(0, 100) + "..." : c.getContent() %></p>
                    
                    <% if(c.getExampleCode() != null && !c.getExampleCode().isEmpty()) { %>
                        <div class="code-preview">
                            <div class="code-preview-label"><i class="fa-solid fa-code"></i> Example Code</div>
                            <div class="code-preview-text"><%= c.getExampleCode().length() > 70 ? c.getExampleCode().substring(0, 70) + "..." : c.getExampleCode() %></div>
                        </div>
                    <% } %>
                    
                    <div class="rating-row">
                        <div class="rating-stars">
                            <% for(int i = 1; i <= 5; i++) { %>
                                <% if(i <= fullStars) { %>
                                    <i class="fa-solid fa-star"></i>
                                <% } else { %>
                                    <i class="fa-regular fa-star"></i>
                                <% } %>
                            <% } %>
                        </div>
                        <span class="rating-value"><%= String.format("%.1f", avgRating) %></span>
                        <span class="rating-count">(<%= ratingCount %>)</span>
                    </div>
                    
                    <div class="comment-preview-card">
                        <i class="fa-solid fa-comment"></i> 
                        <span>Comments: <span id="commentCount-<%= c.getId() %>">0</span></span>
                    </div>
                    
                    <button class="btn-view" onclick='openModal(<%= c.getId() %>, "<%= c.getTitle().replace("\"", "\\\"") %>", "<%= safeExampleCode %>", "<%= c.getContent().replace("\"", "\\\"").replace("'", "\\'").replace("\n", "\\n") %>", "<%= c.getCategory() %>")'>
                        <i class="fa-solid fa-eye"></i> View Details
                    </button>
                </div>
            </div>
        <% } } else { %>
            <div class="empty"><i class="fa-regular fa-folder-open"></i><h3>No Cheat Sheets Found</h3><p>No cheat sheets found for "<%= keyword %>"</p></div>
        <% } %>
    </div>
</div>

<!-- Modal Popup with Rating & Comment -->
<div id="exampleModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa-solid fa-code"></i> <span id="modalTitle">CheatSheet Details</span></h3>
            <span class="close-modal" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div class="desc-box">
                <div style="color: #38bdf8; font-size: 13px; margin-bottom: 10px;"><i class="fa-solid fa-align-left"></i> Content</div>
                <p style="color: #cbd5e1; font-size: 14px; line-height: 1.6;" id="modalDescription"></p>
            </div>
            
            <div class="code-box">
                <div style="color: #22c55e; font-size: 13px; margin-bottom: 10px;"><i class="fa-solid fa-code"></i> Example Code</div>
                <pre id="modalContent">Loading...</pre>
            </div>
            
            <button class="copy-btn" onclick="copyCode()"><i class="fa-regular fa-copy"></i> Copy Code</button>
            
            <!-- RATING FORM with Font Awesome Stars -->
<div class="modal-rating-section">
    <div class="modal-rating-title">
        <i class="fa-solid fa-star" style="color: #facc15;"></i> Rate this Cheatsheet
    </div>
    <form action="rate" method="post" style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
        <input type="hidden" name="cheatsheetId" id="modalCheatsheetId" value="">
        <input type="hidden" name="category" id="modalCategory" value="">
        <select name="rating" required class="star-dropdown">
            <option value="5">&#xf005; &#xf005; &#xf005; &#xf005; &#xf005;</option>
            <option value="4">&#xf005; &#xf005; &#xf005; &#xf005; </option>
            <option value="3">&#xf005; &#xf005; &#xf005; </option>
            <option value="2">&#xf005; &#xf005; </option>
            <option value="1">&#xf005; </option>
        </select>
        <button type="submit" class="rating-submit-btn">Submit Rating</button>
    </form>
</div>
            
            <!-- COMMENT FORM -->
            <div class="modal-comment-section">
                <div class="modal-comment-title"><i class="fa-solid fa-comment"></i> Leave a Comment</div>
                <form action="CommentServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="cheatsheetId" id="modalCommentCheatsheetId" value="">
                    <input type="hidden" name="parentId" value="">
                    <input type="hidden" name="category" id="modalCommentCategory" value="">
                    <textarea name="content" rows="3" placeholder="Write your comment here..." required></textarea>
                    <button type="submit" class="comment-post-btn"><i class="fa-solid fa-paper-plane"></i> Post Comment</button>
                </form>
            </div>
            
            <!-- COMMENT LIST -->
            <div class="modal-comment-list-section">
                <h4><i class="fa-solid fa-comments"></i> Comments <span id="commentCountInModal">(0)</span></h4>
                <div id="commentListInModal">Loading comments...</div>
            </div>
        </div>
    </div>
</div>

<script>
    let currentCode = '';
    let currentCheatsheetId = '';
    let currentCategory = '';
    
    function openModal(id, title, content, description, category) {
        console.log("openModal called - ID: " + id);
        currentCheatsheetId = id;
        currentCategory = category;
        
        document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-code"></i> ' + title;
        document.getElementById('modalDescription').innerText = description || 'No description available';
        document.getElementById('modalContent').innerText = content || 'No example code available';
        document.getElementById('modalCheatsheetId').value = id;
        document.getElementById('modalCategory').value = category;
        
        var commentId = document.getElementById('modalCommentCheatsheetId');
        var commentCat = document.getElementById('modalCommentCategory');
        if(commentId) commentId.value = id;
        if(commentCat) commentCat.value = category;
        
        currentCode = content || '';
        document.getElementById('exampleModal').style.display = 'block';
        document.body.style.overflow = 'hidden';
        
        loadCommentsForModal(id);
    }
    
    function loadCommentsForModal(cheatsheetId) {
        fetch('CommentServlet?action=get&cheatsheetId=' + cheatsheetId)
            .then(response => response.json())
            .then(data => {
                var countSpan = document.getElementById('commentCountInModal');
                var listDiv = document.getElementById('commentListInModal');
                if(countSpan) countSpan.innerText = '(' + data.length + ')';
                if(listDiv) {
                    if(data.length === 0) {
                        listDiv.innerHTML = '<p style="color:#64748b; text-align:center; padding:20px;">No comments yet. Be the first!</p>';
                    } else {
                        var html = '';
                        for(var i = 0; i < data.length; i++) {
                            html += '<div style="background:#0f172a; padding:12px; border-radius:8px; margin-bottom:10px;">' +
                                        '<div style="display:flex; justify-content:space-between; margin-bottom:5px;">' +
                                            '<strong style="color:#38bdf8;">' + (data[i].userName || 'User') + '</strong>' +
                                            '<small style="color:#64748b;">' + (data[i].createdAt || '') + '</small>' +
                                        '</div>' +
                                        '<p style="color:#cbd5e1; margin:0;">' + (data[i].content || '') + '</p>' +
                                    '</div>';
                        }
                        listDiv.innerHTML = html;
                    }
                }
            })
            .catch(error => console.error('Error loading comments:', error));
    }
    
    function loadCommentCounts() {
        <% for(CheatSheet c : list) { %>
        fetch('CommentServlet?action=get&cheatsheetId=<%= c.getId() %>')
            .then(response => response.json())
            .then(data => {
                var span = document.getElementById('commentCount-<%= c.getId() %>');
                if(span) span.innerText = data.length;
            })
            .catch(error => console.error('Error:', error));
        <% } %>
    }
    
    function closeModal() {
        document.getElementById('exampleModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    
    function copyCode() {
        if(!currentCode) { alert("No code to copy!"); return; }
        navigator.clipboard.writeText(currentCode).then(() => {
            const btn = document.querySelector('.copy-btn');
            const original = btn.innerHTML;
            btn.innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
            setTimeout(() => btn.innerHTML = original, 2000);
        });
    }
    
    document.addEventListener('DOMContentLoaded', function() { 
        loadCommentCounts(); 
        console.log("Search page loaded - " + <%= list.size() %> + " cards");
    });
    
    window.onclick = function(e) { 
        const modal = document.getElementById('exampleModal'); 
        if (e.target == modal) closeModal(); 
    }
</script>

</body>
</html>