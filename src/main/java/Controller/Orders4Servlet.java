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
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.Order;
import Model.OrderItem;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "Orders4Servlet", urlPatterns = {"/Orders4Servlet"})
public class Orders4Servlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "hien031204";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            // Lấy danh sách đơn hàng của user
            String orderSql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
            
            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql)) {
                orderStmt.setInt(1, userId);
                
                try (ResultSet rs = orderStmt.executeQuery()) {
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
                        
                        // Lấy chi tiết sản phẩm trong đơn hàng
                        List<OrderItem> items = getOrderItems(conn, order.getOrderId());
                        order.setItems(items);
                        
                        orders.add(order);
                    }
                }
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("View/orders.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải đơn hàng");
            request.getRequestDispatcher("View/orders.jsp").forward(request, response);
        }
    }
    
    private List<OrderItem> getOrderItems(Connection conn, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        
        String itemSql = "SELECT oi.*, p.name as product_name, p.image_url as product_image "
                       + "FROM order_items oi JOIN products p ON oi.product_id = p.id "
                       + "WHERE oi.order_id = ?";
        
        try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
            itemStmt.setInt(1, orderId);
            
            try (ResultSet rs = itemStmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setOptionName(rs.getString("option_name"));
                    item.setProductImage(rs.getString("product_image"));
                    
                    items.add(item);
                }
            }
        }
        
        return items;
    }
}
