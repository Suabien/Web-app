<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    final String ctx = request.getContextPath();

    // ==== Guard: chỉ cho nhà cung cấp ====
    HttpSession sessionObj = request.getSession(false);
    String role = (sessionObj != null && sessionObj.getAttribute("role") != null)
                  ? sessionObj.getAttribute("role").toString()
                  : null;
    if (role == null || !"Nhà cung cấp".equals(role)) {
        response.sendRedirect(ctx + "/HomeProductServlet");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");

    // ==== Dữ liệu từ NccOptionServlet ====
    List<Model.Option> options = (List<Model.Option>) request.getAttribute("listOption");
    List<Model.NccProduct> productList = (List<Model.NccProduct>) request.getAttribute("productList");

    String flashErr = (String) request.getAttribute("errorMessage");
    String flashOk  = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý loại sản phẩm - Fluffy Bear</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="<%=ctx%>/CSS/ncc_product.css"><!-- dùng chung stylesheet -->
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
                    <img class="user-img" src="<%= imagePath != null ? (ctx + "/" + imagePath) : (ctx + "/Images/sanpham1.jpg") %>" />
                </div>
                <span class="greeting">Xin chào, <%= fullName != null ? fullName : "Tên người dùng" %> !</span>
                <!-- Popup thông tin -->
                <div class="user-info-popup" id="userInfoPopup">
                    <div class="user-info-header">
                        <div class="user-info-avatar">
                            <img src="<%= imagePath != null ? (ctx + "/" + imagePath) : (ctx + "/Images/sanpham1.jpg") %>" />
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
                                <a href="/2274820014_NguyenThuHienn/ShopServlet" class="user-info-link">
                                    <i class="fas fa-user-gear"></i>
                                    Quản lý hệ thống
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
                    <li><a href="<%=ctx%>/ShopServlet"><i class="fas fa-users"></i> Quản lý cửa hàng</a></li>
                    <li><a href="<%=ctx%>/NccProductServlet"><i class="fas fa-box"></i> Quản lý sản phẩm</a></li>
                    <li><a href="<%=ctx%>/NccOptionServlet" class="active"><i class="fas fa-tags"></i> Quản lý loại sản phẩm</a></li>
                    <li><a href="<%=ctx%>/NccOrderServlet"><i class="fas fa-shopping-cart"></i> Quản lý đơn hàng</a></li>
                </ul>
            </div>

            <!-- Nội dung chính -->
            <main class="dashboard-content">
                <div class="content-header">
                    <h1 id="content-title">Quản lý loại sản phẩm</h1>
                    <p>Quản lý loại sản phẩm, giá cả của sản phẩm</p>
                </div>
                <!-- Flash message -->
                <% if (flashErr != null) { %>
                    <div class="alert alert-danger"><%= flashErr %></div>
                <% } %>
                <% if (flashOk != null) { %>
                    <div class="alert alert-success"><%= flashOk %></div>
                <% } %>
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
                                <th style="width:60px;">ID</th>
                                <th style="width:70px;">Ảnh</th>
                                <th style="width:120px;">Tên loại sản phẩm</th>
                                <th style="width:220px;">Bộ sản phẩm</th>
                                <th style="width:120px;">Giá</th>
                                <th style="width:100px;">Số lượng</th>
                                <th style="width:180px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (options != null && !options.isEmpty()) {
                                for (Model.Option opt : options) {
                                    // ---- LẤY ĐÚNG GETTER TỪ MODEL.Option ----
                                    String rawImg = (opt.getImage() == null) ? "" : opt.getImage();
                                    String img = !rawImg.isEmpty()
                                            ? (rawImg.startsWith("http") ? rawImg : (ctx + "/" + rawImg))
                                            : (ctx + "/Images/default-avatar.jpg");

                                    String optName  = (opt.getOption_name() == null || opt.getOption_name().isEmpty())
                                                      ? "-" : opt.getOption_name();

                                    String prodName = (opt.getProduct_name() == null || opt.getProduct_name().isEmpty())
                                                      ? ("#" + opt.getProduct_id())
                                                      : opt.getProduct_name();

                                    String price    = (opt.getPrice() == null || opt.getPrice().isEmpty())
                                                      ? "0" : opt.getPrice();

                                    String qty      = String.valueOf(opt.getQuantity());

                                    // escape cho tham số JS
                                    String jsOptName = optName.replace("'", "\\'");
                                    String jsPrice   = price.replace("'", "\\'");
                                    String jsQty     = qty.replace("'", "\\'");
                                    String jsImg     = img.replace("'", "\\'");
                                    String jsProdId  = String.valueOf(opt.getProduct_id()).replace("'", "\\'");
                        %>
                            <tr>
                                <td><strong>#<%= opt.getId() %></strong></td>
                                <td>
                                    <div class="shop-avatar-small">
                                        <img src="<%= img %>" alt="Ảnh loại"
                                             onerror="this.src='<%=ctx%>/Images/default-avatar.jpg'">
                                    </div>
                                </td>
                                <td><%= optName %></td>
                                <td><%= prodName %></td>
                                <td><%= price %>₫</td>
                                <td><%= qty %></td>
                                <td class="action-buttons">
                                    <button class="btn-edit" onclick="openEditModal(
                                        '<%= opt.getId() %>',
                                        '<%= jsOptName %>',
                                        '<%= jsPrice %>',
                                        '<%= jsQty %>',
                                        '<%= jsImg %>',
                                        '<%= jsProdId %>'
                                    )">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>
                                    <button class="btn-delete" onclick="deleteItem('<%= opt.getId() %>')">
                                        <i class="fas fa-trash"></i> Xoá
                                    </button>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" style="text-align:center;padding:40px;color:#6c757d;">
                                    <i class="fas fa-tags" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
                                    Không có dữ liệu
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
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('addOptionModal')">&times;</span>
                <h3><i class="fas fa-tags"></i> Thêm loại sản phẩm</h3>
                <form id="addOptionForm" action="<%=ctx%>/NccOptionServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>Tên loại sản phẩm:</label>
                        <input type="text" name="option_name" class="form-control" required placeholder="VD: Nhẫn bạc 925 size 6">
                    </div>
                    <div class="form-group">
                        <label>Giá:</label>
                        <input type="text" name="price" class="form-control" required placeholder="VD: 199000">
                    </div>
                    <div class="form-group">
                        <label>Số lượng:</label>
                        <input type="number" name="quantity" min="0" class="form-control" required value="0">
                    </div>
                    <div class="form-group">
                        <label>Hình ảnh:</label>
                        <div class="image-upload-container">
                            <input type="file" name="image" class="form-control" accept="image/*" onchange="previewImage(this, 'add-image-preview')">
                            <img id="add-image-preview" alt="Preview" style="max-width:100px;max-height:100px;display:none;border-radius:8px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Bộ sản phẩm:</label>
                        <select name="product_id" class="form-control" required>
                            <%
                                if (productList != null && !productList.isEmpty()) {
                                    for (Model.NccProduct p : productList) {
                            %>
                                <option value="<%= p.getId() %>"><%= p.getName() %></option>
                            <%
                                    }
                                } else {
                            %>
                                <option value="">Không có sản phẩm</option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Thêm loại
                    </button>
                </form>
            </div>
        </div>

        <!-- Modal Sửa loại sản phẩm -->
        <div id="editOptionModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('editOptionModal')">&times;</span>
                <h3><i class="fas fa-edit"></i> Sửa loại sản phẩm</h3>
                <form id="editOptionForm" action="<%=ctx%>/NccOptionServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="form-group">
                        <label>Tên loại sản phẩm:</label>
                        <input type="text" name="option_name" id="edit-option-name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Giá:</label>
                        <input type="text" name="price" id="edit-price" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Số lượng:</label>
                        <input type="number" name="quantity" id="edit-quantity" min="0" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Ảnh hiện tại:</label>
                        <div class="image-upload-container">
                            <img id="edit-image-preview" src="" alt="Preview" style="max-width:100px;max-height:100px;display:none;border-radius:8px;">
                            <input type="file" name="image" id="edit-image" class="form-control" accept="image/*"
                                 onchange="previewImage(this, 'edit-image-preview')">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Bộ sản phẩm:</label>
                        <select name="product_id" id="edit-product-id" class="form-control" required>
                            <%
                                if (productList != null && !productList.isEmpty()) {
                                    for (Model.NccProduct p : productList) {
                            %>
                                <option value="<%= p.getId() %>"><%= p.getName() %></option>
                            <%
                                    }
                                } else {
                            %>
                                <option value="">Không có sản phẩm</option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Cập nhật loại
                    </button>
                </form>
            </div>
        </div>

        <!-- Form xoá ẩn -->
        <form id="deleteForm" action="<%=ctx%>/NccOptionServlet" method="POST" style="display:none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="delete-id">
        </form>

        <script src="<%=ctx%>/JS/ncc_option.js" defer></script>
    </body>
</html>
