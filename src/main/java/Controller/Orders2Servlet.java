/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Order;
import Model.OrderItem;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "Orders2Servlet", urlPatterns = {"/Orders2Servlet"})
public class Orders2Servlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "hien031204";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("details".equals(action)) {
            viewOrderDetails(request, response);
        } else {
            viewOrderList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            updateOrderStatus(request, response);
        } else {
            response.sendRedirect("Orders2Servlet");
        }
    }

    private void viewOrderList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            String sql = "SELECT o.order_id, o.customer_name, o.address, o.phone, "
                       + "o.order_date, o.payment_method, o.total_amount, o.status, "
                       + "COUNT(oi.item_id) as item_count "
                       + "FROM orders o "
                       + "LEFT JOIN order_items oi ON o.order_id = oi.order_id "
                       + "GROUP BY o.order_id "
                       + "ORDER BY o.order_date DESC";
            
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setCustomerName(rs.getString("customer_name"));
                    order.setAddress(rs.getString("address"));
                    order.setPhone(rs.getString("phone"));
                    order.setOrderDate(rs.getDate("order_date"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setItemCount(rs.getInt("item_count"));
                    
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách đơn hàng");
        }
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/Admin/manage4.jsp").forward(request, response);
    }

    private void viewOrderDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = new Order();
        List<OrderItem> items = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            // Lấy thông tin chung đơn hàng
            String orderSql = "SELECT * FROM orders WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(orderSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        order.setOrderId(rs.getInt("order_id"));
                        order.setCustomerName(rs.getString("customer_name"));
                        order.setAddress(rs.getString("address"));
                        order.setPhone(rs.getString("phone"));
                        order.setOrderDate(rs.getDate("order_date"));
                        order.setPaymentMethod(rs.getString("payment_method"));
                        order.setTotalAmount(rs.getBigDecimal("total_amount"));
                        order.setStatus(rs.getString("status"));
                    }
                }
            }
            
            // Lấy danh sách sản phẩm trong đơn hàng
            String itemsSql = "SELECT oi.*, p.name as product_name, p.id as product_id "
                           + "FROM order_items oi JOIN products p ON oi.product_id = p.id "
                           + "WHERE oi.order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(itemsSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        OrderItem item = new OrderItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setProductName(rs.getString("product_name"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        item.setOptionName(rs.getString("option_name"));
                        
                        items.add(item);
                    }
                }
            }
            
            order.setItems(items);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải chi tiết đơn hàng");
        }
        
        request.setAttribute("order", order);
        request.getRequestDispatcher("/View/orderDetails.jsp").forward(request, response);
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("newStatus");
        
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // Lấy trạng thái hiện tại của đơn hàng
            String currentStatus = getCurrentOrderStatus(conn, orderId);
            
            // Cập nhật trạng thái đơn hàng
            updateOrderStatusInDB(conn, orderId, newStatus);
            
            // Xử lý cập nhật số lượng sản phẩm dựa trên thay đổi trạng thái
            handleProductQuantityUpdate(conn, orderId, currentStatus, newStatus);
            
            conn.commit(); // Commit transaction
            
            request.setAttribute("success", "Cập nhật trạng thái đơn hàng thành công!");
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("error", "Lỗi khi cập nhật trạng thái đơn hàng: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        // Quay lại trang quản lý đơn hàng
        viewOrderList(request, response);
    }

    private String getCurrentOrderStatus(Connection conn, int orderId) throws SQLException {
        String sql = "SELECT status FROM orders WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("status");
                }
            }
        }
        return null;
    }

    private void updateOrderStatusInDB(Connection conn, int orderId, String newStatus) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    private void handleProductQuantityUpdate(Connection conn, int orderId, String oldStatus, String newStatus) throws SQLException {
        // Lấy danh sách sản phẩm trong đơn hàng
        List<OrderItem> items = getOrderItems(conn, orderId);
        
        // Xử lý theo các trường hợp chuyển trạng thái
        if ("Chờ duyệt".equals(oldStatus) && "Đang giao".equals(newStatus)) {
            // Duyệt đơn: trừ số lượng sản phẩm
            decreaseProductQuantity(conn, items);
        } 
        else if ("Đang giao".equals(oldStatus) && "Đã giao".equals(newStatus)) {
            // Giao thành công: cộng vào số lượng đã bán
            increaseProductSold(conn, items);
        }
        else if (("Chờ duyệt".equals(oldStatus) || "Đang giao".equals(oldStatus)) && 
                 ("Không duyệt".equals(newStatus) || "Đã hủy".equals(newStatus))) {
            // Hủy đơn: cộng lại số lượng sản phẩm (nếu đã trừ trước đó)
            if ("Đang giao".equals(oldStatus)) {
                increaseProductQuantity(conn, items);
            }
        }
        else if ("Đã hủy".equals(oldStatus) && "Đang giao".equals(newStatus)) {
            // Khôi phục đơn hủy: trừ lại số lượng sản phẩm
            decreaseProductQuantity(conn, items);
        }
    }

    private List<OrderItem> getOrderItems(Connection conn, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT product_id, quantity FROM order_items WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private void decreaseProductQuantity(Connection conn, List<OrderItem> items) throws SQLException {
        String sql = "UPDATE products SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";
        for (OrderItem item : items) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                int affectedRows = ps.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Không đủ số lượng sản phẩm ID: " + item.getProductId());
                }
            }
        }
    }

    private void increaseProductQuantity(Connection conn, List<OrderItem> items) throws SQLException {
        String sql = "UPDATE products SET quantity = quantity + ? WHERE id = ?";
        for (OrderItem item : items) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getProductId());
                ps.executeUpdate();
            }
        }
    }

    private void increaseProductSold(Connection conn, List<OrderItem> items) throws SQLException {
        String sql = "UPDATE products SET sold = sold + ? WHERE id = ?";
        for (OrderItem item : items) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getProductId());
                ps.executeUpdate();
            }
        }
    }
}

