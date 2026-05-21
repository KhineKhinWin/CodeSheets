<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>

<%
    // ၁။ Servlet ကနေလာတဲ့ Attribute နာမည် (cheatSheetList) နဲ့ အတိအကျ ယူရပါမယ်
    List<CheatSheet> list = (List<CheatSheet>) request.getAttribute("cheatSheetList");

    // null safe (error မတက်အောင်)
    if(list == null){
        list = new ArrayList<>();
    }

    // ၂။ ဘယ် Category ကို ရွေးထားလဲဆိုတာ ခေါင်းစဉ်မှာ ပြဖို့ URL က parameter ကို ပြန်ယူပါမယ်
    String catName = request.getParameter("cat");
    if(catName == null || catName.isEmpty()) {
        catName = "All";
    }
    // ပထမစာလုံးကို အကြီးပြောင်းဖို့ (ဥပမာ software -> Software)
    catName = catName.substring(0, 1).toUpperCase() + catName.substring(1);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= catName %> | CheatSheets</title>

<style>
body{
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #f1f5f9;
    margin: 0;
    padding: 0;
}

.container{
    width: 80%;
    margin: auto;
    padding: 40px 20px;
}

h2 {
    margin-bottom: 25px;
    color: #1e293b;
    padding-left: 15px;
}

.card{
    background: white;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
    transition: 0.3s;
    border: 1px solid #e2e8f0;
}

.card:hover{
    transform: translateY(-5px);
    box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
    border-color: #38bdf8;
}

.title{
    font-size: 22px;
    font-weight: bold;
    color: #0f172a;
}

.content{
    margin-top: 10px;
    color: #475569;
    line-height: 1.6;
}

.category-label{
    display: inline-block;
    margin-top: 15px;
    font-size: 13px;
    background: #e0f2fe;
    color: #0369a1;
    padding: 4px 12px;
    border-radius: 20px;
    font-weight: 600;
}

.empty{
    text-align: center;
    color: #94a3b8;
    margin-top: 100px;
    font-size: 18px;
}
</style>
</head>
<body>

<div class="container">

    <h2><%= catName %> Cheat Sheets</h2>

    <%
        if(list.isEmpty()){
    %>
        <div class="empty">
            <i class="fa-solid fa-folder-open" style="font-size: 40px; display: block; margin-bottom: 10px;"></i>
            No Cheat Sheets Found in this Category
        </div>
    <%
        } else {
            for(CheatSheet c : list){
    %>
    <a href="cheat_detail?id=<%= c.getId() %>" style="text-decoration: none; color: inherit;">
        <div class="card">
            <div class="title">
                <%= c.getTitle() %>
            </div>

            <div class="content">
                <%= c.getContent() %>
            </div>

            <div class="category-label">
                <i class="fa-solid fa-tag"></i> <%= c.getCategory() %>
            </div>
        </div>
    </a>
    <%
            }
        }
    %>

</div>

</body>
</html>