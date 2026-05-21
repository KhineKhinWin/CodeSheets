<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="com.cheatsheet.model.Comment" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.repository.CommentRepository" %>
<%@ page import="com.cheatsheet.repository.CheatsheetRepository" %>

<%
    User loginUser = (User) session.getAttribute("loginUser");
    if(loginUser == null || !"admin".equals(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    CommentRepository commentRepo = new CommentRepository();
    CheatsheetRepository cheatsheetRepo = new CheatsheetRepository();
    
    // Get all cheatsheets for filter
    List<CheatSheet> allCheatsheets = cheatsheetRepo.getAllCheatSheetsForAdmin();
    
    // Get filter parameter
    String filterCheatsheetId = request.getParameter("cheatsheetId");
    List<Comment> allComments = new ArrayList<>();
    
    if(filterCheatsheetId != null && !filterCheatsheetId.isEmpty()) {
        int csId = Integer.parseInt(filterCheatsheetId);
        allComments = commentRepo.getCommentsByCheatsheetId(csId);
    } else {
        for(CheatSheet cs : allCheatsheets) {
            allComments.addAll(commentRepo.getCommentsByCheatsheetId(cs.getId()));
        }
    }
    
    // Sort by date (newest first) - with null safety
    allComments.sort((a, b) -> {
        if(a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
        if(a.getCreatedAt() == null) return 1;
        if(b.getCreatedAt() == null) return -1;
        return b.getCreatedAt().compareTo(a.getCreatedAt());
    });
    
    // Build comment tree for replies
    Map<Integer, Comment> commentMap = new HashMap<>();
    List<Comment> topLevelComments = new ArrayList<>();
    
    for(Comment c : allComments) {
        commentMap.put(c.getId(), c);
        c.setReplies(new ArrayList<>());
    }
    
    for(Comment c : allComments) {
        if(c.getParentCommentId() == null) {
            topLevelComments.add(c);
        } else {
            Comment parent = commentMap.get(c.getParentCommentId());
            if(parent != null) {
                parent.getReplies().add(c);
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Comments | Admin Panel</title>
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
    
    /* Header */
    .header {
        background: #1e293b;
        padding: 15px 5%;
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
        color: #facc15;
    }
    
    .logout a {
        display: flex;
        align-items: center;
        gap: 8px;
        background: #ef4444;
        color: white;
        padding: 8px 16px;
        border-radius: 10px;
        text-decoration: none;
        font-weight: 600;
        transition: 0.3s;
    }
    
    .logout a:hover {
        background: #dc2626;
        transform: translateY(-2px);
    }
    
    /* Container */
    .container {
        padding: 30px 5%;
        max-width: 1400px;
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
        background: #facc15;
        color: #0f172a;
        transform: translateX(-5px);
        border-color: #facc15;
    }
    
    /* Page Title */
    .page-title {
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 28px;
        background: linear-gradient(135deg, #facc15, #f59e0b);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }
    
    /* Stats Cards */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 16px;
        padding: 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        transition: 0.3s;
    }
    
    .stat-card:hover {
        transform: translateY(-3px);
        border-color: #facc15;
    }
    
    .stat-icon {
        width: 50px;
        height: 50px;
        background: rgba(250, 204, 21, 0.15);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: #facc15;
    }
    
    .stat-info h3 {
        font-size: 28px;
        font-weight: bold;
        color: white;
    }
    
    .stat-info p {
        color: #94a3b8;
        font-size: 13px;
    }
    
    /* Filter Section */
    .filter-section {
        background: #1e293b;
        padding: 20px 25px;
        border-radius: 16px;
        margin-bottom: 25px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
        border: 1px solid #334155;
    }
    
    .filter-group {
        display: flex;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
    }
    
    .filter-group label {
        color: #facc15;
        font-weight: 600;
    }
    
    .filter-group select {
        padding: 10px 20px;
        border-radius: 10px;
        border: 1px solid #334155;
        background: #0f172a;
        color: white;
        cursor: pointer;
        font-size: 14px;
    }
    
    .filter-group button {
        padding: 10px 24px;
        border-radius: 10px;
        border: none;
        background: #facc15;
        color: #0f172a;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }
    
    .filter-group button:hover {
        background: #f59e0b;
        transform: scale(1.02);
    }
    
    .filter-group .reset-btn {
        background: #334155;
        color: white;
    }
    
    .filter-group .reset-btn:hover {
        background: #475569;
    }
    
    /* Comments Table */
    .table-wrapper {
        background: #1e293b;
        border-radius: 20px;
        border: 1px solid #334155;
        overflow: hidden;
        overflow-x: auto;
    }
    
    .comments-table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .comments-table th {
        background: #0f172a;
        padding: 15px 18px;
        text-align: left;
        color: #facc15;
        font-weight: 600;
        font-size: 14px;
        border-bottom: 2px solid #facc15;
    }
    
    .comments-table td {
        padding: 15px 18px;
        border-bottom: 1px solid #334155;
        color: #cbd5e1;
        font-size: 14px;
        vertical-align: middle;
    }
    
    .comments-table tr:hover td {
        background: rgba(250, 204, 21, 0.05);
    }
    
    .comment-content {
        max-width: 350px;
        line-height: 1.4;
    }
    
    /* Badges */
    .badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 4px 12px;
        border-radius: 30px;
        font-size: 12px;
        font-weight: 600;
    }
    
    .badge-cheatsheet {
        background: rgba(56, 189, 248, 0.2);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.3);
    }
    
    .badge-user {
        background: rgba(250, 204, 21, 0.15);
        color: #facc15;
        border: 1px solid rgba(250, 204, 21, 0.3);
    }
    
    /* Reply Button */
    .reply-btn {
        background: transparent;
        color: #38bdf8;
        border: 1px solid #38bdf8;
        padding: 6px 14px;
        border-radius: 8px;
        cursor: pointer;
        transition: 0.3s;
        font-size: 12px;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        margin-right: 8px;
    }
    
    .reply-btn:hover {
        background: #38bdf8;
        color: #0f172a;
        transform: translateY(-2px);
    }
    
    /* Delete Button */
    .delete-btn {
        background: transparent;
        color: #f87171;
        border: 1px solid #f87171;
        padding: 6px 14px;
        border-radius: 8px;
        cursor: pointer;
        transition: 0.3s;
        font-size: 12px;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    
    .delete-btn:hover {
        background: #ef4444;
        color: white;
        transform: translateY(-2px);
    }
    
    /* Reply Form */
    .reply-form-row {
        background: #0f172a;
        padding: 15px;
        margin-top: 10px;
        border-radius: 12px;
        display: none;
    }
    
    .reply-form-row textarea {
        width: 100%;
        padding: 12px;
        border-radius: 10px;
        background: #1e293b;
        border: 1px solid #334155;
        color: white;
        resize: vertical;
    }
    
    .reply-form-row button {
        margin-top: 10px;
        background: #22c55e;
        color: white;
        border: none;
        padding: 8px 20px;
        border-radius: 8px;
        cursor: pointer;
        margin-right: 8px;
    }
    
    .reply-form-row .cancel-reply {
        background: #ef4444;
    }
    
    /* Replies Section */
    .replies-container {
        margin-top: 12px;
        padding-left: 30px;
        border-left: 2px solid #facc15;
    }
    
    .reply-item {
        background: #0f172a;
        border-radius: 12px;
        padding: 12px;
        margin-bottom: 10px;
    }
    
    .reply-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
        font-size: 12px;
    }
    
    .reply-user {
        color: #facc15;
        font-weight: 600;
    }
    
    .reply-date {
        color: #64748b;
    }
    
    .reply-content {
        color: #cbd5e1;
        font-size: 13px;
        line-height: 1.4;
    }
    
    .admin-badge {
        background: #facc15;
        color: #0f172a;
        font-size: 10px;
        padding: 2px 6px;
        border-radius: 20px;
        margin-left: 8px;
    }
    
    /* No Data */
    .no-data {
        text-align: center;
        padding: 60px 20px;
    }
    
    .no-data i {
        font-size: 64px;
        color: #475569;
        margin-bottom: 15px;
    }
    
    .no-data h3 {
        color: #94a3b8;
        margin-bottom: 8px;
    }
    
    .no-data p {
        color: #64748b;
    }
    
    /* Messages */
    .success-msg, .error-msg {
        padding: 15px 20px;
        border-radius: 12px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        animation: slideDown 0.3s ease;
    }
    
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .success-msg {
        background: rgba(34, 197, 94, 0.15);
        color: #22c55e;
        border: 1px solid #22c55e;
    }
    
    .error-msg {
        background: rgba(239, 68, 68, 0.15);
        color: #ef4444;
        border: 1px solid #ef4444;
    }
    
    /* Scrollbar */
    ::-webkit-scrollbar {
        width: 6px;
        height: 6px;
    }
    
    ::-webkit-scrollbar-track {
        background: #0f172a;
        border-radius: 10px;
    }
    
    ::-webkit-scrollbar-thumb {
        background: #facc15;
        border-radius: 10px;
    }
    
    /* Responsive */
    @media (max-width: 900px) {
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    
    @media (max-width: 600px) {
        .stats-grid {
            grid-template-columns: 1fr;
        }
        .filter-section {
            flex-direction: column;
            align-items: stretch;
        }
        .filter-group {
            justify-content: space-between;
        }
    }
</style>
</head>
<body>

<div class="container">
    <a href="adminDashboard" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>
    
    <h2 class="page-title">
        <i class="fa-solid fa-message"></i> Manage Comments
    </h2>
    
    <!-- Stats Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-comments"></i>
            </div>
            <div class="stat-info">
                <h3><%= allComments.size() %></h3>
                <p>Total Comments</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-book"></i>
            </div>
            <div class="stat-info">
                <h3><%= allCheatsheets.size() %></h3>
                <p>Cheatsheets</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-users"></i>
            </div>
            <div class="stat-info">
                <h3>
                    <% 
                        java.util.Set<String> uniqueUsers = new java.util.HashSet<>();
                        for(Comment c : allComments) {
                            uniqueUsers.add(c.getUserName());
                        }
                    %>
                    <%= uniqueUsers.size() %>
                </h3>
                <p>Active Commenters</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-regular fa-clock"></i>
            </div>
            <div class="stat-info">
                <h3>
                    <% 
                        int todayCount = 0;
                        java.time.LocalDate today = java.time.LocalDate.now();
                        for(Comment c : allComments) {
                            if(c.getCreatedAt() != null) {
                                java.time.LocalDate commentDate = c.getCreatedAt().toLocalDateTime().toLocalDate();
                                if(commentDate.equals(today)) todayCount++;
                            }
                        }
                    %>
                    <%= todayCount %>
                </h3>
                <p>Comments Today</p>
            </div>
        </div>
    </div>
    
    
    
    <!-- Success/Error Messages -->
    <% if(request.getParameter("success") != null) { %>
        <div class="success-msg">
            <i class="fa-solid fa-check-circle"></i> Action completed successfully!
        </div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
        <div class="error-msg">
            <i class="fa-solid fa-exclamation-triangle"></i> Error! Please try again.
        </div>
    <% } %>
   
    <!-- Comments Table -->
    <div class="table-wrapper">
        <table class="comments-table">
            <thead>
                <tr>
                    <th><i class="fa-solid fa-hashtag"></i> ID</th>
                    <th><i class="fa-solid fa-book"></i> Cheatsheet</th>
                    <th><i class="fa-solid fa-user"></i> User</th>
                    <th><i class="fa-solid fa-message"></i> Comment</th>
                    <th><i class="fa-solid fa-calendar"></i> Date</th>
                    <th><i class="fa-solid fa-bolt"></i> Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if(topLevelComments.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="no-data">
                            <i class="fa-regular fa-comment-dots"></i>
                            <h3>No Comments Found</h3>
                            <p>There are no comments in the system yet.</p>
                        </td>
                    </tr>
                <% } else { %>
                    <% for(Comment comment : topLevelComments) { 
                        String cheatsheetTitle = "";
                        for(CheatSheet cs : allCheatsheets) {
                            if(cs.getId() == comment.getCheatsheetId()) {
                                cheatsheetTitle = cs.getTitle();
                                break;
                            }
                        }
                    %>
                        <tr id="comment-row-<%= comment.getId() %>">
                            <td><span class="badge badge-cheatsheet">#<%= comment.getId() %></span></td>
                            <td>
                                <span class="badge badge-cheatsheet">
                                    <i class="fa-solid fa-book"></i> <%= cheatsheetTitle.length() > 35 ? cheatsheetTitle.substring(0, 35) + "..." : cheatsheetTitle %>
                                </span>
                            </td>
                            <td>
                                <span class="badge badge-user">
                                    <i class="fa-solid fa-circle-user"></i> <%= comment.getUserName() %>
                                </span>
                            </td>
                            <td class="comment-content">
                                <i class="fa-regular fa-comment" style="color: #facc15; margin-right: 6px;"></i>
                                <%= comment.getContent().length() > 80 ? comment.getContent().substring(0, 80) + "..." : comment.getContent() %>
                                
                                <!-- Reply Form (hidden initially) -->
                                <div id="reply-form-<%= comment.getId() %>" class="reply-form-row" style="display: none;">
                                    <textarea id="reply-content-<%= comment.getId() %>" rows="2" placeholder="Write your reply as admin..."></textarea>
                                    <div>
                                        <button onclick="submitReply(<%= comment.getId() %>, <%= comment.getCheatsheetId() %>)">
                                            <i class="fa-solid fa-paper-plane"></i> Post Reply
                                        </button>
                                        <button class="cancel-reply" onclick="hideReplyForm(<%= comment.getId() %>)">
                                            Cancel
                                        </button>
                                    </div>
                                </div>
                                
                                <!-- Replies Section -->
                                <% if(comment.getReplies() != null && !comment.getReplies().isEmpty()) { %>
                                    <div class="replies-container">
                                        <% for(Comment reply : comment.getReplies()) { %>
                                            <div class="reply-item">
                                                <div class="reply-header">
                                                    <span class="reply-user">
                                                        <i class="fa-solid fa-reply"></i> <%= reply.getUserName() %>
                                                        <span class="admin-badge">Admin</span>
                                                    </span>
                                                    <span class="reply-date"><%= reply.getCreatedAt() %></span>
                                                </div>
                                                <div class="reply-content">
                                                    <%= reply.getContent().replace("\n", "<br>") %>
                                                </div>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                            </td>
                            <td>
                                <i class="fa-regular fa-calendar" style="color: #64748b;"></i>
                                <%= comment.getCreatedAt() != null ? comment.getCreatedAt() : "Unknown" %>
                            </td>
                            <td>
                                <button class="reply-btn" onclick="showReplyForm(<%= comment.getId() %>)">
                                    <i class="fa-solid fa-reply"></i> Reply
                                </button>
                                <button class="delete-btn" onclick="deleteComment(<%= comment.getId() %>)">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
function applyFilter() {
    var cheatsheetId = document.getElementById('cheatsheetFilter').value;
    if(cheatsheetId) {
        window.location.href = '<%= request.getContextPath() %>/manageComments?cheatsheetId=' + cheatsheetId;
    } else {
        window.location.href = '<%= request.getContextPath() %>/manageComments';
    }
}

function resetFilter() {
    window.location.href = '<%= request.getContextPath() %>/manageComments';
}

function showReplyForm(commentId) {
    var form = document.getElementById('reply-form-' + commentId);
    if(form.style.display === 'none' || form.style.display === '') {
        form.style.display = 'block';
    } else {
        form.style.display = 'none';
    }
}

function hideReplyForm(commentId) {
    var form = document.getElementById('reply-form-' + commentId);
    form.style.display = 'none';
    document.getElementById('reply-content-' + commentId).value = '';
}

function submitReply(commentId, cheatsheetId) {
    var content = document.getElementById('reply-content-' + commentId).value;
    
    if(!content.trim()) {
        alert('Please enter reply content');
        return;
    }
    
    var formData = new FormData();
    formData.append('action', 'add');
    formData.append('cheatsheetId', cheatsheetId);
    formData.append('parent_comment_id', commentId);
    formData.append('content', content.trim());
    
    fetch('<%= request.getContextPath() %>/CommentServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if(data.success) {
            location.reload();
        } else {
            alert('Failed to post reply: ' + (data.error || 'Unknown error'));
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error posting reply');
    });
}

function deleteComment(commentId) {
    if(confirm('Are you sure you want to delete this comment and all its replies? This action cannot be undone.')) {
        fetch('<%= request.getContextPath() %>/manageComments?action=delete&commentId=' + commentId, {
            method: 'GET'
        })
        .then(response => {
            if(response.ok) {
                location.reload();
            } else {
                alert('Error deleting comment');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error deleting comment');
        });
    }
}
</script>

</body>
</html>