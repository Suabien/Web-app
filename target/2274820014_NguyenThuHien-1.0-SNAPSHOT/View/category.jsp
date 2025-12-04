<%-- 
    Document   : category
    Created on : Nov 10, 2025, 5:04:08 PM
    Author     : sucun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.HomeProduct"%>
<%
    String categoryName = (String) request.getAttribute("categoryName");
    String categoryId = (String) request.getAttribute("categoryId");
    List<HomeProduct> products = (List<HomeProduct>) request.getAttribute("products");
    
    if (categoryName == null) {
        categoryName = request.getParameter("categoryName");
    }
    if (categoryId == null) {
        categoryId = request.getParameter("categoryId");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= categoryName != null ? categoryName : "Danh Mục" %> - Fluffy Bear</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="/2274820014_NguyenThuHienn/CSS/home.css">
</head>
<body>
    <header>
        <!-- Same header as home.jsp -->
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
            <!-- Same search and user area as home.jsp -->
        </div>
    </header>

    <main>
        <div class="container">
            <div class="category-header">
                <h1><%= categoryName != null ? categoryName : "Danh Mục Sản Phẩm" %></h1>
                <p>Khám phá các sản phẩm tuyệt vời trong danh mục này</p>
            </div>
            
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
            
            <% if (products != null && !products.isEmpty()) { %>
            <div class="product-grid">
                <% for (HomeProduct product : products) { %>
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
                            <span class="original-price">2.500.000đ</span>
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
                <% } %>
            </div>
            <% } else { %>
            <div class="no-products">
                <div style="text-align: center; padding: 60px 20px; color: #718096;">
                    <i class="fas fa-gem" style="font-size: 4rem; margin-bottom: 20px; opacity: 0.5;"></i>
                    <h3>Không có sản phẩm nào trong danh mục này</h3>
                    <p>Vui lòng quay lại sau!</p>
                </div>
            </div>
            <% } %>
            
            <div class="back-to-home">
                <a href="/2274820014_NguyenThuHienn/HomeProductServlet" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Quay lại trang chủ
                </a>
            </div>
        </div>
    </main>

    <script src="/2274820014_NguyenThuHienn/JS/home.js"></script>
</body>
</html>
