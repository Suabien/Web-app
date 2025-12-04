/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/ReviewServlet"})
public class ReviewServlet extends HttpServlet {
    private final String JDBC_URL  = "jdbc:mysql://localhost:3306/trangsuc_db";
    private final String JDBC_USER = "root";
    private final String JDBC_PASS = "hien031204";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        Integer userId = (Integer) request.getSession().getAttribute("userId");

        if (userId == null || action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing parameters or not logged in.");
            return;
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            switch (action) {
                case "add":
                    addReview(request, response, conn, userId);
                    break;
                case "edit":
                    editReview(request, response, conn, userId);
                    break;
                case "delete":
                    deleteReview(request, response, conn, userId);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Invalid action");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("error");
        }
    }

    private void addReview(HttpServletRequest request, HttpServletResponse response,
                           Connection conn, int userId) throws Exception {
        String ratingStr = request.getParameter("rating");
        String reviewText = request.getParameter("reviewText");
        String productIdStr = request.getParameter("productId");

        if (ratingStr == null || productIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing rating or productId");
            return;
        }

        float rating = Float.parseFloat(ratingStr);
        int productId = Integer.parseInt(productIdStr);

        String insertSql = "INSERT INTO reviews (user_id, product_id, rating, review_text, created_at) " +
                           "VALUES (?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setFloat(3, rating);
            ps.setString(4, reviewText);

            int inserted = ps.executeUpdate();
            if (inserted > 0) {
                String updateSql = "UPDATE products SET rate_count = rate_count + 1, " +
                                   "rating = (rating * (rate_count) + ?) / (rate_count + 1) WHERE id = ?";
                try (PreparedStatement psUpd = conn.prepareStatement(updateSql)) {
                    psUpd.setFloat(1, rating);
                    psUpd.setInt(2, productId);
                    psUpd.executeUpdate();
                }
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("success");
            }
        }
    }

    private void editReview(HttpServletRequest request, HttpServletResponse response,
                            Connection conn, int userId) throws Exception {
        String reviewIdStr = request.getParameter("reviewId");
        String newText = request.getParameter("newText");

        if (reviewIdStr == null || newText == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing parameters");
            return;
        }

        int reviewId = Integer.parseInt(reviewIdStr);
        String updateSql = "UPDATE reviews SET review_text = ? WHERE id = ? AND user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setString(1, newText);
            ps.setInt(2, reviewId);
            ps.setInt(3, userId);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("updated");
            } else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("Not authorized");
            }
        }
    }

    private void deleteReview(HttpServletRequest request, HttpServletResponse response,
                              Connection conn, int userId) throws Exception {
        String reviewIdStr = request.getParameter("reviewId");

        if (reviewIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing reviewId");
            return;
        }

        int reviewId = Integer.parseInt(reviewIdStr);
        String deleteSql = "DELETE FROM reviews WHERE id = ? AND user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, userId);

            int deleted = ps.executeUpdate();
            if (deleted > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("deleted");
            } else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("Not authorized");
            }
        }
    }
}

