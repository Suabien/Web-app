/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.HomeProduct;
import DAO.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "HomeProductServlet", urlPatterns = {"/HomeProductServlet"})
public class HomeProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<HomeProduct> products = new ArrayList<>();
        Connection conn = DatabaseConnection.getConnection();
        
        if (conn != null) {
            String query = "SELECT * FROM products";
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HomeProduct product = new HomeProduct(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getString("price"),
                        rs.getFloat("rating"),
                        rs.getInt("sold"),
                        rs.getInt("type_id")
                    );
                    products.add(product);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("View/home.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
