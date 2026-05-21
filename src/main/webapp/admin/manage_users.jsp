<%@ page import="java.util.*, com.cheatsheet.model.User" %>

<%
List<User> users = (List<User>) request.getAttribute("users");
User loginUser = (User) session.getAttribute("loginUser");

// Admin မဟုတ်ရင် Login page ပြန်လွှတ်မယ်
if(loginUser == null || !"admin".equals(loginUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
<meta charset="UTF-8">
<title>User Management | Admin Dashboard</title>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: radial-gradient(circle at 50% 0%, #1e1b4b 0%, #0b0f19 70%);
        min-height: 100vh;
        color: #e2e8f0;
    }

    /* ========== PREMIUM HEADER ========== */
    .premium-header {
        background: rgba(19, 26, 44, 0.75);
        backdrop-filter: blur(12px);
        padding: 15px 5%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid rgba(99, 102, 241, 0.2);
        position: sticky;
        top: 0;
        z-index: 100;
        box-shadow: 0 4px 30px rgba(0, 0, 0, 0.4);
    }

    .logo-area {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .logo-icon {
        width: 45px;
        height: 45px;
        background: linear-gradient(135deg, #6366f1, #4f46e5);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: white;
        box-shadow: 0 0 15px rgba(99, 102, 241, 0.4);
    }

    .logo-text {
        font-size: 24px;
        font-weight: bold;
        color: white;
    }

    .logo-text span {
        background: linear-gradient(135deg, #818cf8, #6366f1);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    /* Admin Profile */
    .admin-profile {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .admin-info {
        display: flex;
        align-items: center;
        gap: 12px;
        background: #131a2c;
        padding: 6px 18px;
        border-radius: 40px;
        border: 1px solid #222f4d;
    }

    .admin-avatar {
        width: 35px;
        height: 35px;
        background: linear-gradient(135deg, #6366f1, #4f46e5);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: white;
        text-transform: uppercase;
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.3);
    }

    .admin-details {
        display: flex;
        flex-direction: column;
    }

    .admin-name {
        font-weight: 600;
        color: white;
        font-size: 14px;
    }

    .admin-role {
        font-size: 11px;
        color: #818cf8;
    }

    .logout-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        background: rgba(248, 113, 113, 0.08);
        color: #f87171;
        padding: 8px 20px;
        border-radius: 40px;
        text-decoration: none;
        font-weight: 600;
        font-size: 13px;
        transition: 0.3s;
        border: 1px solid rgba(248, 113, 113, 0.2);
    }

    .logout-btn:hover {
        background: #ef4444;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }

    /* Container */
    .container {
        max-width: 1400px;
        margin: 40px auto;
        background: #131a2c;
        border-radius: 24px;
        padding: 30px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        border: 1px solid #222f4d;
    }

    /* Header */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        flex-wrap: wrap;
        gap: 15px;
    }

    .page-header h2 {
        font-size: 28px;
        background: linear-gradient(135deg, #e0e7ff, #a5b4fc);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .btn-back {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: #1e293b;
        color: #94a3b8;
        padding: 10px 22px;
        border-radius: 14px;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid #334155;
    }

    .btn-back:hover {
        background: #6366f1;
        color: white;
        transform: translateX(-4px);
        border-color: #6366f1;
        box-shadow: 0 4px 15px rgba(99, 102, 241, 0.35);
    }

    /* Stats Bar */
    .stats-bar {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
        margin-bottom: 35px;
    }

    .stat-card {
        background: #0f1524;
        border: 1px solid #1e2942;
        border-radius: 18px;
        padding: 22px;
        display: flex;
        align-items: center;
        gap: 18px;
        transition: all 0.3s ease;
    }

    .stat-card:hover {
        transform: translateY(-4px);
        border-color: #6366f1;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }

    .stat-icon {
        width: 52px;
        height: 52px;
        background: rgba(99, 102, 241, 0.1);
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: #818cf8;
        border: 1px solid rgba(99, 102, 241, 0.15);
    }

    .stat-info {
        display: flex;
        flex-direction: column;
    }

    .stat-label {
        color: #64748b;
        font-size: 13px;
        margin-bottom: 2px;
    }

    .stat-number {
        font-size: 28px;
        font-weight: 700;
        color: #ffffff;
        line-height: 1.2;
    }

    /* Table Container */
    .table-wrapper {
        overflow-x: auto;
        border-radius: 18px;
        background: #0f1524;
        border: 1px solid #1e2942;
    }

    /* Table */
    table {
        width: 100%;
        border-collapse: collapse;
        color: #cbd5e1;
    }

    thead th {
        background: #090d16;
        padding: 18px 20px;
        color: #818cf8;
        font-size: 14px;
        font-weight: 600;
        border-bottom: 2px solid #222f4d;
        text-align: left;
    }

    td {
        padding: 16px 20px;
        border-bottom: 1px solid #1e2942;
        font-size: 14px;
        vertical-align: middle;
    }

    tr:last-child td {
        border-bottom: none;
    }

    tr:hover td {
        background: rgba(99, 102, 241, 0.04);
    }

    /* Role Badges */
    .role-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }

    .role-badge.admin {
        background: rgba(248, 113, 113, 0.1);
        color: #f87171;
        border: 1px solid rgba(248, 113, 113, 0.2);
    }

    .role-badge.user {
        background: rgba(56, 189, 248, 0.1);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.2);
    }

    /* Delete Button */
    .delete-btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: rgba(248, 113, 113, 0.08);
        color: #f87171;
        padding: 8px 16px;
        border-radius: 10px;
        text-decoration: none;
        font-size: 13px;
        font-weight: 600;
        transition: all 0.2s ease;
        border: 1px solid rgba(248, 113, 113, 0.2);
        cursor: pointer;
    }

    .delete-btn:hover {
        background: #ef4444;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 70px 20px;
    }

    .empty-state i {
        font-size: 64px;
        color: #334155;
        margin-bottom: 18px;
    }

    .empty-state h3 {
        color: #94a3b8;
        margin-bottom: 8px;
    }

    .empty-state p {
        color: #475569;
    }

    /* Scrollbar */
    ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }

    ::-webkit-scrollbar-track {
        background: #090d16;
    }

    ::-webkit-scrollbar-thumb {
        background: #222f4d;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #334155;
    }

    /* Responsive */
    @media (max-width: 900px) {
        .stats-bar {
            grid-template-columns: repeat(2, 1fr);
        }
        .premium-header {
            flex-direction: column;
            gap: 15px;
        }
    }

    @media (max-width: 600px) {
        .stats-bar {
            grid-template-columns: 1fr;
        }
        .header-section {
            flex-direction: column;
            align-items: flex-start;
        }
        .container {
            padding: 20px;
            margin: 15px;
        }
    }
</style>

</head>

<body>

<header class="premium-header">
    <div class="logo-area">
        <div class="logo-icon">
            <i class="fa-solid fa-code"></i>
        </div>
        <div class="logo-text">Cheat<span>Sheet</span></div>
    </div>
    
   
</header>

<div class="container">
    
    <div class="page-header">
        <h2>
            <i class="fa-solid fa-users-gear"></i> User Management
        </h2>
        <a href="<%= request.getContextPath() %>/adminDashboard" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="stats-bar">
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
            <div class="stat-info">
                <span class="stat-label">Total Users</span>
                <span class="stat-number"><%= (users != null) ? users.size() : 0 %></span>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-user-shield"></i></div>
            <div class="stat-info">
                <span class="stat-label">Admins</span>
                <span class="stat-number">
                    <% 
                        int adminCount = 0;
                        if(users != null){
                            for(User u : users){
                                if("admin".equalsIgnoreCase(u.getRole())) adminCount++;
                            }
                        }
                    %>
                    <%= adminCount %>
                </span>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-user"></i></div>
            <div class="stat-info">
                <span class="stat-label">Regular Users</span>
                <span class="stat-number">
                    <%= ((users != null) ? users.size() : 0) - adminCount %>
                </span>
            </div>
        </div>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th><i class="fa-solid fa-hashtag"></i> ID</th>
                    <th><i class="fa-solid fa-user"></i> Username</th>
                    <th><i class="fa-solid fa-envelope"></i> Email</th>
                    <th><i class="fa-solid fa-shield"></i> Role</th>
                    <th><i class="fa-solid fa-bolt"></i> Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                if(users != null && !users.isEmpty()){
                    for(User u : users){
                %>
                <tr>
                    <td><span class="role-badge" style="background:#1e293b; border-color:#334155;">#<%= u.getId() %></span></td>
                    <td style="font-weight: 500; color: #ffffff;">
                        <i class="fa-regular fa-circle-user" style="color: #38bdf8; margin-right: 8px;"></i>
                        <%= u.getUsername() %>
                    </td>
                    <td>
                        <i class="fa-regular fa-envelope" style="color: #64748b; margin-right: 8px;"></i>
                        <%= u.getEmail() %>
                    </td>
                    <td>
                        <% if("admin".equalsIgnoreCase(u.getRole())) { %>
                            <span class="role-badge admin">
                                <i class="fa-solid fa-crown"></i> Admin
                            </span>
                        <% } else { %>
                            <span class="role-badge user">
                                <i class="fa-solid fa-user"></i> User
                            </span>
                        <% } %>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="<%= request.getContextPath() %>/deleteUser?id=<%= u.getId() %>" 
                               class="delete-btn"
                               onclick="return confirm('Are you sure you want to delete user <%= u.getUsername() %>?')">
                                <i class="fa-solid fa-trash"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="5">
                        <div class="empty-state">
                            <i class="fa-regular fa-folder-open"></i>
                            <h3>No Users Found</h3>
                            <p>There are no registered users in the system yet.</p>
                        </div>
                    </td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>