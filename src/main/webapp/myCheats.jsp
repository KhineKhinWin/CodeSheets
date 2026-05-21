<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>

<%
    List<CheatSheet> list = (List<CheatSheet>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Cheat Sheets</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    body {
        font-family: 'Segoe UI', Tahoma, sans-serif;
        background: #f1f5f9;
        margin: 0;
        padding: 40px 20px;
    }

    h2 {
        text-align: center;
        margin-bottom: 40px;
        color: #0f172a;
        font-size: 30px;
        font-weight: 700;
    }

    /* Card တစ်ခုလုံးရဲ့ ပုံစံ */
    .card {
        background: #e2e8f0;
        border-radius: 16px;
        padding: 25px;
        margin: 20px auto;
        width: 70%;
        max-width: 900px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border-top: 5px solid #6366f1;
        overflow: hidden;
    }

    /* Gray background ပေါ်မှာ ရှိနေမယ့် Title */
    .card h3 {
        margin-bottom: 20px;
        color: #1e293b;
        font-size: 24px;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
        border-bottom: 2px solid #6366f1;
        padding-bottom: 12px;
    }

    /* အတွင်းခန်း - White Box */
    .card-inner-content {
        background: white;
        padding: 25px;
        border-radius: 12px;
        border-left: 4px solid #6366f1;
        box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    }

    /* Section header */
    .section-header {
        color: #4338ca;
        font-size: 18px;
        font-weight: 700;
        margin: 20px 0 10px 0;
        padding-bottom: 5px;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .section-header:first-of-type {
        margin-top: 0;
    }

    /* Bullet points list */
    .bullet-list {
        list-style: none;
        padding: 0;
        margin: 0 0 15px 0;
    }

    .bullet-list li {
        color: #475569;
        font-size: 15px;
        padding: 6px 0 6px 20px;
        display: block;
        position: relative;
        line-height: 1.5;
    }
    
    /* Bullet point icon */
    .bullet-list li::before {
        content: "•";
        color: #6366f1;
        font-weight: bold;
        font-size: 18px;
        position: absolute;
        left: 0;
        top: 4px;
    }
    
    /* Plain text (non-bullet) style */
    .plain-text {
        color: #475569;
        font-size: 15px;
        line-height: 1.6;
        margin: 10px 0;
        padding: 8px 12px;
        background: #f8fafc;
        border-radius: 8px;
    }
    
    /* Code block style */
    .code-block {
        background: #1e293b;
        color: #cbd5e1;
        padding: 15px;
        border-radius: 10px;
        font-family: 'Courier New', monospace;
        font-size: 13px;
        overflow-x: auto;
        margin: 15px 0;
        white-space: pre-wrap;
        word-wrap: break-word;
    }
    
    .code-label {
        color: #38bdf8;
        font-size: 14px;
        font-weight: 600;
        margin: 15px 0 5px 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* BUTTONS */
    .actions {
        margin-top: 25px;
        display: flex;
        gap: 15px;
        justify-content: flex-end;
    }

    .btn {
        text-decoration: none;
        padding: 10px 20px;
        border-radius: 10px;
        font-size: 13px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border: 1px solid transparent;
        cursor: pointer;
    }
    
    .btn-home {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 12px 18px;
        border-radius: 12px;
        background: linear-gradient(135deg, #22d3ee, #0ea5e9);
        color: #0f172a;
        font-weight: 600;
        text-decoration: none;
        box-shadow: 0 8px 20px rgba(34, 211, 238, 0.3);
        transition: all 0.3s ease;
        border: 1px solid rgba(255,255,255,0.1);
        margin-bottom: 20px;
        display: inline-block;
    }

    .btn-home:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 25px rgba(34, 211, 238, 0.45);
        background: linear-gradient(135deg, #0ea5e9, #22d3ee);
    }

    .edit {
        background: #6366f1;
        color: white;
        box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
    }

    .delete {
        background: #ef4444;
        color: white;
        box-shadow: 0 4px 14px rgba(239, 68, 68, 0.3);
    }

    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        opacity: 0.95;
    }

    .empty { 
        text-align: center; 
        color: #94a3b8; 
        margin-top: 60px; 
    }
    
    .category-badge {
        display: inline-block;
        background: #6366f1;
        color: white;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        margin-left: 10px;
    }
</style>
</head>

<body>
<div style="max-width: 1000px; margin: 0 auto;">
    <a href="<%= request.getContextPath() %>/homepage" class="btn-home">
        <i class="fa-solid fa-house"></i> Back to Home
    </a>

    <h2><i class="fa-solid fa-layer-group"></i> My Cheat Sheets</h2>

    <% if (list != null && !list.isEmpty()) { %>
        <% for (CheatSheet c : list) { %>
            <div class="card">
                <h3>
                    <i class="fa-solid fa-bookmark"></i> 
                    <%= c.getTitle() %>
                    <span class="category-badge"><i class="fa-solid fa-tag"></i> <%= c.getCategory() != null ? c.getCategory() : "General" %></span>
                </h3>
                
                <!-- Inner White Box -->
                <div class="card-inner-content">
                    
                    <!-- Description / Content Section -->
                    <div class="section-header">
                        <i class="fa-solid fa-align-left"></i> Content
                    </div>
                    <div class="plain-text">
                        <%= c.getContent() != null && !c.getContent().isEmpty() ? c.getContent().replace("\n", "<br>") : "No description" %>
                    </div>
                    
                    <!-- Example Code Section -->
                    <% if (c.getExampleCode() != null && !c.getExampleCode().isEmpty()) { %>
                        <div class="code-label">
                            <i class="fa-solid fa-code"></i> Example Code
                        </div>
                        <div class="code-block">
                            <pre style="margin: 0; font-family: inherit;"><%= c.getExampleCode() %></pre>
                        </div>
                    <% } %>
                    
                </div>

                <div class="actions">
                    <a class="btn edit" href="edit_cheat?id=<%= c.getId() %>">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                    </a>
                    <a class="btn delete" href="delete_cheat?id=<%= c.getId() %>"
                       onclick="return confirm('Are you sure you want to delete this cheat sheet?')">
                        <i class="fa-solid fa-trash"></i> Delete
                    </a>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="empty">
            <i class="fa-regular fa-folder-open fa-4x"></i>
            <h3>No cheat sheets found</h3>
            <p><a href="create_cheat" style="color: #6366f1;">Create your first cheat sheet →</a></p>
        </div>
    <% } %>
</div>

</body>
</html>