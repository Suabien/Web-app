/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Gigabyte
 */
@MultipartConfig
@WebServlet(name = "UserInfoServlet", urlPatterns = {"/UserInfoServlet"})
public class UserInfoServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "hien031204";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            String sql = "SELECT * FROM user_profiles WHERE user_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String fullName = rs.getString("full_name");
                String imagePath = rs.getString("image_info");

                // Gán vào request để hiển thị ngay
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("phone", rs.getString("phone"));
                request.setAttribute("address", rs.getString("address"));
                request.setAttribute("dob", rs.getDate("dob"));
                request.setAttribute("imagePath", imagePath);

                // Lưu vào session để dùng ở các trang JSP
                session.setAttribute("fullName", fullName);
                session.setAttribute("imagePath", imagePath);

                // ✅ Lưu vào Cookie (và encode để tránh lỗi ký tự không hợp lệ)
                Cookie fullNameCookie = new Cookie("fullName", URLEncoder.encode(fullName, "UTF-8"));
                Cookie imagePathCookie = new Cookie("imagePath", URLEncoder.encode(imagePath, "UTF-8"));
                fullNameCookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
                imagePathCookie.setMaxAge(60 * 60 * 24 * 7);
                response.addCookie(fullNameCookie);
                response.addCookie(imagePathCookie);
            }

            request.getRequestDispatcher("View/user_info.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String fullName = request.getParameter("fullname");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");
        String dob      = request.getParameter("dob");

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            // 1. Xử lý upload ảnh
            String imagePath = null;
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                String fileName = userId + "_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                imagePath = "uploads/" + fileName;
                filePart.write(uploadPath + File.separator + fileName);

                System.out.println("Image uploaded: " + imagePath);
                System.out.println("Physical path: " + uploadPath + File.separator + fileName);
            }

            // 2. Kiểm tra xem user_profiles đã có bản ghi cho userId này chưa
            String checkSql = "SELECT COUNT(*) FROM user_profiles WHERE user_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            boolean exists = rs.getInt(1) > 0;

            // 3. Nếu tồn tại → UPDATE, nếu chưa → INSERT mới
            String finalImagePath = imagePath;
            if (exists) {
                // Nếu không upload ảnh mới, giữ ảnh cũ
                if (finalImagePath == null) {
                    String getOldImageSql = "SELECT image_info FROM user_profiles WHERE user_id = ?";
                    PreparedStatement getOldImageStmt = conn.prepareStatement(getOldImageSql);
                    getOldImageStmt.setInt(1, userId);
                    ResultSet oldImageRs = getOldImageStmt.executeQuery();
                    if (oldImageRs.next()) {
                        finalImagePath = oldImageRs.getString("image_info");
                    }
                }

                // UPDATE
                StringBuilder upd = new StringBuilder(
                    "UPDATE user_profiles " +
                    "SET full_name = ?, email = ?, phone = ?, address = ?, dob = ?"
                );
                if (finalImagePath != null) {
                    upd.append(", image_info = ?");
                }
                upd.append(" WHERE user_id = ?");
                PreparedStatement updStmt = conn.prepareStatement(upd.toString());
                int idx = 1;
                updStmt.setString(idx++, fullName);
                updStmt.setString(idx++, email);
                updStmt.setString(idx++, phone);
                updStmt.setString(idx++, address);
                updStmt.setString(idx++, dob);
                if (finalImagePath != null) {
                    updStmt.setString(idx++, finalImagePath);
                }
                updStmt.setInt(idx, userId);
                updStmt.executeUpdate();

            } else {
                // INSERT mới
                String insertSql = 
                    "INSERT INTO user_profiles " +
                    "(user_id, full_name, email, phone, address, dob, image_info) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insStmt = conn.prepareStatement(insertSql);
                insStmt.setInt(1, userId);
                insStmt.setString(2, fullName);
                insStmt.setString(3, email);
                insStmt.setString(4, phone);
                insStmt.setString(5, address);
                insStmt.setString(6, dob);
                insStmt.setString(7, finalImagePath);
                insStmt.executeUpdate();
            }

            // 4. QUAN TRỌNG: Cập nhật session ngay lập tức
            session.setAttribute("fullName", fullName);
            if (finalImagePath != null) {
                session.setAttribute("imagePath", finalImagePath);
            }

            // 5. Cập nhật cookie
            Cookie fullNameCookie = new Cookie("fullName", URLEncoder.encode(fullName, "UTF-8"));
            Cookie imagePathCookie = new Cookie("imagePath", 
                URLEncoder.encode(finalImagePath != null ? finalImagePath : "Images/default-avatar.jpg", "UTF-8"));
            fullNameCookie.setMaxAge(60 * 60 * 24 * 7);
            imagePathCookie.setMaxAge(60 * 60 * 24 * 7);
            fullNameCookie.setPath("/");
            imagePathCookie.setPath("/");
            response.addCookie(fullNameCookie);
            response.addCookie(imagePathCookie);

            System.out.println("Session updated - fullName: " + fullName + ", imagePath: " + finalImagePath);

            // 6. Quay lại trang profile
            response.sendRedirect(request.getContextPath() + "/UserInfoServlet");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}
