<%@page import="Model.NccProduct"%>
<%@page import="java.util.List"%>
<%@page import="Model.Product"%>
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

    // ==== Danh sách sản phẩm từ NccProductServlet ====
    List<NccProduct> productList = (List<NccProduct>) request.getAttribute("products");
    if (productList == null) {
        response.sendRedirect(ctx + "/NccProductServlet");
        return;
    }

    // ==== (Tùy chọn) Danh sách loại sản phẩm nếu controller cung cấp ====
    // Kỳ vọng: request.setAttribute("types", List<TypeProduct>) với getter getTypeId(), getTypeName()
    List types = (List) request.getAttribute("types");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý sản phẩm - Fluffy Bear</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="<%=ctx%>/CSS/ncc_product.css">
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
                    <img class="user-img" src="<%= imagePath != null ? request.getContextPath() + "/" + imagePath : "/2274820014_NguyenThuHienn/Images/sanpham1.jpg" %>" />
                </div>
                <span class="greeting">Xin chào, <%= fullName != null ? fullName : "Tên người dùng" %> !</span>
                <!-- Popup thông tin -->
                <div class="user-info-popup" id="userInfoPopup">
                    <div class="user-info-header">
                        <div class="user-info-avatar">
                            <img src="<%= imagePath != null ? request.getContextPath() + "/" + imagePath : ctx + "/Images/sanpham1.jpg" %>" />
                        </div>
                        <div class="user-info-name"><%= fullName != null ? fullName : "Tên người dùng" %></div>
                        <div class="user-info-role">
                            <%= "Nhà cung cấp" %>
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
                        <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" style="margin: 0;">
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
                    <li><a href="<%=ctx%>/ShopServlet">
                        <i class="fas fa-users"></i> Quản lý cửa hàng
                    </a></li>
                    <li><a href="<%=ctx%>/NccProductServlet" class="active">
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
                    <h1 id="content-title">Quản lý sản phẩm</h1>
                    <p>Quản lý thông tin sản phẩm, giá cả và số lượng</p>
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
                                <th style="width:60px;">ID</th>
                                <th style="width:70px;">Ảnh</th>
                                <th style="width:180px;">Tên sản phẩm</th>
                                <th style="width:90px;">Loại</th>
                                <th style="width:110px;">Giá</th>
                                <th style="width:90px;">Số lượng</th>
                                <th style="width:80px;">Đã bán</th>
                                <th style="width:90px;">Tồn kho</th>
                                <th style="width:180px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (!productList.isEmpty()) {
                                for (NccProduct p : productList) {
                                    String rawImg = (p.getImage_url() != null && !p.getImage_url().isEmpty())
                                                    ? p.getImage_url() : "";
                                    String img = !rawImg.isEmpty()
                                        ? (rawImg.startsWith("http") ? rawImg : (ctx + "/" + rawImg))
                                        : ctx + "/Images/sanpham1.jpg";

                                    String name = (p.getName() != null && !p.getName().isEmpty()) ? p.getName() : "-";
                                    String typeName = (p.getType_name() != null && !p.getType_name().isEmpty())
                                                      ? p.getType_name() : ("#" + p.getType_id());
                                    String price = (p.getPrice() != null && !p.getPrice().isEmpty()) ? p.getPrice() : "0";

                                    // Số lượng tổng (nếu chỉ có quantity)
                                    int qty = p.getQuantity();

                                    // Thử lấy sold/stock nếu Model đã có; nếu không thì fallback
                                    int sold = 0;
                                    int stock = qty;
                                    try { sold = (int)p.getClass().getMethod("getSold").invoke(p); } catch (Exception ignore) {}
                                    try { sold = (int)p.getClass().getMethod("getSoldQty").invoke(p); } catch (Exception ignore) {}
                                    try { stock = (int)p.getClass().getMethod("getStock").invoke(p); } catch (Exception ignore) {}
                                    try { stock = (int)p.getClass().getMethod("getStockQty").invoke(p); } catch (Exception ignore) {}
                                    if (sold == 0 && stock == qty) {
                                        // Nếu chỉ có quantity: coi quantity là tồn kho hiện tại
                                        // (hoặc bạn có thể phân tách khác khi có dữ liệu thật)
                                }

                                // escape khi truyền vào onclick
                                String jsName   = name.replace("'", "\\'");
                                String jsImg    = img.replace("'", "\\'");
                                String jsPrice  = price.replace("'", "\\'");
                                String jsTypeId = String.valueOf(p.getType_id()).replace("'", "\\'");
                                String jsDesc   = (p.getDescription() == null ? "" : p.getDescription()).replace("'", "\\'");
                        %>
                            <tr>
                                <td><strong>#<%= p.getId() %></strong></td>
                                <td>
                                    <div class="shop-avatar-small">
                                        <img src="<%= img %>" alt="Ảnh SP" onerror="this.src='<%=ctx%>/Images/sanpham1.jpg'">
                                    </div>
                                </td>
                                <td><strong><%= name %></strong></td>
                                <td><%= typeName %></td>
                                <td><%= price %></td>
                                <td><%= qty %></td>
                                <td><%= sold %></td>
                                <td><%= stock %></td>
                                <td class="action-buttons">
                                    <button class="btn-edit" onclick="openEditModal(
                                      '<%= p.getId() %>',
                                      '<%= jsName %>',
                                      '<%= jsPrice %>',
                                      '<%= qty %>',   
                                      '<%= jsTypeId %>',
                                      '<%= jsDesc %>',
                                      '<%= jsImg %>',
                                      '<%= sold %>'       /* nếu muốn hiển thị/readonly trong modal */
                                    )">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>
                                    <button type="button" class="btn-delete" onclick="deleteItem('<%= p.getId() %>')">
                                        <i class="fas fa-trash"></i> Xoá
                                    </button>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="8" style="text-align:center;padding:40px;color:#6c757d;">
                                    <i class="fas fa-box-open" style="font-size:48px;margin-bottom:15px;display:block;opacity:0.5;"></i>
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

        <!-- Modal Thêm sản phẩm -->
        <div id="addProductModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('addProductModal')">&times;</span>
                <h3><i class="fas fa-box"></i> Thêm sản phẩm</h3>
                <form id="addProductForm" action="<%=ctx%>/NccProductServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>Tên sản phẩm:</label>
                        <input type="text" name="name" class="form-control" required placeholder="Nhập tên sản phẩm">
                    </div>
                    <div class="form-group">
                        <label>Giá:</label>
                        <input type="text" name="price" class="form-control" required placeholder="VD: 199000">
                    </div>
                    <div class="form-group">
                        <label>Số lượng:</label>
                        <input type="number" name="quantity" min="0" class="form-control" required value="0" placeholder="VD: 100">
                    </div>
                    <div class="form-group">
                        <label>Loại sản phẩm:</label>
                        <%
                            if (types != null && !((java.util.List)types).isEmpty()) {
                              java.util.List list = (java.util.List) types;
                        %>
                            <select name="type_id" id="add-type-id" class="form-control" required>
                                <option value="" disabled selected>Chọn loại</option>
                                <%
                                    for (Object obj : list) {
                                      String[] t = (String[]) obj;      
                                %>
                                    <option value="<%= t[0] %>"><%= t[1] %></option>
                                <%
                                    }
                                %>
                            </select>
                        <%
                            } else {
                        %>
                            <input type="number" name="type_id" class="form-control" required placeholder="Nhập type_id (số)">
                        <%
                            }
                        %>
                    </div>
                    <div class="form-group">
                        <label>Mô tả:</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Mô tả ngắn..."></textarea>
                    </div>
                    <div class="form-group">
                        <label>Ảnh:</label>
                        <div class="image-upload-container">
                            <input type="file" name="image" class="form-control" accept="image/*" onchange="previewImage(this, 'add-image-preview')">
                            <img id="add-image-preview" alt="Preview" style="max-width:100px;max-height:100px;display:none;border-radius:8px;">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Thêm sản phẩm
                    </button>
                </form>
            </div>
        </div>

        <!-- Modal Sửa sản phẩm -->
        <div id="editProductModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('editProductModal')">&times;</span>
                <h3><i class="fas fa-edit"></i> Sửa sản phẩm</h3>
                <form id="editProductForm" action="<%=ctx%>/NccProductServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="form-group">
                        <label>Tên sản phẩm:</label>
                        <input type="text" name="name" id="edit-name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Giá:</label>
                        <input type="text" name="price" id="edit-price" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Số lượng:</label>
                        <input type="number" name="quantity" id="edit-quantity" min="0" class="form-control" required>
                    </div>
                    <!--<div class="form-group">
                        <label>Đã bán:</label>
                        <input type="number" name="sold" id="edit-sold" class="form-control" value="0" readonly>
                    </div>
                    <div class="form-group">
                        <label>Tồn kho:</label>
                        <input type="number" name="stock" id="edit-stock" min="0" class="form-control" required>
                    </div>-->
                    <div class="form-group">
                        <label>Loại sản phẩm:</label>
                        <%
                            if (types != null && !((java.util.List)types).isEmpty()) {
                              java.util.List list = (java.util.List) types;
                        %>
                            <select name="type_id" id="edit-type-id" class="form-control" required>
                                <option value="" disabled selected>Chọn loại</option>
                                <%
                                    for (Object obj : list) {
                                      String[] t = (String[]) obj;      
                                %>
                                    <option value="<%= t[0] %>"><%= t[1] %></option>
                                <%
                                    }
                                %>
                            </select>
                        <%
                            } else {
                        %>
                            <input type="number" name="type_id" id="edit-type-id" class="form-control" required placeholder="Nhập type_id (số)">
                        <%
                            }
                        %>
                    </div>
                    <div class="form-group">
                        <label>Mô tả:</label>
                        <textarea name="description" id="edit-description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Ảnh:</label>
                        <div class="image-upload-container">
                            <img id="edit-image-preview" src="" alt="Preview" style="max-width:100px;max-height:100px;display:none;border-radius:8px;">
                            <input type="file" name="image" id="edit-image" class="form-control" accept="image/*"
                                   onchange="previewImage(this, 'edit-image-preview')">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Cập nhật sản phẩm
                    </button>
                </form>
            </div>
        </div>

        <!-- Modal Xóa sản phẩm -->
        <form id="deleteForm" action="<%=ctx%>/NccProductServlet" method="POST" style="display:none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="delete-id">
        </form>

        <script src="<%=ctx%>/JS/ncc_product.js" defer></script>
    </body>
</html>
