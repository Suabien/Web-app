<%-- 
    Document   : manage
    Created on : Mar 29, 2025, 6:11:16 PM
    Author     : Gigabyte
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Account" %>
<%@page import="Model.Product" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("role") == null || !"admin".equals(sessionObj.getAttribute("role"))) {
        response.sendRedirect("/2274820014_NguyenThuHienn/HomeProductServlet");
        return;
    }
    if (request.getAttribute("users") == null) {
        response.sendRedirect(request.getContextPath() + "/AccountServlet");
        return;
    }
    
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý tài khoản - Fluffy Bear</title>
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/manage1.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <!-- Header với menu ngang -->
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
                                <a href="#t" class="user-info-link">
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
        
        <!-- Dashboard quản lý -->
        <div class="dashboard-wrapper">
            <!-- Menu dọc mới -->
            <div class="dashboard-sidebar">
                <div class="sidebar-header">
                    <h2><i class="fas fa-cogs"></i> Bảng điều khiển</h2>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="/2274820014_NguyenThuHienn/AccountServlet" class="active">
                        <i class="fas fa-users"></i> Quản lý tài khoản
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/ProductServlet">
                        <i class="fas fa-box"></i> Quản lý sản phẩm
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/OptionServlet">
                        <i class="fas fa-tags"></i> Loại sản phẩm
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/Admin/manage4.jsp">
                        <i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet">
                        <i class="fas fa-store"></i> Xem cửa hàng
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/Admin/dashboard.jsp">
                        <i class="fas fa-chart-bar"></i> Thống kê
                    </a></li>
                </ul>
            </div>
            
            <!-- Nội dung chính -->
            <main class="dashboard-content">
                <div class="content-header">
                    <h1 id="content-title">Quản lý tài khoản người dùng</h1>
                    <p>Quản lý, chỉnh sửa và xoá thông tin tài khoản người dùng.</p>
                </div>

                <!-- Bảng tài khoản -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Danh sách tài khoản</h3>
                        <button class="btn-add" onclick="openModal('addAccountModal')">
                            <i class="fas fa-plus"></i> Thêm tài khoản
                        </button>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th style="width: 60px;">Ảnh</th>
                                <th style="width: 120px;">Tên tài khoản</th>
                                <th style="width: 100px;">Mật khẩu</th>
                                <th style="width: 100px;">Vai trò</th>
                                <th style="width: 120px;">Họ tên</th>
                                <th style="width: 150px;">Email</th>
                                <th style="width: 100px;">SĐT</th>
                                <th style="width: 150px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Account> userList = (List<Account>) request.getAttribute("users");
                                if (userList != null && !userList.isEmpty()) {
                                    for (Account acc : userList) {
                                        String roleClass = "";
                                        if ("Khách hàng".equals(acc.getRole())) {
                                            roleClass = "customer";
                                        } else if ("Người bán hàng".equals(acc.getRole())) {
                                            roleClass = "seller";
                                        } else if ("Nhà cung cấp".equals(acc.getRole())) {
                                            roleClass = "supplier";
                                        }
                            %>
                                        <tr>
                                            <td><strong>#<%= acc.getId() %></strong></td>
                                            <td>
                                                <div class="user-avatar-small">
                                                    <img src="<%= acc.getImagePath() != null && !acc.getImagePath().isEmpty() ? acc.getImagePath() : "/2274820014_NguyenThuHienn/Images/default-avatar.jpg" %>" 
                                                         alt="Avatar" onerror="this.src='/2274820014_NguyenThuHienn/Images/default-avatar.jpg'">
                                                </div>
                                            </td>
                                            <td><strong><%= acc.getUsername() %></strong></td>
                                            <td>••••••••</td>
                                            <td>
                                                <span class="role-badge <%= roleClass %>">
                                                    <%= acc.getRole() %>
                                                </span>
                                            </td>
                                            <td><%= acc.getFullName() != null && !acc.getFullName().equals("Chưa cập nhật") ? acc.getFullName() : "<span style='color: #6c757d;'>-</span>" %></td>
                                            <td><%= acc.getEmail() != null && !acc.getEmail().equals("Chưa cập nhật") ? acc.getEmail() : "<span style='color: #6c757d;'>-</span>" %></td>
                                            <td><%= acc.getPhone() != null && !acc.getPhone().equals("Chưa cập nhật") ? acc.getPhone() : "<span style='color: #6c757d;'>-</span>" %></td>
                                            <td class="action-buttons">
                                                <button class="btn-edit" onclick="openEditModal(
                                                    '<%= acc.getId() %>', 
                                                    '<%= acc.getUsername() %>', 
                                                    '<%= acc.getPassword() %>',
                                                    '<%= acc.getRole() != null ? acc.getRole().replace("'", "\\'") : "" %>',
                                                    '<%= acc.getFullName() != null ? acc.getFullName().replace("'", "\\'") : "" %>',
                                                    '<%= acc.getEmail() != null ? acc.getEmail().replace("'", "\\'") : "" %>',
                                                    '<%= acc.getPhone() != null ? acc.getPhone() : "" %>',
                                                    '<%= acc.getAddress() != null ? acc.getAddress().replace("'", "\\'") : "" %>',
                                                    '<%= acc.getDob() != null ? acc.getDob() : "" %>',
                                                    '<%= acc.getImagePath() != null ? acc.getImagePath().replace("'", "\\'") : "" %>'
                                                )">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                                <button class="btn-delete" onclick="deleteItem('<%= acc.getId() %>')">
                                                    <i class="fas fa-trash"></i> Xoá
                                                </button>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 40px; color: #6c757d;">
                                        <i class="fas fa-users" style="font-size: 48px; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                        Không có dữ liệu tài khoản
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- Modal Thêm tài khoản -->
        <div id="addAccountModal" class="modal">
            <div class="modal-content" style="max-width: 500px;">
                <span class="close-modal" onclick="closeModal('addAccountModal')">&times;</span>
                <h3><i class="fas fa-user-plus"></i> Thêm tài khoản</h3>
                <form id="addAccountForm">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-user"></i> Tên tài khoản
                        </label>
                        <input type="text" name="username" class="form-control" required placeholder="Nhập tên tài khoản">
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-lock"></i> Mật khẩu
                        </label>
                        <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu">
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-user-tag"></i> Vai trò
                        </label>
                        <select name="role" class="form-control" required>
                            <option value="Khách hàng">Khách hàng</option>
                            <option value="Người bán hàng">Người bán hàng</option>
                            <option value="Nhà cung cấp">Nhà cung cấp</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Thêm tài khoản
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Modal Sửa tài khoản -->
        <div id="editAccountModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-modal" onclick="closeModal('editAccountModal')">&times;</span>
                <h3><i class="fas fa-edit"></i> Sửa tài khoản</h3>

                <!-- Tabs Navigation -->
                <div class="form-tabs">
                    <button type="button" class="form-tab active" data-tab="basic-info">
                        <i class="fas fa-user-circle"></i> Thông tin cơ bản
                    </button>
                    <button type="button" class="form-tab" data-tab="profile-info">
                        <i class="fas fa-id-card"></i> Thông tin cá nhân
                    </button>
                    <button type="button" class="form-tab" data-tab="avatar-info">
                        <i class="fas fa-camera"></i> Ảnh đại diện
                    </button>
                </div>

                <form id="editAccountForm" action="AccountServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">

                    <!-- Tab 1: Thông tin cơ bản -->
                    <div class="tab-content active" id="basic-info-tab">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="required">
                                    <i class="fas fa-user"></i> Tên tài khoản
                                </label>
                                <input type="text" name="username" id="edit-username" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label class="required">
                                    <i class="fas fa-lock"></i> Mật khẩu
                                </label>
                                <input type="password" name="password" id="edit-password" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label class="required">
                                <i class="fas fa-user-tag"></i> Vai trò
                            </label>
                            <select name="role" id="edit-role" class="form-control" required>
                                <option value="Khách hàng">Khách hàng</option>
                                <option value="Người bán hàng">Người bán hàng</option>
                                <option value="Nhà cung cấp">Nhà cung cấp</option>
                            </select>
                        </div>
                    </div>

                    <!-- Tab 2: Thông tin cá nhân -->
                    <div class="tab-content" id="profile-info-tab">
                        <div class="form-row">
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-signature"></i> Họ và tên
                                </label>
                                <input type="text" name="full_name" id="edit-fullname" class="form-control" placeholder="Chưa cập nhật">
                            </div>

                            <div class="form-group">
                                <label>
                                    <i class="fas fa-birthday-cake"></i> Ngày sinh
                                </label>
                                <input type="date" name="dob" id="edit-dob" class="form-control">
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label>
                                <i class="fas fa-envelope"></i> Email
                            </label>
                            <input type="email" name="email" id="edit-email" class="form-control" placeholder="Chưa cập nhật">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-phone"></i> Số điện thoại
                                </label>
                                <input type="tel" name="phone" id="edit-phone" class="form-control" placeholder="Chưa cập nhật">
                            </div>

                            <div class="form-group">
                                <label>
                                    <i class="fas fa-map-marker-alt"></i> Địa chỉ
                                </label>
                                <input type="text" name="address" id="edit-address" class="form-control" placeholder="Chưa cập nhật">
                            </div>
                        </div>
                    </div>

                    <!-- Tab 3: Ảnh đại diện -->
                    <div class="tab-content" id="avatar-info-tab">
                        <div class="form-group full-width">
                            <label>
                                <i class="fas fa-image"></i> Ảnh đại diện hiện tại
                            </label>
                            <div class="image-upload-container">
                                <img id="edit-image-preview" src="" alt="Preview" style="max-width: 150px; max-height: 150px; display: none;">
                                <div id="no-image-placeholder" class="upload-placeholder">
                                    <i class="fas fa-user-circle"></i>
                                    <span>Chưa có ảnh đại diện</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label>
                                <i class="fas fa-upload"></i> Tải ảnh mới lên
                            </label>
                            <input type="file" name="image" id="edit-image" class="form-control" accept="image/*" onchange="previewImage(this)">
                            <small style="color: #6c757d; font-size: 12px; display: block; margin-top: 5px;">
                                <i class="fas fa-info-circle"></i> Hỗ trợ: JPG, PNG, GIF (Tối đa 5MB)
                            </small>
                        </div>

                        <input type="hidden" name="existing_image" id="edit-existing-image">
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i> Cập nhật thông tin
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <script src="/2274820014_NguyenThuHienn/JS/manage.js" defer></script>
    </body>
</html>