<%-- 
    Document   : manage3
    Created on : Apr 12, 2025, 12:46:18 AM
    Author     : Gigabyte
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Account" %>
<%@page import="Model.Product" %>
<%@page import="Model.Option" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("role") == null || !"admin".equals(sessionObj.getAttribute("role"))) {
        response.sendRedirect("/2274820014_NguyenThuHienn/HomeProductServlet");
        return;
    }
    
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý loại sản phẩm - Fluffy Bear</title>
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/manage3.css">
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
                    <img class="user-img" src="<%= imagePath != null ? request.getContextPath() + "/" + imagePath : "/2274820014_NguyenThuHienn/Images/default-avatar.jpg" %>" />
                </div>

                <!-- Popup thông tin người dùng -->
                <div class="user-info-popup" id="userInfoPopup">
                    <div class="user-info-header">
                        <div class="user-info-avatar">
                            <img src="<%= imagePath != null ? request.getContextPath() + "/" + imagePath : "/2274820014_NguyenThuHienn/Images/default-avatar.jpg" %>" />
                        </div>
                        <div class="user-info-name"><%= fullName != null ? fullName : "Tên người dùng" %></div>
                        <div class="user-info-role">Quản trị viên</div>
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
                                <a href="/2274820014_NguyenThuHienn/AccountServlet" class="user-info-link">
                                    <i class="fas fa-user-gear"></i>
                                    Quản lý hệ thống
                                </a>
                            </li>
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
                    <li><a href="/2274820014_NguyenThuHienn/ProductServlet">
                        <i class="fas fa-box"></i> Quản lý sản phẩm
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/OptionServlet" class="active">
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
                    <h1 id="content-title">Quản lý loại sản phẩm</h1>
                    <p>Quản lý các loại sản phẩm, thêm, sửa, xoá.</p>
                </div>

                <!-- Bảng loại sản phẩm -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Danh sách loại sản phẩm</h3>
                        <button class="btn-add" onclick="openModal('addOptionModal')">
                            <i class="fas fa-plus"></i> Thêm loại sản phẩm
                        </button>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th style="width: 80px;">Ảnh</th>
                                <th style="width: 120px;">Tên loại sản phẩm</th>
                                <th style="width: 200px;">Sản phẩm</th>
                                <th style="width: 100px;">Giá</th>
                                <th style="width: 80px;">Số lượng</th>
                                <th style="width: 100px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Option> options = (List<Option>) request.getAttribute("listOption");
                                if (options != null && !options.isEmpty()) {
                                    for (Option opt : options) {
                            %>
                                        <tr>
                                            <td><strong>#<%= opt.getId() %></strong></td>
                                            <td>
                                                <div class="product-image-small">
                                                    <img src="<%= request.getContextPath() + "/" + opt.getImage() %>" 
                                                         alt="Option Image" 
                                                         onerror="this.src='<%= request.getContextPath() %>/Images/default-product.jpg'">
                                                </div>
                                            </td>
                                            <td><strong><%= opt.getOption_name() %></strong></td>
                                            <td>
                                                <span class="product-badge">
                                                    <%= opt.getProduct_name() != null ? opt.getProduct_name() : "N/A" %>
                                                </span>
                                            </td>
                                            <td><strong><%= opt.getPrice() %>₫</strong></td>
                                            <td>
                                                <span class="quantity-badge <%= opt.getQuantity() > 10 ? "in-stock" : opt.getQuantity() > 0 ? "low-stock" : "out-of-stock" %>">
                                                    <%= opt.getQuantity() %>
                                                </span>
                                            </td>
                                            <td class="action-buttons">
                                                <button class="btn-edit" onclick="openEditModal(
                                                    '<%= opt.getId() %>', 
                                                    '<%= opt.getOption_name().replace("'", "\\'") %>', 
                                                    '<%= opt.getPrice() %>',
                                                    '<%= opt.getQuantity() %>',
                                                    '<%= opt.getImage() != null ? opt.getImage().replace("'", "\\'") : "" %>',
                                                    '<%= opt.getProduct_id() %>'
                                                )">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                                <button class="btn-delete" onclick="deleteOption('<%= opt.getId() %>')">
                                                    <i class="fas fa-trash"></i> Xoá
                                                </button>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #6c757d;">
                                        <i class="fas fa-tags" style="font-size: 48px; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                        Không có dữ liệu loại sản phẩm
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

        <!-- Modal Thêm loại sản phẩm -->
        <div id="addOptionModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-modal" onclick="closeModal('addOptionModal')">&times;</span>
                <h3><i class="fas fa-tags"></i> Thêm loại sản phẩm mới</h3>
                <form id="addOptionForm" action="OptionServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-tag"></i> Tên loại sản phẩm
                        </label>
                        <input type="text" name="option_name" class="form-control" required placeholder="Nhập tên loại sản phẩm">
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
                            <i class="fas fa-box"></i> Sản phẩm
                        </label>
                        <select name="product_id" class="form-control" required>
                            <option value="">Chọn sản phẩm</option>
                            <% 
                                List<Product> productList = (List<Product>) request.getAttribute("productList");
                                if (productList != null && !productList.isEmpty()) {
                                    for (Product p : productList) {
                            %>
                                <option value="<%= p.getId() %>"><%= p.getName() %></option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-image"></i> Ảnh loại sản phẩm
                        </label>
                        <div class="image-upload-container">
                            <img id="add-option-image-preview" src="" alt="Preview" style="max-width: 150px; max-height: 150px; display: none;">
                            <div id="no-option-image-placeholder-add" class="upload-placeholder">
                                <i class="fas fa-image"></i>
                                <span>Chưa có ảnh loại sản phẩm</span>
                            </div>
                        </div>
                        <input type="file" name="image" id="add-option-image" class="form-control" accept="image/*" onchange="previewImage(this, 'add-option-image-preview', 'no-option-image-placeholder-add')" required>
                        <small style="color: #6c757d; font-size: 12px; display: block; margin-top: 5px;">
                            <i class="fas fa-info-circle"></i> Hỗ trợ: JPG, PNG, GIF (Tối đa 5MB)
                        </small>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Thêm loại sản phẩm
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Modal Sửa loại sản phẩm -->
        <div id="editOptionModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-modal" onclick="closeModal('editOptionModal')">&times;</span>
                <h3><i class="fas fa-edit"></i> Sửa thông tin loại sản phẩm</h3>

                <!-- Tabs Navigation -->
                <div class="form-tabs">
                    <button type="button" class="form-tab active" data-tab="basic-info">
                        <i class="fas fa-info-circle"></i> Thông tin cơ bản
                    </button>
                    <button type="button" class="form-tab" data-tab="image-info">
                        <i class="fas fa-camera"></i> Ảnh loại sản phẩm
                    </button>
                </div>

                <form id="editOptionForm" action="OptionServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">

                    <!-- Tab 1: Thông tin cơ bản -->
                    <div class="tab-content active" id="basic-info-tab">
                        <div class="form-group">
                            <label class="required">
                                <i class="fas fa-tag"></i> Tên loại sản phẩm
                            </label>
                            <input type="text" name="option_name" id="edit-option-name" class="form-control" required>
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
                                <i class="fas fa-box"></i> Sản phẩm
                            </label>
                            <select name="product_id" id="edit-product-id" class="form-control" required>
                                <option value="">Chọn sản phẩm</option>
                                <% 
                                    if (productList != null && !productList.isEmpty()) {
                                        for (Product p : productList) {
                                %>
                                    <option value="<%= p.getId() %>"><%= p.getName() %></option>
                                <% 
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <!-- Tab 2: Ảnh loại sản phẩm -->
                    <div class="tab-content" id="image-info-tab">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-image"></i> Ảnh loại sản phẩm hiện tại
                            </label>
                            <div class="image-upload-container">
                                <img id="edit-option-image-preview" 
                                    src="<%= request.getContextPath() %>/${empty opt.image ? 'Images/default-product.jpg' : opt.image}" 
                                    alt="Preview">
                                <div id="no-option-image-placeholder-edit" class="upload-placeholder" style="display: none;">
                                    <i class="fas fa-image"></i>
                                    <span>Chưa có ảnh loại sản phẩm</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>
                                <i class="fas fa-upload"></i> Cập nhật ảnh mới
                            </label>
                            <input type="file" name="image" id="edit-option-image" class="form-control" accept="image/*" onchange="previewImage(this, 'edit-option-image-preview', 'no-option-image-placeholder-edit')">
                            <small style="color: #6c757d; font-size: 12px; display: block; margin-top: 5px;">
                                <i class="fas fa-info-circle"></i> Hỗ trợ: JPG, PNG, GIF (Tối đa 5MB)
                            </small>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i> Cập nhật loại sản phẩm
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <script src="/2274820014_NguyenThuHienn/JS/manage3.js" defer></script>
    </body>
</html>