<%-- 
    Document   : orderDetails.jsp
    Created on : May 28, 2025, 11:42:44 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Model.Order, Model.OrderItem" %>
<%
    Order order = (Order) request.getAttribute("order");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    // Xác định class cho trạng thái
    String statusClass = "";
    if ("Chờ duyệt".equals(order.getStatus())) {
        statusClass = "chờ-duyệt";
    } else if ("Đang giao".equals(order.getStatus())) {
        statusClass = "đang-giao";
    } else if ("Đã giao".equals(order.getStatus())) {
        statusClass = "đã-giao";
    } else if ("Không duyệt".equals(order.getStatus()) || "Đã hủy".equals(order.getStatus())) {
        statusClass = "không-duyệt";
    }
%>
<%
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");

    // Nếu session chưa có thì đọc từ Cookie
    if (fullName == null || imagePath == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("fullName".equals(cookie.getName())) {
                    fullName = cookie.getValue();
                    session.setAttribute("fullName", fullName); // Gán lại vào session
                }
                if ("imagePath".equals(cookie.getName())) {
                    imagePath = cookie.getValue();
                    session.setAttribute("imagePath", imagePath); // Gán lại vào session
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết đơn hàng #<%= order.getOrderId() %> - Fluffy Bear</title>
    <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/orderdetail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="header-cart">
        <div class="logo">
            <a href="/2274820014_NguyenThuHienn/HomeProductServlet"><img src="/2274820014_NguyenThuHienn/Images/logo.png" alt="Logo"></a>
            <h1><a href="/2274820014_NguyenThuHienn/HomeProductServlet">Fluffy Bear</a></h1>
        </div>

        <nav>
            <ul>
                <li><a href="/2274820014_NguyenThuHienn/AccountServlet"><h3></h3></a></li>
                <li><a href="/2274820014_NguyenThuHienn/ProductServlet"><h3></h3></a></li>
                <li><a href="/2274820014_NguyenThuHienn/OptionServlet"><h3></h3></a></li>
                <li><a href="/2274820014_NguyenThuHienn/Admin/manage4.jsp"><h3></h3></a></li>
            </ul>
        </nav>
        
        <!-- Nút avatar người dùng -->
        <div class="user-avatar-container">
            <div class="user-avatar" onclick="toggleUserInfo()">
                <!-- Ảnh người dùng -->
                <img class="user-img" id="avatar-img" src="<%= imagePath != null ? imagePath : "/2274820014_NguyenThuHienn/Images/default-avatar.jpg" %>" alt="Ảnh đại diện">
            </div>

            <!-- Popup thông tin người dùng -->
            <div class="user-info-popup" id="userInfoPopup">
                <div class="user-info-header">
                    <div class="user-info-avatar">
                        <img class="user-img" id="avatar-img" src="<%= imagePath != null ? imagePath : "/2274820014_NguyenThuHienn/Images/default-avatar.jpg" %>" alt="Ảnh đại diện">
                    </div>
                    <div class="user-info-name"><%= fullName != null ? fullName : "Tên người dùng" %></div>
                    <div class="user-info-role">
                        <%= userRole != null ? 
                            (userRole.equals("admin") ? "Quản trị viên" : 
                             userRole.equals("Người bán hàng") ? "Người bán" :
                             userRole.equals("Nhà cung cấp") ? "Nhà cung cấp" : "Khách hàng") 
                            : "Khách hàng" %>
                    </div>
                </div>

                <div class="user-info-content">
                    <ul class="user-info-menu">
                        <li class="user-info-item">
                            <a href="/2274820014_NguyenThuHienn/UserInfoServlet" class="user-info-link">
                                <i class="fas fa-user-circle"></i>
                                Thông tin cá nhân
                            </a>
                        </li>
                        <!-- CHỈ HIỂN THỊ KHI LÀ ADMIN -->
                        <% if ("admin".equals(userRole)) { %>
                        <li class="user-info-item">
                            <a href="/2274820014_NguyenThuHienn/AccountServlet" class="user-info-link">
                                <i class="fas fa-user-gear"></i>
                                Quản lý hệ thống
                            </a>
                        </li>
                        <% } %>
                        <!-- CHỈ HIỂN THỊ KHI LÀ NHÀ CUNG CẤP -->
                        <% if ("Nhà cung cấp".equals(userRole)) { %>
                        <li class="user-info-item">
                            <a href="#" class="user-info-link">
                                <i class="fas fa-user-gear"></i>
                                Quản lý hệ thống
                            </a>
                        </li>
                        <% } %>
                        <li class="user-info-item">
                            <a href="/2274820014_NguyenThuHienn/Orders4Servlet" class="user-info-link">
                                <i class="fas fa-shopping-bag"></i>
                                Theo dõi đơn hàng
                            </a>
                        </li>
                        <li class="user-info-item">
                            <a href="/2274820014_NguyenThuHienn/View/password.jsp" class="user-info-link">
                                <i class="fas fa-lock"></i>
                                Đổi mật khẩu
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="user-info-footer">
                    <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" style="margin: 0;">
                        <button type="submit" class="logout-btn-popup">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="header-right">
            <span class="admin-greeting">Xin chào, Admin!</span>
        </div>
    </div>

    <div class="dashboard-wrapper">
        <main class="dashboard-content">
            <div class="content-header">
                <h1><i class="fas fa-file-invoice"></i> Chi tiết đơn hàng #<%= order.getOrderId() %></h1>
                <a href="/2274820014_NguyenThuHienn/Orders2Servlet" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <div class="order-details-container">
                <!-- Thông tin đơn hàng -->
                <div class="order-info">
                    <h2><i class="fas fa-shopping-cart"></i> Thông tin đơn hàng</h2>
                    <div class="info-row">
                        <span class="info-label">Mã đơn hàng:</span>
                        <span class="info-value">#<%= order.getOrderId() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Trạng thái:</span>
                        <span class="status-badge <%= statusClass %>">
                            <%= order.getStatus() %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Ngày đặt:</span>
                        <span class="info-value"><%= sdf.format(order.getOrderDate()) %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phương thức thanh toán:</span>
                        <span class="info-value"><%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "Chưa xác định" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Tổng tiền:</span>
                        <span class="info-value price-cell"><%= String.format("%,.0f₫", order.getTotalAmount()) %></span>
                    </div>
                </div>

                <!-- Thông tin khách hàng -->
                <div class="customer-info">
                    <h2><i class="fas fa-user"></i> Thông tin khách hàng</h2>
                    <div class="info-row">
                        <span class="info-label">Tên khách hàng:</span>
                        <span class="info-value"><%= order.getCustomerName() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Địa chỉ giao hàng:</span>
                        <span class="info-value"><%= order.getAddress() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Số điện thoại:</span>
                        <span class="info-value"><%= order.getPhone() %></span>
                    </div>
                </div>

                <!-- Danh sách sản phẩm -->
                <div class="order-items">
                    <h2><i class="fas fa-boxes"></i> Danh sách sản phẩm</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên sản phẩm</th>
                                <th>Mẫu</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < order.getItems().size(); i++) { 
                                OrderItem item = order.getItems().get(i);
                            %>
                            <tr>
                                <td><strong><%= i + 1 %></strong></td>
                                <td><%= item.getProductName() %></td>
                                <td><%= item.getOptionName() != null ? item.getOptionName() : "Mặc định" %></td>
                                <td><%= item.getQuantity() %></td>
                                <td class="price-cell"><%= String.format("%,.0f₫", item.getPrice()) %></td>
                                <td class="price-cell"><%= String.format("%,.0f₫", item.getPrice() * item.getQuantity()) %></td>
                            </tr>
                            <% } %>
                            <tr class="total-row">
                                <td colspan="5" class="text-right"><strong>Tổng cộng:</strong></td>
                                <td class="price-cell"><strong><%= String.format("%,.0f₫", order.getTotalAmount()) %></strong></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Hành động -->
                <div class="order-actions">
                    <% if ("Chờ duyệt".equals(order.getStatus())) { %>
                    <button class="btn-approve" onclick="updateStatus(<%= order.getOrderId() %>, 'Đang giao')">
                        <i class="fas fa-check"></i> Duyệt đơn
                    </button>
                    <button class="btn-reject" onclick="updateStatus(<%= order.getOrderId() %>, 'Không duyệt')">
                        <i class="fas fa-times"></i> Không duyệt
                    </button>
                    <% } else if ("Đang giao".equals(order.getStatus())) { %>
                    <button class="btn-complete" onclick="updateStatus(<%= order.getOrderId() %>, 'Đã giao')">
                        <i class="fas fa-truck"></i> Hoàn thành
                    </button>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <form id="statusForm" method="post" action="Orders2Servlet" style="display:none;">
        <input type="hidden" name="action" value="updateStatus" />
        <input type="hidden" name="orderId" id="formOrderId" />
        <input type="hidden" name="newStatus" id="formNewStatus" />
    </form>

    <script>
        function updateStatus(orderId, newStatus) {
            const statusText = newStatus === 'Đang giao' ? 'duyệt' : 
                             newStatus === 'Không duyệt' ? 'từ chối' : 
                             'hoàn thành';
            
            if (confirm(`Bạn có chắc muốn ${statusText} đơn hàng #${orderId}?`)) {
                document.getElementById('formOrderId').value = orderId;
                document.getElementById('formNewStatus').value = newStatus;
                document.getElementById('statusForm').submit();
            }
        }
        
        // Thông tin người dùng (popup)
        function toggleUserInfo() {
            const popup = document.getElementById("userInfoPopup");
            if (popup.style.display === "block") {
                popup.style.display = "none";
            } else {
                popup.style.display = "block";
                popup.classList.add("show");
            }
        }

        // Ẩn popup khi click ra ngoài
        document.addEventListener("click", function(event) {
            const avatar = document.querySelector(".user-avatar");
            const popup = document.getElementById("userInfoPopup");
            if (avatar && popup && !avatar.contains(event.target) && !popup.contains(event.target)) {
                popup.style.display = "none";
                popup.classList.remove("show");
            }
        });

        // Đóng popup khi scroll 
        window.addEventListener("scroll", function() {
            const popup = document.getElementById("userInfoPopup");
            if (popup && popup.style.display === "block") {
                popup.style.display = "none";
                popup.classList.remove("show");
            }
        });
    </script>
</body>
</html>