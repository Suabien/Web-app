<%@page import="java.util.List"%>
<%@page import="Model.Shop"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    final String ctx = request.getContextPath();

    // ==== Guard: chỉ cho nhà cung cấp (ưu tiên roleCode) ====
    HttpSession sessionObj = request.getSession(false);
    String role     = (sessionObj != null) ? (String) sessionObj.getAttribute("role")     : null;      // "Nhà cung cấp"/"admin"/...
    String roleCode = (sessionObj != null) ? (String) sessionObj.getAttribute("roleCode") : null;      // supplier/admin/...

    boolean isSupplier = "supplier".equals(roleCode) || "Nhà cung cấp".equals(role);
    if (!isSupplier) {
        response.sendRedirect(ctx + "/HomeProductServlet");
        return;
    }

    // Dùng sessionObj nhất quán
    String fullName  = (sessionObj != null) ? (String) sessionObj.getAttribute("fullName")  : null;
    String imagePath = (sessionObj != null) ? (String) sessionObj.getAttribute("imagePath") : null;

    // ==== Danh sách shop từ ShopServlet ====
    @SuppressWarnings("unchecked")
    List<Shop> shopList = (List<Shop>) request.getAttribute("shops");

    // ĐỪNG redirect ở đây để tránh vòng lặp; nếu null thì cho list rỗng
    if (shopList == null) {
        shopList = java.util.Collections.emptyList();
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý cửa hàng - Fluffy Bear</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="<%=ctx%>/CSS/ncc_shop.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <!-- Header -->
        <div class="header-cart">
            <div class="logo">
                <a href="<%=ctx%>/HomeProductServlet"><img src="<%=ctx%>/Images/logo.png" alt="Logo"></a>
                <h1><a href="<%=ctx%>/HomeProductServlet">Fluffy Bear</a></h1>
            </div>
            <!-- Nút avatar -->
            <div class="user-avatar-container">
                <div class="user-avatar" onclick="toggleUserInfo()">
                    <!-- Ảnh  -->
                    <img class="user-img"
                         src="<%= (imagePath != null && !imagePath.isEmpty()) ? (ctx + "/" + imagePath) : (ctx + "/Images/default-avatar.jpg") %>" />
                </div>
                <span class="greeting">Xin chào, <%= fullName != null ? fullName : "Tên người dùng" %> !</span>
                <!-- Popup thông tin -->
                <div class="user-info-popup" id="userInfoPopup">
                    <div class="user-info-header">
                        <div class="user-info-avatar">
                            <img src="<%= (imagePath != null && !imagePath.isEmpty()) ? (ctx + "/" + imagePath) : (ctx + "/Images/default-avatar.jpg") %>" />
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
                                <a href="<%=ctx%>/ShopServlet" class="user-info-link">
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
                        <form action="<%=ctx%>/LogoutServlet" method="post" style="margin: 0;">
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
                    <li><a href="<%=ctx%>/ShopServlet" class="active">
                        <i class="fas fa-users"></i> Quản lý cửa hàng
                    </a></li>
                    <li><a href="<%=ctx%>/NccProductServlet">
                        <i class="fas fa-box"></i> Quản lý sản phẩm
                    </a></li>
                    <li><a href="<%=ctx%>/NccOptionServlet">
                        <i class="fas fa-tags"></i> Quản lý loại sản phẩm
                    </a></li>
                    <li><a href="<%=ctx%>/NccOrderServlet">
                        <i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
                    </a></li>
                </ul>
            </div>

            <!-- Nội dung chính -->
            <main class="dashboard-content">
                <div class="content-header">
                    <h1 id="content-title">Quản lý cửa hàng</h1>
                    <p>Quản lý số lượng cửa hàng nhập sản phẩm từ nhà cung cấp</p>
                </div>
                <!-- Bảng cửa hàng -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Danh sách cửa hàng</h3>
                        <button class="btn-add" onclick="openModal('addShopModal')">
                            <i class="fas fa-plus"></i> Thêm cửa hàng
                        </button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th style="width: 60px;">Ảnh</th>
                                <th style="width: 150px;">Tên cửa hàng</th>
                                <th style="width: 120px;">Tên người bán</th>
                                <th style="width: 150px;">Email</th>
                                <th style="width: 100px;">SĐT</th>
                                <th style="width: 150px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (shopList != null && !shopList.isEmpty()) {
                                  for (Shop shop : shopList) {
                                    String rawImg = shop.getImagePath();
                                    String img = (rawImg != null && !rawImg.trim().isEmpty())
                                                 ? (rawImg.startsWith("http") ? rawImg : ctx + "/" + rawImg)
                                                 : ctx + "/Images/default-avatar.jpg";

                                    String shopName   = shop.getShopName()   != null ? shop.getShopName()   : "-";
                                    String sellerName = shop.getSellerName() != null ? shop.getSellerName() : "-";
                                    String email      = shop.getEmail()      != null ? shop.getEmail()      : "-";
                                    String phone      = shop.getPhone()      != null ? shop.getPhone()      : "-";

                                    String jsShopName   = shopName.replace("\\", "\\\\").replace("'", "\\'");
                                    String jsSellerName = sellerName.replace("\\", "\\\\").replace("'", "\\'");
                                    String jsEmail      = email.replace("\\", "\\\\").replace("'", "\\'");
                                    String jsPhone      = phone.replace("\\", "\\\\").replace("'", "\\'");
                                    String jsImage      = img.replace("\\", "\\\\").replace("'", "\\'");
                            %>
                                <tr>
                                    <td><strong>#<%=shop.getId()%></strong></td>
                                    <td><img class="shop-avatar-small" src="<%=img%>" width="50" height="50"
                                             onerror="this.src='<%=ctx%>/Images/default-avatar.jpg'"></td>
                                    <td><strong><%=shopName%></strong></td>
                                    <td><%=sellerName%></td>
                                    <td><%=email%></td>
                                    <td><%=phone%></td>
                                    <td class="action-buttons">
                                        <button class="btn-edit" onclick="openEditModal(
                                          '<%=shop.getId()%>','<%=jsShopName%>',
                                          '<%=jsSellerName%>','<%=jsEmail%>',
                                          '<%=jsPhone%>','<%=jsImage%>')">
                                          <i class="fas fa-edit"></i> Sửa
                                        </button>
                                        <button class="btn-delete" onclick="deleteItem('<%=shop.getId()%>')">
                                            <i class="fas fa-trash"></i> Xoá
                                        </button>
                                    </td>
                                </tr>
                            <%
                                }
                              } else {
                            %>
                                <tr><td colspan="7" style="text-align:center;">Không có dữ liệu</td></tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- Modal Thêm cửa hàng -->
        <div id="addShopModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('addShopModal')">&times;</span>
                <h3><i class="fas fa-store"></i> Thêm cửa hàng</h3>
                <form action="<%=ctx%>/ShopServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>Tên cửa hàng:</label>
                        <input class="form-control" type="text" name="shop-name" required>
                    </div>
                    <div class="form-group">
                        <label>Tên người bán:</label>
                        <input class="form-control" type="text" name="seller-name" required>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <input class="form-control" type="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label>SĐT:</label>
                        <input class="form-control" type="tel" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label>Ảnh:</label>
                        <div class="image-upload-container">
                            <input type="file" name="image" class="form-control" accept="image/*" onchange="previewImage(this, 'addPreview')">
                            <img id="addPreview" alt="Preview" style="max-width:100px;max-height:100px;display:none;border-radius:8px;">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Thêm cửa hàng
                    </button>
                </form>
            </div>
        </div>

        <!-- Modal Sửa cửa hàng -->
        <div id="editShopModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('editShopModal')">&times;</span>
                <h3><i class="fas fa-edit"></i> Sửa cửa hàng</h3>
                <form action="<%=ctx%>/ShopServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">
                    <input type="hidden" name="existing_image" id="edit-existing-image">
                    <div class="form-group">
                        <label>Tên cửa hàng:</label>
                        <input class="form-control" type="text" name="shop-name" id="edit-shop-name" required>
                    </div>
                    <div class="form-group">
                        <label>Tên người bán:</label>
                        <input class="form-control" type="text" name="seller-name" id="edit-seller-name" required>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <input class="form-control" type="email" name="email" id="edit-email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>SĐT:</label>
                        <input class="form-control" type="tel" name="phone" id="edit-phone" required>
                    </div>
                    <div class="form-group">
                        <label>Ảnh đại diện:</label>
                        <div class="image-upload-container">
                            <img id="editPreview" src="" alt="Preview" style="max-width:100px;max-height:100px;display:none;border-radius:8px;">
                            <input type="file" name="image" id="edit-image" class="form-control" accept="image/*"
                                   onchange="previewImage(this, 'editPreview')">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Cập nhật cửa hàng
                    </button>
                </form>
            </div>
        </div>
                    
        <!-- Form Xóa ẩn (POST) -->
        <form id="deleteForm" action="<%=ctx%>/ShopServlet" method="POST" style="display:none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="delete-id">
        </form>
                    
        <script src="<%=ctx%>/JS/ncc_shop.js" defer></script>
    </body>
</html>
