<%-- 
    Document   : dashboard
    Created on : Nov 25, 2025, 12:41:47 PM
    Author     : sucun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("role") == null || !"admin".equals(sessionObj.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/HomeProductServlet");
        return;
    }
    
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    if (stats == null) {
        response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        return;
    }
    
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
    
    Map<String, Object> revenueData = (Map<String, Object>) stats.get("revenueData");
    String selectedPeriod = (String) revenueData.get("period");
    Map<String, Double> monthlyRevenue = (Map<String, Double>) revenueData.get("revenue");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thống kê - Fluffy Bear</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/CSS/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <!-- Header -->
    <div class="header-cart">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/HomeProductServlet">
                <img src="${pageContext.request.contextPath}/Images/logo.png" alt="Logo">
            </a>
            <h1><a href="${pageContext.request.contextPath}/HomeProductServlet">Fluffy Bear</a></h1>
        </div>
        
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/AccountServlet"></a></li>
                <li><a href="${pageContext.request.contextPath}/ProductServlet"></a></li>
                <li><a href="${pageContext.request.contextPath}/OptionServlet"></a></li>
                <li><a href="${pageContext.request.contextPath}/Admin/manage4.jsp"></a></li>
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
    
    <!-- Dashboard -->
    <div class="dashboard-wrapper">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <h2><i class="fas fa-cogs"></i> Bảng điều khiển</h2>
            </div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/AccountServlet">
                    <i class="fas fa-users"></i> Quản lý tài khoản
                </a></li>
                <li><a href="${pageContext.request.contextPath}/ProductServlet">
                    <i class="fas fa-box"></i> Quản lý sản phẩm
                </a></li>
                <li><a href="${pageContext.request.contextPath}/OptionServlet">
                    <i class="fas fa-tags"></i> Loại sản phẩm
                </a></li>
                <li><a href="${pageContext.request.contextPath}/Admin/manage4.jsp">
                    <i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
                </a></li>
                <li><a href="${pageContext.request.contextPath}/HomeProductServlet">
                    <i class="fas fa-store"></i> Xem cửa hàng
                </a></li>
                <li><a href="${pageContext.request.contextPath}/DashboardServlet" class="active">
                    <i class="fas fa-chart-bar"></i> Thống kê
                </a></li>
            </ul>
        </div>
        
        <!-- Main Content -->
        <main class="dashboard-content">
            <div class="content-header">
                <h1><i class="fas fa-chart-line"></i> Thống kê toàn diện</h1>
                <p>Tổng quan hoạt động và hiệu suất cửa hàng</p>
            </div>

            <!-- Thống kê tổng quan -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-icon users">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= stats.get("totalUsers") %></h3>
                        <p>Tổng người dùng</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon products">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= stats.get("totalProducts") %></h3>
                        <p>Sản phẩm</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orders">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= stats.get("totalOrders") %></h3>
                        <p>Đơn hàng</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon revenue">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= String.format("%,.0f", stats.get("totalRevenue")) %>₫</h3>
                        <p>Doanh thu</p>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ và thống kê chi tiết -->
            <div class="charts-container">
                <!-- Doanh thu theo thời gian -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3><i class="fas fa-chart-line"></i> Doanh thu theo thời gian</h3>
                        <div class="period-selector">
                            <button class="period-btn <%= "week".equals(selectedPeriod) ? "active" : "" %>" data-period="week">Tuần</button>
                            <button class="period-btn <%= "month".equals(selectedPeriod) ? "active" : "" %>" data-period="month">Tháng</button>
                            <button class="period-btn <%= "year".equals(selectedPeriod) ? "active" : "" %>" data-period="year">Năm</button>
                        </div>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- Trạng thái đơn hàng -->
                <div class="chart-card">
                    <h3><i class="fas fa-shopping-bag"></i> Trạng thái đơn hàng</h3>
                    <div class="chart-wrapper center-chart">
                        <canvas id="orderStatusChart"></canvas>
                    </div>
                </div>

                <!-- Tồn kho sản phẩm -->
                <div class="chart-card">
                    <h3><i class="fas fa-boxes"></i> Tồn kho sản phẩm</h3>
                    <div class="chart-wrapper scrollable-chart">
                        <canvas id="inventoryChart"></canvas>
                    </div>
                </div>

                <!-- Đánh giá -->
                <div class="chart-card">
                    <h3><i class="fas fa-star"></i> Phân phối đánh giá</h3>
                    <div class="chart-wrapper">
                        <canvas id="ratingChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Bảng sản phẩm bán chạy -->
            <div class="table-container">
                <div class="table-header">
                    <h3><i class="fas fa-trophy"></i> Top sản phẩm bán chạy</h3>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 60px;">Top</th>
                            <th>Sản phẩm</th>
                            <th style="width: 100px;">Đã bán</th>
                            <th style="width: 120px;">Doanh thu</th>
                            <th style="width: 100px;">Đánh giá</th>
                            <th style="width: 80px;">Số đánh giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String, Object>> topProducts = (List<Map<String, Object>>) stats.get("topProducts");
                            if (topProducts != null && !topProducts.isEmpty()) {
                                int rank = 1;
                                for (Map<String, Object> product : topProducts) {
                                    double avgRating = (Double) product.get("avg_rating");
                                    int reviewCount = (Integer) product.get("review_count");
                        %>
                        <tr>
                            <td style="text-align: center; font-weight: bold;">
                                <% if (rank == 1) { %>
                                    <span style="color: #FFD700; font-size: 28px;">🥇</span>
                                <% } else if (rank == 2) { %>
                                    <span style="color: #C0C0C0; font-size: 28px;">🥈</span>
                                <% } else if (rank == 3) { %>
                                    <span style="color: #CD7F32; font-size: 28px;">🥉</span>
                                <% } else { %>
                                    #<%= rank %>
                                <% } %>
                            </td>
                            <td><%= product.get("name") %></td>
                            <td style="text-align: center;"><%= product.get("sold") %> sản phẩm</td>
                            <td style="text-align: right; font-weight: bold;"><%= String.format("%,.0f", product.get("revenue")) %>₫</td>
                            <td style="text-align: center;">
                                <% if (avgRating > 0) { %>
                                    <span style="color: #FFD700; font-weight: bold;">
                                        <%= String.format("%.1f", avgRating) %>
                                        <i class="fas fa-star" style="color: #FFD700;"></i>
                                    </span>
                                <% } else { %>
                                    <span style="color: #999;">Chưa có</span>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <% if (reviewCount > 0) { %>
                                    <span style="font-weight: bold;"><%= reviewCount %></span>
                                <% } else { %>
                                    <span style="color: #999;">0</span>
                                <% } %>
                            </td>
                        </tr>
                        <% 
                                rank++;
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center;">Không có dữ liệu</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Thống kê tổng quan -->
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-value"><%= ((Map<String, Object>) stats.get("customerStats")).get("totalCustomers") %></div>
                    <div class="stat-label">Tổng khách hàng</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><%= stats.get("totalQuantity") %></div>
                    <div class="stat-label">Tổng số lượng sản phẩm</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><%= String.format("%.1f", ((Map<String, Object>) stats.get("ratingStats")).get("averageRating")) %></div>
                    <div class="stat-label">Điểm đánh giá TB</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><%= ((Map<String, Object>) stats.get("ratingStats")).get("totalReviews") %></div>
                    <div class="stat-label">Tổng đánh giá</div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Dữ liệu từ server
        const monthlyRevenue = <%= new com.google.gson.Gson().toJson(monthlyRevenue) %>;
        const orderStatus = <%= new com.google.gson.Gson().toJson(stats.get("orderStatus")) %>;
        const inventoryData = <%= new com.google.gson.Gson().toJson(stats.get("inventoryStats")) %>;
        const ratingDistribution = <%= new com.google.gson.Gson().toJson(((Map<String, Object>) stats.get("ratingStats")).get("ratingDistribution")) %>;
        const selectedPeriod = '<%= selectedPeriod %>';

        // Biểu đồ doanh thu theo thời gian
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: Object.keys(monthlyRevenue),
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: Object.values(monthlyRevenue),
                    borderColor: '#ff2e63',
                    backgroundColor: 'rgba(255, 47, 99, 0.1)',
                    tension: 0.4,
                    fill: true,
                    borderWidth: 3
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + '₫';
                            }
                        }
                    }
                }
            }
        });

        // Biểu đồ trạng thái đơn hàng
        const orderStatusCtx = document.getElementById('orderStatusChart').getContext('2d');
        new Chart(orderStatusCtx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(orderStatus),
                datasets: [{
                    data: Object.values(orderStatus),
                    backgroundColor: [
                        '#2196F3', '#4CAF50', '#ff2e63', '#FF9800', '#9C27B0', '#607D8B'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Biểu đồ tồn kho sản phẩm - Có thể cuộn được
        const inventoryCtx = document.getElementById('inventoryChart').getContext('2d');
        new Chart(inventoryCtx, {
            type: 'bar',
            data: {
                labels: Object.keys(inventoryData),
                datasets: [{
                    label: 'Số lượng tồn kho',
                    data: Object.values(inventoryData),
                    backgroundColor: '#4CAF50',
                    borderColor: '#45a049',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Số lượng'
                        }
                    },
                    x: {
                        ticks: {
                            autoSkip: false,
                            maxRotation: 45,
                            minRotation: 45
                        }
                    }
                }
            }
        });

        // Biểu đồ đánh giá chi tiết
        const ratingCtx = document.getElementById('ratingChart').getContext('2d');
        const ratingLabels = ['★★★★★ (5)', '★★★★☆ (4)', '★★★☆☆ (3)', '★★☆☆☆ (2)', '★☆☆☆☆ (1)'];
        const ratingData = [];
        const ratingColors = ['#FFD700', '#FFEC8B', '#FFA500', '#FF8C00', '#FF4500'];
        
        for (let i = 5; i >= 1; i--) {
            ratingData.push(ratingDistribution[i] || 0);
        }
        
        new Chart(ratingCtx, {
            type: 'bar',
            data: {
                labels: ratingLabels,
                datasets: [{
                    label: 'Số lượng đánh giá',
                    data: ratingData,
                    backgroundColor: ratingColors,
                    borderColor: ratingColors.map(color => color.replace('0.8', '1')),
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                indexAxis: 'y',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `${context.parsed.x} đánh giá`;
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Số lượng đánh giá'
                        }
                    }
                }
            }
        });

        // Chuyển đổi thời gian xem doanh thu
        document.querySelectorAll('.period-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const period = this.dataset.period;
                window.location.href = '${pageContext.request.contextPath}/DashboardServlet?period=' + period;
            });
        });

        // Toggle user info popup
        function toggleUserInfo() {
            const popup = document.getElementById('userInfoPopup');
            popup.style.display = popup.style.display === 'block' ? 'none' : 'block';
        }

        // Đóng popup khi click bên ngoài
        window.onclick = function(event) {
            if (!event.target.matches('.user-avatar, .user-avatar *')) {
                document.getElementById('userInfoPopup').style.display = 'none';
            }
        }
    </script>
</body>
</html>