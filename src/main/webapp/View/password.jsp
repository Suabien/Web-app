<%-- 
    Document   : password
    Created on : May 25, 2025, 3:45:43 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="/2274820014_NguyenThuHienn/CSS/password.css">
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <title>Đổi mật khẩu</title>
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
                    
        <div class="password-container">
            <div class="password-card">
                <div class="password-header">
                    <h2><i class="fas fa-lock"></i> Đổi mật khẩu</h2>
                    <p>Vui lòng nhập thông tin để thay đổi mật khẩu của bạn</p>
                </div>

                <form class="password-form" id="changePasswordForm">
                    <div class="form-group">
                        <label for="currentPassword">
                            <i class="fas fa-key"></i> Mật khẩu hiện tại
                        </label>
                        <div class="input-with-icon">
                            <input type="password" id="currentPassword" name="currentPassword" required>
                            <i class="fas fa-eye toggle-password" data-target="currentPassword"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPassword">
                            <i class="fas fa-key"></i> Mật khẩu mới
                        </label>
                        <div class="input-with-icon">
                            <input type="password" id="newPassword" name="newPassword" required>
                            <i class="fas fa-eye toggle-password" data-target="newPassword"></i>
                        </div>
                        <div class="password-strength">
                            <span class="strength-bar"></span>
                            <span class="strength-bar"></span>
                            <span class="strength-bar"></span>
                            <span class="strength-text">Độ mạnh mật khẩu</span>
                        </div>
                        <ul class="password-requirements">
                            <li><i class="fas fa-check-circle"></i> Ít nhất 8 ký tự</li>
                            <li><i class="fas fa-check-circle"></i> Chứa chữ hoa và chữ thường</li>
                            <li><i class="fas fa-check-circle"></i> Chứa ít nhất 1 số</li>
                            <li><i class="fas fa-check-circle"></i> Chứa ký tự đặc biệt</li>
                        </ul>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">
                            <i class="fas fa-key"></i> Xác nhận mật khẩu mới
                        </label>
                        <div class="input-with-icon">
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                            <i class="fas fa-eye toggle-password" data-target="confirmPassword"></i>
                        </div>
                        <div class="password-match">
                            <i class="fas fa-check-circle"></i> Mật khẩu khớp
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-change">
                            <i class="fas fa-sync-alt"></i> Đổi mật khẩu
                        </button>
                        <a href="/2274820014_NguyenThuHienn/HomeProductServlet" class="btn-cancel">
                            <i class="fas fa-times"></i> Quay lại
                        </a>
                    </div>
                </form>
            </div>

            <div class="password-security-tips">
                <h3><i class="fas fa-shield-alt"></i> Mẹo bảo mật</h3>
                <ul>
                    <li><i class="fas fa-check"></i> Không sử dụng mật khẩu cũ</li>
                    <li><i class="fas fa-check"></i> Không sử dụng thông tin cá nhân</li>
                    <li><i class="fas fa-check"></i> Sử dụng mật khẩu khác nhau cho các tài khoản</li>
                    <li><i class="fas fa-check"></i> Thay đổi mật khẩu định kỳ</li>
                </ul>
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
        <script src="/2274820014_NguyenThuHienn/JS/password.js" defer></script>
    </body>
</html>
