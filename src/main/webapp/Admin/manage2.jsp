<%-- 
    Document   : manage2
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
    if (request.getAttribute("products") == null) {
        response.sendRedirect(request.getContextPath() + "/ProductServlet");
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
        <title>Quản lý sản phẩm - Fluffy Bear</title>
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/manage2.css">
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
                                <a href="/2274820014_NguyenThuHienn/ShopServlet" class="user-info-link">
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
                    <li><a href="/2274820014_NguyenThuHienn/AccountServlet">
                        <i class="fas fa-users"></i> Quản lý tài khoản
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/ProductServlet" class="active">
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
                    <h1 id="content-title">Quản lý sản phẩm</h1>
                    <p>Quản lý thông tin sản phẩm, giá cả và số lượng.</p>
                </div>

                <!-- Bảng sản phẩm -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Danh sách sản phẩm</h3>
                        <button class="btn-add" onclick="openModal('addProductModal')">
                            <i class="fas fa-plus"></i> Thêm sản phẩm
                        </button>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th style="width: 80px;">Ảnh</th>
                                <th style="width: 150px;">Tên sản phẩm</th>
                                <th style="width: 200px;">Mô tả</th>
                                <th style="width: 100px;">Danh mục SP</th>
                                <th style="width: 100px;">Giá</th>
                                <th style="width: 80px;">Số lượng</th>
                                <th style="width: 100px;">Xuất xứ</th>
                                <th style="width: 80px;">Đánh giá</th>
                                <th style="width: 80px;">Đã bán</th>
                                <th style="width: 110px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Product> productList = (List<Product>) request.getAttribute("products");
                                if (productList != null && !productList.isEmpty()) {
                                    for (Product product : productList) {
                                        String typeName = "";
                                        int typeId = product.getType_id();
                                        if (typeId == 1) {
                                            typeName = "Cao cấp";
                                        } else if (typeId == 2) {
                                            typeName = "Thời trang";
                                        } else if (typeId == 3) {
                                            typeName = "Phong thủy";
                                        } else if (typeId == 4) {
                                            typeName = "Tối giản";
                                        } else if (typeId == 5) {
                                            typeName = "Vintage/retro";
                                        } else {
                                            typeName = "Cá nhân hóa";
                                        }
                            %>
                                        <tr>
                                            <td><strong>#<%= product.getId() %></strong></td>
                                            <td>
                                                <div class="product-image-small">
                                                    <img src="<%= product.getImage_url() != null && !product.getImage_url().isEmpty() ? product.getImage_url() : "/2274820014_NguyenThuHienn/Images/default-product.jpg" %>" 
                                                         alt="Product Image" onerror="this.src='/2274820014_NguyenThuHienn/Images/default-product.jpg'">
                                                </div>
                                            </td>
                                            <td><strong><%= product.getName() %></strong></td>
                                            <td class="description-cell">
                                                <div class="description-content">
                                                    <%= product.getDescription() != null ? product.getDescription() : "<span style='color: #6c757d;'>-</span>" %>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="type-badge">
                                                    <%= typeName %>
                                                </span>
                                            </td>
                                            <td><strong><%= product.getPrice() %>₫</strong></td>
                                            <td>
                                                <span class="quantity-badge <%= product.getQuantity() > 10 ? "in-stock" : product.getQuantity() > 0 ? "low-stock" : "out-of-stock" %>">
                                                    <%= product.getQuantity() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="origin-badge">
                                                    <%= product.getOrigin() != null ? product.getOrigin() : "Việt Nam" %>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="rating-display">
                                                    <i class="fas fa-star"></i>
                                                    <span><%= product.getRating() %></span>
                                                </div>
                                            </td>
                                            <td><%= product.getSold() %></td>
                                            <td class="action-buttons">
                                                <button class="btn-edit" onclick="openEditModal(
                                                    '<%= product.getId() %>', 
                                                    '<%= product.getName().replace("'", "\\'") %>', 
                                                    '<%= product.getDescription() != null ? product.getDescription().replace("'", "\\'") : "" %>',
                                                    '<%= product.getImage_url() != null ? product.getImage_url().replace("'", "\\'") : "" %>',
                                                    '<%= product.getPrice() %>',
                                                    '<%= product.getQuantity() %>',
                                                    '<%= product.getType_id() %>',
                                                    '<%= product.getOrigin() != null ? product.getOrigin().replace("'", "\\'") : "Việt Nam" %>'
                                                )">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                                <button class="btn-delete" onclick="deleteProduct('<%= product.getId() %>')">
                                                    <i class="fas fa-trash"></i> Xoá
                                                </button>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="11" style="text-align: center; padding: 40px; color: #6c757d;">
                                        <i class="fas fa-box-open" style="font-size: 48px; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                        Không có dữ liệu sản phẩm
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

        <!-- Modal Thêm sản phẩm -->
        <div id="addProductModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-modal" onclick="closeModal('addProductModal')">&times;</span>
                <h3><i class="fas fa-box"></i> Thêm sản phẩm mới</h3>
                <form id="addProductForm" action="ProductServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-tag"></i> Tên sản phẩm
                        </label>
                        <input type="text" name="name" class="form-control" required placeholder="Nhập tên sản phẩm">
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-align-left"></i> Mô tả sản phẩm
                        </label>
                        <textarea name="description" class="form-control" required placeholder="Nhập mô tả chi tiết sản phẩm" rows="4"></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-money-bill-wave"></i> Giá (VNĐ)
                            </label>
                            <input type="text" name="price" class="form-control" required placeholder="Ví dụ: 250000">
                        </div>

                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-cubes"></i> Số lượng
                            </label>
                            <input type="number" name="quantity" class="form-control" required placeholder="Nhập số lượng" min="0">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-list"></i> Loại sản phẩm
                        </label>
                        <select name="type_id" class="form-control" required>
                            <option value="1">Cao cấp</option>
                            <option value="2">Thời trang</option>
                            <option value="3">Phong thủy</option>
                            <option value="4">Tối giản</option>
                            <option value="5">Vintage/retro</option>
                            <option value="6">Cá nhân hóa</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-globe-asia"></i> Xuất xứ
                        </label>
                        <select name="origin" class="form-control" required>
                            <option value="Việt Nam">Việt Nam</option>
                            <option value="Trung Quốc">Trung Quốc</option>
                            <option value="Thái Lan">Thái Lan</option>
                            <option value="Hàn Quốc">Hàn Quốc</option>
                            <option value="Nhật Bản">Nhật Bản</option>
                            <option value="Mỹ">Mỹ</option>
                            <option value="Ý">Ý</option>
                            <option value="Pháp">Pháp</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-image"></i> Ảnh sản phẩm
                        </label>
                        <div class="image-upload-container">
                            <img id="add-image-preview" src="" alt="Preview" style="max-width: 150px; max-height: 150px; display: none;">
                            <div id="no-image-placeholder-add" class="upload-placeholder">
                                <i class="fas fa-image"></i>
                                <span>Chưa có ảnh sản phẩm</span>
                            </div>
                        </div>
                        <input type="file" name="image" id="add-image" class="form-control" accept="image/*" onchange="previewImage(this, 'add-image-preview', 'no-image-placeholder-add')" required>
                        <small style="color: #6c757d; font-size: 12px; display: block; margin-top: 5px;">
                            <i class="fas fa-info-circle"></i> Hỗ trợ: JPG, PNG, GIF (Tối đa 5MB)
                        </small>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Thêm sản phẩm
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Modal Sửa sản phẩm -->
        <div id="editProductModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-modal" onclick="closeModal('editProductModal')">&times;</span>
                <h3><i class="fas fa-edit"></i> Sửa thông tin sản phẩm</h3>

                <!-- Tabs Navigation -->
                <div class="form-tabs">
                    <button type="button" class="form-tab active" data-tab="basic-info">
                        <i class="fas fa-info-circle"></i> Thông tin cơ bản
                    </button>
                    <button type="button" class="form-tab" data-tab="image-info">
                        <i class="fas fa-camera"></i> Ảnh sản phẩm
                    </button>
                </div>

                <form id="editProductForm" action="ProductServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">

                    <!-- Tab 1: Thông tin cơ bản -->
                    <div class="tab-content active" id="basic-info-tab">
                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-tag"></i> Tên sản phẩm
                            </label>
                            <input type="text" name="name" id="edit-name" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-align-left"></i> Mô tả sản phẩm
                            </label>
                            <textarea name="description" id="edit-description" class="form-control" required rows="4"></textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="required">
                                    <i class="fas fa-money-bill-wave"></i> Giá (VNĐ)
                                </label>
                                <input type="text" name="price" id="edit-price" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label class="required">
                                    <i class="fas fa-cubes"></i> Số lượng
                                </label>
                                <input type="number" name="quantity" id="edit-quantity" class="form-control" required min="0">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-list"></i> Loại sản phẩm
                            </label>
                            <select name="type_id" id="edit-type" class="form-control" required>
                                <option value="1">Cao cấp</option>
                                <option value="2">Thời trang</option>
                                <option value="3">Phong thủy</option>
                                <option value="4">Tối giản</option>
                                <option value="5">Vintage/retro</option>
                                <option value="6">Cá nhân hóa</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-globe-asia"></i> Xuất xứ
                            </label>
                            <select name="origin" id="edit-origin" class="form-control" required>
                                <option value="Việt Nam">Việt Nam</option>
                                <option value="Trung Quốc">Trung Quốc</option>
                                <option value="Thái Lan">Thái Lan</option>
                                <option value="Hàn Quốc">Hàn Quốc</option>
                                <option value="Nhật Bản">Nhật Bản</option>
                                <option value="Mỹ">Mỹ</option>
                                <option value="Ý">Ý</option>
                                <option value="Pháp">Pháp</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- Tab 2: Ảnh sản phẩm -->
                    <div class="tab-content" id="image-info-tab">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-image"></i> Ảnh sản phẩm hiện tại
                            </label>
                            <div class="image-upload-container">
                                <img id="edit-image-preview" src="" alt="Preview" style="max-width: 200px; max-height: 200px;">
                                <div id="no-image-placeholder-edit" class="upload-placeholder" style="display: none;">
                                    <i class="fas fa-image"></i>
                                    <span>Chưa có ảnh sản phẩm</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>
                                <i class="fas fa-upload"></i> Cập nhật ảnh mới
                            </label>
                            <input type="file" name="image" id="edit-image" class="form-control" accept="image/*" onchange="previewImage(this, 'edit-image-preview', 'no-image-placeholder-edit')">
                            <small style="color: #6c757d; font-size: 12px; display: block; margin-top: 5px;">
                                <i class="fas fa-info-circle"></i> Hỗ trợ: JPG, PNG, GIF (Tối đa 5MB)
                            </small>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i> Cập nhật sản phẩm
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <script src="/2274820014_NguyenThuHienn/JS/manage2.js" defer></script>
    </body>
</html>