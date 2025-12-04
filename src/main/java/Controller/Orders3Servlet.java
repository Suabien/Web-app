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
import java.sql.*;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "Orders3Servlet", urlPatterns = {"/Orders3Servlet"})
public class Orders3Servlet extends HttpServlet {
    private static final String URL="jdbc:mysql://localhost:3306/trangsuc_db";
    private static final String USER="root", PASS="hien031204";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
      req.setCharacterEncoding("UTF-8");
      resp.setContentType("text/plain; charset=UTF-8");
      PrintWriter out = resp.getWriter();

      String action = req.getParameter("action");
      if (!"create".equals(action)) {
        out.print("invalid action");
        return;
      }

      // thông tin đơn
      String customer = req.getParameter("customer_name");
      String phone    = req.getParameter("phone");
      String address  = req.getParameter("address");
      String payMeth  = req.getParameter("payment_method");
      String dateStr  = req.getParameter("order_date");
      java.sql.Date orderDate;
      try {
        java.util.Date d = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(dateStr);
        orderDate = new java.sql.Date(d.getTime());
      } catch(Exception e) {
        orderDate = new java.sql.Date(System.currentTimeMillis());
      }

      // mảng sản phẩm
      String[] pids     = req.getParameterValues("product_id");
      String[] qtys     = req.getParameterValues("quantity");
      String[] prices   = req.getParameterValues("price");
      String[] options  = req.getParameterValues("option_name");

      if (pids==null || pids.length==0) {
        out.print("no items");
        return;
      }

      Connection conn = null;
      PreparedStatement psOrder = null, psItem = null;
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(URL, USER, PASS);
        conn.setAutoCommit(false);

        // Lấy userId từ session
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            out.print("User not logged in");
            return;
        }

        // Câu SQL chèn đơn hàng có thêm user_id
        String sqlOrder = "INSERT INTO orders (user_id, customer_name, phone, address, order_date, payment_method, total_amount, status) "
                        + "VALUES (?,?,?,?,?,?,?,?)";

        // Tính tổng tiền vẫn như cũ
        double totalAmount = 0;
        for (int i=0;i<pids.length;i++) {
          totalAmount += Integer.parseInt(qtys[i]) * Double.parseDouble(prices[i]);
        }
        totalAmount += 0; // phí ship

        psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);

        // Set userId là tham số đầu tiên
        psOrder.setInt(1, userId);
        psOrder.setString(2, customer);
        psOrder.setString(3, phone);
        psOrder.setString(4, address);
        psOrder.setDate(5, orderDate);
        psOrder.setString(6, payMeth);
        psOrder.setDouble(7, totalAmount);
        psOrder.setString(8, "Chờ duyệt");
        psOrder.executeUpdate();

        ResultSet gk = psOrder.getGeneratedKeys();
        if (!gk.next()) throw new SQLException("Không lấy được order_id");
        int orderId = gk.getInt(1);

        // 2. chèn từng item
        String sqlItem = "INSERT INTO order_items (order_id, product_id, quantity, price, option_name) "
                       + "VALUES (?,?,?,?,?)";
        psItem = conn.prepareStatement(sqlItem);
        for (int i=0;i<pids.length;i++) {
          psItem.setInt(1, orderId);
          psItem.setInt(2, Integer.parseInt(pids[i]));
          psItem.setInt(3, Integer.parseInt(qtys[i]));
          psItem.setDouble(4, Double.parseDouble(prices[i]));
          psItem.setString(5, options[i]);
          psItem.addBatch();
        }
        psItem.executeBatch();

        conn.commit();
        out.print("success");
      } catch(Exception e) {
        if (conn!=null) try { conn.rollback(); } catch(SQLException ex){}
        e.printStackTrace();
        out.print("error: "+e.getMessage());
      } finally {
        try { if (psItem!=null) psItem.close(); } catch(SQLException e){}
        try { if (psOrder!=null) psOrder.close(); } catch(SQLException e){}
        try { if (conn!=null) conn.close(); } catch(SQLException e){}
      }
    }
}
