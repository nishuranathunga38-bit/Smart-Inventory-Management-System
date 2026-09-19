<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // සෙෂන් (Session) එකේ පරිශීලක නාමයක් තියෙනවාදැයි බැලීම
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // පරිශීලකයා Login වී නැත්නම්, ඔහුව කෙලින්ම login.jsp පිටුවට යොමු කිරීම
    if (username == null) {
        response.sendRedirect("login.jsp");
        return; // මෙතනින් ඉදිරියට පිටුව ක්‍රියාත්මක වීම නවත්වයි
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Smart Inventory System - Home</title>
    <style>
        /* 1. Dark Futuristic Vibe සහ Background Animation Canvas එක සැකසීම */
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background-color: #0f172a !important; 
            color: #f1f5f9;
            min-height: 100vh;
            margin: 0; 
            padding: 0; 
            overflow-x: hidden;
        }

        /* 3D Animated Background Canvas එක පසුබිමේ රඳවා තැබීමට */
        #bgCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -1;
        }

        /* 2. Premium Dark Navbar එක */
        .navbar { 
            background: rgba(15, 23, 42, 0.85) !important; 
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            color: white; 
            padding: 15px 25px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
            position: relative;
            z-index: 10;
        }

        .navbar h2 { margin: 0; font-size: 20px; font-weight: 600; letter-spacing: 0.5px; color: #38bdf8; }
        .user-info { font-size: 14px; color: #cbd5e1; }
        .logout-link { color: #f87171; text-decoration: none; font-weight: bold; margin-left: 15px; transition: color 0.2s; }
        .logout-link:hover { color: #fca5a5; }

        /* Main Container */
        .main-container { max-width: 1000px; margin: 40px auto; padding: 20px; text-align: center; position: relative; z-index: 10; }

        /* 3. Glassmorphism Dark Welcome Box එක */
        .welcome-box { 
            background: rgba(30, 41, 59, 0.75) !important; 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 40px; 
            border-radius: 20px !important; 
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6) !important; 
        }

        .welcome-box h1 { color: #38bdf8; margin-bottom: 10px; font-weight: 700; font-size: 32px; text-shadow: 0 2px 10px rgba(56, 189, 248, 0.3); }
        .welcome-box p { color: #94a3b8; font-size: 15px; }

        /* Menu Grid */
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 40px; }

        /* 4. Dark Cyber / Inventory Cards */
        .menu-card { 
            background: rgba(15, 23, 42, 0.8) !important; 
            padding: 25px; 
            border-radius: 14px !important; 
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); 
            text-decoration: none; 
            color: #f1f5f9; 
            font-weight: bold; 
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-top: 4px solid #38bdf8; 
            transition: all 0.3s ease-in-out !important; 
        }

        .menu-card:hover { 
            transform: translateY(-8px); 
            background: rgba(30, 41, 59, 0.95) !important; 
            border-color: rgba(56, 189, 248, 0.4);
            box-shadow: 0 12px 30px rgba(56, 189, 248, 0.2) !important;
        }

        .menu-card p { color: #94a3b8; font-size: 13px; font-weight: normal; margin-top: 8px; }
    </style>
</head>
<body>

    <!-- පසුබිමේ 3D පාවෙන Inventory Nodes / Particles Animation එක සඳහා Canvas එක -->
    <canvas id="bgCanvas"></canvas>

    <div class="navbar">
        <h2>Smart Inventory Management System</h2>
        <div class="user-info">
            Welcome, <strong><%= username %></strong> (<%= role %>)
            <a href="LogoutServlet" class="logout-link">Logout</a>
        </div>
    </div>

    <div class="main-container">
        <div class="welcome-box">
            <h1>Business Dashboard</h1>
            <p>පද්ධතියේ මොඩියුලයන් වෙත පිවිසීමට පහතින් තෝරාගන්න.</p>
            
            <div class="menu-grid">
                
                <a href="AIDashboardServlet" class="menu-card" style="border-top-color: #38bdf8;">
                    🧠 AI Business Insights
                    <p>Predictions, Trends & Alerts</p>
                </a>
                
                <% if ("Admin".equalsIgnoreCase(role)) { %>
                    <a href="ProductServlet" class="menu-card" style="border-top-color: #10b981;">
                        📦 Product Management
                        <p>Add, Update & Delete Items</p>
                    </a>
                <% } %>
                
                <a href="SalesServlet" class="menu-card" style="border-top-color: #f59e0b;">
                    🛒 Sales Transactions
                    <p>Record New Orders</p>
                </a>

                <a href="ReportsServlet" class="menu-card" style="border-top-color: #a855f7;">
                    📊 Business Reports & Charts 
                    <p>View Charts & AI Forecasts</p>
                </a>
                
            </div>
        </div>
    </div>

    <!-- 3D Background Animation Script -->
    <script>
        const canvas = document.getElementById('bgCanvas');
        const ctx = canvas.getContext('2d');

        let width = canvas.width = window.innerWidth;
        let height = canvas.height = window.innerHeight;

        window.addEventListener('resize', () => {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
        });

        // 3D Particles / Inventory Nodes setup
        const particles = [];
        const count = 55;

        for (let i = 0; i < count; i++) {
            particles.push({
                x: Math.random() * width,
                y: Math.random() * height,
                vx: (Math.random() - 0.5) * 0.8,
                vy: (Math.random() - 0.5) * 0.8,
                radius: Math.random() * 2.5 + 1
            });
        }

        function animate() {
            ctx.clearRect(0, 0, width, height);
            
            ctx.fillStyle = '#0f172a';
            ctx.fillRect(0, 0, width, height);

            // Draw connecting lines and particles (Inventory Network Vibe)
            for (let i = 0; i < particles.length; i++) {
                let p = particles[i];
                p.x += p.vx;
                p.y += p.vy;

                if (p.x < 0 || p.x > width) p.vx *= -1;
                if (p.y < 0 || p.y > height) p.vy *= -1;

                ctx.beginPath();
                ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(56, 189, 248, 0.5)';
                ctx.fill();

                for (let j = i + 1; j < particles.length; j++) {
                    let p2 = particles[j];
                    let dist = Math.hypot(p.x - p2.x, p.y - p2.y);
                    if (dist < 130) {
                        ctx.beginPath();
                        ctx.moveTo(p.x, p.y);
                        ctx.lineTo(p2.x, p2.y);
                        ctx.strokeStyle = `rgba(56, 189, 248, ${0.2 - dist / 650})`;
                        ctx.lineWidth = 0.8;
                        ctx.stroke();
                    }
                }
            }
            requestAnimationFrame(animate);
        }
        animate();
    </script>
</body>
</html>