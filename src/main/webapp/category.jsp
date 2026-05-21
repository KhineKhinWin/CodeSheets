<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.model.User" %>

<%
    String type = (request.getAttribute("type") != null) ? (String) request.getAttribute("type") : "All";
    List<CheatSheet> list = (List<CheatSheet>) request.getAttribute("list");
    if(list == null){
        list = new ArrayList<>();
    }
    
    User loginUser = (User) session.getAttribute("loginUser");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= type %> Cheat Sheets | CheatSheets</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

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

    /* HEADER */
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

    .logo span {
        color: #38bdf8;
    }

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
        transition: 0.3s;
    }

    .search-bar input:focus {
        border-color: #38bdf8;
        box-shadow: 0 0 8px rgba(56, 189, 248, 0.3);
    }

    .search-bar button {
        padding: 10px 18px;
        border: none;
        background: #38bdf8;
        color: #0f172a;
        border-radius: 0 50px 50px 0;
        cursor: pointer;
        font-weight: bold;
        transition: 0.3s;
    }

    .search-bar button:hover {
        background: #0ea5e9;
    }

    /* NAVBAR */
    .sub-nav {
        background: #0f172a;
        padding: 0 10%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #1e293b;
    }

    .nav-links {
        display: flex;
        align-items: center;
    }

    .nav-links a {
        color: #94a3b8;
        text-decoration: none;
        padding: 12px 18px;
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        font-weight: 500;
        transition: 0.3s;
    }

    .nav-links a:hover,
    .nav-links a.active {
        color: #38bdf8;
    }

    .logout a {
        color: #ef4444;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        font-weight: 500;
        transition: 0.3s;
    }

    .logout a:hover {
        color: #dc2626;
    }

    /* DROPDOWN */
    .dropdown {
        position: relative;
    }

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
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
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
        transition: 0.3s;
    }

    .dropdown-content a:hover {
        background: #0f172a;
        color: #38bdf8;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }

    /* TABS */
    .tabs {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 10px;
        margin: 25px 10% 20px 10%;
    }

    .tabs a {
        text-decoration: none;
        padding: 8px 18px;
        border-radius: 30px;
        background: #1e293b;
        color: #94a3b8;
        border: 1px solid #334155;
        transition: 0.3s;
        font-size: 12px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .tabs a:hover,
    .tabs a.active {
        background: #38bdf8;
        color: #0f172a;
        border-color: #38bdf8;
        transform: translateY(-2px);
    }

    /* MAIN CONTENT */
    .main-content {
        padding: 20px 10% 50px 10%;
    }

    .page-title {
        text-align: center;
        font-size: 28px;
        margin-bottom: 20px;
        color: #38bdf8;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    /* STATS BAR */
    .stats-bar {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 12px 20px;
        margin-bottom: 25px;
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

    .stats-count i {
        font-size: 18px;
        color: #38bdf8;
    }

    .stats-count span {
        font-size: 20px;
        font-weight: bold;
        color: #38bdf8;
        margin-right: 3px;
    }

    /* ========== DRIBBBLE STYLE CARD GRID ========== */
    .card-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 25px;
        align-items: stretch;
    }

    /* Tablet */
    @media (max-width: 1000px) {
        .card-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    /* Mobile */
    @media (max-width: 650px) {
        .card-grid {
            grid-template-columns: 1fr;
        }
        .main-content {
            padding: 20px 5% 40px 5%;
        }
        .tabs {
            margin: 20px 5%;
        }
        .search-bar input {
            width: 200px;
        }
    }

    /* ========== DRIBBBLE STYLE CARD DESIGN ========== */
    .card {
        background: #ffffff;
        border-radius: 24px;
        overflow: hidden;
        transition: all 0.35s cubic-bezier(0.2, 0.9, 0.4, 1.1);
        border: none;
        display: flex;
        flex-direction: column;
        position: relative;
        box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.15);
        cursor: pointer;
    }

    .card:hover {
        transform: translateY(-8px);
        box-shadow: 0 25px 40px -12px rgba(0, 0, 0, 0.25);
    }

    /* Card Image Cover */
    .card-cover {
        height: 160px;
        background-size: cover;
        background-position: center;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    /* Category specific cover colors */
    .card-cover.programming { background: linear-gradient(135deg, #667eea, #764ba2); }
    .card-cover.software { background: linear-gradient(135deg, #f093fb, #f5576c); }
    .card-cover.design { background: linear-gradient(135deg, #4facfe, #00f2fe); }
    .card-cover.data-science { background: linear-gradient(135deg, #43e97b, #38f9d7); }
    .card-cover.languages { background: linear-gradient(135deg, #fa709a, #fee140); }
    .card-cover.education { background: linear-gradient(135deg, #a18cd1, #fbc2eb); }
    .card-cover.default { background: linear-gradient(135deg, #38bdf8, #0ea5e9); }

    .card-cover-icon {
        width: 70px;
        height: 70px;
        background: rgba(255, 255, 255, 0.25);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32px;
        color: white;
        backdrop-filter: blur(8px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    /* Category Badge */
    .card-badge {
        position: absolute;
        top: 15px;
        right: 15px;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(5px);
        color: #facc15;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 600;
        z-index: 2;
        letter-spacing: 0.5px;
    }

    /* Card Content */
    .card-content {
        padding: 20px;
        flex: 1;
        background: white;
    }

    .card-title {
        font-size: 18px;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 10px;
        line-height: 1.3;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        min-height: 46px;
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

    /* Code Preview */
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
        font-family: 'Courier New', monospace;
        font-size: 11px;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    /* Rating Row */
    .rating-row {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 15px;
        flex-wrap: wrap;
    }

    .rating-stars {
        display: inline-flex;
        gap: 3px;
    }

    .rating-stars i {
        font-size: 12px;
    }

    .rating-stars i.fa-solid.fa-star {
        color: #facc15;
    }

    .rating-stars i.fa-regular.fa-star {
        color: #cbd5e1;
    }

    .rating-value {
        font-size: 13px;
        font-weight: 600;
        color: #facc15;
    }

    .rating-count {
        font-size: 11px;
        color: #94a3b8;
    }

    /* View Button */
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
        transition: all 0.3s ease;
    }

    .btn-view:hover {
        background: #38bdf8;
        color: #0f172a;
        transform: translateY(-2px);
    }

    /* Empty State */
    .empty {
        text-align: center;
        padding: 60px 20px;
        background: #1e293b;
        border-radius: 20px;
        border: 1px solid #334155;
        grid-column: 1 / -1;
    }

    .empty i {
        font-size: 64px;
        color: #475569;
        margin-bottom: 20px;
    }

    .empty h3 {
        color: #94a3b8;
        margin-bottom: 10px;
        font-size: 20px;
    }

    .empty p {
        color: #64748b;
        font-size: 14px;
    }

    /* MODAL */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.85);
        backdrop-filter: blur(5px);
    }

    .modal-content {
        background: #1e293b;
        margin: 5% auto;
        padding: 0;
        width: 550px;
        max-width: 90%;
        border-radius: 20px;
        border: 1px solid rgba(56, 189, 248, 0.3);
        animation: modalFadeIn 0.3s ease;
        max-height: 85vh;
        overflow-y: auto;
    }

    @keyframes modalFadeIn {
        from {
            opacity: 0;
            transform: scale(0.95);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
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
        z-index: 10;
    }

    .modal-header h3 {
        color: #38bdf8;
        font-size: 1.2rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .close-modal {
        color: #94a3b8;
        font-size: 26px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }

    .close-modal:hover {
        color: #ef4444;
    }

    .modal-body {
        padding: 22px;
    }

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

    .code-block {
        background: transparent;
        padding: 0;
        margin: 0;
    }

    .code-block pre {
        color: #86efac;
        font-family: 'Courier New', monospace;
        font-size: 13px;
        line-height: 1.5;
        margin: 0;
        white-space: pre-wrap;
    }

    .copy-btn {
        background: #38bdf8;
        color: #0f172a;
        border: none;
        padding: 10px 20px;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        font-size: 13px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: 0.3s;
    }

    .copy-btn:hover {
        background: #0ea5e9;
        transform: translateY(-2px);
    }

    /* Scrollbar */
    ::-webkit-scrollbar {
        width: 5px;
    }

    ::-webkit-scrollbar-track {
        background: #0f172a;
        border-radius: 10px;
    }

    ::-webkit-scrollbar-thumb {
        background: #38bdf8;
        border-radius: 10px;
    }
</style>

<script>
    function getCoverClass(category) {
        switch(category) {
            case 'Programming': return 'programming';
            case 'Software': return 'software';
            case 'Design': return 'design';
            case 'Data Science': return 'data-science';
            case 'Languages': return 'languages';
            case 'Education': return 'education';
            default: return 'default';
        }
    }
</script>

</head>

<body>

<header class="header">
    <a href="homepage" class="logo">
        <i class="fa-solid fa-code"></i>
        Cheat<span>Sheets</span>
    </a>
    <form action="searchCheatsheet" method="get" class="search-bar">
        <input type="text" name="keyword" placeholder="Search cheat sheets...">
        <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
    </form>
</header>

<nav class="sub-nav">
    <div class="nav-links">
        <a href="homepage"><i class="fa-solid fa-house"></i> Home</a>
        <div class="dropdown">
            <a href="#" class="active"><i class="fa-solid fa-book"></i> Cheat Sheets</a>
            <div class="dropdown-content">
                <a href="userAllCheat?name=Programming"><i class="fa-solid fa-code"></i> Programming</a>
                <a href="userAllCheat?name=Software"><i class="fa-solid fa-laptop-code"></i> Software</a>
                <a href="userAllCheat?name=Design"><i class="fa-solid fa-pen-ruler"></i> Design</a>
                <a href="userAllCheat?name=Data Science"><i class="fa-solid fa-chart-line"></i> Data Science</a>
                <a href="userAllCheat?name=Languages"><i class="fa-solid fa-language"></i> Languages</a>
                <a href="userAllCheat?name=Education"><i class="fa-solid fa-graduation-cap"></i> Education</a>
            </div>
        </div>
        <a href="create_cheat"><i class="fa-solid fa-pen-to-square"></i> Create</a>
        <a href="myCheats"><i class="fa-solid fa-user"></i> My Cheats</a>
        <a href="help.jsp"><i class="fa-solid fa-circle-question"></i> Help</a>
    </div>
    <div class="logout">
        <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
</nav>

<div class="tabs">
    <a href="category?name=Programming" class="<%= type.equals("Programming") ? "active" : "" %>"><i class="fa-solid fa-code"></i> Programming</a>
    <a href="category?name=Software" class="<%= type.equals("Software") ? "active" : "" %>"><i class="fa-solid fa-laptop-code"></i> Software</a>
    <a href="category?name=Design" class="<%= type.equals("Design") ? "active" : "" %>"><i class="fa-solid fa-pen-ruler"></i> Design</a>
    <a href="category?name=Data Science" class="<%= type.equals("Data Science") ? "active" : "" %>"><i class="fa-solid fa-chart-line"></i> Data Science</a>
    <a href="category?name=Languages" class="<%= type.equals("Languages") ? "active" : "" %>"><i class="fa-solid fa-language"></i> Languages</a>
    <a href="category?name=Education" class="<%= type.equals("Education") ? "active" : "" %>"><i class="fa-solid fa-graduation-cap"></i> Education</a>
</div>

<div class="main-content">
    <h1 class="page-title">
        <i class="fa-solid fa-layer-group"></i> <%= type %> Cheat Sheets
    </h1>

    <div class="stats-bar">
        <div class="stats-count">
            <i class="fa-solid fa-book-open"></i>
            <div><span><%= list.size() %></span> Cheat Sheets Found</div>
        </div>
        <div class="stats-count">
            <i class="fa-solid fa-tag"></i>
            <div>Category: <strong style="color:#38bdf8"><%= type %></strong></div>
        </div>
    </div>

    <div class="card-grid">
        <% if(list != null && !list.isEmpty()) { 
            for(CheatSheet c : list){ 
                String coverClass = "default";
                if(c.getCategory() != null) {
                    switch(c.getCategory()) {
                        case "Programming": coverClass = "programming"; break;
                        case "Software": coverClass = "software"; break;
                        case "Design": coverClass = "design"; break;
                        case "Data Science": coverClass = "data-science"; break;
                        case "Languages": coverClass = "languages"; break;
                        case "Education": coverClass = "education"; break;
                        default: coverClass = "default";
                    }
                }
        %>
            <div class="card" onclick='viewDetails("<%= c.getId() %>", "<%= c.getTitle().replace("\"", "\\\"") %>", "<%= c.getContent().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") %>", "<%= c.getExampleCode() != null ? c.getExampleCode().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") : "" %>", "<%= c.getCategory() != null ? c.getCategory() : "General" %>")'>
                <div class="card-cover <%= coverClass %>">
                    <div class="card-cover-icon">
                        <i class="fa-solid fa-file-code"></i>
                    </div>
                    <div class="card-badge">
                        <i class="fa-solid fa-tag"></i> <%= c.getCategory() != null ? c.getCategory() : "General" %>
                    </div>
                </div>
                
                <div class="card-content">
                    <h3 class="card-title"><%= c.getTitle() %></h3>
                    <p class="card-description">
                        <%= c.getContent().length() > 100 ? c.getContent().substring(0, 100) + "..." : c.getContent() %>
                    </p>
                    
                    <% if(c.getExampleCode() != null && !c.getExampleCode().isEmpty()) { %>
                        <div class="code-preview">
                            <div class="code-preview-label">
                                <i class="fa-solid fa-code"></i> Example Code
                            </div>
                            <div class="code-preview-text">
                                <%= c.getExampleCode().length() > 70 ? c.getExampleCode().substring(0, 70) + "..." : c.getExampleCode() %>
                            </div>
                        </div>
                    <% } %>
                    
                    <div class="rating-row">
                        <div class="rating-stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-regular fa-star"></i>
                        </div>
                        <span class="rating-value">4.0</span>
                        <span class="rating-count">(0 ratings)</span>
                    </div>
                    
                    <button class="btn-view" onclick="event.stopPropagation(); viewDetails('<%= c.getId() %>', '<%= c.getTitle().replace("\"", "\\\"") %>', '<%= c.getContent().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") %>', '<%= c.getExampleCode() != null ? c.getExampleCode().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") : "" %>', '<%= c.getCategory() != null ? c.getCategory() : "General" %>')">
                        <i class="fa-solid fa-eye"></i> View Details
                    </button>
                </div>
            </div>
        <% } 
        } else { %>
            <div class="empty">
                <i class="fa-regular fa-folder-open"></i>
                <h3>No Cheat Sheets Found</h3>
                <p>There are no cheat sheets in the "<%= type %>" category yet.</p>
            </div>
        <% } %>
    </div>
</div>

<div id="exampleModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa-solid fa-code"></i> <span id="modalTitle">CheatSheet Details</span></h3>
            <span class="close-modal" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div class="desc-box">
                <div style="color: #38bdf8; font-size: 13px; margin-bottom: 10px;">
                    <i class="fa-solid fa-align-left"></i> Description
                </div>
                <p style="color: #cbd5e1; font-size: 14px; line-height: 1.6;" id="modalDescription"></p>
            </div>
            
            <div class="code-box">
                <div style="color: #22c55e; font-size: 13px; margin-bottom: 10px;">
                    <i class="fa-solid fa-code"></i> Example Code
                </div>
                <div class="code-block">
                    <pre id="modalContent">Loading...</pre>
                </div>
            </div>
            
            <button class="copy-btn" onclick="copyCode()">
                <i class="fa-regular fa-copy"></i> Copy Code
            </button>
        </div>
    </div>
</div>

<script>
    let currentCode = '';
    
    function viewDetails(id, title, description, exampleCode, category) {
        event.stopPropagation();
        document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-code"></i> ' + title;
        document.getElementById('modalDescription').innerText = description || 'No description available';
        document.getElementById('modalContent').innerText = exampleCode || 'No example code available';
        currentCode = exampleCode || '';
        
        document.getElementById('exampleModal').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }
    
    function closeModal() {
        document.getElementById('exampleModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    
    function copyCode() {
        if(!currentCode) {
            alert("No code to copy!");
            return;
        }
        navigator.clipboard.writeText(currentCode).then(() => {
            const btn = document.querySelector('.copy-btn');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
            setTimeout(() => {
                btn.innerHTML = originalText;
            }, 2000);
        });
    }
    
    window.onclick = function(event) {
        const modal = document.getElementById('exampleModal');
        if (event.target == modal) closeModal();
    }
</script>

</body>
</html>