<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="java.util.*" %>
<%
String cat = request.getParameter("name");
if(cat == null) cat = "";
cat = cat.trim();
%>
<%
    // Session Check - အသုံးပြုသူ Login ဝင်ထားသလား စစ်ဆေးခြင်း (နှင်မထုတ်တော့ပါ)
    User user = (User) session.getAttribute("loginUser");

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
        
        /* LOGIN / REGISTER BUTTONS STYLE */
        .auth-buttons { display: flex; align-items: center; gap: 12px; }
        .btn-login { color: #cbd5e1; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; padding: 8px 16px; }
        .btn-login:hover { color: #38bdf8; }
        .btn-register { background: #38bdf8; color: #0f172a; text-decoration: none; padding: 8px 20px; border-radius: 50px; font-size: 14px; font-weight: 600; transition: 0.3s; }
        .btn-register:hover { background: #0ea5e9; }

        /* USER LOGGED IN STYLE */
        .user-welcome-info { color: #38bdf8; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 8px; }

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
        .welcome-text { display: flex; align-items: center; gap: 12px; text-align: left; }
        .welcome-text i { font-size: 32px; color: #38bdf8; }
        .welcome-text h2 { color: white; font-size: 22px; }
        .welcome-text p { color: #94a3b8; margin-top: 5px; }

        /* ========== DRIBBBLE STYLE CARD GRID ========== */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-top: 30px; }
        @media (max-width: 1000px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 650px) { .stats-grid { grid-template-columns: 1fr; } .container { padding: 0 15px; } .welcome-text h2 { font-size: 18px; } }

        /* ========== DRIBBBLE STYLE CARD ========== */
        .card { background: #ffffff; border-radius: 24px; overflow: hidden; transition: all 0.35s cubic-bezier(0.2, 0.9, 0.4, 1.1); text-decoration: none; display: flex; flex-direction: column; position: relative; box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.15); cursor: pointer; }
        .card:hover { transform: translateY(-8px); box-shadow: 0 25px 40px -12px rgba(0, 0, 0, 0.25); }
        .card-cover { height: 160px; position: relative; display: flex; align-items: center; justify-content: center; }

        /* Category specific cover colors */
        .cover-programming { background: linear-gradient(135deg, #667eea, #764ba2); }
        .cover-software { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .cover-design { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .cover-data-science { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .cover-languages { background: linear-gradient(135deg, #fa709a, #fee140); }
        .cover-education { background: linear-gradient(135deg, #a18cd1, #fbc2eb); }

        .card-cover-icon { width: 70px; height: 70px; background: rgba(255, 255, 255, 0.25); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; color: white; backdrop-filter: blur(8px); box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); }
        .card-content { padding: 20px; background: white; text-align: left; }
        .card-title { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .card-description { color: #64748b; font-size: 13px; line-height: 1.5; margin-bottom: 15px; }
        .view-more { display: inline-flex; align-items: center; gap: 8px; color: #38bdf8; font-size: 13px; font-weight: 600; text-decoration: none; transition: 0.3s; }
        .view-more:hover { gap: 12px; color: #0ea5e9; }
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
        <% 
            // User က Login ဝင်ထားပြီးသားဆိုရင် သူ့နာမည်ပြမယ်၊ မဝင်ရသေးရင် Login/Register ပြမယ်
            if(user != null) { 
        %>
            <div class="user-welcome-info">
                <i class="fa-solid fa-circle-user"></i> <%= user.getUsername() %>
            </div>
        <% } else { %>
            <div class="auth-buttons">
                <a href="login.jsp" class="btn-login"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
                <a href="register.jsp" class="btn-register"><i class="fa-solid fa-user-plus"></i> Register</a>
            </div>
        <% } %>
    </div>
</nav>

<div class="container">
    
    <div class="welcome-msg">
        <div class="welcome-text">
            <i class="fa-regular fa-hand-peace"></i>
            <div>
                <% if(user != null) { %>
                    <h2>Welcome back, <%= user.getUsername() %>!</h2>
                <% } else { %>
                    <h2>Welcome to CheatSheets!</h2>
                <% } %>
                <p>Ready to learn something new today?</p>
            </div>
        </div>
    </div>

    <div class="stats-grid">
        <a href="category?name=Programming" class="card">
            <div class="card-cover cover-programming">
                <div class="card-cover-icon"><i class="fa-solid fa-code"></i></div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Programming</h3>
                <p class="card-description">Learn programming languages, frameworks, and coding best practices.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Software" class="card">
            <div class="card-cover cover-software">
                <div class="card-cover-icon"><i class="fa-solid fa-laptop-code"></i></div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Software</h3>
                <p class="card-description">Software development tools, version control, and best practices.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Design" class="card">
            <div class="card-cover cover-design">
                <div class="card-cover-icon"><i class="fa-solid fa-pen-ruler"></i></div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Design</h3>
                <p class="card-description">UI/UX design principles, color theory, and design tools.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Data Science" class="card">
            <div class="card-cover cover-data-science">
                <div class="card-cover-icon"><i class="fa-solid fa-chart-line"></i></div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Data Science</h3>
                <p class="card-description">Data analysis, machine learning, and data visualization techniques.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Languages" class="card">
            <div class="card-cover cover-languages">
                <div class="card-cover-icon"><i class="fa-solid fa-language"></i></div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Languages</h3>
                <p class="card-description">Foreign languages, grammar, vocabulary, and learning resources.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>

        <a href="category?name=Education" class="card">
            <div class="card-cover cover-education">
                <div class="card-cover-icon"><i class="fa-solid fa-graduation-cap"></i></div>
            </div>
            <div class="card-content">
                <h3 class="card-title">Education</h3>
                <p class="card-description">Study tips, academic resources, and effective learning strategies.</p>
                <span class="view-more">Browse Sheets <i class="fa-solid fa-arrow-right"></i></span>
            </div>
        </a>
    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>