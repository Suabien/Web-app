/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "hien031204";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/HomeProductServlet");
            return;
        }

        String period = request.getParameter("period");
        if (period == null) {
            period = "month"; // Mặc định là theo tháng
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Map<String, Object> stats = new HashMap<>();
            
            // 1. Thống kê tổng quan
            stats.put("totalUsers", getTotalUsers(conn));
            stats.put("totalProducts", getTotalProducts(conn));
            stats.put("totalOrders", getTotalOrders(conn));
            stats.put("totalRevenue", getTotalRevenue(conn));
            stats.put("totalQuantity", getTotalQuantity(conn));
            
            // 2. Thống kê doanh thu theo thời gian (tuần/tháng/năm)
            stats.put("revenueData", getRevenueData(conn, period));
            stats.put("selectedPeriod", period);
            
            // 3. Thống kê đơn hàng theo trạng thái
            stats.put("orderStatus", getOrderStatusStats(conn));
            
            // 4. Sản phẩm bán chạy (có thêm đánh giá)
            stats.put("topProducts", getTopProducts(conn));
            
            // 5. Thống kê khách hàng
            stats.put("customerStats", getCustomerStats(conn));
            
            // 6. Thống kê tồn kho sản phẩm (tất cả sản phẩm)
            stats.put("inventoryStats", getInventoryStats(conn));
            
            // 7. Thống kê đánh giá
            stats.put("ratingStats", getRatingStats(conn));
            
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("/Admin/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, "Database error: " + e.getMessage());
        }
    }
    
    // Các phương thức lấy dữ liệu thống kê
    private int getTotalUsers(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getTotalProducts(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM products";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getTotalOrders(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private double getTotalRevenue(Connection conn) throws SQLException {
        String sql = "SELECT SUM(oi.quantity * oi.price) as total_revenue " +
                     "FROM order_items oi " +
                     "JOIN orders o ON oi.order_id = o.order_id " +
                     "WHERE o.status = 'Đã giao'";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getDouble("total_revenue") : 0;
        }
    }
    
    private int getTotalQuantity(Connection conn) throws SQLException {
        String sql = "SELECT SUM(quantity) FROM products";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private Map<String, Object> getRevenueData(Connection conn, String period) throws SQLException {
        Map<String, Object> revenueData = new HashMap<>();
        Map<String, Double> revenueMap = new LinkedHashMap<>();
        String sql = "";
        
        switch (period) {
            case "week":
                sql = "SELECT WEEK(order_date) as week, SUM(total_amount) as revenue " +
                      "FROM orders WHERE status = 'Đã giao' AND YEAR(order_date) = YEAR(CURDATE()) " +
                      "GROUP BY WEEK(order_date) ORDER BY week";
                break;
            case "month":
                sql = "SELECT MONTH(order_date) as month, SUM(total_amount) as revenue " +
                      "FROM orders WHERE status = 'Đã giao' AND YEAR(order_date) = YEAR(CURDATE()) " +
                      "GROUP BY MONTH(order_date) ORDER BY month";
                break;
            case "year":
                sql = "SELECT YEAR(order_date) as year, SUM(total_amount) as revenue " +
                      "FROM orders WHERE status = 'Đã giao' " +
                      "GROUP BY YEAR(order_date) ORDER BY year DESC LIMIT 5";
                break;
            default:
                sql = "SELECT MONTH(order_date) as month, SUM(total_amount) as revenue " +
                      "FROM orders WHERE status = 'Đã giao' AND YEAR(order_date) = YEAR(CURDATE()) " +
                      "GROUP BY MONTH(order_date) ORDER BY month";
        }
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String label = "";
                switch (period) {
                    case "week":
                        label = "Tuần " + rs.getInt("week");
                        break;
                    case "month":
                        label = "Tháng " + rs.getInt("month");
                        break;
                    case "year":
                        label = "Năm " + rs.getInt("year");
                        break;
                }
                revenueMap.put(label, rs.getDouble("revenue"));
            }
        }
        
        revenueData.put("period", period);
        revenueData.put("revenue", revenueMap);
        return revenueData;
    }
    
    private Map<String, Integer> getOrderStatusStats(Connection conn) throws SQLException {
        Map<String, Integer> statusStats = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM orders GROUP BY status";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                statusStats.put(rs.getString("status"), rs.getInt("count"));
            }
        }
        return statusStats;
    }
    
    private List<Map<String, Object>> getTopProducts(Connection conn) throws SQLException {
        List<Map<String, Object>> topProducts = new ArrayList<>();

        String sql = "SELECT p.id, p.name, " +
                     "SUM(oi.quantity) as sold, " +
                     "SUM(oi.quantity * oi.price) as revenue " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "JOIN orders o ON oi.order_id = o.order_id " +
                     "WHERE o.status = 'Đã giao' " +
                     "GROUP BY p.id, p.name " +
                     "ORDER BY sold DESC LIMIT 10";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("sold", rs.getInt("sold"));
                product.put("revenue", rs.getDouble("revenue"));

                // Lấy rating riêng để tránh nhân dữ liệu
                Map<String, Object> ratingInfo = getProductRating(conn, rs.getInt("id"));
                product.put("avg_rating", ratingInfo.get("avg_rating"));
                product.put("review_count", ratingInfo.get("review_count"));

                topProducts.add(product);
            }
        }
        return topProducts;
    }

    // Phương thức mới để lấy rating mà không ảnh hưởng đến tính toán doanh thu
    private Map<String, Object> getProductRating(Connection conn, int productId) throws SQLException {
        Map<String, Object> ratingInfo = new HashMap<>();

        String sql = "SELECT COALESCE(AVG(rating), 0) as avg_rating, " +
                     "COUNT(*) as review_count " +
                     "FROM reviews " +
                     "WHERE product_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ratingInfo.put("avg_rating", rs.getDouble("avg_rating"));
                    ratingInfo.put("review_count", rs.getInt("review_count"));
                } else {
                    ratingInfo.put("avg_rating", 0.0);
                    ratingInfo.put("review_count", 0);
                }
            }
        }
        return ratingInfo;
    }
    
    private Map<String, Object> getCustomerStats(Connection conn) throws SQLException {
        Map<String, Object> customerStats = new HashMap<>();
        
        // Tổng số khách hàng
        String sql1 = "SELECT COUNT(*) FROM users WHERE role = 'Khách hàng'";
        try (PreparedStatement stmt = conn.prepareStatement(sql1);
             ResultSet rs = stmt.executeQuery()) {
            customerStats.put("totalCustomers", rs.next() ? rs.getInt(1) : 0);
        }
        
        return customerStats;
    }
    
    private Map<String, Integer> getInventoryStats(Connection conn) throws SQLException {
        Map<String, Integer> inventoryStats = new LinkedHashMap<>();
        String sql = "SELECT name, quantity FROM products WHERE quantity > 0 ORDER BY quantity DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String productName = rs.getString("name");
                int quantity = rs.getInt("quantity");
                
                // Rút gọn tên sản phẩm nếu quá dài
                if (productName.length() > 25) {
                    productName = productName.substring(0, 22) + "...";
                }
                inventoryStats.put(productName, quantity);
            }
        }
        return inventoryStats;
    }
    
    private Map<String, Object> getRatingStats(Connection conn) throws SQLException {
        Map<String, Object> ratingStats = new HashMap<>();
        
        String sql1 = "SELECT AVG(rating) as avg_rating, COUNT(*) as total_reviews FROM reviews";
        try (PreparedStatement stmt = conn.prepareStatement(sql1);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                ratingStats.put("averageRating", rs.getDouble("avg_rating"));
                ratingStats.put("totalReviews", rs.getInt("total_reviews"));
            }
        }
        
        // Phân phối rating
        String sql2 = "SELECT rating, COUNT(*) as count FROM reviews GROUP BY rating ORDER BY rating DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql2);
             ResultSet rs = stmt.executeQuery()) {
            Map<Integer, Integer> ratingDistribution = new HashMap<>();
            while (rs.next()) {
                ratingDistribution.put(rs.getInt("rating"), rs.getInt("count"));
            }
            ratingStats.put("ratingDistribution", ratingDistribution);
        }
        
        return ratingStats;
    }
}