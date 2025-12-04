<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    final String ctx = request.getContextPath();

    // Guard
    HttpSession sessionObj = request.getSession(false);
    String role = (sessionObj != null && sessionObj.getAttribute("role") != null)
                  ? sessionObj.getAttribute("role").toString()
                  : null;
    if (role == null || !"Nhà cung cấp".equals(role)) {
        response.sendRedirect(ctx + "/HomeProductServlet");
        return;
    }

    String fullName  = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");

    Integer pendingCount   = (Integer) request.getAttribute("pendingCount");
    Integer pickupCount    = (Integer) request.getAttribute("pickupCount");
    Integer shippingCount  = (Integer) request.getAttribute("shippingCount");
    Integer deliveredCount = (Integer) request.getAttribute("deliveredCount");
    Integer returnedCount  = (Integer) request.getAttribute("returnedCount");
    Integer canceledCount  = (Integer) request.getAttribute("canceledCount");

    // Danh sách theo trạng thái (OrderView)
    List needActionOrders  = (List) request.getAttribute("needActionOrders");   // Chờ xác nhận
    List waitingShipOrders = (List) request.getAttribute("waitingShipOrders");  // Chờ lấy hàng
    List shippingOrders    = (List) request.getAttribute("shippingOrders");     // Chờ giao
    List deliveredOrders   = (List) request.getAttribute("deliveredOrders");    // Đã giao
    List returnedOrders    = (List) request.getAttribute("returnedOrders");     // Hoàn trả
    List canceledOrders    = (List) request.getAttribute("canceledOrders");     // Đã huỷ
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý đơn hàng - Fluffy Bear</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="<%=ctx%>/CSS/ncc_order.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <!-- Header -->
        <div class="header-cart">
            <div class="logo">
                <a href="<%=ctx%>/HomeProductServlet"><img src="<%=ctx%>/Images/logo.png" alt="Logo"></a>
                <h1><a href="<%=ctx%>/HomeProductServlet">Fluffy Bear</a></h1>
            </div>
            <div class="user-avatar-container">
                <div class="user-avatar" onclick="toggleUserInfo()">
                    <img class="user-img" src="<%= imagePath != null ? (request.getContextPath() + "/" + imagePath) : (ctx + "/Images/sanpham1.jpg") %>" />
                </div>
                <span class="greeting">Xin chào, <%= fullName != null ? fullName : "Tên người dùng" %> !</span>
                <div class="user-info-popup" id="userInfoPopup">
                    <div class="user-info-header">
                        <div class="user-info-avatar">
                            <img src="<%= imagePath != null ? (request.getContextPath() + "/" + imagePath) : (ctx + "/Images/sanpham1.jpg") %>" />
                        </div>
                        <div class="user-info-name"><%= fullName != null ? fullName : "Tên người dùng" %></div>
                        <div class="user-info-role">Nhà cung cấp</div>
                    </div>
                    <div class="user-info-content">
                        <ul class="user-info-menu">
                            <li class="user-info-item">
                                <a href="/2274820014_NguyenThuHienn/UserInfoServlet" class="user-info-link">
                                    <i class="fas fa-user-circle"></i>
                                    Thông tin cá nhân
                                </a>
                            </li>
                            <li class="user-info-item">
                                <a href="/2274820014_NguyenThuHienn/ShopServlet" class="user-info-link">
                                    <i class="fas fa-user-gear"></i> Quản lý hệ thống
                                </a>
                            </li>
                            <li class="user-info-item">
                                <a href="<%=ctx%>/View/password.jsp" class="user-info-link">
                                    <i class="fas fa-lock"></i> Đổi mật khẩu
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="user-info-footer">
                        <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" style="margin:0;">
                            <button type="submit" class="logout-btn-popup">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard -->
        <div class="dashboard-wrapper">
            <!-- Sidebar -->
            <div class="dashboard-sidebar">
                <div class="sidebar-header">
                    <h2><i class="fas fa-cogs"></i> Bảng điều khiển</h2>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="<%=ctx%>/ShopServlet"><i class="fas fa-users"></i> Quản lý cửa hàng</a></li>
                    <li><a href="<%=ctx%>/NccProductServlet"><i class="fas fa-box"></i> Quản lý sản phẩm</a></li>
                    <li><a href="<%=ctx%>/NccOptionServlet"><i class="fas fa-tags"></i> Quản lý loại sản phẩm</a></li>
                    <li><a href="<%=ctx%>/NccOrderServlet" class="active"><i class="fas fa-shopping-cart"></i> Quản lý đơn hàng</a></li>
                </ul>
            </div>

            <main class="dashboard-content">
                <div class="content-header">
                    <h1 id="content-title">Quản lý đơn hàng</h1>
                    <p>Theo dõi và xử lý đơn hàng theo trạng thái</p>
                </div>
                <div class="stat-cards">
                    <div class="stat-card"><div class="stat-title">Chờ xác nhận</div><div class="stat-value"><%= pendingCount==null?0:pendingCount %></div></div>
                    <div class="stat-card"><div class="stat-title">Chờ lấy hàng</div><div class="stat-value"><%= pickupCount==null?0:pickupCount %></div></div>
                    <div class="stat-card"><div class="stat-title">Chờ giao</div><div class="stat-value"><%= shippingCount==null?0:shippingCount %></div></div>
                    <div class="stat-card"><div class="stat-title">Đã giao</div><div class="stat-value"><%= deliveredCount==null?0:deliveredCount %></div></div>
                    <div class="stat-card"><div class="stat-title">Hoàn trả</div><div class="stat-value"><%= returnedCount==null?0:returnedCount %></div></div>
                    <div class="stat-card"><div class="stat-title">Đã huỷ</div><div class="stat-value"><%= canceledCount==null?0:canceledCount %></div></div>
                </div>

                <!-- Chờ xác nhận -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Đơn cần xử lý ngay</h3>
                        <button class="btn-add" onclick="location.reload()">Làm mới</button>
                    </div>
                    <table>
                        <thead>
                        <tr>
                            <th style="width:90px;">Mã</th>
                            <th>Tên cửa hàng</th>
                            <th>Ngày giao</th>
                            <th style="width:150px;">Số lượng</th>
                            <th style="width:140px;">Trạng thái</th>
                            <th style="width:220px;">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                          if (needActionOrders == null || needActionOrders.size() == 0) {
                        %>
                          <tr>
                            <td colspan="8" style="text-align:center;padding:40px;color:#6c757d;">
                              <i class="fas fa-bolt" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                              Không có dữ liệu
                            </td>
                          </tr>
                        <%
                          } else {
                            for (int i = 0; i < needActionOrders.size(); i++) {
                              Object o = needActionOrders.get(i);
                              java.lang.reflect.Method m;

                              String id="#", shop="", seller="", address="", phone="", date="", total="0", statusLabel="Chờ xác nhận", badge="badge-warning";
                              String reason="", product="", optName="", optPrice="", productImg="";
                              try{ m=o.getClass().getMethod("getId");           id          ="#"+String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getShopName");     shop        =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getSellerName");   seller      =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getAddress");      address     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getPhone");        phone       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getOrderDate");    date        =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getTotal");        total       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getStatusLabel");  statusLabel =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getStatusClass");  badge       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getProductName");  product     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getOptionName");   optName     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getOptionPrice");  optPrice    =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getProductImage"); productImg  =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                        %>
                          <tr>
                            <td><%= id %></td>
                            <td><%= shop %></td>
                            <td><%= date %></td>
                            <td><%= total %></td>
                            <td><span class="badge <%= (badge==null||badge.isEmpty())?"badge-warning":badge %>"><%= statusLabel %></span></td>
                            <td class="action-buttons">
                              <button class="btn-view"
                                      onclick="openOrderModal(this)"
                                      data-id="<%= id.replace("#","") %>"
                                      data-shop="<%= shop %>"
                                      data-seller="<%= seller %>"
                                      data-address="<%= address %>"
                                      data-phone="<%= phone %>"
                                      data-orderdate="<%= date %>"
                                      data-status="<%= statusLabel %>"
                                      data-total="<%= total %>"
                                      data-product="<%= product %>"
                                      data-option="<%= optName %>"
                                      data-optionprice="<%= optPrice %>"
                                      data-productimg="<%= (productImg==null||productImg.isEmpty()) ? (ctx + "/Images/sanpham1.jpg") : (ctx + "/" + productImg) %>">
                                <i class="fas fa-eye"></i> Xem
                              </button>
                              <button class="btn-primary"
                                      onclick="advanceStatus('<%= id.replace("#","") %>','Chờ lấy hàng')">
                                <i class="fas fa-check"></i> Xác nhận
                              </button>
                            </td>
                          </tr>
                        <%
                            }
                          }
                        %>
                        </tbody>
                    </table>
                </div>

                <!-- Chờ lấy hàng -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Đơn chờ lấy hàng</h3>
                        <button class="btn-add" onclick="location.reload()">Làm mới</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:90px;">Mã</th>
                                <th>Tên cửa hàng</th>
                                <th>Ngày giao</th>
                                <th>Số lượng</th>
                                <th>Trạng thái</th>
                                <th style="width:220px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                          if (waitingShipOrders == null || waitingShipOrders.size() == 0) {
                        %>
                          <tr>
                            <td colspan="6" style="text-align:center;padding:40px;color:#6c757d;">
                              <i class="fas fa-truck" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                              Không có dữ liệu
                            </td>
                          </tr>
                        <%
                          } else {
                            for (int i = 0; i < waitingShipOrders.size(); i++) {
                              Object o = waitingShipOrders.get(i);
                              java.lang.reflect.Method m;

                              String id="#", shop="", seller="", address="", phone="", date="", total="0", statusLabel="Chờ lấy hàng", badge="badge-primary";
                              String reason="", product="", optName="", optPrice="", productImg="";
                              try{ m=o.getClass().getMethod("getId");           id          ="#"+String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getShopName");     shop        =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getSellerName");   seller      =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getAddress");      address     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getPhone");        phone       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getOrderDate");    date        =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getTotal");        total       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getStatusLabel");  statusLabel =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getStatusClass");  badge       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getProductName");  product     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getOptionName");   optName     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getOptionPrice");  optPrice    =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                              try{ m=o.getClass().getMethod("getProductImage"); productImg  =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                        %>
                          <tr>
                            <td><%= id %></td>
                            <td><%= shop %></td>
                            <td><%= date %></td>
                            <td><%= total %></td>
                            <td><span class="badge <%= (badge==null||badge.isEmpty())?"badge-primary":badge %>"><%= statusLabel %></span></td>
                            <td class="action-buttons">
                              <button class="btn-view"
                                      onclick="openOrderModal(this)"
                                      data-id="<%= id.replace("#","") %>"
                                      data-shop="<%= shop %>"
                                      data-seller="<%= seller %>"
                                      data-address="<%= address %>"
                                      data-phone="<%= phone %>"
                                      data-orderdate="<%= date %>"
                                      data-status="<%= statusLabel %>"
                                      data-total="<%= total %>"
                                      data-product="<%= product %>"
                                      data-option="<%= optName %>"
                                      data-optionprice="<%= optPrice %>"
                                      data-productimg="<%= (productImg==null||productImg.isEmpty()) ? (ctx + "/Images/sanpham1.jpg") : (ctx + "/" + productImg) %>">
                                <i class="fas fa-eye"></i> Xem
                              </button>
                              <button class="btn-success"
                                      onclick="advanceStatus('<%= id.replace("#","") %>','Chờ giao')">
                                <i class="fas fa-truck"></i> Bàn giao
                              </button>
                            </td>
                          </tr>
                        <%
                            }
                          }
                        %>
                        </tbody>
                    </table>
                </div>

                <!-- Chờ giao -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Đơn chờ giao</h3>
                        <button class="btn-add" onclick="location.reload()">Làm mới</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:90px;">ID</th>
                                <th>Tên cửa hàng</th>
                                <th>Ngày giao</th>
                                <th>Số lượng</th>
                                <th>Trạng thái</th>
                                <th style="width:220px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                              if (shippingOrders == null || shippingOrders.size() == 0) {
                            %>
                              <tr>
                                <td colspan="6" style="text-align:center;padding:40px;color:#6c757d;">
                                  <i class="fas fa-truck" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                                  Không có dữ liệu
                                </td>
                              </tr>
                            <%
                              } else {
                                for (int i = 0; i < shippingOrders.size(); i++) {
                                  Object o = shippingOrders.get(i);
                                  java.lang.reflect.Method m;

                                  String id="#", shop="", seller="", address="", phone="", date="", total="0", statusLabel="Chờ giao", badge="badge-info";
                                  String reason="", product="", optName="", optPrice="", productImg="";
                                  try{ m=o.getClass().getMethod("getId");           id          ="#"+String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getShopName");     shop        =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getSellerName");   seller      =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getAddress");      address     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getPhone");        phone       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getOrderDate");    date        =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getTotal");        total       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getStatusLabel");  statusLabel =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getStatusClass");  badge       =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getProductName");  product     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getOptionName");   optName     =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getOptionPrice");  optPrice    =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                                  try{ m=o.getClass().getMethod("getProductImage"); productImg  =String.valueOf(m.invoke(o)); }catch(Exception ignore){}
                            %>
                              <tr>
                                <td><%= id %></td>
                                <td><%= shop %></td>
                                <td><%= date %></td>
                                <td><%= total %></td>
                                <td><span class="badge <%= (badge==null||badge.isEmpty())?"badge-info":badge %>"><%= statusLabel %></span></td>
                                <td class="action-buttons">
                                  <button class="btn-view"
                                          onclick="openOrderModal(this)"
                                          data-id="<%= id.replace("#","") %>"
                                          data-shop="<%= shop %>"
                                          data-seller="<%= seller %>"
                                          data-address="<%= address %>"
                                          data-phone="<%= phone %>"
                                          data-orderdate="<%= date %>"
                                          data-status="<%= statusLabel %>"
                                          data-total="<%= total %>"
                                          data-product="<%= product %>"
                                          data-option="<%= optName %>"
                                          data-optionprice="<%= optPrice %>"
                                          data-productimg="<%= (productImg==null||productImg.isEmpty()) ? (ctx + "/Images/sanpham1.jpg") : (ctx + "/" + productImg) %>">
                                    <i class="fas fa-eye"></i> Xem
                                  </button>
                                  <button class="btn-success"
                                          onclick="advanceStatus('<%= id.replace("#","") %>','Đã giao')">
                                    <i class="fas fa-check"></i> Đánh dấu đã giao
                                  </button>
                                </td>
                              </tr>
                            <%
                                }
                              }
                            %>
                            </tbody>
                    </table>
                </div>

                <!-- Đã giao -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Đơn đã giao</h3>
                        <button class="btn-add" onclick="location.reload()">Làm mới</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:90px;">ID</th>
                                <th>Tên cửa hàng</th>
                                <th>Ngày giao</th>
                                <th>Số lượng</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (deliveredOrders == null || deliveredOrders.size() == 0) {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align:center;padding:40px;color:#6c757d;">
                                        <i class="fas fa-check-circle" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            <%
                                } else {
                                  for (int i = 0; i < deliveredOrders.size(); i++) {
                                    Object o = deliveredOrders.get(i);
                                    java.lang.reflect.Method m;
                                    String id="#", seller="", date="", total="0";
                                    try{ m=o.getClass().getMethod("getId");           id     ="#"+String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getSellerName");   seller = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getOrderDate");    date   = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getTotal");        total  = String.valueOf(m.invoke(o)); }catch(Exception e){}
                            %>
                                <tr>
                                    <td><%= id %></td>
                                    <td><%= seller %></td>
                                    <td><%= date %></td>
                                    <td><%= total %></td>
                                    <td><span class="badge badge-success">Thành công</span></td>
                                </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Hoàn trả -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Đơn hoàn trả</h3>
                        <button class="btn-add" onclick="location.reload()">Làm mới</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:90px;">ID</th>
                                <th>Tên cửa hàng</th>
                                <th>Ngày hoàn</th>
                                <th>Số lượng</th>
                                <th>Lý do</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (returnedOrders == null || returnedOrders.size() == 0) {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align:center;padding:40px;color:#6c757d;">
                                        <i class="fas fa-undo-alt" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            <%
                                } else {
                                  for (int i = 0; i < returnedOrders.size(); i++) {
                                    Object o = returnedOrders.get(i);
                                    java.lang.reflect.Method m;
                                    String id="#", seller="", date="", total="0", reason="";
                                    try{ m=o.getClass().getMethod("getId");           id     ="#"+String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getSellerName");   seller = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getOrderDate");    date   = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getTotal");        total  = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getReason");       reason = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    if (reason == null || reason.trim().isEmpty()) reason = "Không rõ";
                            %>
                                <tr>
                                    <td><%= id %></td>
                                    <td><%= seller %></td>
                                    <td><%= date %></td>
                                    <td><%= total %></td>
                                    <td><%= reason %></td>
                                </tr>
                            <%
                                  }
                                }
                            %>
                        </tbody>
                    </table>
                </div>

              <!-- Đã hủy -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Đơn hủy</h3>
                        <button class="btn-add" onclick="location.reload()">Làm mới</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:90px;">ID</th>
                                <th>Tên cửa hàng</th>
                                <th>Ngày hủy</th>
                                <th>Số lượng</th>
                                <th>Lý do</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (canceledOrders == null || canceledOrders.size() == 0) {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align:center;padding:40px;color:#6c757d;">
                                        <i class="fas fa-ban" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            <%
                                } else {
                                  for (int i = 0; i < canceledOrders.size(); i++) {
                                    Object o = canceledOrders.get(i);
                                    java.lang.reflect.Method m;
                                    String id="#", seller="", date="", total="0", reason="";
                                    try{ m=o.getClass().getMethod("getId");           id     ="#"+String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getSellerName");   seller = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getOrderDate");    date   = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getTotal");        total  = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    try{ m=o.getClass().getMethod("getReason");       reason = String.valueOf(m.invoke(o)); }catch(Exception e){}
                                    if (reason == null || reason.trim().isEmpty()) reason = "Không rõ";
                            %>
                                <tr>
                                    <td><%= id %></td>
                                    <td><%= seller %></td>
                                    <td><%= date %></td>
                                    <td><%= total %></td>
                                    <td><%= reason %></td>
                                </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- Form ẩn cập nhật trạng thái -->
        <form id="orderActionForm" action="<%=ctx%>/NccOrderServlet" method="post" style="display:none;">
            <input type="hidden" name="action" id="oa-action" value="">
            <input type="hidden" name="order_id" id="oa-id" value="">
            <input type="hidden" name="new_status" id="oa-status" value="">
            <input type="hidden" name="reason" id="oa-reason" value="">
        </form>
            
        <!-- Modal chi tiết đơn -->
        <div id="orderDetailModal" class="odm" style="display:none;">
          <div class="odm-dialog">
            <div class="odm-header">
              <h3>Chi tiết đơn <span id="odm-id"></span></h3>
              <button class="odm-close" onclick="closeOrderModal()">&times;</button>
            </div>

            <div class="odm-body">
              <!-- Thông tin chung -->
              <div class="odm-grid">
                <div><strong>Cửa hàng:</strong> <span id="odm-shop"></span></div>
                <div><strong>Người bán:</strong> <span id="odm-seller"></span></div>
                <div><strong>Địa chỉ:</strong> <span id="odm-address"></span></div>
                <div><strong>SĐT:</strong> <span id="odm-phone"></span></div>
                <div><strong>Ngày đặt:</strong> <span id="odm-orderdate"></span></div>
                <div><strong>Trạng thái:</strong> <span id="odm-status"></span></div>
              </div>

              <hr>

              <!-- Sản phẩm/tuỳ chọn -->
              <div class="odm-grid">
                  <div class="odm-row">
                      <div class="odm-row-optional" id="odm-row-product">
                        <strong>Số lượng:</strong> <span id="odm-qty"></span>
                    </div>
                    <div class="odm-row-optional" id="odm-row-product">
                      <strong>Sản phẩm:</strong> <span id="odm-product"></span>
                    </div>
                    <div class="odm-row-optional" id="odm-row-option">
                      <strong>Tuỳ chọn:</strong> <span id="odm-option"></span>
                    </div>
                    <div class="odm-row-optional" id="odm-row-option-price">
                      <strong>Giá tuỳ chọn:</strong> <span id="odm-option-price"></span>
                    </div>
                  </div>
                  <div class="odm-product odm-row-optional" id="odm-row-image" style="margin-top:8px;">
                    <img id="odm-product-img" alt="product" style="max-height:120px;border-radius:10px;">
                </div>
                  </div>
            </div>

            <div class="odm-footer">
              <button class="btn-secondary" onclick="closeOrderModal()">Đóng</button>
            </div>
          </div>
        </div>

        <script>window.__APP_CTX = '<%=request.getContextPath()%>';</script>
        <script src="<%=ctx%>/JS/ncc_order.js"></script>
    </body>
</html>
