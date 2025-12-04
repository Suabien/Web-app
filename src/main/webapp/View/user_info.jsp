<%-- 
    Document   : user_info
    Created on : May 9, 2025, 11:39:31 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%
    // Kiểm tra đăng nhập
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Lấy thông tin từ request attribute
    String fullName = (String) request.getAttribute("fullName");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String address = (String) request.getAttribute("address");
    Date dob = (Date) request.getAttribute("dob");
    String imagePath = (String) request.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
    
    // Định dạng ngày mặc định
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String dobStr = dob != null ? sdf.format(dob) : sdf.format(new Date());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thông tin khách hàng</title>
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/info.css">
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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
        
        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-avatar">
                    <img id="avatar-img" src="<%= imagePath != null ? imagePath : "/2274820014_NguyenThuHienn/Images/sanpham1.jpg" %>" alt="Ảnh đại diện">
                    <div class="avatar-overlay">
                        <i class="fas fa-camera"></i>
                    </div>
                </div>
                <h2>Thông Tin Cá Nhân</h2>
            </div>
            <form class="profile-form" method="POST" action="UserInfoServlet" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullname"><i class="fas fa-user"></i> Họ và tên</label>
                        <input type="text" id="fullname" name="fullname" value="<%= fullName != null ? fullName : "" %>" placeholder="Nhập họ và tên">
                    </div>
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" value="<%= email != null ? email : "" %>" placeholder="Nhập email">
                    </div>
                    <div class="form-group">
                        <label for="dob"><i class="fas fa-birthday-cake"></i> Ngày sinh</label>
                        <input type="date" id="dob" name="dob" value="<%= dobStr %>">
                    </div>
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" value="<%= phone != null ? phone : "" %>" placeholder="Nhập số điện thoại">
                    </div>
                    <div class="form-group full-width">
                        <label for="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input type="text" id="address" name="address" value="<%= address != null ? address : "" %>" placeholder="Nhập địa chỉ">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-edit"><i class="fas fa-edit"></i> Thêm/Chỉnh sửa</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Lưu thay đổi</button>
                </div>
                <input type="file" id="avatar" name="avatar" accept="image/*" style="display: none;">
            </form>
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
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Chế độ chỉnh sửa
                const editBtn = document.querySelector('.btn-edit');
                const inputs = document.querySelectorAll('.profile-form input, .profile-form textarea');
                
                // Ban đầu disable tất cả input
                inputs.forEach(input => {
                    input.disabled = true;
                });
                
                // Bật chế độ chỉnh sửa
                editBtn.addEventListener('click', function() {
                    inputs.forEach(input => {
                        input.disabled = false;
                        input.focus();
                    });
                    
                    // Hiệu ứng focus vào field đầu tiên
                    if (inputs.length > 0) {
                        inputs[0].focus();
                    }
                });
                
                // Xử lý upload ảnh đại diện
                const avatar = document.querySelector('.profile-avatar');
                const avatarInput = document.getElementById('avatar');
                
                avatar.addEventListener('click', function() {
                    avatarInput.click();
                });
                
                avatarInput.addEventListener('change', function(e) {
                    if (e.target.files && e.target.files[0]) {
                        const reader = new FileReader();
                        
                        reader.onload = function(event) {
                            document.getElementById('avatar-img').src = event.target.result;
                            
                            // Hiệu ứng khi thay đổi ảnh
                            avatar.style.transform = 'scale(1.1)';
                            setTimeout(() => {
                                avatar.style.transform = 'scale(1)';
                            }, 300);
                        }
                        
                        reader.readAsDataURL(e.target.files[0]);
                    }
                });
            });
        </script>
    </body>
</html>
