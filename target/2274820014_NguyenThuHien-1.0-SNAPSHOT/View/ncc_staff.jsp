<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, Model.NccOrder" %>
<%
    if (request.getAttribute("nccList") == null) {
        response.sendRedirect(request.getContextPath() + "/NccController");
        return;
    }

    String ctx = request.getContextPath();
    String username = (String) session.getAttribute("username");
    
    List<NccOrder> list = (List<NccOrder>) request.getAttribute("nccList");
    List<Object[]> shops = (List<Object[]>) request.getAttribute("shopList");
    List<String> years = (List<String>) request.getAttribute("yearList");
    
    String msg = (String) request.getAttribute("message");
    String errorMsg = (String) request.getAttribute("errorMsg");
    
    String search = request.getParameter("search");
    String filterSup = request.getParameter("supplier");
    String filterYear = request.getParameter("year");
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử Nhà cung cấp</title>
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage2.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/ncc_staff.css">
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
            <li><a href="<%= ctx %>/Admin/manage5.jsp"><i class="fa fa-box"></i> Sản phẩm</a></li>
            <li><a href="<%= ctx %>/stock_manage.jsp"><i class="fa fa-layer-group"></i> Tồn kho & Nhập hàng</a></li>
            <li><a href="<%= ctx %>/View/ncc_staff.jsp" class="active"><i class="fa fa-truck-field"></i> Nhà cung cấp</a></li>
        </ul>
    </aside>

    <main class="dashboard-content">
        <div class="content-header">
             <div class="section-title"><h1 style="margin: 0 0 20px;">Lịch sử nhập hàng từ Nhà Cung Cấp</h1></div>
        </div>

        <form class="toolbar" method="GET" action="<%= ctx %>/NccController">
            <div class="filter-group">
                <select name="supplier" class="form-select">
                    <option value="">-- Tất cả Nhà cung cấp --</option>
                    <% if(shops!=null) for(Object[] s : shops) { 
                        String selected = String.valueOf(s[0]).equals(filterSup) ? "selected" : "";
                    %>
                        <option value="<%= s[0] %>" <%= selected %>><%= s[1] %></option>
                    <% } %>
                </select>

                <select name="year" class="form-select" style="min-width: 100px;">
                    <option value="">-- Năm --</option>
                    <% if(years!=null) for(String y : years) { 
                        String selected = y.equals(filterYear) ? "selected" : "";
                    %>
                        <option value="<%= y %>" <%= selected %>><%= y %></option>
                    <% } %>
                </select>
            </div>

            <div class="search-box">
                <i class="fa fa-search"></i>
                <input type="text" name="search" placeholder="Tìm tên SP, Mã đơn..." value="<%= (search!=null?search:"") %>">
            </div>
            
            <button class="btn-filter"><i class="fa fa-filter"></i> Tìm kiếm</button>
            
            <% if((search!=null && !search.isEmpty()) || (filterSup!=null && !filterSup.isEmpty())){ %>
                <a href="<%= ctx %>/NccController" class="btn-reset"><i class="fa fa-refresh"></i> Đặt lại</a>
            <% } %>
        </form>

        <% if(msg!=null){ %>
            <div class="msg-success" style="color:#155724;background:#d4edda;border:1px solid #c3e6cb;padding:10px;margin-bottom:10px;border-radius:5px;"><%= msg %></div>
        <% } %>
        <% if(errorMsg!=null){ %>
            <div class="msg-error"><i class="fa fa-exclamation-circle"></i> <%= errorMsg %></div>
        <% } %>

        <div class="table-wrapper">
            <table class="history-table">
                <thead>
                    <tr>
                        <th style="width:50px; text-align:center;">ID</th>
                        <th style="width:110px;">Ngày nhập</th>
                        <th style="width:200px;">Nhà cung cấp</th>
                        <th>Sản phẩm / Phân loại</th>
                        <th style="width:80px; text-align:center;">SL</th>
                        <th style="width:130px; text-align:center;">Trạng thái</th>
                        <th>Ghi chú từ Nhà Cung Cấp</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if(list != null && !list.isEmpty()){ 
                            for(NccOrder o : list){ 
                                String status = (o.getStatus() != null) ? o.getStatus().trim() : "";
                                String badgeClass = "st-wait";
                                if("Đã giao".equalsIgnoreCase(status) || "Đã nhận".equalsIgnoreCase(status) || "Hoàn tất nhập".equalsIgnoreCase(status)) badgeClass = "st-ok";
                                else if("Hoàn trả".equalsIgnoreCase(status) || "Đã hủy".equalsIgnoreCase(status)) badgeClass = "st-cancel";
                    %>
                    <tr>
                        <td style="text-align:center; font-weight:bold; color:#6b7280">#<%= o.getId() %></td>
                        <td><%= o.getOrderDate() %></td>
                        <td>
                            <div class="shop-info">
                                <i class="fa fa-store" style="color:#9ca3af; font-size:12px;"></i> 
                                <%= o.getShopName() %>
                            </div>
                        </td>
                        <td>
                            <span class="product-name"><%= o.getProductName() %></span>
                            <span class="option-name"><i class="fa fa-tag" style="font-size:10px"></i> <%= o.getOptionName() %></span>
                        </td>
                        <td style="text-align:center; font-weight:600;"><%= o.getTotal() %></td>
                        <td style="text-align:center;">
                            <span class="st-badge <%= badgeClass %>"><%= status %></span>
                        </td>
                        <td style="font-style: italic; color:#9ca3af; font-size:12px;">
                            <%= (o.getReason()!=null ? o.getReason() : "—") %>
                        </td>
                    </tr>
                    <% }} else { %> 
                        <tr><td colspan="7" style="text-align:center; padding:40px; color:#9ca3af;">Không tìm thấy dữ liệu.</td></tr> 
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</div>
<script>
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