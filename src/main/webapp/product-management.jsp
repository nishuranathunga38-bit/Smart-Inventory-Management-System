<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.inventory.model.Product"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Management | Smart Inventory</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            /* කලින් තිබූ වර්ණ වෙනුවට Dark Theme වර්ණ */
            --primary: #38bdf8; /* Cyan */
            --danger: #f87171;  /* Soft Red */
            --success: #34d399; /* Soft Green */
            
            /* Dark Theme Backgrounds */
            --bg-dark: #0f172a;
            --bg-card: rgba(30, 41, 59, 0.85); /* Glassmorphism bg */
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
            --border-color: rgba(255, 255, 255, 0.1);
        }

        /* 1. Dark Futuristic Vibe සහ Background Animation Canvas */
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-dark) !important; 
            color: var(--text-main);
            margin: 0; 
            padding: 30px; 
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* 3D Animated Background Canvas */
        #bgCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -1;
        }

        /* Back Link */
        .back-link { text-decoration:none; color: var(--text-muted); font-weight: 600; position: relative; z-index: 10; transition: 0.3s; }
        .back-link:hover { color: var(--primary); }
        
        br { position: relative; z-index: 10; }

        /* Main Layout */
        .container { 
            max-width: 1200px; 
            margin: auto; 
            display: grid; 
            grid-template-columns: 350px 1fr; 
            gap: 30px; 
            position: relative; 
            z-index: 10; 
        }

        /* Glassmorphism Cards */
        .card { 
            background: var(--bg-card) !important; 
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
            padding: 25px; 
            border-radius: 16px !important; 
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.3) !important; 
        }

        h2 { margin-top: 0; color: var(--primary); font-size: 1.5rem; margin-bottom: 20px; text-shadow: 0 2px 5px rgba(56, 189, 248, 0.2); }
        
        .input-group { margin-bottom: 15px; }
        label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-muted); margin-bottom: 5px; }
        
        input, select { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid var(--border-color); 
            border-radius: 8px; 
            box-sizing: border-box; 
            background: rgba(15, 23, 42, 0.6);
            color: var(--text-main);
            font-family: 'Inter', sans-serif;
            transition: 0.3s;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 10px rgba(56, 189, 248, 0.2);
        }

        /* Buttons */
        .btn { 
            width: 100%; 
            padding: 12px; 
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: white; 
            border: none; 
            border-radius: 8px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: 0.3s; 
            font-family: 'Inter', sans-serif;
        }
        .btn:hover { background: #4338ca; box-shadow: 0 4px 15px rgba(79, 70, 229, 0.4); }

        /* Table Styles */
        table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 10px; }
        
        th { 
            background: rgba(30, 41, 59, 0.5); 
            padding: 15px; 
            text-align: left; 
            color: var(--primary); 
            border-bottom: 1px solid var(--border-color);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        td { 
            padding: 18px; 
            border-bottom: 1px solid var(--border-color); 
            color: var(--text-main);
            font-size: 0.95rem;
        }
        
        tr:hover td { background: rgba(255, 255, 255, 0.03); }

        /* Action Buttons */
        .action-btn { padding: 8px 14px; border-radius: 6px; text-decoration: none; font-size: 0.85rem; font-weight: 600; margin-right: 5px; transition: 0.3s; display: inline-block;}
        
        .edit-btn { 
            background: rgba(59, 130, 246, 0.1); 
            color: #60a5fa; 
            border: 1px solid rgba(59, 130, 246, 0.3); 
        }
        .edit-btn:hover { background: rgba(59, 130, 246, 0.2); box-shadow: 0 2px 10px rgba(96, 165, 250, 0.1); }
        
        .delete-btn { 
            background: rgba(239, 68, 68, 0.1); 
            color: var(--danger); 
            border: 1px solid rgba(239, 68, 68, 0.3); 
        }
        .delete-btn:hover { background: rgba(239, 68, 68, 0.2); box-shadow: 0 2px 10px rgba(248, 113, 113, 0.1); }

        /* Responsive */
        @media (max-width: 992px) {
            .container { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <!-- පසුබිමේ 3D පාවෙන Inventory / Stock Items Animation සඳහා Canvas -->
    <canvas id="bgCanvas"></canvas>

    <a href="index.jsp" class="back-link">&larr; Back to Dashboard</a>
    <br><br>

    <div class="container">
        <div class="card">
            <h2>Add New Product</h2>
            <form action="ProductServlet" method="POST">
                <div class="input-group"><label>Product Name</label><input type="text" name="name" required></div>
                <div class="input-group">
                    <label>Category</label>
                    <select name="category">
                        <option>Electronics</option><option>Grocery</option>
                        <option>Clothing</option><option>Pharmaceuticals</option>
                    </select>
                </div>
                <div class="input-group"><label>Price (LKR)</label><input type="number" step="0.01" name="price" required></div>
                <div class="input-group"><label>Stock Quantity</label><input type="number" name="stock_quantity" required></div>
                
                <div class="input-group"><label>Min Stock Level</label><input type="number" name="min_stock_level" value="10" required></div>
                <div class="input-group"><label>Expiry Date</label><input type="date" name="expiry_date"></div>
                
                <button type="submit" class="btn">Save Product</button>
            </form>
        </div>

        <div class="card">
            <h2>Stock Inventory List</h2>
            <table>
                <thead>
                    <tr><th>ID</th><th>Name</th><th>Price</th><th>Qty</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <% 
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null && !products.isEmpty()) {
                            for (Product p : products) {
                    %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td><strong><%= p.getName() %></strong></td>
                        <td>Rs. <%= String.format("%.2f", p.getPrice()) %></td>
                        <td><%= p.getStockQuantity() %></td>
                        <td>
                            <a href="EditProductServlet?id=<%= p.getId() %>" class="action-btn edit-btn">Edit</a>
                            <a href="DeleteProductServlet?id=<%= p.getId() %>" class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                        </td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr><td colspan="5" style="text-align: center; color: var(--text-muted);">No products found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Background Floating Stock / Inventory Particles Animation Script -->
    <script>
        const canvas = document.getElementById('bgCanvas');
        const ctx = canvas.getContext('2d');

        let width = canvas.width = window.innerWidth;
        let height = canvas.height = window.innerHeight;

        window.addEventListener('resize', () => {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
        });

        // Inventory / Stock floating elements setup (Larger size)
        const icons = [];
        const count = 25; // අයිකන ගණන

        for (let i = 0; i < count; i++) {
            icons.push({
                x: Math.random() * width,
                y: Math.random() * height,
                vx: (Math.random() - 0.5) * 0.4,
                vy: -Math.random() * 0.7 - 0.1, // උඩට පාවෙන ස්වභාවය
                size: Math.random() * 20 + 15, // අයිකන ප්‍රමාණය (15px - 35px)
                opacity: Math.random() * 0.3 + 0.1,
                // Inventory සඳහා අදාළ අයිකන
                symbol: ['📦', '🗄️', '🏷️', '🛒', '🏭', ' pallets'][Math.floor(Math.random() * 6)] 
            });
        }

        function animate() {
            ctx.clearRect(0, 0, width, height);
            
            // Dark Background color
            ctx.fillStyle = '#0f172a';
            ctx.fillRect(0, 0, width, height);

            // Draw floating inventory icons
            for (let i = 0; i < icons.length; i++) {
                let icon = icons[i];
                icon.x += icon.vx;
                icon.y += icon.vy;

                // Screen boundary check ( reappear from bottom)
                if (icon.y < -50) {
                    icon.y = height + 50;
                    icon.x = Math.random() * width;
                }
                if (icon.x < -50) icon.x = width + 50;
                if (icon.x > width + 50) icon.x = -50;

                ctx.font = `${icon.size}px Arial`;
                // Primary color with opacity
                ctx.fillStyle = `rgba(56, 189, 248, ${icon.opacity})`; 
                ctx.fillText(icon.symbol, icon.x, icon.y);
            }
            requestAnimationFrame(animate);
        }
        animate();
    </script>

</body>
</html>