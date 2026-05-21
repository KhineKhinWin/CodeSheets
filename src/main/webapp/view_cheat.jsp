<%@ page import="com.cheatsheet.model.CheatSheet" %>

<%
CheatSheet c = (CheatSheet) request.getAttribute("cheat");

if (c == null) {
    response.sendRedirect("community");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= c.getTitle() %> | CheatSheet</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>

body{
    margin:0;
    font-family: 'Segoe UI', sans-serif;
    background:#f1f5f9;
}

/* TOP BAR */
.topbar{
    background:#0f172a;
    padding:15px 10%;
    color:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.topbar a{
    color:white;
    text-decoration:none;
    font-size:16px;
}

.topbar a:hover{
    color:#38bdf8;
}

/* CONTAINER */
.container{
    max-width:900px;
    margin:40px auto;
    background:white;
    padding:40px;
    border-radius:14px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
}

/* TITLE */
.title{
    font-size:32px;
    font-weight:bold;
    color:#0f172a;
    margin-bottom:10px;
}

/* BADGE */
.badge{
    display:inline-block;
    padding:5px 12px;
    border-radius:20px;
    font-size:12px;
    margin-bottom:20px;
    background:#e0f2fe;
    color:#0284c7;
}

/* CONTENT */
.content{
    font-size:16px;
    line-height:1.8;
    color:#334155;
    white-space:pre-wrap;
}

/* BACK BUTTON */
.back{
    margin-top:30px;
}

.back a{
    text-decoration:none;
    color:#64748b;
    font-weight:500;
}

.back a:hover{
    color:#0ea5e9;
}

</style>

</head>

<body>

<!-- TOP BAR -->
<div class="topbar">

    <a href="community">
        <i class="fa-solid fa-arrow-left"></i>
        Back
    </a>

    <div>
        CheatSheet Viewer
    </div>

</div>

<!-- MAIN CONTENT -->
<div class="container">

    <div class="title"><%= c.getTitle() %></div>

    <% if(c.getIsPublic() == 1){ %>
        <span class="badge">Public</span>
    <% } else { %>
        <span class="badge" style="background:#fee2e2;color:#ef4444;">
            Private
        </span>
    <% } %>

    <div class="content">
        <%= c.getContent() %>
    </div>

    <div class="back">
        <a href="community">
            <i class="fa-solid fa-chevron-left"></i>
            Back to Community
        </a>
    </div>

</div>

</body>
</html>