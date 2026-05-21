<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.Category" %>

<%
    List<Category> categories =
    (List<Category>) request.getAttribute("categories");

    if (categories == null) {
        response.sendRedirect("create_cheat");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Cheatsheet</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family: Arial, sans-serif;
    background: linear-gradient(to right,#dbeafe,#f8fafc);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:40px 0;
}

.form-box{
    width:550px;
    background:white;
    padding:40px;
    border-radius:22px;
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
}

.form-box h2{
    text-align:center;
    margin-bottom:10px;
    color:#0f172a;
    font-size:32px;
}

.top-text{
    text-align:center;
    color:#64748b;
    margin-bottom:30px;
    font-size:15px;
}

.input-group{
    margin-bottom:22px;
}

label{
    display:block;
    margin-bottom:8px;
    font-weight:bold;
    color:#334155;
    font-size:15px;
}

input,
textarea,
select{
    width:100%;
    padding:14px;
    border:1px solid #cbd5e1;
    border-radius:12px;
    font-size:15px;
    transition:0.3s;
    outline:none;
    background:#f8fafc;
}

input:focus,
textarea:focus,
select:focus{
    border-color:#38bdf8;
    background:white;
    box-shadow:0 0 10px rgba(56,189,248,0.2);
}

textarea{
    height:180px;
    resize:none;
}

button{
    width:100%;
    padding:15px;
    background:linear-gradient(to right,#0ea5e9,#0284c7);
    color:white;
    border:none;
    border-radius:12px;
    font-size:17px;
    font-weight:bold;
    cursor:pointer;
    transition:0.3s;
}

button:hover{
    transform:translateY(-2px);
    opacity:0.9;
}

.small-line{
    width:70px;
    height:4px;
    background:#0ea5e9;
    margin:12px auto 25px;
    border-radius:10px;
}

/* PUBLIC PRIVATE */

.visibility-box{
    display:flex;
    gap:15px;
    margin-top:10px;
}

.radio-card{
    flex:1;
    cursor:pointer;
}

.radio-card input{
    display:none;
}

.radio-content{
    border:2px solid #cbd5e1;
    border-radius:14px;
    padding:18px;
    background:#f8fafc;
    transition:0.3s;
    font-weight:bold;
    color:#0f172a;
}

.radio-content span{
    display:block;
    margin-top:6px;
    font-size:13px;
    font-weight:normal;
    color:#64748b;
}

.radio-card input:checked + .radio-content{
    border-color:#38bdf8;
    background:#e0f2fe;
    box-shadow:0 0 12px rgba(56,189,248,0.2);
}

</style>

</head>

<body>

<div class="form-box">

    <h2>Create Cheatsheet</h2>

    <div class="small-line"></div>

    <p class="top-text">
        Share your programming knowledge with developers
    </p>

    <form action="create_cheat" method="post">

        <!-- TITLE -->

        <div class="input-group">

            <label>Cheatsheet Title</label>

            <input type="text"
                   name="title"
                   placeholder="Enter cheatsheet title"
                   required>

        </div>

        <!-- CATEGORY -->

        <div class="input-group">

            <label>Select Category</label>

            <select name="categoryId" required>

                <option value="">Choose Category</option>

                <%
                    for(Category cat : categories){
                %>

                <option value="<%= cat.getId() %>">
                    <%= cat.getName() %>
                </option>

                <%
                    }
                %>

            </select>

        </div>

        <!-- CONTENT -->

        <div class="input-group">

            <label>Write Content</label>

            <textarea name="content"
             placeholder="Write your cheatsheet content here..."
             required></textarea>

        </div>
        
        <!-- ✅ EXAMPLE CODE - အသစ်ထည့်ရန် -->
<div class="input-group">

    <label>Example Code (Optional)</label>

    <textarea name="example_code"
              placeholder='java&#10;def hello():&#10;    print("Hello World")'
              rows="8"
              style="font-family: 'Courier New', monospace;"></textarea>

    <p style="font-size: 12px; color: #64748b; margin-top: 6px;">
    </p>

</div>
        <!-- VISIBILITY -->

<div class="input-group">

    <label>Visibility</label>

    <div class="visibility-box">

        <label class="radio-card">

           <input type="radio"
       name="status"
       value="PUBLIC"
       checked>
       
            <div class="radio-content">
                Public
                <span>Everyone can see this cheatsheet</span>
            </div>

        </label>

        <label class="radio-card">

            <input type="radio"
       name="status"
       value="PRIVATE">

            <div class="radio-content">
                Private
                <span>Only you can see this cheatsheet</span>
            </div>

        </label>

    </div>

</div>

                    

        <!-- BUTTON -->

        <button type="submit">

            Publish Cheatsheet
		</button>
		<!-- Back Button - Go to Home -->
        <div style="margin-top: 15px; text-align: center;">
            <a href="homepage" style="
                display: inline-block;
                padding: 12px 20px;
                background: #64748b;
                color: white;
                text-decoration: none;
                border-radius: 12px;
                font-size: 14px;
                font-weight: bold;
                transition: 0.3s;
            " onmouseover="this.style.background='#475569'" onmouseout="this.style.background='#64748b'">
                <i class="fa-solid fa-house"></i> Back 
            </a>
        </div>
</form>
</div>



</body>
</html>