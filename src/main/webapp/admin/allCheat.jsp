<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.repository.RatingRepository" %>
<%@ page import="com.cheatsheet.repository.CommentRepository" %>

<%
    List<CheatSheet> list =
        (List<CheatSheet>) request.getAttribute("list");

    if(list == null){
        list = new ArrayList<>();
    }

    String currentType = request.getParameter("type");
    if(currentType == null) currentType = "";
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
    <meta charset="UTF-8">
    <title>All Cheat Sheets | Repository</title>

    <style>
        /* Global Style */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0f172a;
            color: #e2e8f0;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 85%;
            max-width: 1000px;
            margin: 50px auto;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #f8fafc;
            font-size: 2.5rem;
            margin-bottom: 40px;
            letter-spacing: 1px;
        }

        /* Card Design */
        .card {
            background: #1e293b;
            padding: 30px;
            margin-bottom: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            border: 1px solid #334155;
            transition: transform 0.3s ease, border-color 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            border-color: #38bdf8;
        }

        /* Category Badge */
        .category-badge {
            display: inline-block;
            background: #0ea5e926;
            color: #38bdf8;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
            border: 1px solid #38bdf84d;
        }

        h2 {
            color: #fbbf24;
            margin: 0 0 15px 0;
            font-size: 22px;
        }

        /* Content Box */
        .content-box {
            background: #0f172a;
            padding: 20px;
            border-radius: 10px;
            color: #cbd5e1;
            line-height: 1.8;
            font-family: 'Consolas', 'Monaco', monospace;
            white-space: pre-wrap;
            border-left: 4px solid #38bdf8;
            font-size: 15px;
            overflow-x: auto;
        }

        /* ✅ Example Code Block */
        .example-box {
            margin-top: 20px;
        }
        
        .code-block {
            background: #0f172a;
            padding: 15px;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            line-height: 1.6;
            color: #cbd5e1;
            white-space: pre-wrap;
            word-wrap: break-word;
            overflow-x: auto;
            border-left: 4px solid #facc15;
            max-height: 300px;
            overflow-y: auto;
        }

        /* No Data Style */
        .no-data {
            text-align: center;
            padding: 100px;
            color: #64748b;
            font-size: 1.2rem;
        }
        
        /* CATEGORY TABS */
        .category-tabs {
            display: flex;
            justify-content: center;
            gap: 18px;
            padding: 25px;
            background: #1e293b;
            border-bottom: 1px solid #334155;
            overflow-x: auto;
        }

        .tab-btn {
            text-decoration: none;
            background: #334155;
            color: #cbd5e1;
            padding: 14px 28px;
            border-radius: 40px;
            font-weight: 600;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .tab-btn:hover {
            background: #38bdf8;
            color: white;
            transform: translateY(-3px);
        }

        .tab-btn.active {
            background: #0ea5e9;
            color: white;
            box-shadow: 0 5px 15px rgba(14,165,233,0.4);
        }
        
        .btn-home {
            background: #22d3ee;
            color: #0f172a;
            padding: 10px 15px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            margin: 15px;
            margin-left:250px;
            margin-right:12px;
        }

        .btn-home:hover {
            background: #06b6d4;
            
        }
        .page-title {
        margin-bottom: 25px;
        color: gold;
         margin-left:250px;
         margin-right:12px;
    }
    </style>
</head>

<body>
<a href="<%= request.getContextPath() %>/adminDashboard" class="btn-home">
     <i class="fa-solid fa-arrow-left"></i> Back to Home
</a>
<h2 class="page-title">
        <i class="fa-solid fa-code"></i> CheatSheets
    </h2>

<!-- CATEGORY TABS -->
<div class="category-tabs">
    <a href="allCheatSheets" class="tab-btn">All</a>
    <a href="allCheatSheets?type=Programming" class="tab-btn">Programming</a>
    <a href="allCheatSheets?type=Software" class="tab-btn">Software</a>
    <a href="allCheatSheets?type=Design" class="tab-btn">Design</a>
    <a href="allCheatSheets?type=Data Science" class="tab-btn">Data Science</a>
    <a href="allCheatSheets?type=Languages" class="tab-btn">Languages</a>
    <a href="allCheatSheets?type=Education" class="tab-btn">Education</a>
</div>

<div class="container">
    <% if(list.isEmpty()) { %>
        <div class="no-data">
            <p>No cheat sheets available at the moment.</p>
        </div>
    <% } %>

    <% for(CheatSheet c : list){ %>
        <div class="card">
            <div class="category-badge">
                <i class="fa-solid fa-tag"></i> <%= c.getCategory() %>
            </div>

            <h2><%= c.getTitle() %></h2>

            <div class="content-box">
                <strong>Description:</strong><br>
                <%= c.getContent() %>
            </div>
            
             <!-- ✅ Rating Section -->
    <div class="rating-section" style="margin: 15px 0; padding: 10px; background: #0f172a; border-radius: 8px;">
        <div style="display: flex; align-items: center; gap: 10px;">
            <div class="rating-stars" id="adminRatingStars-<%= c.getId() %>">
                <%-- Stars will be loaded via JS --%>
            </div>
            <span id="adminRatingValue-<%= c.getId() %>">0.0</span>
            <span class="rating-count">(<span id="adminRatingCount-<%= c.getId() %>">0</span>)</span>
        </div>
    </div>

    <!-- ✅ Comment Section -->
    <div class="comment-section-admin" style="margin: 15px 0;">
        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
            <i class="fa-solid fa-comment"></i>
            <strong>Comments: <span id="adminCommentCount-<%= c.getId() %>">0</span></strong>
        </div>
        <div id="adminCommentList-<%= c.getId() %>" style="background: #0f172a; padding: 10px; border-radius: 8px; font-size: 12px; max-height: 100px; overflow-y: auto;">
            <span style="color: #64748b;">Loading comments...</span>
        </div>
    </div>
            

            <!-- ✅ Example Code Section -->
            <div class="example-box">
                <strong style="color: #38bdf8; display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <i class="fa-solid fa-code"></i> Example Code:
                </strong>
                <div class="code-block">
                    <%= c.getExampleCode() != null && !c.getExampleCode().isEmpty() ? c.getExampleCode() : "⚠️ No example code provided for this cheatsheet." %>
                </div>
            </div>
        </div>
    <% } %>
</div>
<script>
    // Load ratings for all cards
    function loadAdminRatings() {
        <%
            RatingRepository ratingRepo = new RatingRepository();
            CommentRepository commentRepo = new CommentRepository();
            for(CheatSheet c : list) {
                double avg = ratingRepo.getAverageRating(c.getId());
                int count = ratingRepo.getRatingCount(c.getId());
        %>
        (function() {
            var id = <%= c.getId() %>;
            var avg = <%= avg %>;
            var count = <%= count %>;
            
            // Update rating value
            var valSpan = document.getElementById('adminRatingValue-' + id);
            if(valSpan) valSpan.innerText = avg.toFixed(1);
            
            // Update rating count
            var countSpan = document.getElementById('adminRatingCount-' + id);
            if(countSpan) countSpan.innerText = count;
            
            // Update stars
            var starsDiv = document.getElementById('adminRatingStars-' + id);
            if(starsDiv) {
                var fullStars = Math.round(avg);
                var html = '';
                for(var i = 1; i <= 5; i++) {
                    if(i <= fullStars) {
                        html += '<i class="fa-solid fa-star" style="color: #facc15; font-size: 12px;"></i>';
                    } else {
                        html += '<i class="fa-regular fa-star" style="color: #475569; font-size: 12px;"></i>';
                    }
                }
                starsDiv.innerHTML = html;
            }
        })();
        <%
            }
        %>
    }
    
    // Load comments for all cards
    function loadAdminComments() {
        <%
            for(CheatSheet c : list) {
        %>
        (function() {
            var id = <%= c.getId() %>;
            fetch('CommentServlet?action=get&cheatsheetId=' + id)
                .then(response => response.json())
                .then(data => {
                    var countSpan = document.getElementById('adminCommentCount-' + id);
                    if(countSpan) countSpan.innerText = data.length;
                    
                    var listDiv = document.getElementById('adminCommentList-' + id);
                    if(listDiv) {
                        if(data.length === 0) {
                            listDiv.innerHTML = '<span style="color: #64748b;">No comments yet</span>';
                        } else {
                            var html = '';
                            for(var i = 0; i < data.length; i++) {
                                var comment = data[i];
                                html += '<div style="padding: 5px 0; border-bottom: 1px solid #334155;">' +
                                            '<strong style="color: #38bdf8;">' + (comment.userName || 'User') + ':</strong> ' +
                                            '<span>' + (comment.content || '') + '</span>' +
                                        '</div>';
                            }
                            listDiv.innerHTML = html;
                        }
                    }
                })
                .catch(error => console.error('Error:', error));
        })();
        <%
            }
        %>
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        loadAdminRatings();
        loadAdminComments();
    });
</script>

</body>
</html>