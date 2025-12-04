/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.HomeProduct;
import DAO.ProductDAO;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String categoryId = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");
        
        try {
            // Lấy sản phẩm theo categoryId
            List<HomeProduct> products = productDAO.getProductsByCategory(Integer.parseInt(categoryId));
            
            request.setAttribute("products", products);
            request.setAttribute("categoryName", categoryName);
            request.setAttribute("categoryId", categoryId);
            request.getRequestDispatcher("/View/category.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/2274820014_NguyenThuHienn/HomeProductServlet");
        }
    }
}
