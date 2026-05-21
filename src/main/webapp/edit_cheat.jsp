<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.Category" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>

<%
CheatSheet cheat = (CheatSheet) request.getAttribute("cheat");

if (cheat == null) {
    response.sendRedirect("myCheats");
    return;
}

List<Category> categories =
    (List<Category>) request.getAttribute("categories");

if (categories == null) {
    categories = new ArrayList<>();
}
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<meta charset="UTF-8">
<title>Edit Cheatsheet</title>

<style>
body{
    margin:0;
    font-family: Arial, sans-serif;
    background: linear-gradient(135deg,#dbeafe,#f8fafc);
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.box{
    width:550px;
    background:white;
    padding:35px;
    border-radius:18px;
    box-shadow:0 10px 30px rgba(0,0,0,0.15);
}

h2{
    text-align:center;
    margin-bottom:5px;
    color:#0f172a;
}

.line{
    width:70px;
    height:4px;
    background:#0ea5e9;
    margin:10px auto 25px;
    border-radius:10px;
}

label{
    font-weight:bold;
    display:block;
    margin-top:15px;
    margin-bottom:6px;
    color:#334155;
}

input, textarea, select{
    width:100%;
    padding:12px;
    border-radius:10px;
    border:1px solid #cbd5e1;
    outline:none;
    font-size:15px;
    background:#f8fafc;
}

input:focus,
textarea:focus,
select:focus{
    border-color:#0ea5e9;
    background:white;
    box-shadow:0 0 8px rgba(14,165,233,0.3);
}

textarea{
    resize:none;
}

button{
    width:100%;
    margin-top:20px;
    padding:14px;
    border:none;
    border-radius:12px;
    background:linear-gradient(to right,#0ea5e9,#0284c7);
    color:white;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
    transition:0.3s;
}

button:hover{
    transform:translateY(-2px);
    opacity:0.9;
}

.back{
    text-align:center;
    margin-top:15px;
}

.back a{
    color:#64748b;
    text-decoration:none;
}

.back a:hover{
    color:#0ea5e9;
}

.hint{
    font-size: 12px;
    color: #64748b;
    margin-top: 5px;
}
</style>

</head>

<body>

<div class="box">

    <h2>Edit Cheatsheet</h2>
    <div class="line"></div>

    <form action="edit_cheat" method="post">

    <input type="hidden"
           name="id"
           value="<%= cheat.getId() %>">

    <label>Title</label>
    <input type="text"
           name="title"
           value="<%= cheat.getTitle() %>"
           required>

    <label>Select Category</label>
    <select name="categoryId" required>
        <option value="">Choose Category</option>
        <%
            for (Category cat : categories) {
        %>
        <option value="<%= cat.getId() %>"
            <%= (cat.getId() == cheat.getCategoryId()) ? "selected" : "" %>>
            <%= cat.getName() %>
        </option>
        <%
            }
        %>
    </select>

    <label>Content</label>
    <textarea name="content" rows="5" required><%= cheat.getContent() %></textarea>

    <!-- ✅ EXAMPLE CODE - အသစ်ထည့် -->
    <label>Example Code (Optional)</label>
    <textarea name="example_code" 
              rows="6"
              style="font-family: 'Courier New', monospace;"><%= cheat.getExampleCode() != null ? cheat.getExampleCode() : "" %></textarea>
    <div class="hint">
        
    </div>

    <label>Visibility</label>
    <select name="status">
        <option value="PUBLIC"
            <%= ("PUBLIC".equalsIgnoreCase(cheat.getStatus())) ? "selected" : "" %>>
            Public
        </option>
        <option value="PRIVATE"
            <%= ("PRIVATE".equalsIgnoreCase(cheat.getStatus())) ? "selected" : "" %>>
            Private
        </option>
    </select>

    <button type="submit">
        Update Cheatsheet
    </button>

</form>
    <div class="back">
        <a href="myCheats">
            <i class="fa-solid fa-arrow-left"></i>
            Back to My Cheats
        </a>
    </div>

</div>

</body>
</html>