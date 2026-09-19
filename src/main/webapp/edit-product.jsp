<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.inventory.model.Product"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <style>
        body { font-family: sans-serif; background-color: #f4f6f9; padding: 20px; }
        .form-container { background: white; width: 400px; margin: auto; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .input-group { margin-bottom: 15px; }
        .input-group label { display: block; font-weight: bold; }
        .input-group input { width: 95%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .btn { width: 100%; padding: 10px; background: #3b82f6; color: white; border: none; cursor: pointer; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Edit Product</h2>
        <% Product p = (Product) request.getAttribute("product"); %>
        
        <form action="EditProductServlet" method="POST">
            <input type="hidden" name="id" value="<%= p.getId() %>">
            
            <div class="input-group">
                <label>Product Name</label>
                <input type="text" name="name" value="<%= p.getName() %>" required>
            </div>
            <div class="input-group">
                <label>Category</label>
                <input type="text" name="category" value="<%= p.getCategory() %>" required>
            </div>
            <div class="input-group">
                <label>Price</label>
                <input type="number" step="0.01" name="price" value="<%= p.getPrice() %>" required>
            </div>
            <div class="input-group">
                <label>Stock Quantity</label>
                <input type="number" name="stock_quantity" value="<%= p.getStockQuantity() %>" required>
            </div>
            <button type="submit" class="btn">Update Product</button>
        </form>
    </div>
</body>
</html>