<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create Account | Register</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .box {
            background: white;
            padding: 50px; 
            border-radius: 25px;
            width: 480px;  
            box-shadow: 0px 15px 45px rgba(0,0,0,0.25);
            text-align: center;
        }

        h2 {
            color: #333;
            font-size: 32px; 
            margin-bottom: 12px;
            font-weight: 700;
        }

        p.subtitle {
            color: #777;
            font-size: 16px;
            margin-bottom: 30px;
        }

        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            font-size: 14px;
            font-weight: 600;
            color: #444;
            margin-left: 5px;
        }

        input {
            width: 100%;
            padding: 15px 20px; 
            margin-top: 8px;
            border: 1.5px solid #eee;
            border-radius: 12px;
            background: #f9f9f9;
            font-size: 16px; 
            transition: 0.3s;
            outline: none;
        }

        input:focus {
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.2);
        }

        button {
            width: 100%;
            padding: 16px; 
            margin-top: 15px;
            background: linear-gradient(to right, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.3);
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(118, 75, 162, 0.4);
        }

        .error {
            background: #ffe5e5;
            color: #d9534f;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 25px;
            border: 1px solid #f5c2c2;
        }

        .link {
            margin-top: 30px;
            font-size: 15px;
            color: #666;
        }

        .link a {
            color: #667eea;
            text-decoration: none;
            font-weight: bold;
        }

        .link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="box">
    <h2>Join Us!</h2>
    <p class="subtitle">Create your account to get started</p>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form action="register" method="post">
        <div class="input-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter your username" required>
        </div>

        <div class="input-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="example@mail.com" required>
        </div>

        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="password" required>
        </div>

        <button type="submit">Create Account</button>
    </form>

    <div class="link">
        Already have an account? <a href="login.jsp">Login</a>
    </div>
    <div class="link">
        Already have an account? <a href="login.jsp">Cancel</a>
    </div>
</div>

</body>
</html>