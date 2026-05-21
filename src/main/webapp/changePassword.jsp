<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cheatsheet.model.User" %>

<%
    User loginUser = (User) session.getAttribute("loginUser");
    if(loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String error = (String) session.getAttribute("error");
    session.removeAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password | CheatSheets</title>
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
            padding: 40px;
            color: #f1f5f9;
        }

        .container {
            max-width: 500px;
            margin: 0 auto;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #334155;
            color: #cbd5e1;
            padding: 10px 20px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
            margin-bottom: 25px;
            border: 1px solid #475569;
        }

        .back-btn:hover {
            background: #38bdf8;
            color: #0f172a;
            transform: translateX(-5px);
        }

        .password-card {
            background: #1e293b;
            border-radius: 24px;
            padding: 35px;
            border: 1px solid #334155;
            box-shadow: 0 20px 35px -12px rgba(0, 0, 0, 0.3);
        }

        .password-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .lock-icon {
            width: 80px;
            height: 80px;
            background: rgba(56, 189, 248, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 36px;
            color: #38bdf8;
            border: 2px solid rgba(56, 189, 248, 0.3);
        }

        .password-header h2 {
            color: white;
            margin-bottom: 5px;
        }

        .password-header p {
            color: #94a3b8;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #cbd5e1;
            font-weight: 500;
            font-size: 14px;
        }

        .form-group label i {
            margin-right: 8px;
            color: #38bdf8;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border-radius: 12px;
            border: 1px solid #334155;
            background: #0f172a;
            color: white;
            font-size: 15px;
            transition: 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #38bdf8;
            box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.2);
        }

        .password-requirements {
            background: #0f172a;
            padding: 12px 15px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .password-requirements p {
            font-size: 12px;
            color: #94a3b8;
            margin-bottom: 8px;
        }

        .password-requirements ul {
            list-style: none;
            padding-left: 0;
        }

        .password-requirements li {
            font-size: 11px;
            color: #64748b;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #38bdf8, #0ea5e9);
            color: #0f172a;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3);
        }

        .error-msg {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            padding: 12px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            border: 1px solid #f87171;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        hr {
            border-color: #334155;
            margin: 20px 0;
        }

        .info-text {
            font-size: 12px;
            color: #64748b;
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <a href="homepage" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Home
    </a>

    <div class="password-card">
        <div class="password-header">
            <div class="lock-icon">
                <i class="fa-solid fa-lock"></i>
            </div>
            <h2><i class="fa-solid fa-key"></i> Change Password</h2>
            <p>Secure your account with a strong password</p>
        </div>

        <% if(error != null) { %>
            <div class="error-msg">
                <i class="fa-solid fa-triangle-exclamation"></i> <%= error %>
            </div>
        <% } %>

        <form method="post" action="changePassword">
            <div class="form-group">
                <label><i class="fa-solid fa-lock"></i> Current Password</label>
                <input type="password" name="currentPassword" placeholder="Enter your current password" required>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-key"></i> New Password</label>
                <input type="password" name="newPassword" id="newPassword" placeholder="Enter new password" required>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-check-double"></i> Confirm New Password</label>
                <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm new password" required>
            </div>

            <div class="password-requirements">
                <p><i class="fa-solid fa-info-circle"></i> Password Requirements:</p>
                <ul>
                    <li><i class="fa-regular fa-circle-check"></i> At least 4 characters long</li>
                    <li><i class="fa-regular fa-circle-check"></i> Can include letters, numbers, and symbols</li>
                    <li><i class="fa-regular fa-circle-check"></i> Case-sensitive</li>
                </ul>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa-solid fa-arrow-right-to-bracket"></i> Change Password
            </button>
        </form>

        <hr>

        <div class="info-text">
            <i class="fa-solid fa-shield-haltered"></i> After changing password, you will need to login again.
            <br>
            <a href="editProfile" style="color: #38bdf8; text-decoration: none;"><i class="fa-regular fa-user"></i> Edit Profile instead?</a>
        </div>
    </div>
</div>

<script>
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    
    function validatePasswordMatch() {
        if(newPassword.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity("Passwords do not match");
        } else {
            confirmPassword.setCustomValidity("");
        }
    }
    
    newPassword.addEventListener('input', validatePasswordMatch);
    confirmPassword.addEventListener('input', validatePasswordMatch);
</script>

</body>
</html>