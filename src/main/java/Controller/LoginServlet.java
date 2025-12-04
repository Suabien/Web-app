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
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/loginservlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String username = request.getParameter("user");
        String password = request.getParameter("pass");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            request.setAttribute("status", "error");
            request.setAttribute("action", "login");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        if (username.length() < 5 || password.length() < 8) {
            request.setAttribute("message", "Tên tài khoản tối thiểu 5 kí tự, mật khẩu tối thiểu 8 kí tự!");
            request.setAttribute("status", "error");
            request.setAttribute("action", "login");
            request.setAttribute("user", username);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Kiểm tra tài khoản tồn tại
            String checkUserQuery = "SELECT * FROM users WHERE username=?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery);
            checkStmt.setString(1, username);
            ResultSet userCheck = checkStmt.executeQuery();

            if (!userCheck.next()) {
                request.setAttribute("message", "Tài khoản chưa tồn tại! Vui lòng đăng ký.");
                request.setAttribute("status", "error");
                request.setAttribute("action", "login");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Kiểm tra đăng nhập & lấy vai trò (role) cùng user id
            String query = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id"); // Lấy user id từ CSDL
                String role = rs.getString("role"); // Lấy vai trò của user từ CSDL

                // Lưu thông tin vào session (bao gồm userId, username, role)
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                // Chuyển hướng theo vai trò
                if ("admin".equals(role)) {
                    // Admin → Trang quản lý
                    response.sendRedirect("/2274820014_NguyenThuHienn/View/manage.jsp");

                } else {
                    // Khách hàng bình thường → Trang chủ
                    response.sendRedirect("/2274820014_NguyenThuHienn/HomeProductServlet");
                }
            } else {
                request.setAttribute("message", "Sai tài khoản hoặc mật khẩu!");
                request.setAttribute("status", "error");
                request.setAttribute("action", "login");
                request.setAttribute("user", username);
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra!");
            request.setAttribute("status", "error");
            request.setAttribute("action", "login");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
