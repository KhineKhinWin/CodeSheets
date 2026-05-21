<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="java.util.*" %>
<%
String cat = request.getParameter("name");
if(cat == null) cat = "";
cat = cat.trim();
%>
<%
    // Session Check
    User user = (User) session.getAttribute("loginUser");

    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Total Sheets
    Object sheetsAttr = request.getAttribute("totalSheets");
    String totalSheets = (sheetsAttr != null) ? sheetsAttr.toString() : "0";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home | CheatSheets</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        *{ margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body{ background: white; }
        
        /* HEADER */
        .header{ background: #1e293b; padding: 15px 10%; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #334155; position: sticky; top: 0; z-index: 100; }
        .logo{ font-size: 28px; font-weight: bold; color: white; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .logo span{ color: #38bdf8; }
        
        /* SEARCH BAR */
        .search-bar{ flex: 1; display: flex; justify-content: center; margin-left: -180px; }
        .search-bar input{ width: 450px; padding: 10px 18px; border: 1px solid #334155; outline: none; background: #0f172a; color: white; border-radius: 50px 0 0 50px; font-size: 14px; transition: 0.3s; }
        .search-bar input:focus{ border-color: #38bdf8; box-shadow: 0 0 8px rgba(56,189,248,0.3); }
        .search-bar button{ padding: 10px 18px; border: none; background: #38bdf8; color: #0f172a; border-radius: 0 50px 50px 0; cursor: pointer; font-weight: bold; transition: 0.3s; }
        .search-bar button:hover{ background: #0ea5e9; }
        
        /* NAVBAR */
        .sub-nav{ background: #0f172a; padding: 0 10%; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #1e293b; }
        .nav-links{ display: flex; align-items: center; }
        .nav-links a{ color: #94a3b8; text-decoration: none; padding: 12px 18px; display: flex; align-items: center; gap: 6px; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .nav-links a:hover, .nav-links a.active{ color: #38bdf8; }
        
        /* USER PROFILE DROPDOWN */
        .user-dropdown { position: relative; display: inline-block; }
        .user-btn { display: flex; align-items: center; gap: 10px; background: #1e293b; padding: 8px 16px; border-radius: 40px; cursor: pointer; transition: 0.3s; border: 1px solid #334155; }
        .user-btn:hover { background: #334155; border-color: #38bdf8; }
        .user-avatar { width: 32px; height: 32px; background: linear-gradient(135deg, #38bdf8, #0ea5e9); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; }
        .user-name { color: white; font-weight: 500; }
        .user-dropdown-content { display: none; position: absolute; right: 0; top: 55px; width: 280px; background: white; border-radius: 16px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); overflow: hidden; z-index: 999; border: 1px solid #e2e8f0; }
        .user-dropdown:hover .user-dropdown-content { display: block; }
        .user-dropdown-header { padding: 20px; background: linear-gradient(135deg, #0f172a, #1e293b); color: white; text-align: center; border-bottom: 1px solid #334155; }
        .user-dropdown-avatar { width: 60px; height: 60px; background: linear-gradient(135deg, #38bdf8, #0ea5e9); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 10px; color: white; }
        .user-dropdown-header h4 { margin-bottom: 5px; }
        .user-dropdown-header p { font-size: 12px; color: #94a3b8; }
        .user-dropdown-item { padding: 12px 20px; display: flex; align-items: center; gap: 12px; color: #1e293b; text-decoration: none; transition: 0.3s; border-bottom: 1px solid #f1f5f9; }
        .user-dropdown-item:hover { background: #e0f2fe; color: #0284c7; }
        .user-dropdown-item i { width: 20px; color: #38bdf8; }
        .logout-item { color: #ef4444; }
        .logout-item i { color: #ef4444; }
        .logout-item:hover { background: #fef2f2; color: #dc2626; }

        /* DROPDOWN */
        .dropdown{ position: relative; }
        .dropdown-content{ display: none; position: absolute; top: 100%; left: 0; width: 240px; background: #1e293b; border-radius: 10px; overflow: hidden; z-index: 999; border: 1px solid #334155; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
        .dropdown-content a { padding: 10px 16px; border-bottom: 1px solid #334155; color: #cbd5e1; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.3s; }
        .dropdown-content a:hover { background: #0f172a; color: #38bdf8; }
        .dropdown:hover .dropdown-content { display: block; }

        .right-section { display: flex; align-items: center; gap: 20px; }

        /* CONTAINER & GRID */
        .container{ max-width: 1200px; margin: 30px auto; padding: 0 20px; text-align: center; }
        
        /* Welcome Message */
        .welcome-msg { background: linear-gradient(135deg, #1e293b, #0f172a); padding: 20px 25px; border-radius: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; border: 1px solid #334155; }
        .welcome-text { display: flex; align-items: center; gap: 12px; }
        .welcome-text i { font-size: 32px; color: #38bdf8; }
        .welcome-text h2 { color: white; font-size: 22px; }
        .welcome-text p { color: #94a3b8; margin-top: 5px; }
        .total-badge { background: #38bdf8; color: #0f172a; padding: 8px 18px; border-radius: 30px; font-size: 14px; font-weight: bold; }

        /* ========== DRIBBBLE STYLE CARD GRID ========== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            margin-top: 30px;
        }

        /* Tablet */
        @media (max-width: 1000px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        /* Mobile */
        @media (max-width: 650px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .container {
                padding: 0 15px;
            }
            .welcome-text h2 {
                font-size: 18px;
            }
        }

        /* ========== DRIBBBLE STYLE CARD ========== */
        .card {
            background: #ffffff;
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.35s cubic-bezier(0.2, 0.9, 0.4, 1.1);
            text-decoration: none;
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

        /* Card Cover */
        .card-cover {
            height: 160px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Category specific cover colors */
        .cover-programming { background: linear-gradient(135deg, #667eea, #764ba2); }
        .cover-software { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .cover-design { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .cover-data-science { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .cover-languages { background: linear-gradient(135deg, #fa709a, #fee140); }
        .cover-education { background: linear-gradient(135deg, #a18cd1, #fbc2eb); }

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

        /* Card Content */
        .card-content {
            padding: 20px;
            background: white;
            text-align: left;
        }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .card-description {
            color: #64748b;
            font-size: 13px;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        /* View More Link */
        .view-more {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #38bdf8;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
        }

        .view-more:hover {
            gap: 12px;
            color: #0ea5e9;
        }

        /* Empty State */
        .empty {
            text-align: center;
            padding: 60px 20px;
            background: #1e293b;
            border-radius: 20px;
            border: 1px solid #334155;
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
    </style>
</head>

<body>

<header class="header">
    <a href="home.jsp" class="logo">
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
        <a href="home.jsp" class="<%= (cat.equals("") ? "active" : "") %>"><i class="fa-solid fa-house"></i> Home</a>
		
        <div class="dropdown">
            <a href="categories"><i class="fa-solid fa-book"></i> Cheat Sheets</a>
            <div class="dropdown-content">
                <a href="category?name=Programming"><i class="fa-solid fa-code"></i> Programming</a>
                <a href="category?name=Software"><i class="fa-solid fa-laptop-code"></i> Software</a>
                <a href="category?name=Design"><i class="fa-solid fa-pen-ruler"></i> Design</a>
                <a href="category?name=Data Science"><i class="fa-solid fa-chart-line"></i> Data Science</a>
                <a href="category?name=Languages"><i class="fa-solid fa-language"></i> Languages</a>
                <a href="category?name=Education"><i class="fa-solid fa-graduation-cap"></i> Education</a>
            </div>
        </div>

        <div class="dropdown">
            <a href="create_cheat"><i class="fa-solid fa-pen-to-square"></i> Create</a>
            <div class="dropdown-content">
                <a href="create_cheat"><i class="fa-solid fa-file-pen"></i> Create Cheatsheet</a>
            </div>
        </div>

        <a href="myCheats"><i class="fa-solid fa-user"></i> My Cheats</a>
        
        <a href="help.jsp"><i class="fa-solid fa-circle-question"></i> Help</a>
    </div>

    <div class="right-section">
        <a href="logout" class="user-dropdown-item logout-item">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </a>
        </div>
    </div>
</nav>

<div class="container">
    
    <!-- Welcome Message -->
    <div class="welcome-msg">
        <div class="welcome-text">
            <i class="fa-regular fa-hand-peace"></i>
            <div>
                <h2>Welcome back, <%= user.getUsername() %>!</h2>
                <p>Ready to learn something new today?</p>
            </div>
        </div>
    </div>

    <!-- Dribbble Style Category Cards -->
    <div class="stats-grid">
        <a href="category?name=Programming" class="card">
            <div class="card-cover cover-programming">
                <div class="card-cover-icon">
                    <i class="fa-solid fa-code"></i>
                </div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Programming</h3>
                <p class="card-description">Learn programming languages, frameworks, and coding best practices.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Software" class="card">
            <div class="card-cover cover-software">
                <div class="card-cover-icon">
                    <i class="fa-solid fa-laptop-code"></i>
                </div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Software</h3>
                <p class="card-description">Software development tools, version control, and best practices.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Design" class="card">
            <div class="card-cover cover-design">
                <div class="card-cover-icon">
                    <i class="fa-solid fa-pen-ruler"></i>
                </div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Design</h3>
                <p class="card-description">UI/UX design principles, color theory, and design tools.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Data Science" class="card">
            <div class="card-cover cover-data-science">
                <div class="card-cover-icon">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Data Science</h3>
                <p class="card-description">Data analysis, machine learning, and data visualization techniques.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Languages" class="card">
            <div class="card-cover cover-languages">
                <div class="card-cover-icon">
                    <i class="fa-solid fa-language"></i>
                </div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Languages</h3>
                <p class="card-description">Foreign languages, grammar, vocabulary, and learning resources.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Education" class="card">
            <div class="card-cover cover-education">
                <div class="card-cover-icon">
                    <i class="fa-solid fa-graduation-cap"></i>
                </div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Education</h3>
                <p class="card-description">Study tips, academic resources, and effective learning strategies.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>
    </div>
</div>

<!-- ================= FOOTER ================= -->
<%@ include file="footer.jsp" %>

</body>
</html>