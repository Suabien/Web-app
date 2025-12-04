<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="DAO.DatabaseConnection,java.sql.*,java.text.NumberFormat,java.util.Locale" %>
<%
  request.setCharacterEncoding("UTF-8");
  String oidParam = request.getParameter("order_id");
  String ctx = request.getContextPath(); // Lấy context path để link CSS
  int oid = 0;
  try { oid = Integer.parseInt(oidParam); } catch(Exception ignore){}

  String cust="", addr="", phone="", date="", paymentMethod="COD";
  double totalAmount = 0;
  String rows = "";
  double subTotal = 0; 
  
  NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

  if (oid > 0) {
    try (Connection cn = DatabaseConnection.getConnection()) {
      // 1. Lấy Header
      try (PreparedStatement ps = cn.prepareStatement(
           "SELECT customer_name, address, phone, order_date, total_amount, payment_method FROM orders WHERE order_id=?")) {
        ps.setInt(1, oid);
        try (ResultSet r = ps.executeQuery()) {
          if (r.next()) {
            cust  = r.getString("customer_name");
            addr  = r.getString("address");
            phone = r.getString("phone");
            java.sql.Date d = r.getDate("order_date");
            date  = (d == null ? "" : d.toString());
            totalAmount = r.getDouble("total_amount");
            if(r.getString("payment_method") != null) paymentMethod = r.getString("payment_method");
          }
        }
      }

      // 2. Lấy Items & Tính SubTotal
      try (PreparedStatement ps = cn.prepareStatement(
           "SELECT p.name AS product_name, IFNULL(oi.option_name,'') AS option_name, oi.quantity, oi.price " +
           "FROM order_items oi JOIN products p ON p.id = oi.product_id WHERE oi.order_id=?")) {
        ps.setInt(1, oid);
        try (ResultSet rs = ps.executeQuery()) {
          StringBuilder sb = new StringBuilder();
          int i = 1;
          while (rs.next()) {
            String name = rs.getString("product_name");
            String opt  = rs.getString("option_name");
            int qty     = rs.getInt("quantity");
            
            double priceVal = 0;
            String priceStr = rs.getString("price");
            try { priceVal = Double.parseDouble(priceStr); } 
            catch (Exception e) { try { priceVal = Double.parseDouble(priceStr.replace(".","").replace(",","")); } catch(Exception ex){} }
            
            subTotal += (priceVal * qty);

            String displayOpt = (opt == null || opt.trim().isEmpty()) ? "" : " (" + opt + ")";
            sb.append("<tr>")
              .append("<td style='text-align:center'>").append(i++).append("</td>")
              .append("<td><div class='prod-name'>").append(name).append(displayOpt).append("</div></td>")
              .append("<td style='text-align:center'>").append(qty).append("</td>")
              .append("<td style='text-align:right'>").append(nf.format(priceVal)).append("</td>") 
              .append("<td style='text-align:right'>").append(nf.format(priceVal * qty)).append("</td>") 
              .append("</tr>");
          }
          rows = sb.length() == 0 ? "<tr><td colspan='5' style='text-align:center;padding:20px'>Trống</td></tr>" : sb.toString();
        }
      }
    } catch(Exception e){ rows = "Lỗi: "+e.getMessage(); }
  }
  
  double shippingFee = totalAmount - subTotal;
  if(shippingFee < 0) shippingFee = 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Phiếu giao hàng #<%= oid %></title>
  <link rel="stylesheet" href="<%= ctx %>/CSS/print_item.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="invoice-container">
  <button class="print-btn" onclick="window.print()"><i class="fa fa-print"></i> IN PHIẾU</button>

  <div class="header">
    <div class="logo">
      <h1>Fluffy Bear</h1>
      <p style="margin:5px 0 0; color:#666">Phụ kiện & Quà tặng</p>
      <p style="margin:2px 0 0; font-size:12px"><i class="fa fa-phone"></i> 0987.654.321</p>
    </div>
    <div class="invoice-info">
      <h2>PHIẾU GIAO HÀNG</h2>
      <div style="margin-top:5px">Mã đơn: <strong>#<%= oid %></strong></div>
      <div>Ngày đặt: <%= date %></div>
      <div style="margin-top:5px; font-weight:bold; color:#2563eb">PTTT: <%= paymentMethod %></div>
    </div>
  </div>

  <div class="addresses">
    <div class="addr-col">
      <div class="addr-title">NGƯỜI GỬI</div>
      <div class="addr-box">
        <strong>Cửa hàng Fluffy Bear</strong>
        <span class="addr-line">Địa chỉ: 123 Cầu Giấy, Hà Nội</span>
        <span class="addr-line">Website: fluffybear.vn</span>
      </div>
    </div>
    <div class="addr-col">
      <div class="addr-title">NGƯỜI NHẬN</div>
      <div class="addr-box">
        <strong><%= cust %></strong>
        <span class="addr-line"><i class="fa fa-phone"></i> <%= phone %></span>
        <span class="addr-line"><i class="fa fa-map-marker-alt"></i> <%= addr %></span>
      </div>
    </div>
  </div>

  <table>
    <thead>
      <tr>
        <th style="width:40px;text-align:center">STT</th>
        <th>Sản phẩm</th>
        <th style="width:50px;text-align:center">SL</th>
        <th style="width:110px;text-align:right">Đơn giá</th>
        <th style="width:110px;text-align:right">Thành tiền</th>
      </tr>
    </thead>
    <tbody><%= rows %></tbody>
  </table>

  <div class="totals">
    <table class="totals-table">
      <tr>
        <td class="lbl">Tạm tính:</td>
        <td class="val"><%= nf.format(subTotal) %></td>
      </tr>
      <tr>
        <td class="lbl">Phí vận chuyển:</td>
        <td class="val"><%= nf.format(shippingFee) %></td>
      </tr>
      <tr class="grand-row">
        <td class="grand-lbl">TỔNG CỘNG:</td>
        <td class="grand-total"><%= nf.format(totalAmount) %></td>
      </tr>
    </table>
  </div>

  <div class="footer">
    <p>Cảm ơn quý khách đã mua hàng! Vui lòng quay video khi mở hộp để được hỗ trợ đổi trả.</p>
  </div>
</div>
</body>
</html>