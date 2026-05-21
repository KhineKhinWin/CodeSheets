<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%@ page import="com.cheatsheet.model.User" %>
<%@ page import="com.cheatsheet.repository.RatingRepository" %>
<%@ page import="com.cheatsheet.repository.CommentRepository" %>

<%
    List<CheatSheet> list = (List<CheatSheet>) request.getAttribute("list");
    if(list == null) list = new ArrayList<>();

    String currentCat = (request.getAttribute("type") != null) ? (String) request.getAttribute("type") : "";

    User user = (User) session.getAttribute("loginUser");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }
    
    RatingRepository ratingRepo = new RatingRepository();
    CommentRepository commentRepo = new CommentRepository();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= currentCat %> Cheatsheets</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

<style>
    /* Your existing CSS styles (keep as is) */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); min-height: 100vh; color: #f1f5f9; }
    .header { background: #1e293b; padding: 15px 10%; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #334155; position: sticky; top: 0; z-index: 100; }
    .logo { font-size: 28px; font-weight: bold; color: white; text-decoration: none; display: flex; align-items: center; gap: 8px; }
    .logo span { color: #38bdf8; }
    .search-bar { flex: 1; display: flex; justify-content: center; margin-left: -180px; }
    .search-bar input { width: 450px; padding: 10px 18px; border: 1px solid #334155; outline: none; background: #0f172a; color: white; border-radius: 50px 0 0 50px; font-size: 14px; }
    .search-bar button { padding: 10px 18px; border: none; background: #38bdf8; color: #0f172a; border-radius: 0 50px 50px 0; cursor: pointer; font-weight: bold; }
    .search-bar button:hover { background: #0ea5e9; }
    .sub-nav { background: #0f172a; padding: 0 10%; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #1e293b; }
    .nav-links { display: flex; align-items: center; }
    .nav-links a { color: #94a3b8; text-decoration: none; padding: 12px 18px; display: flex; align-items: center; gap: 6px; font-size: 14px; font-weight: 500; transition: 0.3s; }
    .nav-links a:hover, .nav-links a.active { color: #38bdf8; }
    .logout a { color: #ef4444; text-decoration: none; display: flex; align-items: center; gap: 6px; font-size: 14px; font-weight: 500; }
    .logout a:hover { color: #dc2626; }
    .dropdown { position: relative; }
    .dropdown-content { display: none; position: absolute; top: 100%; left: 0; width: 240px; background: #1e293b; border-radius: 10px; overflow: hidden; z-index: 999; border: 1px solid #334155; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
    .dropdown-content a { padding: 10px 16px; border-bottom: 1px solid #334155; color: #cbd5e1; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.3s; }
    .dropdown-content a:hover { background: #0f172a; color: #38bdf8; }
    .dropdown:hover .dropdown-content { display: block; }
    .main-content { padding: 20px 10% 50px 10%; }
    .page-title { text-align: center; font-size: 32px; margin-bottom: 20px; background: linear-gradient(135deg, #38bdf8, #818cf8); -webkit-background-clip: text; background-clip: text; color: transparent; }
    .stats-bar { background: #1e293b; border: 1px solid #334155; border-radius: 12px; padding: 12px 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
    .stats-count { display: flex; align-items: center; gap: 8px; color: #cbd5e1; font-size: 13px; }
    .stats-count i { font-size: 18px; color: #38bdf8; }
    .stats-count span { font-size: 20px; font-weight: bold; color: #38bdf8; }
    .card-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }
    @media (max-width: 1000px) { .card-container { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 650px) { .card-container { grid-template-columns: 1fr; } .main-content { padding: 20px 5%; } }
    .card { background: #ffffff; border-radius: 24px; overflow: hidden; transition: all 0.35s cubic-bezier(0.2, 0.9, 0.4, 1.1); border: none; display: flex; flex-direction: column; position: relative; box-shadow: 0 10px 30px -5px rgba(0,0,0,0.15); cursor: pointer; }
    .card:hover { transform: translateY(-8px); box-shadow: 0 25px 40px -12px rgba(0,0,0,0.25); }
    .card-cover { height: 160px; position: relative; display: flex; align-items: center; justify-content: center; }
    .cover-programming { background: linear-gradient(135deg, #667eea, #764ba2); }
    .cover-software { background: linear-gradient(135deg, #f093fb, #f5576c); }
    .cover-design { background: linear-gradient(135deg, #4facfe, #00f2fe); }
    .cover-data-science { background: linear-gradient(135deg, #43e97b, #38f9d7); }
    .cover-languages { background: linear-gradient(135deg, #fa709a, #fee140); }
    .cover-education { background: linear-gradient(135deg, #a18cd1, #fbc2eb); }
    .cover-default { background: linear-gradient(135deg, #38bdf8, #0ea5e9); }
    .card-cover-icon { width: 70px; height: 70px; background: rgba(255,255,255,0.25); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; color: white; backdrop-filter: blur(8px); }
    .card-badge { position: absolute; top: 15px; right: 15px; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); color: #facc15; padding: 5px 12px; border-radius: 20px; font-size: 10px; font-weight: 600; z-index: 2; }
    .card-content { padding: 20px; background: white; }
    .card-title { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 10px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 46px; }
    .card-description { color: #64748b; font-size: 13px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 15px; min-height: 38px; }
    .code-preview { background: #f1f5f9; border-radius: 12px; padding: 12px; margin-bottom: 15px; border-left: 3px solid #22c55e; }
    .code-preview-label { display: flex; align-items: center; gap: 6px; color: #22c55e; font-size: 10px; font-weight: 700; margin-bottom: 6px; text-transform: uppercase; }
    .code-preview-text { color: #334155; font-family: monospace; font-size: 11px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    .rating-row { display: flex; align-items: center; gap: 12px; margin-bottom: 15px; flex-wrap: wrap; }
    .rating-stars { display: inline-flex; gap: 3px; }
    .rating-stars i { font-size: 12px; }
    .rating-stars i.fa-solid.fa-star { color: #facc15; }
    .rating-stars i.fa-regular.fa-star { color: #cbd5e1; }
    .rating-value { font-size: 13px; font-weight: 600; color: #facc15; }
    .rating-count { font-size: 11px; color: #94a3b8; }
    .comment-preview { margin: 10px 0; padding: 8px 12px; background: #f1f5f9; border-radius: 10px; font-size: 11px; color: #64748b; display: flex; align-items: center; gap: 6px; }
    .comment-preview i { color: #38bdf8; }
    .btn-view { width: 100%; display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 10px 16px; background: #0f172a; color: white; border: none; border-radius: 14px; cursor: pointer; font-size: 12px; font-weight: 600; margin-top: 10px; transition: all 0.3s ease; }
    .btn-view:hover { background: #38bdf8; color: #0f172a; transform: translateY(-2px); }
    .empty { text-align: center; padding: 60px 20px; background: #1e293b; border-radius: 20px; border: 1px solid #334155; grid-column: 1 / -1; }
    .empty i { font-size: 64px; color: #475569; margin-bottom: 20px; }
    .empty h3 { color: #94a3b8; margin-bottom: 10px; font-size: 20px; }
    .empty p { color: #64748b; font-size: 14px; }
    .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.85); backdrop-filter: blur(5px); }
    .modal-content { background: #1e293b; margin: 5% auto; padding: 0; width: 650px; max-width: 90%; border-radius: 20px; border: 1px solid rgba(56,189,248,0.3); animation: modalFadeIn 0.3s ease; max-height: 85vh; overflow-y: auto; }
    @keyframes modalFadeIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
    .modal-header { padding: 18px 22px; background: linear-gradient(135deg, #0f172a, #1e293b); border-bottom: 1px solid #334155; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; }
    .modal-header h3 { color: #38bdf8; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
    .close-modal { color: #94a3b8; font-size: 26px; cursor: pointer; }
    .close-modal:hover { color: #ef4444; }
    .modal-body { padding: 22px; }
    .desc-box { background: #0f172a; padding: 18px; border-radius: 12px; margin-bottom: 18px; border-left: 4px solid #38bdf8; }
    .code-box { background: #0a0a0f; padding: 18px; border-radius: 12px; margin-bottom: 18px; border-left: 4px solid #22c55e; }
    .code-box pre { color: #86efac; font-family: monospace; font-size: 13px; white-space: pre-wrap; word-wrap: break-word; background: #0a0a0f; margin: 0; }
    .copy-btn { background: #38bdf8; color: #0f172a; border: none; padding: 10px 20px; border-radius: 10px; cursor: pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 15px; }
    .copy-btn:hover { background: #0ea5e9; transform: translateY(-2px); }
    .modal-rating-section { margin-top: 20px; padding-top: 15px; border-top: 1px solid #334155; }
    .modal-rating-title { color: #facc15; font-size: 14px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .star-dropdown { padding: 8px 12px; border-radius: 8px; border: 1px solid #334155; background: #0f172a; color: #facc15; cursor: pointer; }
    .rating-submit-btn { background: #facc15; color: #0f172a; border: none; padding: 8px 16px; border-radius: 8px; font-weight: bold; cursor: pointer; }
    .rating-submit-btn:hover { background: #eab308; }
    .modal-comment-section { margin-top: 20px; padding-top: 15px; border-top: 1px solid #334155; }
    .modal-comment-title { color: #38bdf8; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .modal-comment-section textarea { width: 100%; padding: 10px; border-radius: 10px; border: 1px solid #334155; background: #0f172a; color: white; resize: vertical; }
    .comment-post-btn { background: #22c55e; color: white; border: none; padding: 8px 20px; border-radius: 8px; margin-top: 10px; cursor: pointer; }
    .comment-post-btn:hover { background: #16a34a; }
    .modal-comment-list-section { margin-top: 20px; padding-top: 15px; border-top: 1px solid #334155; }
    .modal-comment-list-section h4 { color: #38bdf8; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-track { background: #0f172a; border-radius: 10px; }
    ::-webkit-scrollbar-thumb { background: #38bdf8; border-radius: 10px; }
    .star-dropdown { padding: 8px 12px; border-radius: 8px; border: 1px solid #334155; background: #0f172a; color: #facc15; cursor: pointer; font-family: 'Font Awesome 6 Free', 'Segoe UI', monospace; font-weight: 900; font-size: 14px; }
    .star-dropdown option { background: #1e293b; color: #facc15; font-family: 'Font Awesome 6 Free', 'Segoe UI', monospace; font-weight: 900; padding: 8px; }
    .reply-box { margin-left: 30px; margin-top: 10px; padding-left: 15px; border-left: 2px solid #38bdf8; }
    .reply-btn { background: none; border: none; color: #38bdf8; cursor: pointer; font-size: 11px; margin-left: 10px; padding: 2px 8px; }
    .reply-btn:hover { text-decoration: underline; }
    .reply-form { margin-top: 8px; display: none; }
    .reply-form textarea { width: 90%; font-size: 12px; padding: 8px; border-radius: 8px; border: 1px solid #334155; background: #0f172a; color: white; }
    .reply-submit-btn { background: #38bdf8; border: none; padding: 5px 12px; border-radius: 6px; margin-top: 5px; cursor: pointer; color: #0f172a; font-weight: bold; font-size: 11px; }
    .reply-submit-btn:hover { background: #0ea5e9; }
    .reply-cancel-btn { background: #ef4444; border: none; padding: 5px 12px; border-radius: 6px; margin-left: 8px; cursor: pointer; color: white; font-size: 11px; font-weight: bold; }
    .reply-cancel-btn:hover { background: #dc2626; }
    .comment-item { transition: all 0.2s ease; background: #0f172a; padding: 12px; border-radius: 8px; margin-bottom: 10px; }
    .comment-item:hover { background: #1a2744 !important; }
    .success-temp { background: #22c55e; color: white; padding: 10px 15px; border-radius: 10px; margin-bottom: 15px; text-align: center; animation: fadeOut 3s ease forwards; }
    @keyframes fadeOut { 0% { opacity: 1; } 70% { opacity: 1; } 100% { opacity: 0; display: none; } }
</style>

<script>
    var currentCheatsheetId = null;
    var currentCategory = '<%= currentCat %>' || 'All';
    
    // ၁။ MODAL ဖွင့်ပြီး DATA များ ထည့်သွင်းပေးသည့် အပိုင်း
    function viewDetails(id) {
        console.log("viewDetails called - ID: " + id);
        currentCheatsheetId = id;
        
        // Modal အတွင်းရှိ Hidden input fields အားလုံးကို ID ဖြည့်ပေးခြင်း
        var modalCheatsheetId = document.getElementById('modalCheatsheetId');
        if(modalCheatsheetId) modalCheatsheetId.value = id;
        
        var modalCommentCheatsheetId = document.getElementById('modalCommentCheatsheetId');
        if(modalCommentCheatsheetId) modalCommentCheatsheetId.value = id;
        
        var formCheatsheetField = document.querySelector('#mainCommentForm input[name="cheatsheetId"]');
        if(formCheatsheetField) formCheatsheetField.value = id;
        
        var card = document.querySelector('.card[data-id="' + id + '"]');
        
        if(card) {
            var title = card.querySelector('.card-title').innerText;
            var description = card.querySelector('.card-description').innerText;
            var fullCode = card.getAttribute('data-full-code');
            var exampleCode = (fullCode && fullCode !== '' && fullCode !== 'null') ? fullCode : 'No example code available';
            exampleCode = exampleCode.replace(/&quot;/g, '"');
            
            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-code"></i> ' + escapeHtml(title);
            document.getElementById('modalDescription').innerHTML = escapeHtml(description).replace(/\n/g, '<br>');
            document.getElementById('modalContent').innerHTML = '<pre style="margin:0; white-space:pre-wrap;">' + escapeHtml(exampleCode) + '</pre>';
            
            document.getElementById('detailsModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
            
            loadComments(id);
        } else {
            alert("Error: Could not load cheatsheet data");
        }
    }
    
    // ၂။ COMMENT များဆွဲထုတ်ပြီး ဖော်ပြပေးသည့် အပိုင်း
    function loadComments(cheatsheetId) {
        console.log("Loading comments for cheatsheet:", cheatsheetId);
        
        var listDiv = document.getElementById('commentListInModal');
        var countSpan = document.getElementById('commentCountInModal');
        
        if(!listDiv) return;
        
        listDiv.innerHTML = '<div style="text-align:center; padding:20px;"><i class="fa-solid fa-spinner fa-spin"></i> Loading comments...</div>';
        
        fetch('CommentServlet?action=get&cheatsheetId=' + cheatsheetId)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if(countSpan) countSpan.innerText = '(' + data.length + ')';
                if(data.length === 0) {
                    listDiv.innerHTML = '<p style="color:#64748b; text-align:center; padding:20px;">No comments yet. Be the first!</p>';
                } else {
                    var commentTree = buildCommentTree(data);
                    listDiv.innerHTML = renderCommentTree(commentTree, cheatsheetId);
                }
            })
            .catch(function(error) {
                listDiv.innerHTML = '<p style="color:#ef4444; text-align:center; padding:20px;">Error loading comments.</p>';
            });
    }
    
    function buildCommentTree(comments) {
        var map = {}, roots = [];
        if(!comments || comments.length === 0) return roots;
        
        for(var i = 0; i < comments.length; i++) {
            var c = comments[i];
            map[c.id] = { id: c.id, userName: c.userName, content: c.content, createdAt: c.createdAt, parent_comment_id: c.parent_comment_id, replies: [] };
        }
        
        for(var i = 0; i < comments.length; i++) {
            var c = comments[i];
            if(c.parent_comment_id && map[c.parent_comment_id]) {
                map[c.parent_comment_id].replies.push(map[c.id]);
            } else {
                roots.push(map[c.id]);
            }
        }
        
        roots.sort(function(a,b) { return new Date(a.createdAt) - new Date(b.createdAt); });
        return roots;
    }
    
    function renderCommentTree(comments, cheatsheetId) {
        if(!comments || comments.length === 0) return '';
        var html = '';
        for(var i = 0; i < comments.length; i++) {
            html += renderSingleComment(comments[i], cheatsheetId);
        }
        return html;
    }
    
    function renderSingleComment(comment, cheatsheetId) {
        var createdAt = comment.createdAt || '';
        var userName = comment.userName || 'User';
        var content = comment.content || '';
        var commentId = comment.id;
        var replies = comment.replies || [];
        
        var formattedDate = '';
        if(createdAt) {
            try { formattedDate = new Date(createdAt).toLocaleString(); } catch(e) { formattedDate = createdAt; }
        }
        
        var html = '<div class="comment-item" data-comment-id="' + commentId + '" data-cheatsheet-id="' + cheatsheetId + '">' +
                    '<div style="display:flex; justify-content:space-between; margin-bottom:5px; flex-wrap:wrap;">' +
                        '<strong style="color:#38bdf8;"><i class="fa-solid fa-user"></i> ' + escapeHtml(userName) + '</strong>' +
                        '<small style="color:#64748b;"><i class="fa-regular fa-clock"></i> ' + escapeHtml(formattedDate) + '</small>' +
                    '</div>' +
                    '<p style="color:#cbd5e1; margin:8px 0 10px 0; line-height:1.5;">' + escapeHtml(content).replace(/\n/g, '<br>') + '</p>' +
                    '<button class="reply-btn" onclick="showReplyForm(' + commentId + ')"><i class="fa-solid fa-reply"></i> Reply</button>' +
                    '<div id="reply-form-' + commentId + '" class="reply-form" style="display:none; margin-top:10px;">' +
                        '<textarea id="reply-content-' + commentId + '" rows="2" placeholder="Write your reply..." style="width:100%; padding:8px; border-radius:8px; border:1px solid #334155; background:#0f172a; color:white;"></textarea>' +
                        '<div style="margin-top:8px;">' +
                            '<button class="reply-submit-btn" onclick="submitReply(' + commentId + ')">Post Reply</button>' +
                            '<button class="reply-cancel-btn" onclick="hideReplyForm(' + commentId + ')">Cancel</button>' +
                        '</div>' +
                    '</div>';
        
        if(replies.length > 0) {
            html += '<div class="reply-box">';
            for(var i = 0; i < replies.length; i++) {
                html += renderSingleComment(replies[i], cheatsheetId);
            }
            html += '</div>';
        }
        html += '</div>';
        return html;
    }
    
    // ၃။ REPLY ပေးသည့် စနစ်ထိန်းချုပ်မှုများ
    function showReplyForm(commentId) {
        var allForms = document.querySelectorAll('.reply-form');
        for(var i = 0; i < allForms.length; i++) allForms[i].style.display = 'none';
        var form = document.getElementById('reply-form-' + commentId);
        if(form) {
            form.style.display = 'block';
            var ta = document.getElementById('reply-content-' + commentId);
            if(ta) ta.focus();
        }
    }

    function hideReplyForm(commentId) {
        var form = document.getElementById('reply-form-' + commentId);
        if(form) {
            form.style.display = 'none';
            var ta = document.getElementById('reply-content-' + commentId);
            if(ta) ta.value = '';
        }
    }
    
    function submitReply(commentId) {
        var content = document.getElementById('reply-content-' + commentId).value;
        var cheatsheetId = document.getElementById('modalCheatsheetId').value || currentCheatsheetId;
        
        if(!cheatsheetId) { alert('Missing cheatsheet ID'); return; }
        if(!content.trim()) { alert('Please enter reply'); return; }
        
        var params = new URLSearchParams();
        params.append('action', 'add');
        params.append('cheatsheetId', cheatsheetId);
        params.append('parent_comment_id', commentId);
        params.append('content', content.trim());
        
        fetch('CommentServlet', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString() })
            .then(function(r) { return r.json(); })
            .then(function(d) {
                if(d.success) {
                    document.getElementById('reply-content-' + commentId).value = '';
                    hideReplyForm(commentId);
                    loadComments(cheatsheetId);
                    showSuccessMessage('Reply posted!');
                } else { alert('Failed: ' + (d.error || 'Unknown')); }
            })
            .catch(function(e) { console.error(e); alert('Error posting reply'); });
    }
    
    

 // ===================================================
 // 🔄 FORMS EVENT LISTENERS (UNIFIED & CLEANED)
 // ===================================================
 document.addEventListener('DOMContentLoaded', function() {
     console.log("Unified Forms Handlers Initialized.");

     // (က) MAIN COMMENT FORM SUBMIT (URLSearchParams အသုံးပြုထားသည်)
     var commentForm = document.getElementById('mainCommentForm');
     if (commentForm) {
         commentForm.addEventListener('submit', function(e) {
             e.preventDefault();
             
             // ID ကို နေရာစုံမှ ရှာဖွေရယူခြင်း
             var cheatsheetId = document.getElementById('modalCommentCheatsheetId').value || currentCheatsheetId;
             var content = document.getElementById('mainCommentContent').value;
             
             if (!cheatsheetId) {
                 alert("Error: Cheatsheet ID မရှိပါ။ ကျေးဇူးပြု၍ မော်ဒယ်ကို ပိတ်ပြီး ပြန်ဖွင့်ပါ။");
                 return;
             }
             
             // Backend သို့ ပို့ရန် Parameters များ ပြင်ဆင်ခြင်း
             var params = new URLSearchParams();
             params.append('action', 'add');
             params.append('cheatsheetId', cheatsheetId);
             params.append('content', content.trim());
             
             var btn = this.querySelector('button[type="submit"]');
             if (btn) btn.disabled = true;
             
             fetch('CommentServlet', { 
                 method: 'POST', 
                 headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, 
                 body: params.toString() 
             })
             .then(function(res) { return res.json(); })
             .then(function(data) {
                 if (btn) btn.disabled = false;
                 if (data.success) {
                     document.getElementById('mainCommentContent').value = ''; // တက်စ်ဧရိယာ ရှင်းလင်းခြင်း
                     loadComments(cheatsheetId); // Comment စာရင်းအား Dynamic Refresh လုပ်ခြင်း
                     showSuccessMessage('Comment posted successfully!');
                 } else {
                     alert('Failed to post comment: ' + (data.error || 'Unknown backend error'));
                 }
             })
             .catch(function(err) {
                 if (btn) btn.disabled = false;
                 console.error(err);
                 alert('Network Error ကြောင့် Comment ပေး၍မရပါ။');
             });
         });
     }

     // (ခ) RATING FORM SUBMIT (REDIRECTS TO CATEGORY PAGE)
     var ratingForm = document.getElementById('category');
     if (ratingForm) {
         ratingForm.addEventListener('submit', function(e) {
             e.preventDefault();
             
             var cheatsheetId = document.getElementById('modalCheatsheetId').value || currentCheatsheetId;
             var rating = document.getElementById('ratingSelect').value;
             var category = document.getElementById('modalCategory').value || currentCategory;
             
             if (!cheatsheetId) { 
                 alert('Missing Cheatsheet ID'); 
                 return; 
             }
             
             var btn = this.querySelector('button[type="submit"]');
             if (btn) btn.disabled = true;
             
             var params = new URLSearchParams();
             params.append('cheatsheetId', cheatsheetId);
             params.append('rating', rating);
             
             fetch('rate', { 
                 method: 'POST', 
                 headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, 
                 body: params.toString() 
             })
             .then(function(r) { return r.json(); })
             .then(function(data) {
                 if (btn) btn.disabled = false;
                 if (data.success) {
                     window.location.href = 'category?name=' + encodeURIComponent(category);
                 } else {
                     alert('Rating failed: ' + data.error);
                 }
             })
             .catch(function(e) { 
                 if (btn) btn.disabled = false; 
                 alert('Error rating.'); 
             });
         });
     }
 }); // 🛑 DOMContentLoaded အပိတ် ကွင်းစကွင်းပိတ် အတိအကျဖြစ်သည်
    // ၅။ အထွေထွေ UTILITY FUNCTIONS (CLOSE, COPY, ESCAPE HTML)
    function showSuccessMessage(message) {
        var section = document.querySelector('.modal-comment-list-section');
        if(section) {
            var old = section.querySelector('.success-temp');
            if(old) old.remove();
            var msg = document.createElement('div');
            msg.className = 'success-temp';
            msg.innerHTML = '<i class="fa-solid fa-check-circle"></i> ' + message;
            section.insertBefore(msg, section.firstChild);
            setTimeout(function() { if(msg) msg.remove(); }, 3000);
        }
    }
    
    function closeModal() {
        document.getElementById('detailsModal').style.display = 'none';
        document.body.style.overflow = 'auto';
        currentCheatsheetId = null;
    }
    
    function copyCode() {
        var code = document.getElementById('modalContent').innerText;
        if(code && code !== 'No example code available') {
            navigator.clipboard.writeText(code).then(function() { alert('Code copied!'); });
        } else { alert('No code to copy!'); }
    }
    
    function escapeHtml(str) {
        if(!str) return '';
        return str.replace(/[&<>]/g, function(m) {
            if(m === '&') return '&amp;';
            if(m === '<') return '&lt;';
            if(m === '>') return '&gt;';
            return m;
        });
    }
    
    window.onclick = function(e) {
        var modal = document.getElementById('detailsModal');
        if(e.target == modal) closeModal();
    }
    
    
</script>

</head>
<body>

<!-- ========== HEADER ==========

<!-- ========== HEADER ========== -->
<header class="header">
    <a href="homepage" class="logo"><i class="fa-solid fa-code"></i> Cheat<span>Sheets</span></a>
    <form action="searchCheatsheet" method="get" class="search-bar">
        <input type="text" name="keyword" placeholder="Search...">
        <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
    </form>
</header>

<!-- ========== NAVBAR ========== -->
<nav class="sub-nav">
    <div class="nav-links">
        <a href="homepage"><i class="fa-solid fa-house"></i> Home</a>
        <div class="dropdown">
            <a href="#" class="active"><i class="fa-solid fa-book"></i> Cheat Sheets</a>
            <div class="dropdown-content">
                <a href="userAllCheat?name=Programming"><i class="fa-solid fa-code"></i> Programming</a>
                <a href="userAllCheat?name=Software"><i class="fa-solid fa-laptop-code"></i> Software</a>
                <a href="userAllCheat?name=Design"><i class="fa-solid fa-pen-ruler"></i> Design</a>
                <a href="userAllCheat?name=Data Science"><i class="fa-solid fa-chart-line"></i> Data Science</a>
                <a href="userAllCheat?name=Languages"><i class="fa-solid fa-language"></i> Languages</a>
                <a href="userAllCheat?name=Education"><i class="fa-solid fa-graduation-cap"></i> Education</a>
            </div>
        </div>
        <a href="create_cheat"><i class="fa-solid fa-pen-to-square"></i> Create</a>
        <a href="myCheats"><i class="fa-solid fa-user"></i> My Cheats</a>
        <a href="help.jsp"><i class="fa-solid fa-circle-question"></i> Help</a>
    </div>
    <div class="logout"><a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></div>
</nav>

<!-- ========== MAIN CONTENT ========== -->
<div class="main-content">
    <h1 class="page-title"><i class="fa-solid fa-layer-group"></i> <%= currentCat %> Cheatsheets</h1>

    <div class="stats-bar">
        <div class="stats-count"><i class="fa-solid fa-book-open"></i><div><span><%= list.size() %></span> Cheat Sheets Found</div></div>
        <div class="stats-count"><i class="fa-solid fa-tag"></i><div>Category: <strong style="color:#38bdf8"><%= currentCat %></strong></div></div>
    </div>

    <div class="card-container">
        <% if(list.size() > 0){
            for(CheatSheet c : list){
                double avgRating = 0;
                int ratingCount = 0;
                int commentCount = 0;
                try {
                    avgRating = ratingRepo.getAverageRating(c.getId());
                    ratingCount = ratingRepo.getRatingCount(c.getId());
                    commentCount = commentRepo.getCommentCount(c.getId());
                } catch(Exception e) { e.printStackTrace(); }
                
                String coverClass = "cover-default";
                if(c.getCategory() != null) {
                    switch(c.getCategory()) {
                        case "Programming": coverClass = "cover-programming"; break;
                        case "Software": coverClass = "cover-software"; break;
                        case "Design": coverClass = "cover-design"; break;
                        case "Data Science": coverClass = "cover-data-science"; break;
                        case "Languages": coverClass = "cover-languages"; break;
                        case "Education": coverClass = "cover-education"; break;
                    }
                }
                int fullStars = (int) Math.round(avgRating);
                
                String fullCode = c.getExampleCode() != null ? c.getExampleCode() : "";
                String escapedFullCode = fullCode.replace("\"", "&quot;");
        %>
            <div class="card" data-id="<%= c.getId() %>" data-full-code="<%= escapedFullCode %>">
                <div class="card-cover <%= coverClass %>">
                    <div class="card-cover-icon"><i class="fa-solid fa-file-code"></i></div>
                    <div class="card-badge"><i class="fa-solid fa-tag"></i> <%= c.getCategory() != null ? c.getCategory() : "General" %></div>
                </div>
                <div class="card-content">
                    <h3 class="card-title"><%= c.getTitle() %></h3>
                    <p class="card-description"><%= c.getContent().length() > 100 ? c.getContent().substring(0, 100) + "..." : c.getContent() %></p>
                    
                    <% if(c.getExampleCode() != null && !c.getExampleCode().isEmpty()) { %>
                        <div class="code-preview">
                            <div class="code-preview-label"><i class="fa-solid fa-code"></i> Example Code</div>
                            <div class="code-preview-text"><%= c.getExampleCode().length() > 70 ? c.getExampleCode().substring(0, 70) + "..." : c.getExampleCode() %></div>
                        </div>
                    <% } %>
                    
                    <div class="rating-row">
                        <div class="rating-stars">
                            <% for(int i = 1; i <= 5; i++) { %>
                                <% if(i <= fullStars) { %>
                                    <i class="fa-solid fa-star"></i>
                                <% } else { %>
                                    <i class="fa-regular fa-star"></i>
                                <% } %>
                            <% } %>
                        </div>
                        <span class="rating-value"><%= String.format("%.1f", avgRating) %></span>
                        <span class="rating-count">(<%= ratingCount %>)</span>
                    </div>
                    
                    <div class="comment-preview">
                        <i class="fa-solid fa-comment"></i> 
                        <span>Comments: <span id="commentCount-<%= c.getId() %>"><%= commentCount %></span></span>
                    </div>
                    
                    <button class="btn-view" onclick="viewDetails(<%= c.getId() %>)">
                        <i class="fa-solid fa-eye"></i> View Details
                    </button>
                </div>
            </div>
        <% } } else { %>
            <div class="empty"><i class="fa-regular fa-folder-open"></i><h3>No Cheat Sheets Found</h3><p>There are no cheat sheets in this category yet.</p></div>
        <% } %>
    </div>
</div>

<!-- Modal Template အပိုင်း -->
<div id="detailsModal" class="modal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 id="modalTitle">Cheatsheet Details</h3>
      <span class="close-modal" onclick="closeModal()">&times;</span>
    </div>
    
    <div class="modal-body">
      <!-- Description & Code Box -->
      <div id="modalDescription" class="desc-box"></div>
      <button class="copy-btn" onclick="copyCode()"><i class="fa-solid fa-copy"></i> Copy Code</button>
      <div id="modalContent" class="code-box"></div>

      <!-- ၁။ Rating Form အပိုင်း -->
      <div class="modal-rating-section">
        <h4 class="modal-rating-title"><i class="fa-solid fa-star"></i> Rate this Cheatsheet</h4>
        <form id="category">
          <!-- ⭐ အရေးကြီးဆုံး ID field (Rating အတွက်) -->
          <input type="hidden" id="modalCheatsheetId" name="cheatsheetId" value="" />
          <input type="hidden" id="modalCategory" name="category" value="<%= currentCat %>" />
          
          <select id="ratingSelect" class="star-dropdown">
            <option value="5">&#xf005; &#xf005; &#xf005; &#xf005; &#xf005; </option>
            <option value="4">&#xf005; &#xf005; &#xf005; &#xf005; </option>
            <option value="3">&#xf005; &#xf005; &#xf005; </option>
            <option value="2">&#xf005; &#xf005; </option>
            <option value="1">&#xf005;</option>
          </select>
          <button type="submit" class="rating-submit-btn">Submit Rating</button>
        </form>
      </div>

      <!-- ၂။ Comment Form အပိုင်း -->
      <div class="modal-comment-section">
        <h4 class="modal-comment-title"><i class="fa-solid fa-comment"></i> Leave a Comment</h4>
        <form id="mainCommentForm">
          <!-- 💬 အရေးကြီးဆုံး ID field (Comment အတွက်) -->
          <input type="hidden" id="modalCommentCheatsheetId" name="cheatsheetId" value="" />
          <input type="hidden" name="action" value="add" />
          
          <textarea name="content" id="mainCommentContent" rows="3" placeholder="Share your thoughts about this cheatsheet..." required></textarea>
          <button type="submit" class="comment-post-btn">Post Comment</button>
        </form>
      </div>

      <!-- ၃။ Comment List ပြသမည့် နေရာ -->
      <div class="modal-comment-list-section">
        <h4>Comments <span id="commentCountInModal">(0)</span></h4>
        <div id="commentListInModal"></div>
      </div>

    </div>
  </div>
</div>

</body>
</html>