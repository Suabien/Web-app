<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.ProductView, java.util.List" %>
<%
    // 1. Tự động gọi Controller
    if (request.getAttribute("productList") == null) {
        response.sendRedirect(request.getContextPath() + "/ProductListController");
        return;
    }

    String ctx = request.getContextPath();
    String username = (String) session.getAttribute("username");
    if(username == null) username = "Admin";

    List<ProductView> list = (List<ProductView>) request.getAttribute("productList");
    String errorMsg = (String) request.getAttribute("errorMsg");
    String message = (String) request.getAttribute("message");
    
    String search = request.getParameter("search");
    String filterType = request.getParameter("type");
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage2.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage5.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        table td { vertical-align: middle !important; }
        .action-buttons { display: flex; justify-content: center; align-items: center; gap: 5px; }
        .dashboard-wrapper { min-height: 100vh; display: flex; }
        .dashboard-sidebar { min-height: 100vh; height: auto; }
    </style>
</head>
<body>
<div class="header-cart">
    <div class="logo">
        <a href="<%= ctx %>/HomeProductServlet"><img src="<%= ctx %>/Images/logo.png" alt="Logo"></a>
        <h1><a href="<%= ctx %>/HomeProductServlet">Fluffy Bear</a></h1>
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
                         userRole.equals("staff") ? "Người bán hàng" :
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
                    <!-- CHỈ HIỂN THỊ KHI LÀ NGƯỜI BÁN -->
                    <% if ("staff".equals(userRole)) { %>
                    <li class="user-info-item">
                        <a href="/2274820014_NguyenThuHienn/staff.jsp" class="user-info-link">
                            <i class="fas fa-user-gear"></i>
                            Quản lý hệ thống
                        </a>
                    </li>
                    <% } %>
                    <% if (!"staff".equals(userRole) && !"Nhà cung cấp".equals(userRole)) { %>
                    <li class="user-info-item">
                        <a href="/2274820014_NguyenThuHienn/Orders4Servlet" class="user-info-link">
                            <i class="fas fa-shopping-bag"></i>
                            Theo dõi đơn hàng
                        </a>
                    </li>
                    <% } %>
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
        <span class="admin-greeting">Xin chào, <%= username %>!</span>
    </div>
</div>

<div class="dashboard-wrapper">
    <aside class="dashboard-sidebar">
        <div class="sidebar-header"><h2><i class="fas fa-cogs"></i> Người bán</h2></div>
        <ul class="sidebar-menu">
            <li><a href="<%= ctx %>/staff.jsp"><i class="fas fa-list-check"></i> Đơn hàng</a></li>
            <li><a href="<%= ctx %>/Admin/manage5.jsp" class="active"><i class="fa fa-box"></i> Sản phẩm</a></li>
            <li><a href="<%= ctx %>/stock_manage.jsp"><i class="fa fa-layer-group"></i> Tồn kho & Nhập hàng</a></li>
            <li><a href="<%= ctx %>/View/ncc_staff.jsp"><i class="fa fa-truck-field"></i> Nhà cung cấp</a></li>
        </ul>
    </aside>

    <main class="dashboard-content">
        <div class="page-header-flex">
            <div class="content-header">
                <div class="section-title"><h1 style="margin: 0 0 20px;">Quản lý sản phẩm</h1></div>
            </div>

            <form class="toolbar-form" method="GET" action="<%= ctx %>/ProductListController">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" placeholder="Tìm kiếm..." value="<%= (search!=null?search:"") %>">
                </div>
                
                <select name="type" class="filter-select" onchange="this.form.submit()">
                    <option value="">-- Tất cả loại --</option>
                    <option value="1" <%= "1".equals(filterType)?"selected":"" %>>Cao cấp</option>
                    <option value="2" <%= "2".equals(filterType)?"selected":"" %>>Thời trang</option>
                    <option value="3" <%= "3".equals(filterType)?"selected":"" %>>Phong thuỷ</option>
                    <option value="4" <%= "4".equals(filterType)?"selected":"" %>>Tối giản</option>
                    <option value="5" <%= "5".equals(filterType)?"selected":"" %>>Vintage/Retro</option>
                    <option value="6" <%= "6".equals(filterType)?"selected":"" %>>Cá nhân hóa</option>
                </select>

                <button type="button" class="btn-add" onclick="openModal('addProductModal')">
                    <i class="fa fa-plus"></i> Thêm mới
                </button>
            </form>
        </div>

        <% if (message != null) { %><div style="color:green; padding:10px; background:#d1e7dd; margin-bottom:10px;"><%= message %></div><% } %>
        <% if (errorMsg != null) { %><div class="msg-error"><%= errorMsg %></div><% } %>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th style="width:50px;">ID</th>
                    <th style="width:80px;">Ảnh</th>
                    <th style="width:250px;">Tên & Biến thể</th>
                    <th>Mô tả</th>
                    <th style="width:100px;">Phân loại</th>
                    <th style="width:110px;">Giá</th>
                    <th style="width:80px; text-align:center">Tồn</th>
                    <th style="width:140px;">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (list != null && !list.isEmpty()) {
                        for (ProductView p : list) {
                            String safeName = (p.getName()==null?"":p.getName()).replace("\"","&quot;").replace("'","&#39;");
                            String safeDesc = (p.getDescription()==null?"":p.getDescription()).replace("\"","&quot;").replace("'","&#39;");
                            String safeImg = (p.getImageUrl()==null?"":p.getImageUrl()).replace("\"","&quot;").replace("'","&#39;");
                            String safePrice = (p.getPrice()==null?"":p.getPrice()).replace("\"","&quot;").replace("'","&#39;");
                %>
                <tr>
                    <td style="color:#6b7280; font-weight:600">#<%= p.getId() %></td>
                    <td>
                        <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                            <img class="product-thumb" src="<%= p.getImageUrl() %>" alt="thumb">
                        <% } %>
                    </td>
                    <td>
                        <div style="font-weight:700; font-size:14px; color:#111827; margin-bottom:4px"><%= p.getName() %></div>
                        <% if (p.getVariantList() != null && !p.getVariantList().isEmpty()) { %>
                            <div style="font-size:12px; color:#6b7280; display:flex; gap:5px; align-items:center;">
                                <i class="fa fa-tags" style="font-size:10px"></i> <%= p.getVariantList() %>
                            </div>
                        <% } else { %>
                            <span style="font-size:11px; color:#9ca3af; font-style:italic;">(Chưa có biến thể)</span>
                        <% } %>
                    </td>
                    <td><div class="desc-text"><%= p.getDescription() %></div></td>
                    <td><%= p.getTypeName() %></td>
                    <td style="font-weight:600; color:#374151"><%= p.getPrice() %></td>
                    <td style="text-align:center"><span class="badge-stock"><%= p.getTotalStock() %></span></td>
                    <td class="action-buttons">
                        <button class="btn-icon btn-edit" title="Sửa"
                                data-id="<%= p.getId() %>" data-name="<%= safeName %>" data-desc="<%= safeDesc %>"
                                data-img="<%= safeImg %>" data-price="<%= safePrice %>" data-type="<%= p.getTypeId() %>"
                                onclick="openProductEditModalFromBtn(this)">
                            <i class="fa fa-pen"></i>
                        </button>

                        <button class="btn-icon btn-delete" title="Xóa" onclick="deleteItem('<%= p.getId() %>')">
                            <i class="fa fa-trash"></i>
                        </button>

                        <button class="btn-variant" title="Quản lý biến thể"
                                data-id="<%= p.getId() %>" data-name="<%= safeName %>"
                                onclick="openVariantModal(this)">
                             Biến thể <i class="fa fa-arrow-right" style="margin-left:4px; font-size:10px"></i>
                        </button>
                    </td>
                </tr>
                <% }} else { %>
                    <tr><td colspan="8" style="text-align:center; padding:30px; color:#9ca3af">Không tìm thấy sản phẩm nào.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<div id="addProductModal" class="modal">
    <div class="modal-content">
        <div class="modal-header"><h3>Thêm sản phẩm mới</h3><span class="close-modal" onclick="closeModal('addProductModal')">&times;</span></div>
        <form action="<%= ctx %>/ProductListController" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="modal-body-full form-group"><label>Tên sản phẩm</label><input type="text" name="name" class="form-control" required></div>
                <div class="modal-body-full form-group"><label>Mô tả</label><textarea name="description" class="form-control" required></textarea></div>
                <div class="form-group"><label>Ảnh đại diện</label><label class="custom-file-upload"><i class="fas fa-cloud-upload-alt"></i> Chọn ảnh<input type="file" name="image" accept="image/*" style="display:none" onchange="previewImage(this,'add-image-preview')" required></label><img id="add-image-preview" class="product-thumb" style="display:none; margin-top:10px"></div>
                <div class="form-group"><label>Giá hiển thị</label><input type="text" name="price" class="form-control" required></div>
                <div class="form-group"><label>Phân loại</label><select name="type_id" class="form-control" required><option value="1">Cao cấp</option><option value="2">Thời trang</option><option value="3">Phong thuỷ</option><option value="4">Tối giản</option><option value="5">Vintage/Retro</option><option value="6">Cá nhân hóa</option></select></div>
            </div>
            <div class="modal-footer"><button class="btn-submit">Thêm sản phẩm</button></div>
        </form>
    </div>
</div>

<div id="editProductModal" class="modal">
    <div class="modal-content">
        <div class="modal-header"><h3>Sửa sản phẩm</h3><span class="close-modal" onclick="closeModal('editProductModal')">&times;</span></div>
        <form action="<%= ctx %>/ProductListController" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="edit"><input type="hidden" id="edit-product-id" name="id">
            <div class="modal-body">
                <div class="modal-body-full form-group"><label>Tên sản phẩm</label><input type="text" id="edit-name" name="name" class="form-control" required></div>
                <div class="modal-body-full form-group"><label>Mô tả</label><textarea id="edit-description" name="description" class="form-control" required></textarea></div>
                <div class="form-group"><label>Ảnh hiện tại</label><img id="current-image-preview" class="product-thumb" style="margin-bottom:10px"><label class="custom-file-upload"><i class="fas fa-cloud-upload-alt"></i> Chọn ảnh khác<input type="file" id="edit-image" name="image" accept="image/*" style="display:none" onchange="previewImage(this,'edit-image-preview')"></label><img id="edit-image-preview" class="product-thumb" style="display:none; margin-top:10px"></div>
                <div class="form-group"><label>Giá hiển thị</label><input type="text" id="edit-price" name="price" class="form-control" required></div>
                <div class="form-group"><label>Phân loại</label><select id="edit-type" name="type_id" class="form-control" required><option value="1">Cao cấp</option><option value="2">Thời trang</option><option value="3">Phong thuỷ</option><option value="4">Tối giản</option><option value="5">Vintage/Retro</option><option value="6">Cá nhân hóa</option></select></div>
            </div>
            <div class="modal-footer"><button class="btn-submit">Cập nhật</button></div>
        </form>
    </div>
</div>

<div id="variantModal" class="modal">
    <div class="modal-content" style="max-width:800px;">
        <div class="modal-header"><h3>Biến Thể Sản Phẩm</h3><span class="close-modal" onclick="closeModal('variantModal')">&times;</span></div>
        <div class="modal-body" style="grid-template-columns:1fr 1fr; align-items:end;">
            <div class="modal-body-full" style="margin-bottom:10px;"><span class="variant-header">Sản phẩm #<span id="variant-product-id"></span> – <span id="variant-product-name" style="color:#f97373"></span></span></div>
            <div class="form-group"><label>Tên biến thể</label><input type="text" id="variant-name" class="form-control" placeholder="Nhập tên..."></div>
            <div class="form-group"><label>Giá</label><input type="text" id="variant-price" class="form-control" placeholder="VD: 200.000"></div>
            <div class="form-group"><label>Tồn kho ban đầu</label><input type="number" id="variant-qty" class="form-control" min="0" value="0"></div>
            <div class="form-group"><button type="button" class="btn-submit" onclick="addVariant()" style="width:100%">+ Thêm</button></div>
            <div class="modal-body-full" style="margin-top:10px;"><table class="variant-table"><thead><tr><th style="width:60px;">Mã</th><th>Tên biến thể</th><th style="width:110px;">Giá</th><th style="width:80px;">Tồn</th><th style="width:80px;">Xử lý</th></tr></thead><tbody id="variant-tbody"></tbody></table></div>
        </div>
        <div class="modal-footer"><button class="btn-submit" style="background:#6b7280" onclick="closeModal('variantModal')">Đóng</button></div>
    </div>
</div>

<script>
    function openModal(id){ document.getElementById(id).style.display='block'; }
    function closeModal(id){ document.getElementById(id).style.display='none'; }
    function previewImage(input, previewId){
        const file = input.files && input.files[0];
        const img = document.getElementById(previewId);
        if(!file){ img.style.display='none'; img.src=''; return; }
        const reader = new FileReader();
        reader.onload = e => { img.src = e.target.result; img.style.display='inline-block'; };
        reader.readAsDataURL(file);
    }
    function openProductEditModalFromBtn(btn){
        const d = btn.dataset;
        document.getElementById('edit-product-id').value = d.id || '';
        document.getElementById('edit-name').value = d.name || '';
        document.getElementById('edit-description').value = d.desc || '';
        document.getElementById('current-image-preview').src = d.img || '';
        document.getElementById('edit-price').value = d.price || '';
        document.getElementById('edit-type').value = d.type || 1;
        openModal('editProductModal');
    }
    function deleteItem(id){
        if(confirm('Xoá sản phẩm #' + id + ' ?')){
            // ĐỔI LINK DELETE: ProductListController
            location.href = '<%= ctx %>/ProductListController?action=delete&id=' + encodeURIComponent(id);
        }
    }
    
    // Variant Script (Giữ nguyên vì nó gọi AJAX tới VariantServlet)
    let currentVariantProductId = null;
    function openVariantModal(btn){
        const id = btn.dataset.id;
        const name = btn.dataset.name || '';
        currentVariantProductId = id;
        document.getElementById('variant-product-id').textContent = id;
        document.getElementById('variant-product-name').textContent = name;
        document.getElementById('variant-name').value = '';
        document.getElementById('variant-price').value = '';
        document.getElementById('variant-qty').value = 0;
        loadVariants(id);
        openModal('variantModal');
    }
    function loadVariants(productId){
        const tbody = document.getElementById('variant-tbody');
        tbody.innerHTML = "<tr><td colspan='5'>Đang tải...</td></tr>";
        fetch('<%= ctx %>/VariantServlet?action=list&productId=' + encodeURIComponent(productId), { method: 'GET' })
            .then(r => r.text()).then(html => { tbody.innerHTML = html || "<tr><td colspan='5'>Chưa có biến thể.</td></tr>"; })
            .catch(() => { tbody.innerHTML = "<tr><td colspan='5'>Lỗi tải biến thể.</td></tr>"; });
    }
    function addVariant(){
        if(!currentVariantProductId) return;
        const name = document.getElementById('variant-name').value.trim();
        const price = document.getElementById('variant-price').value.trim();
        const qty = document.getElementById('variant-qty').value;
        if(!name){ alert('Vui lòng nhập tên biến thể'); return; }
        const formData = new URLSearchParams();
        formData.append('productId', currentVariantProductId);
        formData.append('option_name', name);
        formData.append('price', price);
        formData.append('quantity', qty);
        fetch('<%= ctx %>/VariantServlet', {
            method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }, body: formData.toString()
        }).then(r => r.text()).then(html => {
            document.getElementById('variant-tbody').innerHTML = html;
            document.getElementById('variant-name').value = '';
            document.getElementById('variant-price').value = '';
            document.getElementById('variant-qty').value = 0;
        }).catch(() => alert('Lỗi khi thêm biến thể'));
    }
    function deleteVariant(id){
        if(!currentVariantProductId) return;
        if(!confirm('Xoá biến thể #' + id + ' ?')) return;
        fetch('<%= ctx %>/VariantServlet?action=delete&productId=' + encodeURIComponent(currentVariantProductId) + '&id=' + encodeURIComponent(id), { method: 'GET' })
            .then(r => r.text()).then(html => { document.getElementById('variant-tbody').innerHTML = html; })
            .catch(() => alert('Lỗi khi xoá biến thể'));
    }
    // Thông tin người dùng (popup)
    function toggleUserInfo() {
        const popup = document.getElementById("userInfoPopup");
        if (popup.style.display === "block") {
            popup.style.display = "none";
        } else {
            popup.style.display = "block";
            popup.classList.add("show");
        }
    }

    // Ẩn popup khi click ra ngoài
    document.addEventListener("click", function(event) {
        const avatar = document.querySelector(".user-avatar");
        const popup = document.getElementById("userInfoPopup");
        if (avatar && popup && !avatar.contains(event.target) && !popup.contains(event.target)) {
            popup.style.display = "none";
            popup.classList.remove("show");
        }
    });

    // Đóng popup khi scroll 
    window.addEventListener("scroll", function() {
        const popup = document.getElementById("userInfoPopup");
        if (popup && popup.style.display === "block") {
            popup.style.display = "none";
            popup.classList.remove("show");
        }
    });
</script>
</body>
</html>