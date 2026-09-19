package com.inventory.controller;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.SaleDAO;
import com.inventory.model.Product;
import com.inventory.model.Sale;
import java.io.IOException;
import java.util.List;

// Tomcat 10+ සඳහා javax වෙනුවට jakarta භාවිත කර ඇත
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SalesServlet", urlPatterns = {"/SalesServlet"})
public class SalesServlet extends HttpServlet {

    private SaleDAO saleDAO = new SaleDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // පේජ් එක ලෝඩ් වෙද්දී දැනට තියෙන බඩු සහ පැරණි සේල්ස් ලිස්ට් එක යවනවා
        List<Product> products = productDAO.getAllProducts();
        List<Sale> sales = saleDAO.getAllSales();

        request.setAttribute("productList", products);
        request.setAttribute("salesList", sales);

        request.getRequestDispatcher("sales.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Product product = productDAO.getProductById(productId); // මේ method එක ProductDAO එකේ තියෙන්න ඕනේ

        if (product != null) {
            if (product.getStockQuantity() >= quantity) {
                double totalPrice = product.getPrice() * quantity;
                Sale sale = new Sale(productId, quantity, totalPrice);

                boolean success = saleDAO.recordSale(sale);
                if (success) {
                    request.setAttribute("message", "Sale recorded successfully!");
                } else {
                    request.setAttribute("error", "Failed to record sale.");
                }
            } else {
                request.setAttribute("error", "Insufficient stock available!");
            }
        }

        doGet(request, response); // නැවත පිටුව ලෝඩ් කිරීම
    }
}