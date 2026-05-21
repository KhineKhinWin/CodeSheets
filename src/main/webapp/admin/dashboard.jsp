<%@ page import="com.cheatsheet.model.User" %>

<%
    // loginUser လို့ ပြောင်းယူပါ
    User user = (User) session.getAttribute("loginUser");
    
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Role စစ်တဲ့နေရာမှာလည်း logic မှန်ပါစေ
    if(!"admin".equalsIgnoreCase(user.getRole())){
        response.sendRedirect("home.jsp");
        return;
    }

    Object usersObj = request.getAttribute("totalUsers");
    Object sheetsObj = request.getAttribute("totalSheets");
    Object commentsObj = request.getAttribute("totalComments");
    Object likesObj = request.getAttribute("totalLikes");
    Object ratingsObj = request.getAttribute("totalRatings");

    int totalUsers = usersObj == null ? 0 : (Integer) usersObj;
    int totalSheets = sheetsObj == null ? 0 : (Integer) sheetsObj;
    int totalComments = commentsObj == null ? 0 : (Integer) commentsObj;
    int totalLikes = likesObj == null ? 0 : (Integer) likesObj;
    int totalRatings = ratingsObj == null ? 0 : (Integer) ratingsObj;
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(to right, #0f172a, #1e293b);
            display: flex;
            min-height: 100vh;
        }

        /* ================= SIDEBAR ================= */
        .sidebar {
            width: 260px;
            background: #020617;
            border-right: 2px solid #22d3ee;
            position: fixed;
            height: 100vh;
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
        }

        .sidebar-logo {
            color: #22d3ee;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 50px;
            text-align: center;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .sidebar-nav a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 18px;
            padding: 12px 20px;
            border-radius: 10px;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .sidebar-nav a:hover, .sidebar-nav a.active {
            background: rgba(34, 211, 238, 0.1);
            color: #22d3ee;
        }

        .logout-link {
            margin-top: auto;
            color: #ef4444 !important;
        }

        /* ================= MAIN CONTENT AREA ================= */
        .main-content {
            margin-left: 260px;
            width: calc(100% - 260px);
            padding: 40px;
        }

        .title h1 {
            font-size: 36px;
            color: white;
            margin-bottom: 30px;
        }

        /* ================= DASHBOARD GRID ================= */
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .card {
            background: linear-gradient(145deg, #1e293b, #0f172a);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            transition: 0.3s;
            text-align: center;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h2 {
            margin-bottom: 10px;
            font-size: 20px;
        }

        .card p {
            font-size: 40px;
            font-weight: bold;
        }

        /* ================= CARD COLORS ================= */
        
        /* Total Users Card - Blue */
        .card-users {
            border-left: 5px solid #ec4899;
        }
        .card-users h2 {
            color: #f472b6;
        }
        .card-users p {
            color: #ec4899;
        }
        
        /* Total Cheatsheets Card - Green */
        .card-sheets {
            border-left: 5px solid #22c55e;
        }
        .card-sheets h2 {
            color: #4ade80;
        }
        .card-sheets p {
            color: #22c55e;
        }
        
        /* Total Comments Card - Purple */
        .card-comments {
            border-left: 5px solid #a855f7;
        }
        .card-comments h2 {
            color: #c084fc;
        }
        .card-comments p {
            color: #a855f7;
        }
        
        /* Total Ratings Card - Yellow/Gold */
        .card-ratings {
            border-left: 5px solid #facc15;
        }
        .card-ratings h2 {
            color: #fde047;
        }
        .card-ratings p {
            color: #facc15;
        }

        /* ================= ACTION BUTTONS ================= */
        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 20px;
        }

        .actions a {
            background: #22d3ee;
            color: #0f172a;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .actions a:hover {
            background: #06b6d4;
            transform: scale(1.05);
        }
        
        /* ✅ Fix for sidebar items - ensure they don't wrap */
        .sidebar-nav a {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        /* ✅ Responsive: if screen is too small */
        @media (max-width: 768px) {
            .sidebar {
                width: 220px;
                padding: 20px 15px;
            }
            .sidebar-nav a {
                font-size: 14px;
                padding: 10px 15px;
            }
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
                padding: 20px;
            }
        }
        
        @media (max-width: 576px) {
            .sidebar {
                width: 70px;
                padding: 20px 10px;
            }
            .sidebar-logo {
                font-size: 12px;
            }
            .sidebar-nav a span {
                display: none;
            }
            .sidebar-nav a i {
                margin: 0 auto;
            }
            .main-content {
                margin-left: 70px;
                width: calc(100% - 70px);
            }
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-logo">
            CheatSheet Admin
        </div>
        
        <div class="sidebar-nav">
            <a href="adminDashboard" class="active">
                <i class="fa-solid fa-house"></i> 
                <span>Home</span>
            </a>
            <a href="allCheatSheets">
                <i class="fa-solid fa-code"></i> 
                <span>CheatSheets</span>
            </a>
            <a href="createSheet">
                <i class="fa-solid fa-plus"></i> 
                <span>Create</span>
            </a>
            <a href="manageUsers">
                <i class="fa-solid fa-users"></i> 
                <span>Manage Users</span>
            </a>
            <a href="manageSheets">
                <i class="fa-solid fa-book"></i> 
                <span>Manage Sheets</span>
            </a>
            <a href="manageComments">
                <i class="fa-solid fa-comments"></i> 
                <span>Manage Comment</span>
            </a>
            <a href="logout" class="logout-link">
                <i class="fa-solid fa-right-from-bracket"></i> 
                <span>Logout</span>
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="title">
            <h1>Admin Dashboard</h1>
        </div>

        <div class="dashboard">
            <!-- Total Users Card -->
            <div class="card card-users">
                <h2><i class="fa-solid fa-users"></i> Total Users</h2>
                <p><%= totalUsers %></p>
            </div>
            
            <!-- Total Cheatsheets Card -->
            <div class="card card-sheets">
                <h2><i class="fa-solid fa-file-alt"></i> Total CheatSheets</h2>
                <p><%= totalSheets %></p>
            </div>
            
            <!-- Total Comments Card -->
            <div class="card card-comments">
                <h2><i class="fa-solid fa-comment"></i> Total Comments</h2>
                <p><%= totalComments %></p>
            </div>
            
            <!-- Total Ratings Card -->
            <div class="card card-ratings">
                <h2><i class="fa-solid fa-star"></i> Total Ratings</h2>
                <p><%= totalRatings %></p>
            </div>
        </div>
        
    </div>

</body>
</html>