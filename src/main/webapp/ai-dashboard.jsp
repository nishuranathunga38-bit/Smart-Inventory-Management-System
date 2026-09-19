<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.inventory.model.Product"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Business Insights | Smart Inventory</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap');

        body { 
            font-family: 'Inter', sans-serif; 
            background: radial-gradient(circle at top right, #0f172a, #1e293b); 
            color: #f1f5f9; 
            margin: 0; 
            padding: 40px; 
            min-height: 100vh;
        }

        .btn-back { 
            display: inline-block; 
            margin-bottom: 25px; 
            color: #38bdf8; 
            text-decoration: none; 
            font-weight: 600; 
            transition: 0.3s;
        }
        .btn-back:hover { color: #fff; transform: translateX(-5px); }

        .header { margin-bottom: 40px; border-left: 4px solid #38bdf8; padding-left: 20px; }
        .header h1 { margin: 0; font-size: 32px; letter-spacing: -0.5px; }
        .header p { color: #94a3b8; margin: 8px 0 0 0; }

        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }

        .card { 
            background: rgba(30, 41, 59, 0.6); 
            backdrop-filter: blur(12px); 
            padding: 25px; 
            border-radius: 16px; 
            border: 1px solid rgba(255,255,255,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover { transform: translateY(-5px); border-color: rgba(56, 189, 248, 0.3); }

        .card-ai { grid-column: 1 / -1; background: linear-gradient(135deg, #1e1b4b, #311042); border: 1px solid #7e22ce; }
        .card-ai h2 { color: #c084fc; }

        h2 { margin-top: 0; font-size: 19px; display: flex; align-items: center; gap: 10px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { color: #94a3b8; font-size: 13px; text-transform: uppercase; padding: 12px; border-bottom: 1px solid #334155; }
        td { padding: 12px; border-bottom: 1px solid #334155; }

        ul { margin: 0; padding-left: 20px; }
        li { margin-bottom: 12px; font-size: 16px; color: #e2e8f0; }
        
        .badge { padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: bold; }
        .badge-red { background: #7f1d1d; color: #fecaca; }
        .badge-amber { background: #78350f; color: #fef3c7; }
    </style>
</head>
<body>

    <a href="index.jsp" class="btn-back">⬅ Back to Dashboard</a>

    <div class="header">
        <h1>🧠 AI Business Insights & Predictive Dashboard</h1>
        <p>Smart Inventory - ස්වයංක්‍රීය දත්ත විශ්ලේෂණ වාර්තා</p>
    </div>

    <div class="grid">
        <div class="card card-ai">
            <h2>🔮 Smart AI Restock Recommendations</h2>
            <ul>
                <% 
                    List<Product> lowStock = (List<Product>) request.getAttribute("lowStock");
                    List<Product> expiring = (List<Product>) request.getAttribute("expiring");
                    
                    if ((lowStock == null || lowStock.isEmpty()) && (expiring == null || expiring.isEmpty())) {
                %>
                    <li>Everything looks perfect! Your inventory levels are stable.</li>
                <% } else {
                    if (lowStock != null && !lowStock.isEmpty()) { %>
                        <li><strong>Urgent:</strong> <%= lowStock.size() %> items running low. Prioritize restocking <strong><%= lowStock.get(0).getName() %></strong>.</li>
                    <% }
                    if (expiring != null && !expiring.isEmpty()) { %>
                        <li><strong>Strategy:</strong> <strong><%= expiring.get(0).getName() %></strong> expires within 30 days. Launch a flash sale to clear stock.</li>
                    <% }
                } %>
            </ul>
        </div>

        <div class="card">
            <h2>🚨 Low Stock Alert</h2>
            <table>
                <thead><tr><th>Product</th><th>Qty</th><th>Min Level</th></tr></thead>
                <tbody>
                    <% if(lowStock != null && !lowStock.isEmpty()) { 
                        for(Product p : lowStock) { %>
                        <tr><td><%= p.getName() %></td><td><span class="badge badge-red"><%= p.getStockQuantity() %></span></td><td><%= p.getMinStockLevel() %></td></tr>
                    <% } } else { %>
                        <tr><td colspan="3" style="color:#64748b">No low stock items.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h2>📅 Expiring Within 30 Days</h2>
            <table>
                <thead><tr><th>Product</th><th>Qty</th><th>Expiry Date</th></tr></thead>
                <tbody>
                    <% if(expiring != null && !expiring.isEmpty()) { 
                        for(Product p : expiring) { %>
                        <tr><td><%= p.getName() %></td><td><%= p.getStockQuantity() %></td><td><span class="badge badge-amber"><%= p.getExpiryDate() %></span></td></tr>
                    <% } } else { %>
                        <tr><td colspan="3" style="color:#64748b">No products expiring soon.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>