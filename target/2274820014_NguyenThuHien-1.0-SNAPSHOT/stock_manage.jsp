<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, Model.Option" %>
<%
    // Tự động redirect nếu chạy trực tiếp
    if (request.getAttribute("inventoryList") == null) {
        response.sendRedirect("StockController");
        return;
    }

    String ctx = request.getContextPath();
    String username = (String) session.getAttribute("username");
    
    List<Option> inventoryList = (List<Option>) request.getAttribute("inventoryList");
    List<Option> productList = (List<Option>) request.getAttribute("productList");
    List<Object[]> nccList = (List<Object[]>) request.getAttribute("nccList");
    List<String> supplierList = (List<String>) request.getAttribute("supplierList");
    
    String message = (String) request.getAttribute("message");
    String errorMsg = (String) request.getAttribute("errorMsg");
    String search = request.getParameter("search");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tồn kho & Nhập hàng</title>
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage2.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/stock_manage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>
<div class="header-cart">
    <div class="logo">
        <a href="<%= ctx %>/HomeProductServlet"><img src="<%= ctx %>/Images/logo.png" alt="Logo"></a>
        <h1>Fluffy Bear</h1>
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
                <div class="user-info-name"><%= username != null ? username : "Tên người dùng" %></div>
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
            <li><a href="<%= ctx %>/Admin/manage5.jsp"><i class="fa fa-box"></i> Sản phẩm</a></li>
            <li><a href="<%= ctx %>/stock_manage.jsp" class="active"><i class="fa fa-layer-group"></i> Tồn kho & Nhập hàng</a></li>
            <li><a href="<%= ctx %>/View/ncc_staff.jsp"><i class="fa fa-truck-field"></i> Nhà cung cấp</a></li>
        </ul>
    </aside>

    <main class="dashboard-content">
        <div class="content-header">
             <div class="section-title"><h1 style="margin: 0 0 20px;">Quản lý Kho hàng</h1></div>
        </div>
        <br>

        <% if(message!=null){ %><div class="msg msg-ok"><i class="fa fa-check-circle"></i> <%= message %></div><% } %>
        <% if(errorMsg!=null){ %><div class="msg msg-err"><i class="fa fa-exclamation-triangle"></i> <%= errorMsg %></div><% } %>

        <div class="layout-stock">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Danh sách tồn kho</span>
                    <form class="search-form" method="GET" action="StockController">
                        <input type="text" name="search" class="search-input" placeholder="Nhập tên sản phẩm..." value="<%= (search!=null?search:"") %>">
                        <button class="btn-search" title="Tìm kiếm"><i class="fa fa-search"></i></button>
                    </form>
                </div>
                
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th style="width:50px; text-align:center;">STT</th>
                                <th>Sản phẩm / Biến thể</th>
                                <th style="width:120px;">Giá bán</th>
                                <th style="width:100px; text-align:center;">Tồn kho</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if(inventoryList!=null && !inventoryList.isEmpty()){
                                int stt = 1;
                                for(Option opt : inventoryList){
                            %>
                            <tr>
                                <td style="text-align:center; color:#6b7280; font-weight:600"><%= stt++ %></td>
                                <td>
                                    <div style="font-weight:700; font-size:14px; color:#111827; margin-bottom:2px;">
                                        <%= opt.getProduct_name() %>
                                    </div>
                                    <div style="font-size:12px; color:#6b7280; display:flex; align-items:center; gap:5px;">
                                        <i class="fa fa-layer-group" style="font-size:10px"></i> 
                                        <%= opt.getOption_name() %>
                                    </div>
                                </td>
                                <td style="font-weight:500"><%= opt.getPrice() %></td>
                                <td style="text-align:center;">
                                    <span class="badge-qty"><%= opt.getQuantity() %></span>
                                </td>
                            </tr>
                            <% }} else { %> 
                            <tr><td colspan="4" style="text-align:center; padding:30px; color:#9ca3af;">Chưa có dữ liệu tồn kho (Bảng options trống).</td></tr> 
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header"><span class="card-title">Phiếu nhập kho</span></div>
                <form method="post" action="StockController" onsubmit="return validateMaxQty()">
                    <div class="form-group">
                        <label>Đơn hàng từ Nhà Cung Cấp </label>
                        <select name="nccOrderId" id="ncc-select">
                            <option value="" data-prod="" data-qty="" data-sup="">-- Nhập lẻ (Không theo đơn) --</option>
                            <% if(nccList!=null) for(Object[] ncc : nccList) { 
                                // ncc[1]: Tên SP, ncc[2]: Tên Biến thể, ncc[3]: Số lượng, ncc[4]: Tên Shop
                                String fullName = ncc[1] + " - " + ncc[2];
                            %>
                                <option value="<%= ncc[0] %>" 
                                        data-prod="<%= fullName %>" 
                                        data-prod-only="<%= ncc[1] %>"
                                        data-qty="<%= ncc[3] %>" 
                                        data-sup="<%= ncc[4] %>">
                                    Đơn #<%= ncc[0] %>: <%= fullName %> - SL: <%= ncc[3] %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Chọn sản phẩm nhập kho <span style="color:red">*</span></label>
                        <select name="optionId" id="product-select" required>
                            <% if(productList!=null) for(Option p : productList) { 
                                String pName = p.getProduct_name() + " - " + p.getOption_name();
                            %>
                                <option value="<%= p.getId() %>" data-name="<%= pName %>">
                                    <%= pName %> (Tồn: <%= p.getQuantity() %>)
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Số lượng nhập <span style="color:red">*</span></label>
                        <input type="number" name="quantity" id="qty-input" min="1" placeholder="VD: 50" required>
                        <small id="qty-hint" style="color:green; display:none;"></small>
                    </div>

                    <div class="form-group">
                        <label>Nhà cung cấp</label>
                        <select name="supplier" id="sup-select">
                            <option value="">-- Chọn nhà cung cấp --</option>
                            <% if(supplierList!=null) for(String s : supplierList){ %>
                                <option value="<%= s %>"><%= s %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Ngày nhập</label>
                        <input type="date" name="importDate">
                    </div>

                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="note" rows="3" placeholder="Ghi chú lô hàng..."></textarea>
                    </div>

                    <button class="btn-submit"><i class="fa fa-save"></i> Lưu phiếu nhập</button>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    const nccSel = document.getElementById('ncc-select');
    const prodSel = document.getElementById('product-select');
    const supSel = document.getElementById('sup-select');
    const qtyInput = document.getElementById('qty-input');
    const qtyHint = document.getElementById('qty-hint');
    
    // Biến lưu số lượng tối đa cho phép
    let maxAllowedQty = 999999; 

    if(nccSel){
        nccSel.addEventListener('change', function(){
            const opt = this.options[this.selectedIndex];
            const supName = opt.getAttribute('data-sup');
            const prodName = opt.getAttribute('data-prod-only'); // Tên sản phẩm (chưa kèm biến thể)
            const qty = opt.getAttribute('data-qty');

            // 1. Tự chọn Nhà cung cấp
            if(supName && supSel) {
                supSel.value = supName;
            }

            // 2. Tự chọn Sản phẩm (So sánh tương đối)
            // Logic: Tìm trong list sản phẩm, dòng nào chứa tên sản phẩm từ đơn hàng NCC thì chọn
            if(prodName && prodSel) {
                for(let i=0; i<prodSel.options.length; i++) {
                    // So sánh tên sản phẩm có chứa trong tên option không
                    if(prodSel.options[i].text.includes(prodName)) {
                        prodSel.selectedIndex = i;
                        break; 
                    }
                }
            }

            // 3. Điền số lượng và đặt giới hạn
            if(qty) {
                qtyInput.value = qty;
                maxAllowedQty = parseInt(qty);
                qtyHint.style.display = 'block';
                qtyHint.innerText = 'Tối đa theo đơn: ' + qty;
            } else {
                qtyInput.value = '';
                maxAllowedQty = 999999;
                qtyHint.style.display = 'none';
            }
        });
    }

    // Hàm kiểm tra trước khi submit
    function validateMaxQty() {
        const val = parseInt(qtyInput.value);
        if(val > maxAllowedQty) {
            alert('Số lượng nhập không được vượt quá số lượng đơn hàng (' + maxAllowedQty + ')');
            return false;
        }
        return true;
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