<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login | Welcome Back</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Google Fonts (Inter) -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">

<style>
    body {
        font-family: 'Inter', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
    }
    
    .card {
        border: none;
        border-radius: 24px;
        backdrop-filter: blur(10px);
        background: rgba(255, 255, 255, 0.95);
    }
    
    .login-header h3 {
        font-weight: 700;
        color: #333;
        letter-spacing: -0.5px;
    }
    
    .form-label {
        font-size: 0.85rem;
        font-weight: 600;
        color: #555;
        margin-left: 2px;
    }
    
    .form-control {
        padding: 12px 16px;
        border-radius: 12px;
        border: 1.5px solid #eee;
        background-color: #f8f9fa;
        transition: 0.3s;
    }
    
    .form-control:focus {
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
        border-color: #667eea;
        background-color: #fff;
    }
    
    .btn-login {
        padding: 12px;
        border-radius: 12px;
        background: linear-gradient(to right, #667eea, #764ba2);
        border: none;
        font-weight: 600;
        transition: 0.3s;
        margin-top: 10px;
    }
    
    .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        opacity: 0.95;
    }
    
    .error-box {
        background-color: #fff5f5;
        color: #e53e3e;
        padding: 12px;
        border-radius: 10px;
        font-size: 0.9rem;
        border-left: 4px solid #e53e3e;
        margin-bottom: 20px;
    }
    
    .register-link {
        color: #667eea;
        text-decoration: none;
        font-weight: 600;
    }
    
    .register-link:hover {
        text-decoration: underline;
    }
</style>

</head>

<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh;">

    <div class="card shadow-2xl p-4 p-md-5" style="width: 100%; max-width: 420px;">

        <div class="login-header text-center mb-4">
            <div class="mb-3">
                <span style="font-size: 45px;">👋</span>
            </div>
            <h3>Welcome  CheatSheet!</h3>
            <p class="text-muted small">Please enter your details to sign in</p>
        </div>

        <!-- ERROR MESSAGE -->
        <%
            String error = (String) request.getAttribute("error");
            if(error != null){
        %>
            <div class="error-box">
                <i class="bi bi-exclamation-circle-fill me-2"></i> <%= error %>
            </div>
        <%
            }
        %>

        <form action="login" method="post">

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <input type="email" name="email" class="form-control" placeholder="email" required>
            </div>

            <div class="mb-4">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" placeholder=" password" required>
            </div>

            <button class="btn btn-primary btn-login w-100 mb-3">Sign In</button>

        </form>

        <div class="text-center mt-3">
            <p class="text-muted small">
                Don't have an account? 
                <a href="register.jsp" class="register-link">Create Account</a>
            </p>
        </div>

    </div>

</div>

</body>
</html>