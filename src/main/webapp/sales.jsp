<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.inventory.model.Product"%>
<%@page import="com.inventory.model.Sale"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sales Transactions - Smart Inventory</title>
    <style>
        /* Dark Futuristic Vibe සහ Background Animation Canvas එක සැකසීම */
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background-color: #0f172a !important; 
            color: #f1f5f9;
            margin: 0; 
            padding: 20px; 
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
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

        .btn-back { display: inline-block; margin-bottom: 20px; color: #38bdf8; text-decoration: none; font-weight: bold; position: relative; z-index: 10; transition: color 0.2s; }
        .btn-back:hover { color: #7dd3fc; }

        /* Glassmorphism Dark Container එක */
        .container { 
            max-width: 900px; 
            margin: 0 auto; 
            background: rgba(30, 41, 59, 0.85) !important; 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 30px; 
            border-radius: 16px !important; 
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6) !important; 
            position: relative;
            z-index: 10;
        }

        h1, h2 { color: #38bdf8; text-shadow: 0 2px 10px rgba(56, 189, 248, 0.2); }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #cbd5e1; }
        
        select, input[type="number"] { 
            width: 100%; 
            padding: 10px; 
            border: 1px solid rgba(255, 255, 255, 0.15); 
            border-radius: 6px; 
            box-sizing: border-box; 
            background: rgba(15, 23, 42, 0.9);
            color: #f1f5f9;
            font-size: 14px;
        }
        
        select:focus, input[type="number"]:focus {
            border-color: #38bdf8;
            outline: none;
            box-shadow: 0 0 10px rgba(56, 189, 248, 0.3);
        }

        .btn-submit { 
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); 
            color: white; 
            border: none; 
            padding: 12px 20px; 
            font-weight: bold; 
            border-radius: 6px; 
            cursor: pointer; 
            width: 100%; 
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
        }
        
        .btn-submit:hover { 
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.4);
        }

        .alert { padding: 10px; margin-bottom: 15px; border-radius: 6px; font-weight: bold; }
        .alert-success { background-color: rgba(6, 95, 70, 0.8); color: #34d399; border: 1px solid #059669; }
        .alert-danger { background-color: rgba(153, 27, 27, 0.8); color: #fca5a5; border: 1px solid #dc2626; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 30px; background: rgba(15, 23, 42, 0.6); border-radius: 8px; overflow: hidden; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.08); color: #e2e8f0; }
        th { background-color: rgba(30, 41, 59, 0.9); color: #38bdf8; }
        tr:hover { background: rgba(255, 255, 255, 0.02); }
    </style>
</head>
<body>

    <!-- පසුබිමේ පාවෙන Cart සහ Sales Products Animation එක සඳහා Canvas එක -->
    <canvas id="bgCanvas"></canvas>

    <a href="index.jsp" class="btn-back">⬅ Back to Dashboard</a>

    <div class="container">
        <h1>🛒 Record New Sales Transaction</h1>
        
        <%-- පණිවිඩ පෙන්වීම --%>
        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("message") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="SalesServlet" method="POST">
            <div class="form-group">
                <label for="productId">Select Product:</label>
                <select name="productId" id="productId" required>
                    <option value="">-- Choose a Product --</option>
                    <% 
                        List<Product> productList = (List<Product>) request.getAttribute("productList");
                        if(productList != null) {
                            for(Product p : productList) {
                    %>
                        <option value="<%= p.getId() %>"><%= p.getName() %> (Available: <%= p.getStockQuantity() %> - Rs.<%= p.getPrice() %>)</option>
                    <% 
                            }
                        }
                    %>
                </select>
            </div>

            <div class="form-group">
                <label for="quantity">Quantity to Sell:</label>
                <input type="number" name="quantity" id="quantity" min="1" required>
            </div>

            <button type="submit" class="btn-submit">Complete Transaction 💳</button>
        </form>

        <h2>Recent Sales History</h2>
        <table>
            <thead>
                <tr>
                    <th>Date & Time</th>
                    <th>Product Name</th>
                    <th>Qty Sold</th>
                    <th>Total Price (Rs.)</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Sale> salesList = (List<Sale>) request.getAttribute("salesList");
                    if(salesList != null && !salesList.isEmpty()) {
                        for(Sale s : salesList) {
                %>
                    <tr>
                        <td><%= s.getSaleDate() %></td>
                        <td><%= s.getProductName() %></td>
                        <td><%= s.getQuantity() %></td>
                        <td style="font-weight: bold; color: #34d399;"><%= s.getTotalPrice() %>0</td>
                    </tr>
                <% 
                        }
                    } else {
                %>
                    <tr><td colspan="4" style="text-align: center; color: #94a3b8;">No sales recorded yet.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Background Floating E-commerce / Sales Particles Animation Script -->
    <script>
        const canvas = document.getElementById('bgCanvas');
        const ctx = canvas.getContext('2d');

        let width = canvas.width = window.innerWidth;
        let height = canvas.height = window.innerHeight;

        window.addEventListener('resize', () => {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
        });

        // Sales / Inventory floating elements setup (Size එක වැඩි කර ඇත)
        const icons = [];
        const count = 28;

        for (let i = 0; i < count; i++) {
            icons.push({
                x: Math.random() * width,
                y: Math.random() * height,
                vx: (Math.random() - 0.5) * 0.5,
                vy: -Math.random() * 0.6 - 0.2, // උඩට පාවෙන ස්වභාවය
                size: Math.random() * 35 + 30, // ප්‍රමාණය 20px සිට 45px දක්වා විශාල කර ඇත
                opacity: Math.random() * 0.4 + 0.2,
                symbol: ['🛒', '📦', '💳', '📊', '🛍️'][Math.floor(Math.random() * 5)]
            });
        }

        function animate() {
            ctx.clearRect(0, 0, width, height);
            
            ctx.fillStyle = '#0f172a';
            ctx.fillRect(0, 0, width, height);

            // Draw floating sales icons
            for (let i = 0; i < icons.length; i++) {
                let ic = icons[i];
                ic.x += ic.vx;
                ic.y += ic.vy;

                // Screen boundary check
                if (ic.y < -50) {
                    ic.y = height + 50;
                    ic.x = Math.random() * width;
                }
                if (ic.x < 0 || ic.x > width) ic.vx *= -1;

                ctx.font = `${ic.size}px Arial`;
                ctx.fillStyle = `rgba(56, 189, 248, ${ic.opacity})`;
                ctx.fillText(ic.symbol, ic.x, ic.y);
            }
            requestAnimationFrame(animate);
        }
        animate();
    </script>
</body>
</html>