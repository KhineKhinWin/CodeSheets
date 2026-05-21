<%@ page import="com.cheatsheet.repository.CommentRepository" %>
<%@ page import="com.cheatsheet.model.Comment" %>
<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("loginUser");
    CheatSheet cs = (CheatSheet) request.getAttribute("cheatsheet");
    
    CommentRepository commentRepo = new CommentRepository();
    List<Comment> comments = new ArrayList<>();
    int commentCount = 0;
    
    if (cs != null) {
        comments = commentRepo.getCommentsByCheatsheetId(cs.getId());
        commentCount = commentRepo.getCommentCount(cs.getId());
    }
%>

<div class="comment-section">
    <hr>
    <h3>
        <i class="fa-solid fa-comments"></i> 
        Comments (<%= commentCount %>)
    </h3>
    
    <% if (user != null) { %>
        <div class="add-comment">
            <form action="CommentServlet" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="cheatsheetId" value="<%= cs != null ? cs.getId() : 0 %>">
                <input type="hidden" name="parentId" value="">
                <textarea name="content" rows="3" placeholder="Write a comment..." required></textarea>
                <button type="submit" class="comment-btn">
                    <i class="fa-solid fa-paper-plane"></i> Post Comment
                </button>
            </form>
        </div>
    <% } else { %>
        <div class="login-to-comment">
            <p><a href="login.jsp">Login</a> to leave a comment</p>
        </div>
    <% } %>
    
    <div class="comments-list">
        <% if (comments.isEmpty()) { %>
            <p class="no-comments">No comments yet. Be the first to comment!</p>
        <% } else { %>
            <% for (Comment comment : comments) { %>
                <div class="comment-item" id="comment-<%= comment.getId() %>">
                    <div class="comment-header">
                        <img class="avatar" src="https://ui-avatars.com/api/?name=<%= comment.getUserName() %>&background=22d3ee&color=fff" alt="avatar">
                        <strong><%= comment.getUserName() %></strong>
                        <span class="comment-time">
                            <i class="fa-regular fa-clock"></i>
                            <%= comment.getCreatedAt() %>
                        </span>
                        <% if (user != null && "admin".equalsIgnoreCase(user.getRole())) { %>
                            <a href="CommentServlet?action=delete&commentId=<%= comment.getId() %>&cheatsheetId=<%= cs.getId() %>" 
                               class="delete-comment" 
                               onclick="return confirm('Delete this comment and all replies?')">
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        <% } %>
                        <% if (user != null) { %>
                            <button class="reply-btn" onclick="showReplyForm(<%= comment.getId() %>)">
                                <i class="fa-solid fa-reply"></i> Reply
                            </button>
                        <% } %>
                    </div>
                    <div class="comment-content">
                        <%= comment.getContent().replace("\n", "<br>") %>
                    </div>
                    
                    <div class="reply-form" id="reply-form-<%= comment.getId() %>" style="display:none;">
                        <form onsubmit="submitReply(event, <%= comment.getId() %>, <%= cs.getId() %>)">
                            <textarea name="content" rows="2" placeholder="Write a reply..." required></textarea>
                            <button type="submit" class="reply-submit">Reply</button>
                            <button type="button" class="reply-cancel" onclick="hideReplyForm(<%= comment.getId() %>)">Cancel</button>
                        </form>
                    </div>
                    
                    <% if (comment.getReplies() != null && !comment.getReplies().isEmpty()) { %>
                        <div class="replies">
                            <% for (Comment reply : comment.getReplies()) { %>
                                <div class="reply-item">
                                    <div class="comment-header">
                                        <img class="avatar-small" src="https://ui-avatars.com/api/?name=<%= reply.getUserName() %>&background=818cf8&color=fff" alt="avatar">
                                        <strong><%= reply.getUserName() %></strong>
                                        <span class="comment-time">
                                            <i class="fa-regular fa-clock"></i>
                                            <%= reply.getCreatedAt() %>
                                        </span>
                                    </div>
                                    <div class="comment-content">
                                        <%= reply.getContent().replace("\n", "<br>") %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<script>
    function showReplyForm(commentId) {
        // Hide all reply forms first
        var allForms = document.querySelectorAll('.reply-form');
        for(var i = 0; i < allForms.length; i++) {
            allForms[i].style.display = 'none';
        }
        var form = document.getElementById('reply-form-' + commentId);
        if(form) {
            form.style.display = 'block';
        }
    }

    function hideReplyForm(commentId) {
        var form = document.getElementById('reply-form-' + commentId);
        if(form) {
            form.style.display = 'none';
            var textarea = form.querySelector('textarea');
            if(textarea) textarea.value = '';
        }
    }

    function submitReply(event, parentCommentId, cheatsheetId) {
        event.preventDefault();
        
        var form = document.getElementById('reply-form-' + parentCommentId);
        var content = form.querySelector('textarea[name="content"]').value;
        
        if(!content.trim()) {
            alert("Please enter a reply");
            return;
        }
        
        var formData = new FormData();
        formData.append("action", "add");
        formData.append("cheatsheetId", cheatsheetId);
        formData.append("category", "<%= cs != null ? cs.getCategory() : "Programming" %>");
        formData.append("parentId", parentCommentId);
        formData.append("content", content);
        
        fetch('<%= request.getContextPath() %>/CommentServlet', {
            method: 'POST',
            body: formData
        })
        .then(function(response) {
            if(response.ok) {
                hideReplyForm(parentCommentId);
                location.reload();
            } else {
                alert("Error posting reply");
            }
        })
        .catch(function(error) {
            console.error("Error:", error);
            alert("Error posting reply");
        });
    }
</script>

<style>
    .comment-section {
        margin-top: 30px;
    }
    
    .comment-section h3 {
        color: #38bdf8;
        margin-bottom: 20px;
    }
    
    .add-comment textarea {
        width: 100%;
        padding: 12px;
        border-radius: 10px;
        border: none;
        background: #0f172a;
        color: white;
        font-family: inherit;
        resize: vertical;
    }
    
    .comment-btn {
        background: #38bdf8;
        color: #0f172a;
        padding: 8px 20px;
        border-radius: 8px;
        border: none;
        margin-top: 10px;
        cursor: pointer;
        font-weight: bold;
    }
    
    .login-to-comment {
        background: #0f172a;
        padding: 15px;
        border-radius: 10px;
        text-align: center;
        margin-bottom: 20px;
    }
    
    .login-to-comment a {
        color: #38bdf8;
        text-decoration: none;
    }
    
    .comments-list {
        margin-top: 25px;
        max-height: 500px;
        overflow-y: auto;
    }
    
    .comment-item {
        background: #1e293b;
        padding: 18px;
        border-radius: 12px;
        margin-bottom: 20px;
    }
    
    .comment-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }
    
    .comment-header strong {
        color: #38bdf8;
    }
    
    .avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
    }
    
    .avatar-small {
        width: 24px;
        height: 24px;
        border-radius: 50%;
    }
    
    .comment-time {
        font-size: 11px;
        color: #64748b;
    }
    
    .comment-content {
        color: #cbd5e1;
        line-height: 1.5;
        margin-left: 44px;
        margin-bottom: 10px;
    }
    
    .delete-comment {
        color: #ef4444;
        text-decoration: none;
        margin-left: auto;
    }
    
    .reply-btn {
        background: transparent;
        color: #38bdf8;
        border: none;
        cursor: pointer;
        font-size: 12px;
    }
    
    .reply-btn:hover {
        color: #0ea5e9;
    }
    
    .reply-form {
        margin-top: 15px;
        margin-left: 44px;
    }
    
    .reply-form textarea {
        width: 100%;
        padding: 10px;
        border-radius: 8px;
        background: #0f172a;
        border: 1px solid #334155;
        color: white;
    }
    
    .reply-submit {
        background: #22c55e;
        color: white;
        padding: 6px 15px;
        border: none;
        border-radius: 6px;
        margin-top: 8px;
        cursor: pointer;
    }
    
    .reply-cancel {
        background: #ef4444;
        color: white;
        padding: 6px 15px;
        border: none;
        border-radius: 6px;
        margin-top: 8px;
        margin-left: 8px;
        cursor: pointer;
    }
    
    .replies {
        margin-left: 44px;
        margin-top: 15px;
        padding-left: 15px;
        border-left: 2px solid #334155;
    }
    
    .reply-item {
        background: #0f172a;
        padding: 12px;
        border-radius: 10px;
        margin-bottom: 10px;
    }
    
    .no-comments {
        color: #64748b;
        text-align: center;
        padding: 20px;
    }
</style>