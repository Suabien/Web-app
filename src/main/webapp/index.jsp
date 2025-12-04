<%-- 
    Document   : index
    Created on : Feb 28, 2025, 9:21:57 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/login.css">  
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Fluffy Bear - Đăng nhập</title>
        <link rel="icon" href="/2274820014_NguyenThuHienn/Images/logo5.png" type="image/png">
    </head>
    <body>
        <% 
            String message = (String) request.getAttribute("message");
            String status = (String) request.getAttribute("status");
            String action = (String) request.getAttribute("action");

            if (message != null && status != null && action != null) { 
        %>
        <!-- Popup Thông Báo -->
        <div class="popup-overlay" id="popup">
            <div class="popup-box <%= status %>">
                <span class="popup-close" onclick="closePopup()">&times;</span>
                <div class="popup-icon">
                    <i class="<%= status.equals("success") ? "fas fa-check-circle" : "fas fa-times-circle" %>"></i>
                </div>
                <h2>
                    <%= status.equals("success") ? 
                          (action.equals("login") ? "Đăng nhập thành công!" : "Đăng ký thành công!") 
                        : (action.equals("login") ? "Đăng nhập thất bại!" : "Đăng ký thất bại!") %>
                </h2>
                <p><%= message %></p>
                <button class="popup-btn" onclick="closePopup()">OK</button>
            </div>
        </div>
        <% } %>
        
        <div class="auth-container">
            <div class="auth-wrapper">
                <!-- Logo và tên cửa hàng -->
                <div class="auth-header">
                    <img src="/2274820014_NguyenThuHienn/Images/logo5.png" alt="Fluffy Bear Logo" class="logo">
                    <h1>Fluffy Bear</h1>
                </div>
                
                <!-- Form Đăng nhập -->
                <div class="form-container login-form" id="loginForm">
                    <form action="loginservlet" method="POST" class="auth-form">
                        <h2>Đăng nhập</h2>
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input type="text" name="user" placeholder="Tên đăng nhập" 
                                   value="<%= request.getAttribute("user") != null ? request.getAttribute("user") : "" %>">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" name="pass" placeholder="Mật khẩu">
                        </div>
                        <button type="submit" class="auth-btn">Đăng nhập <i class="fas fa-sign-in-alt"></i></button>
                        <p class="switch-form">Chưa có tài khoản? <span onclick="showRegister()">Đăng ký ngay</span></p>
                    </form>
                </div>
                
                <!-- Form Đăng ký -->
                <div class="form-container register-form" id="registerForm" style="display: none;">
                    <form action="registerservlet" method="POST" class="auth-form">
                        <h2>Đăng ký</h2>
                        <div class="input-group">
                            <i class="fas fa-user-plus"></i>
                            <input type="text" name="user" placeholder="Tên đăng nhập" 
                                   value="<%= request.getAttribute("user") != null ? request.getAttribute("user") : "" %>">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" name="pass" placeholder="Mật khẩu">
                        </div>
                        
                        <div class="role-selection">
                            <label class="role-label">Chọn vai trò:</label>
                            <div class="role-options">
                                <div class="role-option selected" data-role="Khách hàng">
                                    <i class="fas fa-user-circle"></i>
                                    <span class="role-text">Khách hàng</span>
                                </div>
                                <div class="role-option" data-role="Người bán hàng">
                                    <i class="fas fa-store"></i>
                                    <span class="role-text">Người bán hàng</span>
                                </div>
                                <div class="role-option" data-role="Nhà cung cấp">
                                    <i class="fas fa-truck"></i>
                                    <span class="role-text">Nhà cung cấp</span>
                                </div>
                            </div>
                            <input type="hidden" name="role" id="selectedRole" value="Khách hàng">
                        </div>
                        
                        <button type="submit" class="auth-btn">Đăng ký<i class="fas fa-user-pen"></i></button>
                        <p class="switch-form">Đã có tài khoản? <span onclick="showLogin()">Đăng nhập ngay</span></p>
                    </form>
                </div>
            </div>
            
            <!-- Background Slideshow -->
            <div class="auth-bg">
                <div class="bg-slide active" style="background-image: url('/2274820014_NguyenThuHienn/Images/banner1.jpg');"></div>
                <div class="bg-slide" style="background-image: url('/2274820014_NguyenThuHienn/Images/banner2.jpg');"></div>
            </div>
        </div>
                    
        <script src="/2274820014_NguyenThuHienn/JS/javascript.js"></script>
        <script src="/2274820014_NguyenThuHienn/JS/login.js"></script>
    </body>
</html>