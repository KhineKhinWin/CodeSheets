<%@ page import="java.util.List" %>
<%@ page import="com.cheatsheet.model.Category" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>

<%
    CheatSheet s =
        (CheatSheet) request.getAttribute("sheet");

    if (s == null) {
%>

<h2 style="color:red;">No data found!</h2>

<%
        return;
    }

    String contextPath = request.getContextPath();

    List<Category> categories =
        (List<Category>) request.getAttribute("categories");
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <title>Edit CheatSheet</title>

    <style>
        body{
            background:#0f172a;
            font-family:Arial;
            color:white;
        }

        .box{
            width:550px;
            min-height: 520px;
            margin:50px auto;
            background:#1e293b;
            padding:25px;
            border-radius:12px;
        }

        input, textarea, select{
            width:100%;
            padding:10px;
            margin-top:10px;
            margin-bottom:15px;
            border-radius:8px;
            border:none;
        }

        textarea{
            font-family: 'Courier New', monospace;
        }

        button{
            width:100%;
            padding:10px;
            background:#0ea5e9;
            color:white;
            border:none;
            border-radius:8px;
            cursor:pointer;
        }

        button:hover{
            background:#0284c7;
        }

        h2{
            text-align:center;
            color:#22d3ee;
        }

        label{
            font-weight:bold;
            display:block;
            margin-top:10px;
        }

        .hint{
            font-size:12px;
            color:#94a3b8;
            margin-top:-10px;
            margin-bottom:15px;
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
    </style>
</head>

<body>

<div class="box">

    <h2>Edit CheatSheet</h2>

    <form action="<%= contextPath %>/editSheet"
          method="post">

        <input type="hidden"
               name="id"
               value="<%= s.getId() %>"/>

        <label>Title</label>
        <input type="text"
               name="title"
               value="<%= s.getTitle() %>"
               required/>

        <label>Category Name</label>
        <select name="categoryId" required>
            <% for(Category c : categories){ %>
                <option value="<%= c.getId() %>"
                    <%= (c.getId() == s.getCategoryId()) ? "selected" : "" %>>
                    <%= c.getName() %>
                </option>
            <% } %>
        </select>

        <label>Content</label>
        <textarea name="content"
                  rows="6"><%= s.getContent() %></textarea>

        <!-- ✅ EXAMPLE CODE - အသစ်ထည့် -->
        <label>Example Code (Optional)</label>
        <textarea name="example_code"
                  rows="8"
                  style="font-family: 'Courier New', monospace;"><%= s.getExampleCode() != null ? s.getExampleCode() : "" %></textarea>
        <div class="hint">
            
        </div>

        <label>Visibility</label>
        <select name="status">
            <option value="PUBLIC"
                <%= ("PUBLIC".equalsIgnoreCase(s.getStatus())) ? "selected" : "" %>>
                Public
            </option>
            <option value="PRIVATE"
                <%= ("PRIVATE".equalsIgnoreCase(s.getStatus())) ? "selected" : "" %>>
                Private
            </option>
        </select>

        <button type="submit">Update Cheatsheet</button>

    </form>
    <div class="back">
        <a href="manageSheets">
            <i class="fa-solid fa-arrow-left"></i>
            Back 
        </a>
    </div>

</div>

</body>
</html>