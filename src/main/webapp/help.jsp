<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Help Center</title>

<!-- FONT AWESOME -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>

/* ===== BASE ===== */
body{
    margin:0;
    font-family: 'Segoe UI', sans-serif;
    background:#f1f5f9;
    color:#1e293b;
}

/* ===== HEADER ===== */
.header{
    background:#1e293b;
    color:white;
    padding:30px;
    text-align:center;
}

.header h1{
    margin-bottom:5px;
}

.header p{
    color:#94a3b8;
}

/* ===== CONTAINER ===== */
.container{
    max-width:1100px;
    margin:40px auto;
    padding:0 20px;
}

/* ===== GRID ===== */
.grid{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:25px;
}

/* ===== CARD ===== */
.card{
    background:white;
    padding:25px;
    border-radius:12px;
    text-align:center;
    text-decoration:none;
    color:inherit;
    border:1px solid #e2e8f0;
    transition:0.3s;
}

.card:hover{
    transform:translateY(-6px);
    box-shadow:0 10px 25px rgba(0,0,0,0.1);
    border-color:#38bdf8;
}

/* ICON */
.card i{
    font-size:35px;
    color:#38bdf8;
    margin-bottom:15px;
}

/* TITLE */
.card h3{
    margin-bottom:10px;
}

/* TEXT */
.card p{
    font-size:14px;
    color:#64748b;
}

/* ===== FAQ ===== */
.faq{
    margin-top:50px;
}

.faq h2{
    margin-bottom:20px;
}

.faq-item{
    background:white;
    margin-bottom:10px;
    padding:15px;
    border-radius:8px;
    border:1px solid #e2e8f0;
}

.faq-item h4{
    margin-bottom:5px;
}

</style>

</head>

<body>

<!-- HEADER -->
<div class="header">
    <h1>Help Center</h1>
    <p>How can we help you?</p>
</div>

<div class="container">

<!-- HELP CARDS -->
<div class="grid">

    <div class="card">
        <i class="fa-solid fa-magnifying-glass"></i>
        <h3>Search Guide</h3>
        <p>How to search cheat sheets easily</p>
    </div>

    <div class="card">
        <i class="fa-solid fa-pen-to-square"></i>
        <h3>Create Guide</h3>
        <p>How to create new cheat sheets</p>
    </div>

    <div class="card">
        <i class="fa-solid fa-upload"></i>
        <h3>Upload File</h3>
        <p>How to upload PDF or files</p>
    </div>

    <div class="card">
        <i class="fa-solid fa-users"></i>
        <h3>Community</h3>
        <p>How to use community features</p>
    </div>

    <div class="card">
        <i class="fa-solid fa-bug"></i>
        <h3>Report Issue</h3>
        <p>Report bugs or errors</p>
    </div>

    <div class="card">
        <i class="fa-solid fa-headset"></i>
        <h3>Contact Support</h3>
        <p>Get help from admin team</p>
    </div>

</div>

<!-- FAQ -->
<div class="faq">

    <h2>Frequently Asked Questions</h2>

    <div class="faq-item">
        <h4>❓ How do I create a cheat sheet?</h4>
        <p>Go to Create → Click "Create Cheatsheet" → Fill form → Save</p>
    </div>

    <div class="faq-item">
        <h4>❓ Why I can't upload file?</h4>
        <p>Check file size (max limit) and file format (PDF, image)</p>
    </div>

    <div class="faq-item">
        <h4>❓ How to reset password?</h4>
        <p>Contact admin or use forgot password option in login page</p>
    </div>

</div>

</div>

</body>
</html>