/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "hien031204";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String orderId = request.getParameter("orderId");
        
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            String sql = "UPDATE orders SET status = 'Đã hủy' WHERE order_id = ? AND user_id = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(orderId));
                stmt.setInt(2, userId);
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    session.setAttribute("message", "Đã hủy đơn hàng #" + orderId);
                } else {
                    session.setAttribute("error", "Không thể hủy đơn hàng");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra khi hủy đơn hàng");
        }
        
        response.sendRedirect("Orders4Servlet");
    }
}