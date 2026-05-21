<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Error Page</title>

<style>

    body{
        margin:0;
        padding:0;
        background:#0f172a;
        font-family:Arial;
        display:flex;
        justify-content:center;
        align-items:center;
        height:100vh;
        color:white;
    }

    .error-box{
        background:#1e293b;
        padding:40px;
        border-radius:15px;
        text-align:center;
        width:400px;
        box-shadow:0 10px 25px rgba(0,0,0,0.4);
    }

    h1{
        color:#ef4444;
        margin-bottom:15px;
    }

    p{
        color:#cbd5e1;
        margin-bottom:25px;
    }

    a{
        display:inline-block;
        padding:12px 20px;
        background:#38bdf8;
        color:white;
        text-decoration:none;
        border-radius:8px;
        font-weight:bold;
    }

    a:hover{
        background:#0ea5e9;
    }

</style>

</head>

<body>

<div class="error-box">

    <h1>Something Went Wrong!</h1>

    <p>
        Rating submit failed or page not found.
    </p>

    <a href="userAllCheat">
        Back To Cheatsheets
    </a>

</div>

</body>
</html>