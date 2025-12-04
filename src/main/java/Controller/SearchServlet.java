/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import Model.HomeProduct;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/SearchServlet"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        
        List<HomeProduct> searchResults = new ArrayList<>();
        Connection conn = DatabaseConnection.getConnection();
        
        if (conn != null) {
            String query = "SELECT * FROM products WHERE name LIKE ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, "%" + searchTerm + "%");
                ResultSet rs = ps.executeQuery();
                
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
                    searchResults.add(product);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("searchResults", searchResults);
        request.getRequestDispatcher("View/search.jsp").forward(request, response);
    }
}
