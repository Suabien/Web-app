<%-- 
    Document   : manage4
    Created on : Apr 16, 2025, 4:08:18 PM
    Author     : Gigabyte
--%>

<%@page import="java.sql.*, java.util.*, java.text.*" %>
<%@page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("role") == null || !"admin".equals(sessionObj.getAttribute("role"))) {
        response.sendRedirect("/2274820014_NguyenThuHienn/HomeProductServlet");
        return;
    }
    
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");

    // Kết nối DB
    String url = "jdbc:mysql://localhost:3306/trangsuc_db";
    String user = "root";
    String pass = "hien031204";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(url, user, pass);
    
    // Query lấy danh sách đơn hàng (không join với order_items)
    String sql = 
      "SELECT o.order_id, o.customer_name, o.address, o.phone, "
    + "o.order_date, o.payment_method, o.total_amount, o.status, "
    + "COUNT(oi.item_id) as item_count "  // Đếm số sản phẩm trong đơn
    + "FROM orders o "
    + "LEFT JOIN order_items oi ON o.order_id = oi.order_id "
    + "GROUP BY o.order_id "
    + "ORDER BY o.order_date DESC";
    
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý đơn hàng - Fluffy Bear</title>
        <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/manage.css">
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
                    <li><a href="/2274820014_NguyenThuHienn/OptionServlet">
                        <i class="fas fa-tags"></i> Loại sản phẩm
                    </a></li>
                    <li><a href="/2274820014_NguyenThuHienn/Admin/manage4.jsp" class="active">
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
                    <h1 id="content-title">Quản lý đơn hàng</h1>
                    <p>Xem, duyệt đơn và quản lý đơn hàng của khách hàng.</p>
                </div>

                <!-- Form ẩn để gửi trạng thái cập nhật -->
                <form id="orderForm" method="post" action="<%= request.getContextPath() %>/Orders2Servlet" style="display:none;">
                    <input type="hidden" name="action" value="updateStatus" />
                    <input type="hidden" name="orderId" id="orderIdInput" />
                    <input type="hidden" name="newStatus" id="newStatusInput" />
                </form>

                <!-- Bảng đơn hàng -->
                <div class="table-container">
                    <div class="table-header">
                        <h3><i class="fas fa-list"></i> Danh sách đơn hàng</h3>
                        <div class="filter-controls">
                            <select id="statusFilter" class="form-control" style="width: 200px; margin-right: 10px;" onchange="filterOrders()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Chờ duyệt">Chờ duyệt</option>
                                <option value="Đang giao">Đang giao</option>
                                <option value="Đã giao">Đã giao</option>
                                <option value="Đã huỷ">Đã huỷ</option>
                            </select>
                        </div>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 120px;">Khách hàng</th>
                                <th style="width: 150px;">Địa chỉ</th>
                                <th style="width: 100px;">SĐT</th>
                                <th style="width: 80px;">Số SP</th> 
                                <th style="width: 100px;">Ngày đặt</th>
                                <th style="width: 100px;">Phương thức TT</th>
                                <th style="width: 100px;">Tổng tiền</th>
                                <th style="width: 100px;">Trạng thái</th>
                                <th style="width: 120px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while(rs.next()) {
                                    int orderId = rs.getInt("order_id");
                                    String customerName = rs.getString("customer_name");
                                    String address = rs.getString("address");
                                    String phone = rs.getString("phone");
                                    int itemCount = rs.getInt("item_count");
                                    String paymentMethod = rs.getString("payment_method");
                                    java.sql.Date orderDate = rs.getDate("order_date");
                                    double totalAmount = rs.getDouble("total_amount");
                                    String status = rs.getString("status");

                                    // Xác định class cho trạng thái
                                    String statusClass = "";
                                    if ("Chờ duyệt".equals(status)) {
                                        statusClass = "status-pending";
                                    } else if ("Đang giao".equals(status)) {
                                        statusClass = "status-shipping";
                                    } else if ("Đã giao".equals(status)) {
                                        statusClass = "status-delivered";
                                    } else if ("Đã huỷ".equals(status)) {
                                        statusClass = "status-rejected";
                                    }
                            %>
                                <tr data-status="<%= status %>">
                                    <td><strong>#<%= orderId %></strong></td>
                                    <td><strong><%= customerName %></strong></td>
                                    <td>
                                        <div class="address-content">
                                            <%= address %>
                                        </div>
                                    </td>
                                    <td><%= phone %></td>
                                    <td class="text-center">
                                        <span class="badge" style="background: #e3f2fd; color: #1976d2; padding: 4px 8px; border-radius: 12px;">
                                            <%= itemCount %> SP
                                        </span>
                                    </td>
                                    <td><%= orderDate != null ? sdf.format(orderDate) : "" %></td>
                                    <td><%= paymentMethod %></td>
                                    <td><strong class="price-cell"><%= String.format("%,.0f₫", totalAmount) %></strong></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= status %>
                                        </span>
                                    </td>
                                    <td class="action-buttons">
                                        <% if ("Chờ duyệt".equals(status)) { %>
                                            <button class="btn-approve" onclick="approveOrder(<%= orderId %>)">
                                                <i class="fas fa-check"></i> Duyệt
                                            </button>
                                            <button class="btn-reject" onclick="rejectOrder(<%= orderId %>)">
                                                <i class="fas fa-times"></i> Không duyệt
                                            </button>
                                        <% } else if ("Đang giao".equals(status)) { %>
                                            <button class="btn-complete" onclick="completeOrder(<%= orderId %>)">
                                                <i class="fas fa-truck"></i> Hoàn thành
                                            </button>
                                        <% } %>
                                        <a href="${pageContext.request.contextPath}/Orders2Servlet?action=details&orderId=<%= orderId %>"
                                           class="btn-detail">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            <%
                                }
                                rs.close();
                                ps.close();
                                conn.close();
                            %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <script>
            // Hàm cập nhật trạng thái đơn hàng
            function updateOrderStatus(orderId, newStatus) {
                document.getElementById('orderIdInput').value = orderId;
                document.getElementById('newStatusInput').value = newStatus;
                document.getElementById('orderForm').submit();
            }

            // Hàm duyệt đơn hàng
            function approveOrder(orderId) {
                if(confirm('Bạn có chắc muốn duyệt đơn hàng #' + orderId + '?\nĐơn hàng sẽ chuyển sang trạng thái "Đang giao".')) {
                    showNotification('🔄 Đang xử lý duyệt đơn hàng...', 'info');
                    updateOrderStatus(orderId, 'Đang giao');
                }
            }

            // Hàm từ chối đơn hàng
            function rejectOrder(orderId) {
                if(confirm('Bạn có chắc muốn từ chối đơn hàng #' + orderId + '?\nĐơn hàng sẽ bị hủy và không thể khôi phục.')) {
                    showNotification('🔄 Đang xử lý từ chối đơn hàng...', 'info');
                    updateOrderStatus(orderId, 'Đã huỷ');
                }
            }

            // Hàm hoàn thành đơn hàng
            function completeOrder(orderId) {
                if(confirm('Bạn có chắc đơn hàng #' + orderId + ' đã được giao thành công?\nĐơn hàng sẽ chuyển sang trạng thái "Đã giao".')) {
                    showNotification('🔄 Đang xử lý hoàn thành đơn hàng...', 'info');
                    updateOrderStatus(orderId, 'Đã giao');
                }
            }

            // Hàm lọc đơn hàng theo trạng thái
            function filterOrders() {
                const filterValue = document.getElementById('statusFilter').value.toLowerCase();
                const rows = document.querySelectorAll('tbody tr');
                
                rows.forEach(row => {
                    const status = row.getAttribute('data-status').toLowerCase();
                    if (filterValue === '' || status === filterValue.toLowerCase()) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            // Hàm hiển thị thông báo
            function showNotification(message, type) {
                // Remove existing notifications
                document.querySelectorAll('.notification').forEach(notification => {
                    notification.remove();
                });

                const notification = document.createElement('div');
                notification.className = `notification ${type}`;
                notification.innerHTML = `
                    <span>${message}</span>
                    <button onclick="this.parentElement.remove()">&times;</button>
                `;
                
                notification.style.cssText = `
                    position: fixed;
                    top: 120px;
                    right: 20px;
                    const type = '<%= request.getAttribute("type") %>';
                    const bgColor = type === 'success' ? '#4CAF50'
                    : type === 'error' ? '#f44336'
                    : '#2196F3';

                    const toast = document.querySelector('.toast');
                    toast.style.background = bgColor;
                    color: white;
                    padding: 15px 20px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                    z-index: 1001;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    animation: slideInRight 0.3s ease-out;
                `;
                
                document.body.appendChild(notification);
                
                // Auto remove after 3 seconds
                setTimeout(() => {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 3000);
            }

            // Thêm CSS animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes slideInRight {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
                
                .notification button {
                    background: none;
                    border: none;
                    color: white;
                    font-size: 18px;
                    cursor: pointer;
                    padding: 0;
                    width: 20px;
                    height: 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
            `;
            document.head.appendChild(style);

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