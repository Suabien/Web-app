<%-- 
    Document   : orders
    Created on : May 25, 2025, 1:44:09 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Model.Order"%>
<%@page import="Model.OrderItem"%>
<%@page import="java.util.List"%>
<%
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String error = (String) request.getAttribute("error");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="/2274820014_NguyenThuHienn/CSS/orders.css">
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <title>Theo dõi đơn hàng</title>
    </head>
    <body>
        <div class="header-cart">
            <div class="logo">
                <a href="/2274820014_NguyenThuHienn/HomeProductServlet"><img src="/2274820014_NguyenThuHienn/Images/logo.png" alt="Logo"></a>
                <h1><a href="/2274820014_NguyenThuHienn/HomeProductServlet">Fluffy Bear</a></h1>
            </div>

            <nav>
                <ul>
                    <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet"><h3>Trang chủ</h3></a></li>
                    <li><a href="/2274820014_NguyenThuHienn/View/about.jsp"><h3>Giới thiệu</h3></a></li>
                    <li><a href="#contact"><h3>Liên hệ</h3></a></li>
                </ul>
            </nav>

            <div class="header-right">
                <form class="search-bar">
                    <input type="text" placeholder="Nhập sản phẩm cần tìm kiếm..." />
                    <img src="/2274820014_NguyenThuHienn/Images/search.png" alt="search" class="search-icon" />
                </form>

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

                <!-- Giỏ hàng -->
                <div class="cart-container">
                    <a href="/2274820014_NguyenThuHienn/View/giohang.jsp">
                        <img src="/2274820014_NguyenThuHienn/Images/shopping-cart.png" alt="Cart" class="cart-icon" />
                        <span class="cart-count">0</span>
                    </a>
                </div>
            </div>
        </div>
                    
        <div class="orders-container">
            <h1 class="orders-title">Theo dõi đơn hàng của bạn</h1>

            <!-- Filter đơn hàng -->
            <div class="order-filters">
                <button class="filter-btn active">Tất cả</button>
                <button class="filter-btn">Chờ duyệt</button>
                <button class="filter-btn">Đang giao</button>
                <button class="filter-btn">Đã giao</button>
                <button class="filter-btn">Đã hủy</button>
            </div>

            <!-- Danh sách đơn hàng -->
            <div class="orders-list">
                <% if (error != null) { %>
                    <div class="error-message"><%= error %></div>
                <% } else if (orders == null || orders.isEmpty()) { %>
                    <div class="no-orders">
                        <img src="/2274820014_NguyenThuHienn/Images/no-order.png" alt="Không có đơn hàng">
                        <h3>Bạn chưa có đơn hàng nào</h3>
                        <p>Hãy mua sắm ngay để trải nghiệm những sản phẩm tuyệt vời của chúng tôi</p>
                        <a href="/2274820014_NguyenThuHienn/HomeProductServlet" class="shop-now">Mua sắm ngay</a>
                    </div>
                <% } else { 
                    for (Order order : orders) { 
                        String statusClass = "";
                        String statusIcon = "";
                        switch (order.getStatus()) {
                            case "Chờ duyệt":
                                statusClass = "pending";
                                statusIcon = "fas fa-clock";
                                break;
                            case "Đang giao":
                                statusClass = "shipping";
                                statusIcon = "fas fa-truck";
                                break;
                            case "Đã giao":
                                statusClass = "delivered";
                                statusIcon = "fas fa-check-circle";
                                break;
                            case "Đã hủy":
                                statusClass = "cancelled";
                                statusIcon = "fas fa-times-circle";
                                break;
                        }
                %>
                <div class="order-card">
                    <div class="order-header">
                        <div class="order-info">
                            <span class="order-id">Mã đơn hàng: #FB<%= order.getOrderId() %></span>
                            <span class="order-date">Ngày đặt: <%= dateFormat.format(order.getOrderDate()) %></span>
                            <span class="order-method">Phương thức thanh toán: <%= order.getPaymentMethod() %></span>
                        </div>
                        <div class="order-status <%= statusClass %>">
                            <i class="<%= statusIcon %>"></i> <%= order.getStatus() %>
                        </div>
                    </div>

                    <div class="order-body">
                        <!-- Thông tin khách hàng -->
                        <div class="customer-info">
                            <h3><i class="fas fa-user"></i> Thông tin giao hàng</h3>
                            <div class="info-grid">
                                <div>
                                    <p><strong>Họ tên:</strong> <%= order.getCustomerName() %></p>
                                    <p><strong>Địa chỉ:</strong> <%= order.getAddress() %></p>
                                </div>
                                <div>
                                    <p><strong>SĐT:</strong> <%= order.getPhone() %></p>
                                </div>
                            </div>
                        </div>

                        <!-- Chi tiết sản phẩm -->
                        <div class="order-products">
                            <h3><i class="fas fa-box-open"></i> Sản phẩm đã đặt</h3>
                            <% for (OrderItem item : order.getItems()) { %>
                            <div class="product-item">
                                <img src="<%= item.getProductImage() %>" alt="<%= item.getProductName() %>">
                                <div class="product-details">
                                    <h3><%= item.getProductName() %></h3>
                                    <p><strong>Mã SP:</strong> SP<%= item.getProductId() %></p>
                                    <p><strong>Số lượng:</strong> <%= item.getQuantity() %></p>
                                    <p><strong>Đơn giá:</strong> <%= String.format("%,.0fđ", item.getPrice()) %></p>
                                    <p><strong>Thành tiền:</strong> <%= String.format("%,.0fđ", item.getPrice() * item.getQuantity()) %></p>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        
                        <!-- Tiến trình đơn hàng -->
                        <div class="tracking-progress">
                            <h3><i class="fas fa-map-marked-alt"></i> Tiến trình đơn hàng</h3>
                            <div class="progress-steps">
                                <!-- Bước 1: Đã đặt hàng -->
                                <div class="step completed">
                                    <div class="step-icon"><i class="fas fa-check"></i></div>
                                    <div class="step-label">Đã đặt hàng</div>
                                    <div class="step-date"><%= dateFormat.format(order.getOrderDate()) %></div>
                                </div>

                                <!-- Nếu đơn hàng bị huỷ -->
                                <% if (order.getStatus().equals("Đã hủy")) { %>
                                    <div class="step cancelled">
                                        <div class="step-icon"><i class="fas fa-times"></i></div>
                                        <div class="step-label">Đã hủy</div>
                                        <div class="step-date"><%= dateFormat.format(order.getOrderDate()) %></div>
                                    </div>
                                    <div class="step">
                                        <div class="step-icon"><i class="far fa-circle"></i></div>
                                        <div class="step-label">Chờ duyệt</div>
                                        <div class="step-date"></div>
                                    </div>
                                    <div class="step">
                                        <div class="step-icon"><i class="far fa-circle"></i></div>
                                        <div class="step-label">Đóng gói</div>
                                        <div class="step-date"></div>
                                    </div>
                                    <div class="step">
                                        <div class="step-icon"><i class="far fa-circle"></i></div>
                                        <div class="step-label">Hoàn thành</div>
                                        <div class="step-date"></div>
                                    </div>
                                <% } else { %>
                                    <!-- Bước 2: Xác nhận -->
                                    <div class="step
                                        <%= order.getStatus().equals("Xác nhận") || 
                                             order.getStatus().equals("Đóng gói") || 
                                             order.getStatus().equals("Đang giao") || 
                                             order.getStatus().equals("Đã giao") ? "completed" : 
                                             order.getStatus().equals("Chờ duyệt") ? "waiting" : "" %>">
                                        <div class="step-icon">
                                            <i class="<%= order.getStatus().equals("Chờ duyệt") ? "fas fa-clock" : 
                                                       (order.getStatus().equals("Xác nhận") || 
                                                        order.getStatus().equals("Đóng gói") || 
                                                        order.getStatus().equals("Đang giao") || 
                                                        order.getStatus().equals("Đã giao")) ? "fas fa-check" : "far fa-circle" %>"></i>
                                        </div>
                                        <div class="step-label">Chờ duyệt</div>
                                        <div class="step-date">
                                            <% if (!order.getStatus().equals("Chờ duyệt")) { %>
                                                <%= dateFormat.format(order.getOrderDate()) %>
                                            <% } %>
                                        </div>
                                    </div>

                                    <!-- Bước 3: Đóng gói -->
                                    <div class="step <%= order.getStatus().equals("Đóng gói") || 
                                                            order.getStatus().equals("Đang giao") || 
                                                            order.getStatus().equals("Đã giao") ? "completed" : "" %>">
                                        <div class="step-icon">
                                            <i class="<%= order.getStatus().equals("Đóng gói") || 
                                                         order.getStatus().equals("Đang giao") || 
                                                         order.getStatus().equals("Đã giao") ? "fas fa-check" : "far fa-circle" %>"></i>
                                        </div>
                                        <div class="step-label">Đóng gói</div>
                                        <div class="step-date">
                                            <% if (order.getStatus().equals("Đóng gói") || 
                                                   order.getStatus().equals("Đang giao") || 
                                                   order.getStatus().equals("Đã giao")) { %>
                                                <%= dateFormat.format(order.getOrderDate()) %>
                                            <% } %>
                                        </div>
                                    </div>

                                    <!-- Bước 4: Đang giao -->
                                    <div class="step <%= order.getStatus().equals("Đang giao") ? "current" : 
                                                            order.getStatus().equals("Đã giao") ? "completed" : "" %>">
                                        <div class="step-icon">
                                            <i class="<%= order.getStatus().equals("Đang giao") ? "fas fa-truck" : 
                                                         order.getStatus().equals("Đã giao") ? "fas fa-check" : "far fa-circle" %>"></i>
                                        </div>
                                        <div class="step-label">Đang giao</div>
                                        <div class="step-date">
                                            <% if (order.getStatus().equals("Đang giao") || 
                                                   order.getStatus().equals("Đã giao")) { %>
                                                <%= dateFormat.format(order.getOrderDate()) %>
                                            <% } %>
                                        </div>
                                    </div>

                                    <!-- Bước 5: Hoàn thành -->
                                    <div class="step <%= order.getStatus().equals("Đã giao") ? "completed" : "" %>">
                                        <div class="step-icon"><i class="<%= order.getStatus().equals("Đã giao") ? "fas fa-check" : "far fa-circle" %>"></i></div>
                                        <div class="step-label">Hoàn thành</div>
                                        <div class="step-date">
                                            <% if (order.getStatus().equals("Đã giao")) { %>
                                                <%= dateFormat.format(order.getOrderDate())%>
                                            <% } %>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Tổng kết đơn hàng -->
                        <div class="order-summary">
                            <h3><i class="fas fa-receipt"></i> Tổng kết đơn hàng</h3>
                            <div class="summary-grid">
                                <div>
                                    <p><strong>Tổng tiền hàng:</strong></p>
                                    <p><strong>Phí vận chuyển:</strong></p>
                                    <p><strong>Giảm giá:</strong></p>
                                    <p class="total"><strong>Tổng thanh toán:</strong></p>
                                </div>
                                <div class="text-right">
                                    <p><%= String.format("%,.0fđ", order.getTotalAmount()) %></p>
                                    <p>30.000đ</p>
                                    <p>-0đ</p>
                                    <p class="total"><%= String.format("%,.0fđ", order.getTotalAmount().doubleValue() + 30000) %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Footer với nút phù hợp -->
                    <div class="order-footer">
                        <% if ("Chờ duyệt".equals(order.getStatus())) { %>
                            <button class="order-btn cancel" data-order-id="<%= order.getOrderId() %>">
                                <i class="fas fa-times-circle"></i> Hủy đơn hàng
                            </button>
                        <% } else if ("Đã giao".equals(order.getStatus())) { %>
                            <button class="order-btn reorder">
                                <i class="fas fa-shopping-cart"></i> Mua lại
                            </button>
                        <% } else if ("Đang giao".equals(order.getStatus())) { %>
                            <button class="order-btn disabled" disabled>
                                <i class="fas fa-truck"></i> Đang giao hàng
                            </button>
                        <% } else if ("Đã hủy".equals(order.getStatus())) { %>
                            <button class="order-btn disabled" disabled>
                                <i class="fas fa-ban"></i> Đơn hàng đã bị hủy
                            </button>
                        <% } %>
                        <button class="order-btn contact">
                            <i class="fas fa-headset"></i> Liên hệ hỗ trợ
                        </button>
                    </div>
                </div>
                <% } 
                } %>
            </div>
        </div>
            
        <footer class="footer" id="contact">    
            <div class="footer-content">
                <div class="footer-column">
                    <div class="footer-logo">
                        <img src="/2274820014_NguyenThuHienn/Images/logo.png" alt="Fluffy Bear Logo">
                        <h2>Fluffy Bear</h2>
                    </div>
                    <p class="footer-slogan">Mang đến những món trang sức chất lượng với tình yêu và sự tận tâm</p>
                    <div class="footer-social">
                        <a href="https://www.facebook.com/" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                        <a href="https://www.instagram.com/" class="social-icon"><i class="fab fa-instagram"></i></a>
                        <a href="https://www.tiktok.com/vi-VN/" class="social-icon"><i class="fab fa-tiktok"></i></a>
                        <a href="https://www.youtube.com/" class="social-icon"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>

                <div class="footer-column">
                    <h3 class="footer-title">Liên kết nhanh</h3>
                    <ul class="footer-links">
                        <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet">Trang chủ</a></li>
                        <li><a href="/2274820014_NguyenThuHienn/View/about.jsp">Giới thiệu</a></li>
                        <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet#type-1">Sản phẩm</a></li>
                        <li><a href="/2274820014_NguyenThuHienn/View/giohang.jsp">Giỏ hàng</a></li>
                    </ul>
                </div>

                <div class="footer-column">
                    <h3 class="footer-title">Thông tin liên hệ</h3>
                    <ul class="footer-contact">
                        <li><i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận XYZ, TP.Hà Nội</li>
                        <li><i class="fas fa-phone"></i> 0123 456 789</li>
                        <li><i class="fas fa-envelope"></i> support@fluffybear.com</li>
                        <li><i class="fas fa-clock"></i> Mở cửa: 8:00 - 21:00 hàng ngày</li>
                    </ul>
                </div>

                <div class="footer-column">
                    <h3 class="footer-title">Đăng ký nhận tin</h3>
                    <p class="footer-newsletter">Nhận thông tin khuyến mãi và sản phẩm mới nhất</p>
                    <form class="newsletter-form">
                        <input type="email" placeholder="Nhập email của bạn" required>
                        <button type="submit"><i class="fas fa-paper-plane"></i></button>
                    </form>
                </div>
            </div>

            <div class="footer-bottom">
                <p class="footer-copyright">© 2025 Fluffy Bear. All rights reserved.</p>
            </div>
        </footer>
            
        <script src="/2274820014_NguyenThuHienn/JS/cart.js" defer></script>
        <script src="/2274820014_NguyenThuHienn/JS/orders.js" defer></script>
    </body>
</html>