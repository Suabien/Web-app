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

@WebServlet(name = "RegisterServlet", urlPatterns = {"/registerservlet"})
public class RegisterServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
        String role = request.getParameter("role");
        
        // Debug: in ra role để kiểm tra
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        System.out.println("Role: " + role);
        
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            request.setAttribute("status", "error");
            request.setAttribute("action", "register");
            request.setAttribute("user", username);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        if (username.length() < 5 || password.length() < 8) {
            request.setAttribute("message", "Tên tài khoản phải tối thiểu 5 ký tự và mật khẩu tối thiểu 8 ký tự!");
            request.setAttribute("status", "error");
            request.setAttribute("action", "register");
            request.setAttribute("user", username);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // Validate role - nếu role null thì set mặc định
        if (role == null || role.trim().isEmpty()) {
            role = "Khách hàng";
        }
        
        // Validate role hợp lệ
        if (!role.equals("Khách hàng") && !role.equals("Người bán hàng") && !role.equals("Nhà cung cấp")) {
            role = "Khách hàng"; // Mặc định nếu role không hợp lệ
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            String checkUser = "SELECT * FROM users WHERE username=?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUser);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("message", "Tài khoản đã tồn tại!");
                request.setAttribute("status", "error");
                request.setAttribute("action", "register");
                request.setAttribute("user", username);
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                // CẬP NHẬT CÂU LỆNH SQL ĐỂ THÊM ROLE
                String insertUser = "INSERT INTO users(username, password, role) VALUES (?,?,?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertUser);
                insertStmt.setString(1, username);
                insertStmt.setString(2, password);
                insertStmt.setString(3, role); 

                int rows = insertStmt.executeUpdate();
                if (rows > 0) {
                    request.setAttribute("message", "Đăng ký thành công với vai trò " + role + "! Hãy đăng nhập nào.");
                    request.setAttribute("status", "success");
                    request.setAttribute("action", "register");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "Đăng ký thất bại!");
                    request.setAttribute("status", "error");
                    request.setAttribute("action", "register");
                    request.setAttribute("user", username);
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi kết nối CSDL: " + e.getMessage());
            request.setAttribute("status", "error");
            request.setAttribute("action", "register");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}