/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Account;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AccountServlet", urlPatterns = {"/AccountServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AccountServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "hien031204";
    private static final String UPLOAD_DIR = "uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "add":
                    addUser(request, response);
                    return;
                case "edit":
                    editUser(request, response);
                    return;
                case "delete":
                    deleteUser(request, response);
                    return;
            }
        }
        
        List<Account> userList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            
            // Lấy thông tin tài khoản và thông tin cá nhân
            String query = "SELECT u.id, u.username, u.password, u.role, " +
                         "up.full_name, up.email, up.phone, up.address, up.dob, up.image_info " +
                         "FROM users u LEFT JOIN user_profiles up ON u.id = up.user_id " +
                         "WHERE u.role != 'admin'"; 
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                Account acc = new Account(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
                
                // Thêm thông tin user profile vào account
                acc.setFullName(rs.getString("full_name"));
                acc.setEmail(rs.getString("email"));
                acc.setPhone(rs.getString("phone"));
                acc.setAddress(rs.getString("address"));
                acc.setDob(rs.getString("dob"));
                acc.setImagePath(rs.getString("image_info"));
                
                userList.add(acc);
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("users", userList);
        request.getRequestDispatcher("View/manage.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); 

        // Validate role
        if (role == null || role.trim().isEmpty()) {
            role = "Khách hàng"; // Mặc định nếu không có role
        }

        // Validate không cho tạo tài khoản admin
        if ("admin".equals(role)) {
            role = "Khách hàng";
        }

        try {
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            // CẬP NHẬT CÂU LỆNH SQL ĐỂ THÊM ROLE
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO users (username, password, role) VALUES (?, ?, ?)", 
                Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, role); 

            stmt.executeUpdate();

            // Lấy ID của user vừa tạo
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int userId = rs.getInt(1);

                // Tạo profile trống cho user mới
                PreparedStatement profileStmt = conn.prepareStatement(
                    "INSERT INTO user_profiles (user_id) VALUES (?)");
                profileStmt.setInt(1, userId);
                profileStmt.executeUpdate();
                profileStmt.close();
            }

            stmt.close();
            conn.close();

            // Log để debug
            System.out.println("Thêm tài khoản thành công: " + username + ", Role: " + role);

        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("AccountServlet");
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Validate role
        if (role == null || role.trim().isEmpty()) {
            role = "Khách hàng";
        }

        String fullName = request.getParameter("full_name");
        if (fullName == null || fullName.trim().isEmpty()) fullName = "Chưa cập nhật";

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) email = "Chưa cập nhật";

        String phone = request.getParameter("phone");
        if (phone == null || phone.trim().isEmpty()) phone = "Chưa cập nhật";

        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) address = "Chưa cập nhật";

        String dob = request.getParameter("dob");
        if (dob == null || dob.trim().isEmpty()) dob = "Chưa cập nhật";

        try {
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            // 1. Cập nhật bảng users - SỬA LẠI CÂU LỆNH SQL
            PreparedStatement userStmt = conn.prepareStatement(
                "UPDATE users SET username = ?, password = ?, role = ? WHERE id = ?");
            userStmt.setString(1, username);
            userStmt.setString(2, password);
            userStmt.setString(3, role); // Thêm role
            userStmt.setInt(4, id);
            userStmt.executeUpdate();

            // Xử lý upload ảnh
            String imagePath = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // Tạo thư mục upload nếu chưa tồn tại
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Lưu file ảnh
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String filePath = uploadPath + File.separator + fileName;
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                }
                imagePath = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
            }

            // 2. Kiểm tra xem user_profiles đã có bản ghi chưa
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM user_profiles WHERE user_id = ?");
            checkStmt.setInt(1, id);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            boolean profileExists = rs.getInt(1) > 0;

            // 3. Cập nhật hoặc thêm mới user_profiles
            if (profileExists) {
                PreparedStatement updateStmt;
                if (imagePath != null) {
                    updateStmt = conn.prepareStatement(
                        "UPDATE user_profiles SET full_name = ?, email = ?, phone = ?, " +
                        "address = ?, dob = ?, image_info = ? WHERE user_id = ?");
                    updateStmt.setString(1, fullName);
                    updateStmt.setString(2, email);
                    updateStmt.setString(3, phone);
                    updateStmt.setString(4, address);
                    updateStmt.setString(5, dob);
                    updateStmt.setString(6, imagePath);
                    updateStmt.setInt(7, id);
                } else {
                    updateStmt = conn.prepareStatement(
                        "UPDATE user_profiles SET full_name = ?, email = ?, phone = ?, " +
                        "address = ?, dob = ? WHERE user_id = ?");
                    updateStmt.setString(1, fullName);
                    updateStmt.setString(2, email);
                    updateStmt.setString(3, phone);
                    updateStmt.setString(4, address);
                    updateStmt.setString(5, dob);
                    updateStmt.setInt(6, id);
                }
                updateStmt.executeUpdate();
            } else {
                PreparedStatement insertStmt = conn.prepareStatement(
                    "INSERT INTO user_profiles (user_id, full_name, email, phone, " +
                    "address, dob, image_info) VALUES (?, ?, ?, ?, ?, ?, ?)");
                insertStmt.setInt(1, id);
                insertStmt.setString(2, fullName);
                insertStmt.setString(3, email);
                insertStmt.setString(4, phone);
                insertStmt.setString(5, address);
                insertStmt.setString(6, dob);
                insertStmt.setString(7, imagePath);
                insertStmt.executeUpdate();
            }

            conn.close();

            // Thêm log để debug
            System.out.println("Cập nhật thành công user ID: " + id + ", Role: " + role);

        } catch (Exception e) {
            e.printStackTrace();
            // Thêm log lỗi chi tiết
            System.out.println("Lỗi khi cập nhật user: " + e.getMessage());
        }
        response.sendRedirect("AccountServlet");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        try {
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            // Xóa cả user và profile (nhờ cascade delete)
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE id = ?");
            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("AccountServlet");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}