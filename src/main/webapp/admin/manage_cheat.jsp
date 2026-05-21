<%@ page import="java.util.List" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="com.cheatsheet.repository.RatingRepository" %>
<%@ page import="com.cheatsheet.repository.CommentRepository" %>

<%
    // Check if admin is logged in
    User loginUser = (User) session.getAttribute("loginUser");
    if(loginUser == null || !"admin".equals(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    RatingRepository ratingRepo = new RatingRepository();
    CommentRepository commentRepo = new CommentRepository();
    List<CheatSheet> sheets = (List<CheatSheet>) request.getAttribute("sheets");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Cheat Sheets | Admin Panel</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
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

    /* Container */
    .table-container {
        max-width: 1400px;
        margin: 40px auto;
        background: #131a2c;
        border-radius: 24px;
        padding: 30px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        border: 1px solid #222f4d;
    }

    /* Header Section */
    .header-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        flex-wrap: wrap;
        gap: 15px;
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

    .page-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 28px;
        background: linear-gradient(135deg, #e0e7ff, #a5b4fc);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    /* Stats Cards */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
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

    .stat-info h3 {
        font-size: 28px;
        font-weight: 700;
        color: #ffffff;
        line-height: 1.2;
    }

    .stat-info p {
        color: #64748b;
        font-size: 13px;
        margin-top: 2px;
    }

    /* Success Message */
    .success-msg {
        background: rgba(16, 185, 129, 0.1);
        color: #34d399;
        padding: 14px 20px;
        border-radius: 14px;
        margin-bottom: 25px;
        border: 1px solid rgba(16, 185, 129, 0.25);
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 500;
        animation: slideDown 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Table Wrapper */
    .table-wrapper {
        overflow-x: auto;
        border-radius: 18px;
        background: #0f1524;
        border: 1px solid #1e2942;
    }

    /* Custom Table */
    .custom-table {
        width: 100%;
        border-collapse: collapse;
        color: #cbd5e1;
    }

    .custom-table thead th {
        background: #090d16;
        padding: 18px 20px;
        color: #818cf8;
        font-size: 14px;
        font-weight: 600;
        border-bottom: 2px solid #222f4d;
        text-align: left;
    }

    .custom-table tbody td {
        padding: 16px 20px;
        border-bottom: 1px solid #1e2942;
        font-size: 14px;
        vertical-align: middle;
    }

    .custom-table tbody tr:last-child td {
        border-bottom: none;
    }

    .custom-table tbody tr:hover td {
        background: rgba(99, 102, 241, 0.04);
    }

    /* Badges */
    .badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        background: #1e293b;
        color: #cbd5e1;
        border: 1px solid #334155;
    }

    .badge-category {
        background: rgba(14, 165, 233, 0.1);
        color: #38bdf8;
        border-color: rgba(14, 165, 233, 0.2);
    }

    /* Rating Stars */
    .rating-stars {
        display: inline-flex;
        gap: 3px;
        margin-right: 5px;
    }

    .rating-stars i {
        font-size: 12px;
    }

    .rating-stars i.fa-solid.fa-star {
        color: #fbbf24;
    }

    .rating-stars i.fa-regular.fa-star {
        color: #334155;
    }

    /* Modal Styling */
    .code-modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(4, 6, 10, 0.8);
        backdrop-filter: blur(8px);
    }

    .code-modal-content {
        background: #131a2c;
        margin: 6% auto;
        padding: 0;
        width: 720px;
        max-width: 92%;
        border-radius: 24px;
        border: 1px solid #222f4d;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        animation: modalFadeIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        max-height: 85vh;
        overflow-y: auto;
    }

    .code-modal-header {
        padding: 20px 26px;
        background: #0f1524;
        border-bottom: 1px solid #1e2942;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
    }

    .code-modal-header h3 {
        font-size: 1.25rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .close-code-modal {
        color: #64748b;
        font-size: 26px;
        cursor: pointer;
        transition: color 0.2s;
    }

    .close-code-modal:hover {
        color: #ef4444;
    }

    .code-modal-body {
        padding: 26px;
    }

    .code-display {
        background: #090d16;
        padding: 20px;
        border-radius: 16px;
        border-left: 4px solid #6366f1;
        overflow-x: auto;
        border-top: 1px solid #141b2b;
        border-right: 1px solid #141b2b;
        border-bottom: 1px solid #141b2b;
    }

    .code-display pre {
        color: #a5b4fc;
        font-family: 'Fira Code', 'Courier New', monospace;
        font-size: 13.5px;
        white-space: pre-wrap;
        word-wrap: break-word;
        margin: 0;
        line-height: 1.5;
    }

    .copy-code-btn {
        background: #6366f1;
        color: white;
        border: none;
        padding: 10px 22px;
        border-radius: 12px;
        cursor: pointer;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s ease;
    }

    .copy-code-btn:hover {
        background: #4f46e5;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
    }

    @keyframes modalFadeIn {
        from { opacity: 0; transform: scale(0.96); }
        to { opacity: 1; transform: scale(1); }
    }

    /* Action Buttons */
    .btn-action {
        text-decoration: none;
        padding: 8px 16px;
        border-radius: 10px;
        font-size: 13px;
        font-weight: 600;
        transition: all 0.2s ease;
        margin-right: 8px;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        cursor: pointer;
    }

    .btn-edit {
        background: rgba(56, 189, 248, 0.08);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.2);
    }

    .btn-edit:hover {
        background: #38bdf8;
        color: #090d16;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(56, 189, 248, 0.3);
    }

    .btn-delete {
        background: rgba(248, 113, 113, 0.08);
        color: #f87171;
        border: 1px solid rgba(248, 113, 113, 0.2);
    }

    .btn-delete:hover {
        background: #ef4444;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }

    /* No Data */
    .no-data {
        text-align: center;
        padding: 70px 20px;
    }

    .no-data i {
        font-size: 64px;
        color: #334155;
        margin-bottom: 18px;
    }

    .no-data h3 {
        color: #94a3b8;
        margin-bottom: 8px;
    }

    .no-data p {
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
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 600px) {
        .stats-grid {
            grid-template-columns: 1fr;
        }
        .header-section {
            flex-direction: column;
            align-items: flex-start;
        }
        .table-container {
            padding: 20px;
            margin: 15px;
        }
    }
</style>
</head>
<body>

<div class="table-container">
    
    <div class="header-section">
        <a href="<%= contextPath %>/adminDashboard" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
        <h2 class="page-title">
            <i class="fa-solid fa-book"></i> Manage Cheat Sheets
        </h2>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-file-code"></i>
            </div>
            <div class="stat-info">
                <h3><%= sheets != null ? sheets.size() : 0 %></h3>
                <p>Total Cheat Sheets</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-star"></i>
            </div>
            <div class="stat-info">
                <h3>
                    <% 
                        double totalRating = 0;
                        int ratedCount = 0;
                        if(sheets != null) {
                            for(CheatSheet s : sheets) {
                                double avg = ratingRepo.getAverageRating(s.getId());
                                if(avg > 0) {
                                    totalRating += avg;
                                    ratedCount++;
                                }
                            }
                        }
                        double avgAll = ratedCount > 0 ? totalRating / ratedCount : 0;
                    %>
                    <%= String.format("%.1f", avgAll) %>
                </h3>
                <p>Average Rating</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-tag"></i>
            </div>
            <div class="stat-info">
                <h3>
                    <% 
                        java.util.Set<String> categories = new java.util.HashSet<>();
                        if(sheets != null) {
                            for(CheatSheet s : sheets) {
                                if(s.getCategory() != null) categories.add(s.getCategory());
                            }
                        }
                    %>
                    <%= categories.size() %>
                </h3>
                <p>Categories</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-comment"></i>
            </div>
            <div class="stat-info">
                <h3>
                    <% 
                        int totalComments = 0;
                        if(sheets != null) {
                            for(CheatSheet s : sheets) {
                                totalComments += commentRepo.getCommentCount(s.getId());
                            }
                        }
                    %>
                    <%= totalComments %>
                </h3>
                <p>Total Comments</p>
            </div>
        </div>
    </div>

    <% if(request.getParameter("success") != null) { %>
        <div class="success-msg">
            <i class="fa-solid fa-circle-check"></i> Updated Successfully!
        </div>
    <% } %>

    <div class="table-wrapper">
        <table class="custom-table">
            <thead>
                <tr>
                    <th><i class="fa-solid fa-hashtag"></i> ID</th>
                    <th><i class="fa-solid fa-file-code"></i> Title</th>
                    <th><i class="fa-solid fa-star"></i> Rating</th>
                    <th><i class="fa-solid fa-comment"></i> Comments</th>
                    <th><i class="fa-solid fa-layer-group"></i> Category</th>
                    <th><i class="fa-solid fa-gear"></i> Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (sheets != null && !sheets.isEmpty()) { 
                    for (CheatSheet s : sheets) {
                        double avgRating = ratingRepo.getAverageRating(s.getId());
                        int ratingCount = ratingRepo.getRatingCount(s.getId());
                        int commentCount = commentRepo.getCommentCount(s.getId());
                        
                        int fullStars = (int) Math.round(avgRating);
                        
                        String fullCode = s.getExampleCode() != null ? s.getExampleCode() : "";
                        String escapedFullCode = fullCode.replace("\"", "&quot;").replace("\n", "\\n");
                        String escapedTitle = s.getTitle().replace("\"", "&quot;");
                        String escapedCategory = (s.getCategory() != null ? s.getCategory() : "Uncategorized").replace("\"", "&quot;");
                %>
                    <tr id="sheet-row-<%= s.getId() %>"
                        data-id="<%= s.getId() %>"
                        data-title="<%= escapedTitle %>"
                        data-category="<%= escapedCategory %>"
                        data-rating="<%= String.format("%.1f", avgRating) %> (<%= ratingCount %>)"
                        data-comments="<%= commentCount %>"
                        data-code="<%= escapedFullCode %>">
                        
                        <td><span class="badge"><i class="fa-solid fa-hashtag"></i> <%= s.getId() %></span></td>
                        <td style="font-weight: 500; color: #ffffff;"><%= s.getTitle() %></td>
                        
                        <td>
                            <div class="rating-stars">
                                <% for(int i = 1; i <= 5; i++) { %>
                                    <% if(i <= fullStars) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } else { %>
                                        <i class="fa-regular fa-star"></i>
                                    <% } %>
                                <% } %>
                            </div>
                            <span style="margin-left: 5px; color: #facc15; font-weight: 600;"><%= String.format("%.1f", avgRating) %></span>
                            <span style="color: #475569; font-size: 11px;">(<%= ratingCount %>)</span>
                        </td>
                        <td>
                            <i class="fa-regular fa-comment" style="color: #818cf8; margin-right: 5px;"></i>
                            <%= commentCount %>
                        </td>
                        <td>
                            <span class="badge badge-category">
                                <i class="fa-solid fa-tag"></i> <%= s.getCategory() != null ? s.getCategory() : "Uncategorized" %>
                            </span>
                        </td>
                        <td>
                            <button class="btn-action" style="background: rgba(16, 185, 129, 0.08); color: #34d399; border: 1px solid rgba(16, 185, 129, 0.2);" onclick="showSheetDetails(<%= s.getId() %>)">
                                <i class="fa-solid fa-eye"></i> Details
                            </button>
                            <a href="<%= contextPath %>/editSheet?id=<%= s.getId() %>" class="btn-action btn-edit">
                                <i class="fa-solid fa-pen-to-square"></i> Edit
                            </a>
                            <a href="<%= contextPath %>/deleteSheet?id=<%= s.getId() %>" 
                               class="btn-action btn-delete" 
                               onclick="return confirm('Are you sure you want to delete &quot;<%= s.getTitle() %>&quot;? This action cannot be undone.')">
                                <i class="fa-solid fa-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                <% } 
                } else { %>
                    <tr>
                        <td colspan="6" class="no-data">
                            <i class="fa-regular fa-folder-open"></i>
                            <h3>No Cheat Sheets Found</h3>
                            <p>There are no cheat sheets in the system yet.</p>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div id="detailsModal" class="code-modal">
    <div class="code-modal-content" style="width: 750px;">
        <div class="code-modal-header" style="border-bottom-color: #222f4d;">
            <h3 style="color: #34d399;"><i class="fa-solid fa-circle-info"></i> <span id="dtModalTitle">Cheat Sheet Details</span></h3>
            <span class="close-code-modal" onclick="closeDetailsModal()">&times;</span>
        </div>
        <div class="code-modal-body" style="color: #cbd5e1; font-size: 14px;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px; background: #0f1524; padding: 18px; border-radius: 16px; border: 1px solid #1e2942;">
                <div><strong style="color: #818cf8;">ID:</strong> <span id="dtId" style="margin-left: 8px;"></span></div>
                <div><strong style="color: #818cf8;">Category:</strong> <span id="dtCategory" style="margin-left: 8px;" class="badge badge-category"></span></div>
                <div><strong style="color: #818cf8;">Avg Rating:</strong> <span id="dtRating" style="margin-left: 8px; color: #fbbf24; font-weight: 600;"></span></div>
                <div><strong style="color: #818cf8;">Total Comments:</strong> <span id="dtComments" style="margin-left: 8px;"></span></div>
            </div>
            
            <div style="margin-bottom: 20px;">
                <strong style="color: #818cf8; display: block; margin-bottom: 6px;">Cheat Sheet Title:</strong>
                <div id="dtFullTitle" style="font-size: 16px; font-weight: 600; color: white; background: #0f1524; padding: 12px 18px; border-radius: 12px; border: 1px solid #1e2942;"></div>
            </div>
            
            <div>
                <strong style="color: #34d399; display: block; margin-bottom: 8px;"><i class="fa-solid fa-code"></i> Source Code / Content:</strong>
                <div class="code-display" style="max-height: 300px; overflow-y: auto;">
                    <pre id="dtCodeContent"></pre>
                </div>
            </div>
        </div>
        <div style="padding: 18px 26px; background: #0f1524; border-top: 1px solid #1e2942; text-align: right; display: flex; justify-content: space-between; align-items: center;">
            <button class="copy-code-btn" style="margin-top:0; background: #6366f1;" onclick="copyDetailedCode()">
                <i class="fa-regular fa-copy"></i> Copy Source Code
            </button>
            <button style="background: #1e293b; color: #94a3b8; border: 1px solid #334155; padding: 10px 24px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: all 0.2s;" 
                    onclick="closeDetailsModal()" onmouseover="this.style.background='#334155'; this.style.color='white';" onmouseout="this.style.background='#1e293b'; this.style.color='#94a3b8';">Close</button>
        </div>
    </div>
</div>

<script>
    function showSheetDetails(id) {
        var row = document.getElementById('sheet-row-' + id);
        if(row) {
            var title = row.getAttribute('data-title');
            var category = row.getAttribute('data-category');
            var rating = row.getAttribute('data-rating');
            var comments = row.getAttribute('data-comments');
            var code = row.getAttribute('data-code');
            
            var decodedCode = code.replace(/&quot;/g, '"').replace(/\\n/g, '\n');
            
            document.getElementById('dtId').innerText = '#' + id;
            document.getElementById('dtFullTitle').innerText = title;
            document.getElementById('dtCategory').innerText = category;
            document.getElementById('dtRating').innerText = rating;
            document.getElementById('dtComments').innerText = comments + ' Comments';
            document.getElementById('dtCodeContent').innerText = decodedCode ? decodedCode : '— No Code Content Available —';
            
            document.getElementById('detailsModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
    }
    
    function closeDetailsModal() {
        document.getElementById('detailsModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    
    function copyDetailedCode() {
        var codeText = document.getElementById('dtCodeContent').innerText;
        if(codeText && codeText !== '— No Code Content Available —') {
            navigator.clipboard.writeText(codeText).then(() => {
                alert('✅ Source Code copied to clipboard!');
            });
        } else {
            alert('No code to copy!');
        }
    }

    window.onclick = function(e) {
        var detailsModal = document.getElementById('detailsModal');
        if(e.target == detailsModal) closeDetailsModal();
    }
</script>

</body>
</html>