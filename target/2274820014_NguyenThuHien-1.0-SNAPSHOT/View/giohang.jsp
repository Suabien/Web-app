<%-- 
    Document   : giohang
    Created on : Mar 23, 2025, 11:51:49 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ hàng</title>
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/cart.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body data-userid="${userid}">
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
                <form class="search-bar" action="/2274820014_NguyenThuHienn/SearchServlet" method="post">
                    <input type="text" name="searchTerm" placeholder="Nhập sản phẩm cần tìm kiếm..." />
                    <button type="submit" class="search-icon-btn">
                        <img src="/2274820014_NguyenThuHienn/Images/search.png" alt="search" class="search-icon" />
                    </button>
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
        <div class="shopping-container">
            <div class="header-shopping-cart">
                <h1>Giỏ hàng của bạn</h1>
            </div>
            
            <div class="action-links">
              <a href="/2274820014_NguyenThuHienn/HomeProductServlet" class="go-out">❮ Tiếp tục mua sắm</a>
              <a href="/2274820014_NguyenThuHienn/Orders4Servlet" class="go-order">Theo dõi đơn hàng ❯</a>
            </div>
            
            <div class="content-container">
                <!-- Phần trái: Danh sách sản phẩm -->
                <div class="left-box">
                    <div class="cart-header">
                        <input type="checkbox" id="select-all" checked>
                        <span>Chọn tất cả</span>
                        <span class="name-header">Tên sản phẩm</span>
                        <span class="classify-header">Phân loại</span>
                        <span class="price-header">Giá thành</span>
                        <span class="quantity-header">Số lượng</span>
                        <span class="unit-header">Thao tác</span>
                    </div>
                    <div id="cart-items"></div>
                </div>
                
                <!-- Phần phải: Tổng giá tiền và nút mua hàng -->
                <div class="right-box" id="cart-items">
                    <h2>Tóm tắt đơn hàng</h2>
                    <div class="summary">
                        <p>Tạm tính: <span id="subtotal">0đ</span></p>
                        <p>Giảm giá: <span>0đ</span></p>
                        <p>Phí ship: <span id="shipping-fee">0đ</span></p>
                        <p>Tiết kiệm được: <span id="savings">0đ</span></p>
                        <p class="total-price">Tổng tiền: <span>0đ</span></p>
                    </div>
                    <button class="checkout-btn">Mua hàng</button>
                </div>
            </div>
        </div>
                    
        <!-- Modal Đặt hàng -->
        <div id="checkoutModal" class="modal">
            <div class="modal-container">
                <div class="modal-header">
                    <h2>Thông tin mua hàng</h2>
                    <span class="modal-close">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="checkoutForm">
                        <input type="hidden" id="userid" value="${userid}">
                        <div class="form-section">
                            <h3 class="section-title">Thông tin giao hàng</h3>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="modalCustomerName">Họ và tên</label>
                                    <input type="text" id="modalCustomerName" placeholder="Nhập họ tên" required>
                                </div>

                                <div class="form-group">
                                    <label for="modalPhone">Số điện thoại</label>
                                    <input type="tel" id="modalPhone" placeholder="Nhập số điện thoại" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="modalAddress">Địa chỉ nhận hàng</label>
                                <textarea id="modalAddress" rows="2" placeholder="Nhập địa chỉ chi tiết" required></textarea>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">Phương thức thanh toán</h3>
                            <div class="payment-method-options">
                                <div class="payment-option selected">
                                    <input type="radio" id="paymentCOD" name="paymentMethod" value="COD" checked>
                                    <label for="paymentCOD">Thanh toán khi nhận hàng (COD)</label>
                                    <div class="payment-description">Nhận hàng và thanh toán trực tiếp</div>
                                </div>

                                <div class="payment-option">
                                    <input type="radio" id="paymentBank" name="paymentMethod" value="Bank">
                                    <label for="paymentBank">Chuyển khoản ngân hàng</label>
                                    <div class="payment-description">Chuyển khoản qua QR Code</div>
                                </div>
                            </div>

                            <!-- QR Code Container -->
                            <div id="qrCodeContainer" class="qr-code-container">
                                <div class="qr-code-title">Quét mã QR để thanh toán</div>
                                <img src="/2274820014_NguyenThuHienn/Images/qr-code.jpg" alt="QR Code" class="qr-code-image">
                                <div class="qr-code-info">
                                    <p>Quét mã QR bằng ứng dụng ngân hàng của bạn để thanh toán</p>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">Tóm tắt đơn hàng</h3>
                            <div class="order-summary">
                                <div class="summary-item">
                                    <span>Ngày đặt</span>
                                    <span id="order-date"></span>
                                </div>
                                <div class="summary-item">
                                    <span>Tổng sản phẩm:</span>
                                    <span id="modalTotalItems">0</span>
                                </div>
                                <div class="summary-item">
                                    <span>Tạm tính:</span>
                                    <span id="modalSubtotal">0đ</span>
                                </div>
                                <div class="summary-item">
                                    <span>Phí vận chuyển:</span>
                                    <span id="modalShipFee">30.000đ</span>
                                </div>
                                <div class="summary-item">
                                    <span>Giảm giá:</span>
                                    <span id="modalDiscount">-0đ</span>
                                </div>
                                <div class="summary-total">
                                    <span>Tổng cộng:</span>
                                    <span id="modalTotalPrice">0đ</span>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary cancel-btn">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                    <button type="submit" form="checkoutForm" class="btn btn-primary">
                        <i class="fas fa-check"></i> Đặt hàng
                    </button>
                </div>
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
    </body>
</html>
