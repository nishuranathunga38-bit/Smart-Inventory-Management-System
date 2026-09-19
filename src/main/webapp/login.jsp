<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Smart Inventory</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 300px; text-align: center; }
        .login-box h2 { color: #1e3a8a; margin-bottom: 20px; }
        .input-field { width: 90%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; }
        .btn-submit { width: 97%; padding: 10px; background: #1e3a8a; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        .btn-submit:hover { background: #111827; }
        .error-msg { color: red; font-size: 14px; margin-bottom: 10px; }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>System Login</h2>
        
        <% 
            String error = request.getParameter("error");
            if(error != null) {
                out.println("<div class='error-msg'>" + error + "</div>");
            }
        %>
        
        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
            <input type="text" name="username" class="input-field" placeholder="Username" required><br>
            <input type="password" name="password" class="input-field" placeholder="Password" required><br>
            <button type="submit" class="btn-submit">Login</button>
        </form>
    </div>

</body>
</html>