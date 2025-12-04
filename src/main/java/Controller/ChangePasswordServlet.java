/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/ChangePasswordServlet"})
public class ChangePasswordServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "hien031204";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            // Kiểm tra mật khẩu hiện tại
            if (!validateCurrentPassword(userId, currentPassword)) {
                out.print("{\"status\":\"error\",\"message\":\"Mật khẩu hiện tại không đúng\"}");
                return;
            }

            // Kiểm tra mật khẩu mới và xác nhận
            if (!newPassword.equals(confirmPassword)) {
                out.print("{\"status\":\"error\",\"message\":\"Mật khẩu mới và xác nhận không khớp\"}");
                return;
            }

            // Kiểm tra độ mạnh mật khẩu
            if (newPassword.length() < 8) {
                out.print("{\"status\":\"error\",\"message\":\"Mật khẩu phải có ít nhất 8 ký tự\"}");
                return;
            }

            // Cập nhật mật khẩu mới
            updatePassword(userId, newPassword);

            out.print("{\"status\":\"success\",\"message\":\"Đổi mật khẩu thành công\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\",\"message\":\"Lỗi hệ thống\"}");
        } finally {
            out.flush();
            out.close();
        }
    }

    private boolean validateCurrentPassword(int userId, String currentPassword) throws SQLException {
        String sql = "SELECT password FROM users WHERE id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("password").equals(currentPassword);
            }
            return false;
        }
    }

    private void updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        }
    }
}
