/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Filter;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
@WebFilter(filterName = "UserInfoFilter", urlPatterns = {"/*"})
public class UserInfoFilter implements Filter {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "hien031204";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        System.out.println("=== UserInfoFilter Debug ===");
        System.out.println("Session: " + session);

        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            System.out.println("UserID from session: " + userId);
            System.out.println("Current fullName: " + session.getAttribute("fullName"));
            System.out.println("Current imagePath: " + session.getAttribute("imagePath"));

            // CHỈ load từ database nếu chưa có thông tin trong session
            if (userId != null && session.getAttribute("fullName") == null) {
                System.out.println("Loading user info from database...");
                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                    String sql = "SELECT full_name, image_info FROM user_profiles WHERE user_id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, userId);

                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        String fullName = rs.getString("full_name");
                        String imagePath = rs.getString("image_info");

                        System.out.println("DB - fullName: " + fullName);
                        System.out.println("DB - imagePath: " + imagePath);

                        // CHỈ set giá trị mặc định nếu database trả về null
                        if (fullName == null) fullName = "Tên người dùng";
                        if (imagePath == null) imagePath = "Images/default-avatar.jpg";

                        // Lưu vào session
                        session.setAttribute("fullName", fullName);
                        session.setAttribute("imagePath", imagePath);

                        // Lưu vào Cookie
                        Cookie fullNameCookie = new Cookie("fullName", URLEncoder.encode(fullName, "UTF-8"));
                        Cookie imagePathCookie = new Cookie("imagePath", URLEncoder.encode(imagePath, "UTF-8"));
                        fullNameCookie.setMaxAge(60 * 60 * 24 * 7);
                        imagePathCookie.setMaxAge(60 * 60 * 24 * 7);
                        fullNameCookie.setPath("/");
                        imagePathCookie.setPath("/");
                        httpResponse.addCookie(fullNameCookie);
                        httpResponse.addCookie(imagePathCookie);

                        System.out.println("User info loaded successfully!");
                    } else {
                        System.out.println("No user profile found in database");
                        // Set default values
                        session.setAttribute("fullName", "Tên người dùng");
                        session.setAttribute("imagePath", "Images/default-avatar.jpg");
                    }
                } catch (SQLException e) {
                    System.err.println("Database error in filter: " + e.getMessage());
                    e.printStackTrace();
                    // Set default values on error
                    session.setAttribute("fullName", "Tên người dùng");
                    session.setAttribute("imagePath", "Images/default-avatar.jpg");
                }
            } else {
                System.out.println("User info already loaded in session, skipping database query");
            }
        }
        System.out.println("=== End Filter Debug ===");

        chain.doFilter(request, response);
    }
}
