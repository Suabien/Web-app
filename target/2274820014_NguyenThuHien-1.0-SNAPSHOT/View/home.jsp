<%-- 
    Document   : home
    Created on : Feb 28, 2025, 11:50:30 PM
    Author     : Gigabyte
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.HomeProduct"%>
<%@page import="java.util.ArrayList"%>
<%
    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");

    // Nếu session chưa có thì đọc từ Cookie
    if (fullName == null || imagePath == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("fullName".equals(cookie.getName())) {
                    fullName = cookie.getValue();
                    session.setAttribute("fullName", fullName); // Gán lại vào session
                }
                if ("imagePath".equals(cookie.getName())) {
                    imagePath = cookie.getValue();
                    session.setAttribute("imagePath", imagePath); // Gán lại vào session
                }
            }
        }
    }
    
    // Lấy tham số phân trang từ request
    String pageParam = request.getParameter("page");
    String categoryParam = request.getParameter("category");
    
    // Thiết lập phân trang mặc định
    int currentPage = 1;
    int productsPerPage = 6;
    
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/home.css">
<!DOCTYPE html>
<html>
<body>
<header>
    <div class="logo">
        <a href="/2274820014_NguyenThuHienn/HomeProductServlet"><img src="/2274820014_NguyenThuHienn/Images/logo.png" alt="Logo"></a>
        <h1><a href="/2274820014_NguyenThuHienn/HomeProductServlet">Fluffy Bear</a></h1>
    </div>
    
    <nav>
        <ul>
            <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet"><h3>Trang chủ</h3></a></li>
            <li><a href="/2274820014_NguyenThuHienn/View/about.jsp"><h3>Giới thiệu</h3></a></li>
            <li><a href="#contact"><h3>Liên hệ</h3></a></li>
        </ul>
    </nav>
    
    <div class="header-right">
        <form class="search-bar" action="/2274820014_NguyenThuHienn/SearchServlet" method="post">
            <input type="text" name="searchTerm" placeholder="Nhập sản phẩm cần tìm kiếm..." />
            <button type="submit" class="search-icon-btn">
                <img src="/2274820014_NguyenThuHienn/Images/search.png" alt="search" class="search-icon" />
            </button>
        </form>
        
        <!-- Nút avatar người dùng -->
        <div class="user-avatar-container">
            <div class="user-avatar" onclick="toggleUserInfo()">
                <!-- Ảnh người dùng -->
                <img class="user-img" id="avatar-img" src="<%= imagePath != null ? imagePath : "/2274820014_NguyenThuHienn/Images/default-avatar.jpg" %>" alt="Ảnh đại diện">
            </div>

            <!-- Popup thông tin người dùng -->
            <div class="user-info-popup" id="userInfoPopup" style="<% if ("staff".equals(userRole) || "Nhà cung cấp".equals(userRole)) { %> left: -205px; <% } %>">
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
                            <a href="#" class="user-info-link">
                                <i class="fas fa-user-gear"></i>
                                Quản lý hệ thống
                            </a>
                        </li>
                        <% } %>
                        <!-- CHỈ HIỂN THỊ KHI LÀ NGƯỜI BÁN -->
                        <% if ("staff".equals(userRole)) { %>
                        <li class="user-info-item">
                            <a href="#" class="user-info-link">
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
        
        <!-- Giỏ hàng -->
        <% if (!"staff".equals(userRole) && !"Nhà cung cấp".equals(userRole)) { %>
        <div class="cart-container">
            <a href="/2274820014_NguyenThuHienn/View/giohang.jsp">
                <img src="/2274820014_NguyenThuHienn/Images/shopping-cart.png" alt="Cart" class="cart-icon" />
                <span class="cart-count">0</span>
            </a>
        </div>
        <% } %>
    </div>
</header>
    
    <main>
        <!-- Banner Slideshow -->
        <div class="slideshow-container">
            <div class="slide fade">
                <img src="/2274820014_NguyenThuHienn/Images/slide1.png" alt="Trang sức cao cấp Fluffy Bear">
            </div>
            <div class="slide fade">
                <img src="/2274820014_NguyenThuHienn/Images/slide2.webp" alt="Bộ sưu tập mới nhất">
            </div>
            <div class="slide fade">
                <img src="/2274820014_NguyenThuHienn/Images/slide3.jpg" alt="Khuyến mãi đặc biệt">
            </div>
            <div class="slide fade">
                <img src="/2274820014_NguyenThuHienn/Images/slide4.jpg" alt="Quà tặng ý nghĩa">
            </div>
            <div class="slide fade">
                <img src="/2274820014_NguyenThuHienn/Images/slide5.jpg" alt="Trang sức phong thủy">
            </div>
            
            <!-- Nút chuyển ảnh -->
            <a class="prev" onclick="changeSlide(-1)">❮</a>
            <a class="next" onclick="changeSlide(1)">❯</a>
            
            <!-- Dots indicator -->
            <div class="dots-container">
                <span class="dot" onclick="currentSlide(1)"></span>
                <span class="dot" onclick="currentSlide(2)"></span>
                <span class="dot" onclick="currentSlide(3)"></span>
                <span class="dot" onclick="currentSlide(4)"></span>
                <span class="dot" onclick="currentSlide(5)"></span>
            </div>
        </div>
        
        <!-- Featured Categories -->
        <section class="featured-categories">
            <div class="container">
                <h2 class="section-title">Danh Mục Nổi Bật</h2>
                <div class="categories-grid">
                    <div class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-gem"></i>
                        </div>
                        <h3>Trang Sức Cao Cấp</h3>
                        <p>Những món trang sức tinh xảo và sang trọng</p>
                    </div>
                    <div class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-crown"></i>
                        </div>
                        <h3>Trang Sức Thời Trang</h3>
                        <p>Xu hướng mới nhất cho phong cách hiện đại</p>
                    </div>
                    <div class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-yin-yang"></i>
                        </div>
                        <h3>Trang Sức Phong Thủy</h3>
                        <p>Mang lại may mắn và bình an</p>
                    </div>
                    <div class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <h3>Trang Sức Cá Nhân Hóa</h3>
                        <p>Khắc tên, ngày đặc biệt theo yêu cầu</p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Main Content -->
        <div class="container">
            <div class="content-wrapper">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="sidebar-header">
                        <img src="/2274820014_NguyenThuHienn/Images/icon-sidebar.png" alt="Danh mục sản phẩm">
                        <h2>Danh Mục Sản Phẩm</h2>
                    </div>
                    <ul class="category-list">
                        <li><a href="#type-1"><i class="fas fa-gem"></i> Trang sức cao cấp</a></li>
                        <li><a href="#type-2"><i class="fas fa-crown"></i> Trang sức thời trang</a></li>
                        <li><a href="#type-3"><i class="fas fa-yin-yang"></i> Trang sức phong thủy</a></li>
                        <li><a href="#type-4"><i class="fas fa-minimize"></i> Trang sức tối giản</a></li>
                        <li><a href="#type-5"><i class="fas fa-clock-rotate-left"></i> Trang sức vintage</a></li>
                        <li><a href="#type-6"><i class="fas fa-user-pen"></i> Trang sức cá nhân hóa</a></li>
                    </ul>
                    
                    <!-- Banner quảng cáo sidebar -->
                    <div class="sidebar-banner">
                        <img src="/2274820014_NguyenThuHienn/Images/banner1.jpg" alt="Khuyến mãi đặc biệt">
                        <div class="banner-content">
                            <h3>Giảm giá 20%</h3>
                            <p>Cho đơn hàng đầu tiên</p>
                            <button class="banner-btn">Mua ngay</button>
                        </div>
                    </div>
                </aside>

                <!-- Main Product Area -->
                <div class="main-content">
                    <!-- Filter Bar -->
                    <div class="filter-section">
                        <div class="filter-bar">
                            <div class="filter-group">
                                <span class="filter-label">Sắp xếp theo:</span>
                                <button class="filter-btn active">Phổ biến</button>
                                <button class="filter-btn">Bán chạy</button>
                                <button class="filter-btn">Mới nhất</button>
                            </div>
                            <div class="filter-group">
                                <select class="filter-select">
                                    <option value="">Giá: Mặc định</option>
                                    <option value="low">Giá: Thấp đến Cao</option>
                                    <option value="high">Giá: Cao đến Thấp</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Products by Category -->
                    <%
                        List<HomeProduct> products = (List<HomeProduct>) request.getAttribute("products");

                        int[] typeIds = {1,2,3,4,5,6};
                        String[] typeNames = {
                            "Trang sức cao cấp", 
                            "Trang sức thời trang", 
                            "Trang sức phong thuỷ",
                            "Trang sức tối giản (Minimalist)",
                            "Trang sức vintage/retro",
                            "Trang sức cá nhân hoá (Khắc tên, Ngày đặc biệt)"
                        };
                        String[] typeIcons = {
                            "fas fa-gem",
                            "fas fa-crown", 
                            "fas fa-yin-yang",
                            "fas fa-minimize",
                            "fas fa-clock-rotate-left",
                            "fas fa-user-pen"
                        };

                        for (int i = 0; i < typeIds.length; i++) {
                            // Lọc sản phẩm theo danh mục
                            List<HomeProduct> categoryProducts = new ArrayList<>();
                            if (products != null) {
                                for (HomeProduct product : products) {
                                    if (product.getType_id() == typeIds[i]) {
                                        categoryProducts.add(product);
                                    }
                                }
                            }
                            
                            // Tính toán phân trang cho danh mục này
                            int categoryCurrentPage = currentPage;
                            if (categoryParam != null && categoryParam.equals("type-" + typeIds[i])) {
                                categoryCurrentPage = currentPage;
                            } else if (categoryParam == null && i == 0) {
                                categoryCurrentPage = currentPage;
                            } else {
                                categoryCurrentPage = 1; // Mặc định trang 1 cho các danh mục khác
                            }
                            
                            int categoryTotalProducts = categoryProducts.size();
                            int categoryTotalPages = (int) Math.ceil((double) categoryTotalProducts / productsPerPage);
                            int categoryStartIndex = (categoryCurrentPage - 1) * productsPerPage;
                            int categoryEndIndex = Math.min(categoryStartIndex + productsPerPage, categoryTotalProducts);
                            
                            // Lấy sản phẩm cho trang hiện tại
                            List<HomeProduct> currentPageProducts = categoryProducts.subList(
                                categoryStartIndex, 
                                categoryEndIndex
                            );
                    %>
                    <section class="product-section" id="type-<%= typeIds[i] %>">
                        <div class="section-header">
                            <div class="section-title-wrapper">
                                <i class="<%= typeIcons[i] %>"></i>
                                <h2 class="section-title"><%= typeNames[i] %></h2>
                            </div>
                            <div class="pagination-info">
                                <span class="page-info">Trang <%= categoryCurrentPage %> / <%= categoryTotalPages %></span>
                            </div>
                        </div>
                        
                        <div class="product-grid">
                            <%
                                if (!currentPageProducts.isEmpty()) {
                                    for (HomeProduct product : currentPageProducts) {
                            %>
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="<%= product.getImage_url() %>" alt="<%= product.getName() %>">
                                    <div class="product-overlay">
                                        <button class="quick-view" data-id="<%= product.getId() %>">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="add-to-cart" data-id="<%= product.getId() %>">
                                            <i class="fas fa-shopping-cart"></i>
                                        </button>
                                    </div>
                                    <div class="product-badge">
                                        <span class="badge hot">Hot</span>
                                    </div>
                                </div>
                                <div class="product-info">
                                    <h3 class="product-name"><%= product.getName() %></h3>
                                    <div class="product-price">
                                        <span class="current-price"><%= product.getPrice() %>đ</span>
                                        <span class="original-price">15.500.000đ</span>
                                    </div>
                                    <div class="product-meta">
                                        <div class="rating">
                                            <i class="fas fa-star"></i>
                                            <span><%= product.getRating() %></span>
                                        </div>
                                        <div class="sold">
                                            Đã bán <%= product.getSold() %>
                                        </div>
                                    </div>
                                </div>
                                <a href="ProductDetailServlet?id=<%= product.getId() %>" class="product-link"></a>
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <div class="no-products">
                                <i class="fas fa-box-open"></i>
                                <p>Không có sản phẩm nào trong danh mục này</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                        
                        <!-- Pagination Controls -->
                        <% if (categoryTotalPages > 1) { %>
                        <div class="pagination-container">
                            <div class="pagination">
                                <% if (categoryCurrentPage > 1) { %>
                                <a href="?page=<%= categoryCurrentPage - 1 %>&category=type-<%= typeIds[i] %>#type-<%= typeIds[i] %>" class="page-link prev">
                                    <i class="fas fa-chevron-left"></i> Trang trước
                                </a>
                                <% } %>
                                
                                <div class="page-numbers">
                                    <% 
                                        int startPage = Math.max(1, categoryCurrentPage - 2);
                                        int endPage = Math.min(categoryTotalPages, categoryCurrentPage + 2);
                                        
                                        for (int p = startPage; p <= endPage; p++) {
                                            if (p == categoryCurrentPage) {
                                    %>
                                    <span class="page-number active"><%= p %></span>
                                    <% } else { %>
                                    <a href="?page=<%= p %>&category=type-<%= typeIds[i] %>#type-<%= typeIds[i] %>" class="page-number"><%= p %></a>
                                    <% } %>
                                    <% } %>
                                </div>
                                
                                <% if (categoryCurrentPage < categoryTotalPages) { %>
                                <a href="?page=<%= categoryCurrentPage + 1 %>&category=type-<%= typeIds[i] %>#type-<%= typeIds[i] %>" class="page-link next">
                                    Trang sau <i class="fas fa-chevron-right"></i>
                                </a>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </section>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        
        <!-- Special Offers Banner -->
        <section class="special-offers">
            <div class="container">
                <div class="offer-banner">
                    <div class="offer-content">
                        <h2>Ưu Đãi Đặc Biệt</h2>
                        <p>Giảm giá lên đến 20% cho các ngày lễ đặc biệt</p>
                        <button class="offer-btn">Mua ngay</button>
                    </div>
                    <div class="offer-image">
                        <img src="/2274820014_NguyenThuHienn/Images/sanpham4.webp" alt="Ưu đãi đặc biệt">
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Newsletter Section -->
        <section class="newsletter-section">
            <div class="container">
                <div class="newsletter-content">
                    <h2>Đăng Ký Nhận Tin</h2>
                    <p>Nhận thông tin khuyến mãi và sản phẩm mới nhất từ Fluffy Bear</p>
                    <form class="newsletter-form">
                        <input type="email" placeholder="Nhập email của bạn" required>
                        <button type="submit">Đăng ký <i class="fas fa-paper-plane"></i></button>
                    </form>
                </div>
            </div>
        </section>
        
        <!-- Scroll to Top Button -->
        <button id="scrollToTop" class="scroll-top">
            <i class="fas fa-chevron-up"></i>
        </button>
    </main>

<footer class="footer" id="contact">    
    <div class="footer-content">
        <div class="footer-column">
            <div class="footer-logo">
                <img src="/2274820014_NguyenThuHienn/Images/logo.png" alt="Fluffy Bear Logo">
                <h2>Fluffy Bear</h2>
            </div>
            <p class="footer-slogan">Mang đến những món trang sức chất lượng với tình yêu và sự tận tâm</p>
            <div class="footer-social">
                <a href="https://www.facebook.com/" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                <a href="https://www.instagram.com/" class="social-icon"><i class="fab fa-instagram"></i></a>
                <a href="https://www.tiktok.com/vi-VN/" class="social-icon"><i class="fab fa-tiktok"></i></a>
                <a href="https://www.youtube.com/" class="social-icon"><i class="fab fa-youtube"></i></a>
            </div>
        </div>
        
        <div class="footer-column">
            <h3 class="footer-title">Liên kết nhanh</h3>
            <ul class="footer-links">
                <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet">Trang chủ</a></li>
                <li><a href="/2274820014_NguyenThuHienn/View/about.jsp">Giới thiệu</a></li>
                <li><a href="#type-1">Sản phẩm</a></li>
                <li><a href="/2274820014_NguyenThuHienn/View/giohang.jsp">Giỏ hàng</a></li>
            </ul>
        </div>
        
        <div class="footer-column">
            <h3 class="footer-title">Thông tin liên hệ</h3>
            <ul class="footer-contact">
                <li><i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận XYZ, TP.Hà Nội</li>
                <li><i class="fas fa-phone"></i> 0123 456 789</li>
                <li><i class="fas fa-envelope"></i> support@fluffybear.com</li>
                <li><i class="fas fa-clock"></i> Mở cửa: 8:00 - 21:00 hàng ngày</li>
            </ul>
        </div>
        
        <div class="footer-column">
            <h3 class="footer-title">Đăng ký nhận tin</h3>
            <p class="footer-newsletter">Nhận thông tin khuyến mãi và sản phẩm mới nhất</p>
            <form class="newsletter-form">
                <input type="email" placeholder="Nhập email của bạn" required>
                <button type="submit"><i class="fas fa-paper-plane"></i></button>
            </form>
        </div>
    </div>
    
    <div class="footer-bottom">
        <p class="footer-copyright">© 2025 Fluffy Bear. All rights reserved.</p>
    </div>
</footer>

<script src="/2274820014_NguyenThuHienn/JS/home.js"></script>
<script src="/2274820014_NguyenThuHienn/JS/cart.js" defer></script>
</body>
</html>