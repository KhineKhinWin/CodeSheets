<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cheatsheet.model.User" %>

<%
    User loginUser = (User) session.getAttribute("loginUser");
    if(loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile | CheatSheets</title>
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
            max-width: 600px;
            margin: 0 auto;
        }

        /* Back Button */
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

        /* Profile Card */
        .profile-card {
            background: #1e293b;
            border-radius: 24px;
            padding: 35px;
            border: 1px solid #334155;
            box-shadow: 0 20px 35px -12px rgba(0, 0, 0, 0.3);
        }

        /* Profile Header */
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #38bdf8, #0ea5e9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 56px;
            font-weight: bold;
            color: white;
            box-shadow: 0 10px 25px rgba(56, 189, 248, 0.3);
        }

        .profile-header h2 {
            color: white;
            margin-bottom: 5px;
            font-size: 28px;
        }

        .profile-header p {
            color: #94a3b8;
            font-size: 14px;
        }

        /* Profile Info */
        .profile-info {
            margin-bottom: 25px;
        }

        .info-row {
            display: flex;
            align-items: center;
            padding: 15px;
            background: #0f172a;
            border-radius: 16px;
            margin-bottom: 12px;
            border: 1px solid #334155;
        }

        .info-icon {
            width: 45px;
            height: 45px;
            background: rgba(56, 189, 248, 0.15);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #38bdf8;
            font-size: 20px;
        }

        .info-details {
            flex: 1;
        }

        .info-label {
            font-size: 12px;
            color: #94a3b8;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 18px;
            font-weight: 600;
            color: white;
        }

        /* Role Badge */
        .role-badge {
            display: inline-block;
            background: rgba(56, 189, 248, 0.2);
            color: #38bdf8;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .btn-edit, .btn-password {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
            font-size: 14px;
        }

        .btn-edit {
            background: linear-gradient(135deg, #38bdf8, #0ea5e9);
            color: #0f172a;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3);
        }

        .btn-password {
            background: transparent;
            color: #38bdf8;
            border: 1px solid #38bdf8;
        }

        .btn-password:hover {
            background: #38bdf8;
            color: #0f172a;
            transform: translateY(-2px);
        }

        /* Divider */
        .divider {
            height: 1px;
            background: #334155;
            margin: 20px 0;
        }

        /* Member Since */
        .member-since {
            text-align: center;
            font-size: 12px;
            color: #64748b;
            margin-top: 20px;
        }

        /* Responsive */
        @media (max-width: 500px) {
            body {
                padding: 20px;
            }
            .profile-card {
                padding: 25px;
            }
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <a href="<%= request.getContextPath() %>/homepage" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Home
    </a>

    <div class="profile-card">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="avatar">
                <%= loginUser.getUsername().charAt(0) %>
            </div>
            <h2><%= loginUser.getUsername() %></h2>
            <p>
                <span class="role-badge">
                    <i class="fa-solid <%= loginUser.getRole() != null && loginUser.getRole().equals("admin") ? "fa-crown" : "fa-user" %>"></i>
                    <%= loginUser.getRole() != null ? loginUser.getRole() : "User" %>
                </span>
            </p>
        </div>

        <!-- Profile Information -->
        <div class="profile-info">
            <div class="info-row">
                <div class="info-icon">
                    <i class="fa-regular fa-envelope"></i>
                </div>
                <div class="info-details">
                    <div class="info-label">Email Address</div>
                    <div class="info-value"><%= loginUser.getEmail() %></div>
                </div>
            </div>

            <div class="info-row">
                <div class="info-icon">
                    <i class="fa-regular fa-id-card"></i>
                </div>
                <div class="info-details">
                    <div class="info-label">User ID</div>
                    <div class="info-value">#<%= loginUser.getId() %></div>
                </div>
            </div>

            <div class="info-row">
                <div class="info-icon">
                    <i class="fa-regular fa-calendar"></i>
                </div>
                <div class="info-details">
                    <div class="info-label">Member Since</div>
                    <div class="info-value">
                        <% if(loginUser.getCreatedAt() != null) { %>
                            <%= loginUser.getCreatedAt() %>
                        <% } else { %>
                            January 1, 2024
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="<%= request.getContextPath() %>/editProfile" class="btn-edit">
                <i class="fa-solid fa-pen-to-square"></i> Edit Profile
            </a>
            <a href="<%= request.getContextPath() %>/changePassword" class="btn-password">
                <i class="fa-solid fa-key"></i> Change Password
            </a>
        </div>

        <div class="divider"></div>

        <div class="member-since">
            <i class="fa-regular fa-heart"></i> Thank you for being part of CheatSheets community!
        </div>
    </div>
</div>

</body>
</html>