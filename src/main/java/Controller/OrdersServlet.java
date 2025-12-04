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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "OrdersServlet", urlPatterns = {"/OrdersServlet"})
public class OrdersServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            Connection conn = null;
            PreparedStatement pstmtOrder = null;
            PreparedStatement pstmtItem = null;

            try {
                // Lấy thông tin từ request
                int userId = Integer.parseInt(request.getParameter("user_id"));
                String customerName = request.getParameter("customer_name");
                String address = request.getParameter("address");
                String phone = request.getParameter("phone");
                String paymentMethod = request.getParameter("payment_method");
                String orderDateStr = request.getParameter("order_date"); // yyyy-MM-dd
                int productId = Integer.parseInt(request.getParameter("product_id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                double totalAmount = Double.parseDouble(request.getParameter("total_amount"));
                String optionName = request.getParameter("option_name");
                String status = "Chờ duyệt";

                Date orderDate = Date.valueOf(orderDateStr);

                conn = DatabaseConnection.getConnection();
                conn.setAutoCommit(false); // Bắt đầu transaction

                // 1. Thêm vào bảng orders
                String sqlOrder = "INSERT INTO orders (user_id, customer_name, address, phone, order_date, payment_method, total_amount, status) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                pstmtOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
                pstmtOrder.setInt(1, userId);
                pstmtOrder.setString(2, customerName);
                pstmtOrder.setString(3, address);
                pstmtOrder.setString(4, phone);
                pstmtOrder.setDate(5, orderDate);
                pstmtOrder.setString(6, paymentMethod);
                pstmtOrder.setDouble(7, totalAmount);
                pstmtOrder.setString(8, status);

                int affectedRows = pstmtOrder.executeUpdate();
                if (affectedRows == 0) throw new SQLException("Không thể tạo đơn hàng.");

                int orderId = -1;
                try (ResultSet generatedKeys = pstmtOrder.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Không lấy được order_id.");
                    }
                }

                // 2. Thêm vào bảng order_items
                String sqlItem = "INSERT INTO order_items (order_id, product_id, quantity, price, option_name) VALUES (?, ?, ?, ?, ?)";
                pstmtItem = conn.prepareStatement(sqlItem);

                double unitPrice = totalAmount / quantity;

                pstmtItem.setInt(1, orderId);
                pstmtItem.setInt(2, productId);
                pstmtItem.setInt(3, quantity);
                pstmtItem.setDouble(4, unitPrice);
                pstmtItem.setString(5, optionName);
                pstmtItem.executeUpdate();

                conn.commit();
                response.getWriter().write("success");

            } catch (Exception e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                e.printStackTrace();
                response.getWriter().write("error: " + e.getMessage());
            } finally {
                try {
                    if (pstmtItem != null) pstmtItem.close();
                    if (pstmtOrder != null) pstmtOrder.close();
                    if (conn != null) conn.setAutoCommit(true);
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
}

