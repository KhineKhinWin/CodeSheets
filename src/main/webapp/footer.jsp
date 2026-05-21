<%@ page contentType="text/html;charset=UTF-8" %>

<!-- ✅ Font Awesome (IMPORTANT) -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

<style>
    /* ================= FOOTER BASE ================= */
    .footer {
        background: #0f172a;
        color: #e2e8f0;
        margin-top: 60px;
        border-top: 1px solid #1e293b;
        font-family: Arial, sans-serif;
    }

    .footer-container {
        width: 90%;
        max-width: 1100px;
        margin: auto;
        padding: 40px 0;

        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 30px;
    }

    .footer h3 {
        color: #38bdf8;
        margin-bottom: 15px;
        font-size: 18px;
    }

    .footer p {
        color: #94a3b8;
        font-size: 14px;
        line-height: 1.7;
    }

    .footer a {
        display: block;
        color: #cbd5e1;
        text-decoration: none;
        margin-bottom: 8px;
        font-size: 14px;
        transition: 0.3s;
    }

    .footer a:hover {
        color: #38bdf8;
        padding-left: 6px;
    }

    .social-icons {
        display: flex;
        gap: 10px;
        margin-top: 10px;
    }

    .social-icons a {
        width: 35px;
        height: 35px;
        display: flex;
        justify-content: center;
        align-items: center;

        border-radius: 8px;
        background: #1e293b;
        border: 1px solid #334155;

        color: #e2e8f0;
        font-size: 13px;

        transition: 0.3s;
    }

    .social-icons a:hover {
        background: #38bdf8;
        color: #0f172a;
        transform: translateY(-2px);
    }

    .bottom-bar {
        text-align: center;
        padding: 15px 10px;
        border-top: 1px solid #1e293b;
        font-size: 13px;
        color: #64748b;
    }

    .bottom-bar span {
        color: #38bdf8;
    }
</style>

<!-- ================= FOOTER ================= -->
<footer class="footer">

    <div class="footer-container">

        <!-- ABOUT -->
        <div>
            <h3>CheatSheet Community</h3>
            <p>
                A modern platform for developers to share and learn cheat sheets
                in Programming, Software, Design, Data Science and Education.
            </p>
        </div>

        <!-- QUICK LINKS -->
        <div>
            <h3><i class="fa-solid fa-link"></i> Quick Links</h3>

            <a href="home.jsp"><i class="fa-solid fa-house"></i> Home</a>
            <a href="allCheatSheets"><i class="fa-solid fa-book"></i> All Cheatsheets</a>
            <a href="create_cheat"><i class="fa-solid fa-plus"></i> Create Cheat</a>
            <a href="login.jsp"><i class="fa-solid fa-lock"></i> Login</a>
        </div>

        <!-- CATEGORIES -->
        <div>
            <h3><i class="fa-solid fa-layer-group"></i> Categories</h3>

            <a href="#"><i class="fa-solid fa-code"></i> Programming</a>
            <a href="#"><i class="fa-solid fa-desktop"></i> Software</a>
            <a href="#"><i class="fa-solid fa-pen-ruler"></i> Design</a>
            <a href="#"><i class="fa-solid fa-chart-line"></i> Data Science</a>
            <a href="#"><i class="fa-solid fa-graduation-cap"></i> Education</a>
        </div>

        <!-- SOCIAL -->
        <div>
            <h3>Connect With Us</h3>
            <p>Follow us for updates and new cheat sheets.</p>

            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
                <a href="#"><i class="fa-brands fa-youtube"></i></a>
                <a href="#"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

    </div>

    <!-- BOTTOM -->
   <div class="bottom-bar">
    <i class="fa-solid fa-copyright"></i> 2026 
    <span>CheatSheet Community</span> 
    | <i class="fa-solid fa-code"></i> Built for Developers 
    <i class="fa-solid fa-rocket"></i>
</div>

</footer>