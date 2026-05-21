<%@ page import="java.util.List" %>
<%@ page import="com.cheatsheet.model.Category" %>

<%
    String contextPath = request.getContextPath();
    List<Category> categories =
        (List<Category>) request.getAttribute("categories");
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
    <title>Create CheatSheet</title>

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            background:#0f172a;
            font-family:Arial, sans-serif;
            color:white;
        }

        .container{
            width:600px;
            margin:50px auto;
            background:#1e293b;
            padding:30px;
            border-radius:16px;
            box-shadow:0 10px 25px rgba(0,0,0,0.4);
        }

        h1{
            text-align:center;
            margin-bottom:25px;
            color:#38bdf8;
        }

        label{
            display:block;
            margin-top:15px;
            margin-bottom:8px;
            font-weight:bold;
        }

        input,
        textarea,
        select{
            width:100%;
            padding:12px;
            border:none;
            border-radius:10px;
            outline:none;
            background:#334155;
            color:white;
            font-size:15px;
        }

        textarea{
            resize:vertical;
        }

        button{
            width:100%;
            margin-top:25px;
            padding:14px;
            border:none;
            border-radius:10px;
            background:#0ea5e9;
            color:white;
            font-size:16px;
            font-weight:bold;
            cursor:pointer;
            transition:0.3s;
        }

        button:hover{
            background:#0284c7;
        }

        .back-btn{
            display:inline-block;
            margin-top:20px;
            text-decoration:none;
            color:#cbd5e1;
        }

        .back-btn:hover{
            color:#38bdf8;
        }
    </style>
</head>

<body>

<div class="container">

    <h1>Create CheatSheet</h1>

    <%-- Form Action ကို /create_cheat လို့ ပြင်ထားပါတယ် --%>
    <form action="<%= contextPath %>/createSheet" method="post">

        <label>Title</label>
        <input type="text"
               name="title"
               placeholder="Enter CheatSheet Title"
               required>

        <label>Category Name</label>
        <select name="categoryId" required>
            <option value="">Select Category</option>
            <%
                if (categories != null) {
                    for (Category c : categories) {
            %>
                <option value="<%= c.getId() %>">
                    <%= c.getName() %>
                </option>
            <%
                    }
                }
            %>
        </select>

        <label>Content</label>
        <textarea name="content"
                  rows="10"
                  placeholder="Write CheatSheet Content..."
                  required></textarea>
                  
                  <label>Example Code (Optional)</label>
				  <textarea name="example_code"
          					rows="6"
         					placeholder='python&#10;def hello():&#10;    print("Hello World")&#10;&#10;# ဥပမာ code ကို ဒီနေရာမှာ ရေးပါ'
          					style="font-family: 'Courier New', monospace;"></textarea>

        <button type="submit">
            Create CheatSheet
        </button>

    </form>

    <a class="back-btn" href="<%= contextPath %>/adminDashboard">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>

</div>

</body>
</html>