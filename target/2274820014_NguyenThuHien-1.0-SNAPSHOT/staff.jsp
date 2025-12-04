<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.StaffOrderView, java.util.List, java.text.NumberFormat, java.util.Locale" %>
<%
    if (request.getAttribute("viewData") == null) {
        response.sendRedirect("StaffController");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    
    String role = (String) session.getAttribute("role");
    if (role == null || !(role.equalsIgnoreCase("staff") || role.equalsIgnoreCase("admin"))) {
        response.sendRedirect(ctx + "/index.jsp"); return;
    }
    String username = (String) session.getAttribute("username");
    if (username == null) username = "staff";

    StaffOrderView viewData = (StaffOrderView) request.getAttribute("viewData");
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    
    String errorMsg = (String) request.getAttribute("errorMsg");
    if (errorMsg == null) errorMsg = viewData.getErrorMsg();
    
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng</title>
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/manage2.css">
    <link rel="stylesheet" href="<%= ctx %>/CSS/staff.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>
<div class="header-cart">
    <div class="logo"><a href="<%= ctx %>/HomeProductServlet"><img src="<%= ctx %>/Images/logo.png" alt="Logo"></a><h1>Fluffy Bear</h1></div>
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
            <li><a href="<%= ctx %>/staff.jsp" class="active"><i class="fas fa-list-check"></i> Đơn hàng</a></li>
            <li><a href="<%= ctx %>/Admin/manage5.jsp"><i class="fa fa-box"></i> Sản phẩm</a></li>
            <li><a href="<%= ctx %>/stock_manage.jsp"><i class="fa fa-layer-group"></i> Tồn kho & Nhập hàng</a></li>
            <li><a href="<%= ctx %>/View/ncc_staff.jsp"><i class="fa fa-truck-field"></i> Nhà cung cấp</a></li>
        </ul>
    </aside>

    <main class="dashboard-content">
        <div class="section-title"><h1 style="margin: 0 0 20px;">Quản lý Đơn hàng</h1></div>

        <div class="kpi-grid">
            <div class="kpi-card" onclick="switchTab('tab-wait')">
                <div class="kpi-icon bg-orange"><i class="fas fa-clock"></i></div>
                <div class="kpi-info"><h4>Chờ duyệt</h4><p class="val"><%= viewData.getkChoDuyet() %></p></div>
            </div>
            <div class="kpi-card" onclick="switchTab('tab-ship')">
                <div class="kpi-icon bg-blue"><i class="fas fa-truck"></i></div>
                <div class="kpi-info"><h4>Đang giao</h4><p class="val"><%= viewData.getkDangGiao() %></p></div>
            </div>
            <div class="kpi-card" onclick="switchTab('tab-done')">
                <div class="kpi-icon bg-green"><i class="fas fa-check-circle"></i></div>
                <div class="kpi-info"><h4>Đã giao</h4><p class="val"><%= viewData.getkDaGiao() %></p></div>
            </div>
            <div class="kpi-card" onclick="switchTab('tab-cancel')">
                <div class="kpi-icon bg-gray"><i class="fas fa-ban"></i></div>
                <div class="kpi-info"><h4>Đã hủy</h4><p class="val"><%= viewData.getkDaHuy() %></p></div>
            </div>
        </div>

        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab('tab-wait')">Chờ duyệt <span class="badge"><%= viewData.getkChoDuyet() %></span></button>
            <button class="tab-btn" onclick="switchTab('tab-ship')">Đang giao <span class="badge"><%= viewData.getkDangGiao() %></span></button>
            <button class="tab-btn" onclick="switchTab('tab-done')">Đã giao <span class="badge"><%= viewData.getkDaGiao() %></span></button>
            <button class="tab-btn" onclick="switchTab('tab-cancel')">Đã hủy <span class="badge"><%= viewData.getkDaHuy() %></span></button>
        </div>

        <%! 
            public String renderTable(List<Model.StaffOrderView> list, String actionType, NumberFormat nf, String ctx) {
                StringBuilder sb = new StringBuilder();
                sb.append("<table>");
                sb.append("<thead><tr>");
                sb.append("<th class='w-stt'>STT</th>");
                sb.append("<th class='w-cust'>Khách hàng / Địa chỉ</th>");
                sb.append("<th class='w-prod'>Sản phẩm đặt mua</th>");
                sb.append("<th class='w-pay'>Thanh toán</th>");
                sb.append("<th class='w-act'>").append( ("wait".equals(actionType) || "ship".equals(actionType)) ? "Thao tác" : "Trạng thái" ).append("</th>");
                sb.append("</tr></thead>");
                sb.append("<tbody>");

                if(list != null && !list.isEmpty()){
                    for(Model.StaffOrderView item : list){ 
                        int oid = item.getOrderId();
                        String pttt = item.getPaymentMethod();
                        if(pttt == null) pttt = "COD";
                        
                        String itemList = item.getItemList();
                        if(itemList == null) itemList = "<i style='color:#999'>Chưa có sản phẩm</i>";
                        
                        String totalAmount = nf.format(item.getTotalAmount());
                        String orderDate = (item.getOrderDate() != null ? item.getOrderDate().toString() : "");

                        sb.append("<tr>");
                        sb.append("<td class='w-stt'><strong>#").append(oid).append("</strong></td>");
                        
                        sb.append("<td class='w-cust'>");
                        sb.append("<span class='customer-name'>").append(item.getCustomerName()).append("</span>");
                        sb.append("<span class='customer-phone'><i class='fa fa-phone'></i> ").append(item.getPhone()).append("</span>");
                        sb.append("<div class='customer-addr'><i class='fa fa-map-marker'></i> ").append(item.getAddress()).append("</div>");
                        sb.append("</td>");

                        sb.append("<td class='w-prod'>").append(itemList).append("</td>");

                        sb.append("<td class='w-pay'>");
                        sb.append("<div class='pttt-tag'>").append(pttt).append("</div>");
                        sb.append("<div class='price-tag'>").append(totalAmount).append("</div>");
                        sb.append("<div style='font-size:11px;color:#6b7280;margin-top:4px'>").append(orderDate).append("</div>");
                        sb.append("</td>");
                        
                        sb.append("<td class='w-act'><div class='actions'>");
                        if("wait".equals(actionType)) {
                            sb.append("<button class='btn-lg btn-white' onclick='printSlip(").append(oid).append(")'> <i class='fa fa-print'></i> In phiếu</button>");
                            
                            sb.append("<form action='").append(ctx).append("/OrdersServlet' method='post' onsubmit='return confirm(\"Xác nhận giao đơn này cho ĐVVC?\")'>");
                            sb.append("<input type='hidden' name='action' value='updateStatus'>");
                            sb.append("<input type='hidden' name='order_id' value='").append(oid).append("'>");
                            sb.append("<input type='hidden' name='new_status' value='Đang giao'>");
                            sb.append("<button class='btn-lg btn-blue'><i class='fa fa-truck'></i> Đã giao cho ĐVVC</button></form>");

                            sb.append("<form action='").append(ctx).append("/OrdersServlet' method='post' onsubmit='return confirm(\"Hủy đơn này?\")'>");
                            sb.append("<input type='hidden' name='action' value='updateStatus'>");
                            sb.append("<input type='hidden' name='order_id' value='").append(oid).append("'>");
                            sb.append("<input type='hidden' name='new_status' value='Đã hủy'>");
                            sb.append("<button class='btn-lg btn-red'><i class='fa fa-times'></i> Hủy đơn</button></form>");
                        } 
                        else if("ship".equals(actionType)) {
                            sb.append("<button class='btn-lg btn-white' onclick='printSlip(").append(oid).append(")'> <i class='fa fa-print'></i> In phiếu</button>");
                            sb.append("<span class='status-pill sp-ship'><i class='fa fa-shipping-fast'></i> Đang giao</span>");
                        } 
                        else if("done".equals(actionType)) {
                            sb.append("<span class='status-pill sp-done'>Thành công</span>");
                        } 
                        else if("cancel".equals(actionType)) {
                            sb.append("<span class='status-pill sp-cancel'>Đã hủy</span>");
                        }
                        sb.append("</div></td></tr>");
                    }
                } else {
                    sb.append("<tr><td colspan='5' style='text-align:center;padding:30px;color:#9ca3af'>Không có đơn hàng nào.</td></tr>");
                }
                sb.append("</tbody></table>");
                return sb.toString();
            }
        %>

        <% if (errorMsg != null) { %>
            <div class='msg error'>Lỗi: <%= errorMsg %></div>
        <% } %>

        <div id="tab-wait" class="tab-content active">
            <div class="card-table"><%= renderTable(viewData.getWaitList(), "wait", nf, ctx) %></div>
        </div>
        <div id="tab-ship" class="tab-content">
            <div class="card-table"><%= renderTable(viewData.getShipList(), "ship", nf, ctx) %></div>
        </div>
        <div id="tab-done" class="tab-content">
            <div class="card-table"><%= renderTable(viewData.getDoneList(), "done", nf, ctx) %></div>
        </div>
        <div id="tab-cancel" class="tab-content">
            <div class="card-table"><%= renderTable(viewData.getCancelList(), "cancel", nf, ctx) %></div>
        </div>

    </main>
</div>

<script>
    function switchTab(tabId) {
        document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        event.currentTarget.classList.add('active');
        localStorage.setItem('activeOrderTab', tabId);
    }
    document.addEventListener("DOMContentLoaded", function() {
        const savedTab = localStorage.getItem('activeOrderTab');
        if(savedTab) {
            const tabBtn = document.querySelector(`button[onclick="switchTab('${savedTab}')"]`);
            if(tabBtn) tabBtn.click();
        }
    });
    function printSlip(id){
        window.open('<%= ctx %>/print_item.jsp?order_id='+id, 'PRINT_'+id, 'height=800,width=750');
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