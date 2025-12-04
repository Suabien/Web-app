<%-- 
    Document   : sanpham
    Created on : Mar 17, 2025, 10:54:02 PM
    Author     : Gigabyte
--%>

<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Product, Model.ProductDetail, Model.Review, java.util.*, com.google.gson.Gson" %>
<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
    response.sendRedirect("index.jsp");
    return;
}
%>
<%
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("fullName".equals(cookie.getName())) {
                session.setAttribute("fullName", java.net.URLDecoder.decode(cookie.getValue(), "UTF-8"));
            }
            if ("imagePath".equals(cookie.getName())) {
                session.setAttribute("imagePath", java.net.URLDecoder.decode(cookie.getValue(), "UTF-8"));
            }
        }
    }

    String fullName = (String) session.getAttribute("fullName");
    String imagePath = (String) session.getAttribute("imagePath");
    String userRole = (String) session.getAttribute("role");
%>

<link rel="stylesheet" href="/2274820014_NguyenThuHienn/CSS/product.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${product.name}</title>
    </head>
<body>
    <%
        Product product = (Product) request.getAttribute("product");
        List<ProductDetail> optionList = (List<ProductDetail>) request.getAttribute("optionList");
        List<String> optionNames = (List<String>) request.getAttribute("optionNames");
        List<String> optionImages = (List<String>) request.getAttribute("optionImages");

        String mainImage = (product != null && product.getImage_url() != null) ? product.getImage_url() : "/2274820014_NguyenThuHienn/Images/sanpham1.jpg";
        String productName = (product != null) ? product.getName() : "Tên sản phẩm";
        String rating = (product != null) ? String.valueOf(product.getRating()) : "0.0";
        int sold = (product != null) ? product.getSold() : 0;
        String description = (product != null) ? product.getDescription() : "";
        int stock = (product != null) ? product.getQuantity() : 100;
    %>
    <%
        Map<String, String> optionPriceMap = new HashMap<>();
        Map<String, String> optionImageMap = new HashMap<>();
        if (optionNames != null && optionList != null && optionImages != null) {
            for (int i = 0; i < optionNames.size(); i++) {
                String name = optionNames.get(i);
                String price = optionList.get(i).getPrice();
                String img = optionImages.get(i);
                optionPriceMap.put(name, price);
                optionImageMap.put(name, img);
            }
        }
        Gson gson = new Gson();
        String pricesJson = gson.toJson(optionPriceMap);
        String imagesJson = gson.toJson(optionImageMap);
    %>
    <div class="header-cart">
        <div class="logo">
            <a href="/2274820014_NguyenThuHienn/HomeProductServlet"><img src="/2274820014_NguyenThuHienn/Images/logo.png" alt="Logo"></a>
            <h1><a href="/2274820014_NguyenThuHienn/HomeProductServlet">Fluffy Bear</a></h1>
        </div>

        <nav>
            <ul>
                <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet"><h3>Trang chủ</h3></a></li>
                <li><a href="/2274820014_NguyenThuHienn/View/about.jsp"><h3>Giới thiệu</h3></a></li>
                <li><a href="/2274820014_NguyenThuHienn/HomeProductServlet#contact"><h3>Liên hệ</h3></a></li>
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
    </div>
    
    <div class="product-container">
        <div class="product-gallery">
            <div class="main-image">
                <img src="<%= mainImage %>" alt="anh1">
            </div>
            <div class="thumbnail-container">
                <% if (optionImages != null && !optionImages.isEmpty()) {
                    for (String img : optionImages) { %>
                        <div class="thumbnail"><img src="<%= img %>" alt="option"></div>
                <% } } else { %>
                        Không có ảnh mẫu sản phẩm
                <% } %>
            </div>
        </div>
        <div class="product-details" data-options="${optionsStr}">
            <h1>${product.name}</h1>
            <input type="hidden" id="product-image" value="${product.image_url}" />
            <div class="rating">${product.rating} ⭐ | ${product.rate_count} Đánh giá | ${product.sold} Đã bán</div>
            <% if (optionList != null && !optionList.isEmpty()) { %>
                <div class="price"
                    data-base-price="<%= optionList.get(0).getPrice() %>"
                    data-option-prices='<%= gson.toJson(optionPriceMap) %>'>
                    <%= optionList.get(0).getPrice() %>đ
                </div>
            <% } else { %>
                <div class="price">Không có tuỳ chọn sản phẩm.</div>
            <% } %>
            <div class="product-shipping">
                <h2>Vận chuyển:</h2>
                <p>
                    🚚 Nhận hàng trong vòng 7 - 10 ngày, phí giao ₫0 <br>
                    ✅ Trả hàng miễn phí 15 ngày • Bảo hiểm bảo vệ người tiêu dùng
                </p>
            </div>
            <div class="product-return"></div>
            <div class="product-options">
                <% if (optionNames != null && !optionNames.isEmpty()) {
                    for (int i = 0; i < optionNames.size(); i++) {
                        String name = optionNames.get(i);
                %>
                    <button
                      class="option-btn <%= (i == 0 ? "active" : "") %>"
                      data-option-name="<%= name %>"
                    ><%= name %></button>
                <%  }
                } else { %>
                    Không có mẫu sản phẩm nào
                <% } %>
            </div>
            <div class="product-quantity">
                <h2>Số lượng:</h2>
                <button class="qty-btn minus">-</button>
                <input type="number" value="1" min="1" max="100">
                <button class="qty-btn plus">+</button>
                <span class="stock"><%= stock %> sản phẩm có sẵn</span>
            </div>
            <button class="cart-btn">🛒 Thêm vào giỏ hàng</button>
            <button class="buy-btn">Mua ngay</button>
            
            <!-- Modal Mua ngay -->
            <div id="buyModal" class="modal">
              <div class="modal-content">
                <div class="modal-header">
                  <h2 class="modal-title">Thông tin mua hàng</h2>
                  <span class="modal-close">&times;</span>
                </div>

                <div class="modal-body">
                  <form id="buyForm">
                    <input type="hidden" id="userId" value="<%= userId %>" />
                    <input type="hidden" id="productId" value="${product.id}" />
                    <input type="hidden" name="price" id="productPrice" 
                           value="<%= optionList.isEmpty() ? 0 : optionList.get(0).getPrice() %>">
                    <input type="hidden" name="option_name" id="optionNameField"
                           value="<%= (optionNames != null && !optionNames.isEmpty()) 
                           ? optionNames.get(0) : "" %>">

                    <div class="form-section">
                      <h3 class="form-section-title">Thông tin giao hàng</h3>

                      <div class="form-group">
                        <label class="form-label" for="customerName">Họ và tên:</label>
                        <input class="form-input" type="text" id="customerName" name="customerName" placeholder="Nhập họ và tên đầy đủ" required>
                      </div>

                      <div class="form-group">
                        <label class="form-label" for="address">Địa chỉ:</label>
                        <input class="form-input" type="text" id="address" name="address" placeholder="Nhập địa chỉ nhận hàng" required>
                      </div>

                      <div class="form-group">
                        <label class="form-label" for="phone">Số điện thoại:</label>
                        <input class="form-input" type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại liên hệ" required>
                      </div>
                    </div>

                    <div class="form-section">
                      <h3 class="form-section-title">Thông tin thanh toán</h3>

                      <div class="payment-info">
                        <div class="payment-item">
                          <span>Sản phẩm:</span>
                          <span id="modalProductName">${product.name}</span>
                        </div>
                        <div class="payment-item">
                          <span>Số lượng:</span>
                          <span id="modalQuantity">1</span>
                        </div>
                        <div class="payment-item">
                          <span>Ngày đặt:</span>
                          <span id="modalDate"></span>
                        </div>

                        <div class="payment-method-group">
                          <label class="form-label" for="paymentMethod">Phương thức thanh toán:</label>
                          <select class="form-input" id="paymentMethod" name="paymentMethod">
                            <option value="COD">COD (Thanh toán khi nhận hàng)</option>
                            <option value="Bank">Chuyển khoản ngân hàng</option>
                          </select>
                        </div>

                        <!-- QR Code Container -->
                        <div class="qr-container" id="qrContainer">
                          <img src="/2274820014_NguyenThuHienn/Images/qr-code.jpg" alt="QR Code thanh toán" class="qr-code">
                          <p class="qr-note">Quét mã QR để thanh toán qua ngân hàng</p>
                        </div>

                        <div class="payment-item">
                          <span>Phí ship:</span>
                          <span id="modalShipFee">30.000₫</span>
                        </div>
                        <div class="payment-item">
                          <span>Giảm giá:</span>
                          <span id="modalDiscount">0₫</span>
                        </div>
                        <div class="payment-total">
                          <span>Thành tiền:</span>
                          <span id="modalTotalPrice"></span>
                        </div>
                      </div>
                    </div>
                  </form>
                </div>

                <div class="modal-footer">
                  <button type="submit" form="buyForm" class="btn-primary">Đặt hàng</button>
                  <button type="button" class="btn-secondary cancel-btn">Hủy</button>
                </div>
              </div>
            </div>
        </div>
    </div>
            
    <div class="product-extra" data-product-id="${product.id}">
        <!-- Mô tả sản phẩm -->
        <div class="product-description-box">
          <h2>Mô tả sản phẩm:</h2>
          <p><%= description %></p>
        </div>

        <!-- Đánh giá & Bình luận -->
        <div class="product-review-box">
          <div class="review-header">
            <h2>Đánh giá:</h2>
            <div class="stars">
              <span class="star" data-value="1">&#9734;</span>
              <span class="star" data-value="2">&#9734;</span>
              <span class="star" data-value="3">&#9734;</span>
              <span class="star" data-value="4">&#9734;</span>
              <span class="star" data-value="5">&#9734;</span>
            </div>
            <% if (product != null) { %>
            <span class="rating-count">/ Lượt đánh giá: <%= product.getRate_count() %></span>
            <% } else { %>
              <span class="rating-count">Không tìm thấy sản phẩm</span>
            <% } %>
          </div>
          <div class="comment-section">
            <label for="comment">Bình luận:</label>
            <textarea id="comment" name="comment" placeholder="Viết bình luận..." rows="2"></textarea>
          </div>
          <button id="submit-review">Gửi đánh giá</button>
        </div>
        
        <div class="review-section">
            <h3>Đánh giá của khách hàng</h3>

            <%
                Object reviewListObj = request.getAttribute("reviewList");
                if (reviewListObj instanceof List) {
                    List<Review> reviewList = (List<Review>) reviewListObj;
                    if (reviewList != null && !reviewList.isEmpty()) {
            %>
                <div class="review-list">
                    <%
                        for (Review review : reviewList) {
                            String displayName = review.getUsername() != null ? 
                                              review.getUsername() : "Khách hàng khác";
                            String reviewText = review.getReview_text() != null ? 
                                             review.getReview_text() : "";
                            int roundedRating = review.getRoundedRating();
                            String createdDate = review.getCreated_at() != null ? 
                                              review.getCreated_at().toString() : "";

                            // Kiểm tra xem review có thuộc về user hiện tại không
                            boolean isCurrentUserReview = false;
                            Integer currentUserId = (Integer) session.getAttribute("userId");
                            if (currentUserId != null && currentUserId.equals(review.getUserId())) {
                                isCurrentUserReview = true;
                            }
                    %>
                        <div class="review-item" data-review-id="<%= review.getId() %>">
                            <div class="review-header2">
                                <div class="review-info">
                                    <span class="review-name"><%= displayName %></span>
                                    <div class="stars1">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <%= i <= roundedRating ? "★" : "☆" %>
                                        <% } %>
                                    </div>
                                </div>
                                <% if (isCurrentUserReview) { %>
                                    <div class="review-actions">
                                        <i class="fas fa-edit icon-effect edit-btn" data-review-id="<%= review.getId() %>"></i>
                                        <i class="fas fa-trash-alt icon-effect delete-btn" data-review-id="<%= review.getId() %>"></i>
                                    </div>
                                <% } %>
                            </div>
                            <p class="review-text"><%= reviewText %></p>
                            <span class="review-date">
                                <%= createdDate %>
                            </span>
                        </div>
                    <%
                        }
                    %>
                </div>
            <%
                    } else {
            %>
                <p class="no-reviews">Chưa có đánh giá nào cho sản phẩm này.</p>
            <%
                    }
                }
            %>
        </div>
    </div>
        
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
                    <li><a href="#trang-suc-cao-cap">Sản phẩm</a></li>
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
    <!-- Hết -->
    <script src="/2274820014_NguyenThuHienn/JS/javascript.js"></script>
    <script src="/2274820014_NguyenThuHienn/JS/cart.js" defer></script>
    <script src="/2274820014_NguyenThuHienn/JS/productdetail.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const options = document.querySelectorAll(".option-btn");
            const priceElement = document.querySelector(".price");
            const quantityInput = document.querySelector("input[type='number']");
            const minusBtn = document.querySelector(".qty-btn.minus");
            const plusBtn = document.querySelector(".qty-btn.plus");
            const mainImage = document.querySelector(".main-image img");
            
            const productPrices = JSON.parse('<%= pricesJson %>');
            const productImages = JSON.parse('<%= imagesJson %>');

            let currentSelected = null;
            let currentMainImage = mainImage.src;

            // Xử lý chọn mẫu và giá tiền
            options.forEach(option => {
                option.addEventListener("click", () => {
                    const selectedOption = option.textContent.trim();

                    // Kiểm tra nếu đang chọn và click lần 2 => Bỏ chọn
                    if (option.classList.contains("active")) {
                        option.classList.remove("active");
                        priceElement.textContent = "2.000.000đ - 10.000.000đ";
                        currentSelected = null;
                        <% if (product != null) { %>
                            mainImage.src = "<%= product.getImage_url() %>"; // Ảnh mặc định
                        <% } else { %>
                            Không có ảnh nào
                        <% } %>
                        currentMainImage = mainImage.src;
                    } else {
                        // Reset trạng thái các nút khác
                        options.forEach(o => o.classList.remove("active"));
                        option.classList.add("active");

                        priceElement.textContent = productPrices[selectedOption];
                        currentSelected = selectedOption;

                        // Đổi ảnh chính theo mẫu mới chọn
                        if (productImages[currentSelected]) {
                            mainImage.src = productImages[currentSelected];
                            currentMainImage = mainImage.src;
                        }
                    }
                });

                // Hover vào nút mẫu thì đổi ảnh tạm thời
                option.addEventListener("mouseover", () => {
                    const selectedOption = option.textContent.trim();
                    if (productImages[selectedOption]) {
                        mainImage.src = productImages[selectedOption];
                    }
                });

                // Rời chuột khỏi nút thì trả về ảnh cũ đang chọn
                option.addEventListener("mouseout", () => {
                    mainImage.src = currentMainImage;
                });
            });

            // Xử lý click vào thumbnail để đổi ảnh chính
            const thumbnails = document.querySelectorAll(".thumbnail img");

            thumbnails.forEach(thumbnail => {
                thumbnail.addEventListener("click", () => {
                    const newImageSrc = thumbnail.src;
                    mainImage.src = newImageSrc;
                    currentMainImage = newImageSrc; // Lưu lại ảnh chính mới
                });
            });

            // Xử lý tăng giảm số lượng
            minusBtn.addEventListener("click", () => {
                let currentValue = parseInt(quantityInput.value);
                if (currentValue > 1) quantityInput.value = currentValue - 1;
            });

            plusBtn.addEventListener("click", () => {
                let currentValue = parseInt(quantityInput.value);
                if (currentValue < 100) quantityInput.value = currentValue + 1;
            });
        });

        document.addEventListener('DOMContentLoaded', function() {
          // 1) Lấy các element
          const stars = document.querySelectorAll('.product-review-box .star');
          const commentInput = document.getElementById('comment');
          const submitBtn = document.getElementById('submit-review');
          let selectedRating = 0;

          if (!submitBtn) {
            console.error('Không tìm thấy nút #submit-review');
            return;
          }

          // 2) Hover & click cho stars
          stars.forEach(star => {
            const val = parseInt(star.dataset.value, 10);
            star.addEventListener('mouseover', () => {
              stars.forEach(s => {
                s.innerText = (parseInt(s.dataset.value, 10) <= val) ? '★' : '☆';
              });
            });
            star.addEventListener('mouseout', () => {
              stars.forEach(s => {
                s.innerText = (parseInt(s.dataset.value, 10) <= selectedRating) ? '★' : '☆';
              });
            });
            star.addEventListener('click', () => {
              selectedRating = val;
              console.log('Đã chọn rating =', selectedRating);
              stars.forEach(s => {
                s.innerText = (parseInt(s.dataset.value, 10) <= selectedRating) ? '★' : '☆';
              });
            });
          });

        // Gửi đánh giá
        document.getElementById("submit-review").addEventListener("click", () => {
          const comment = commentInput.value.trim();
          if (selectedRating === 0) {
            alert("Vui lòng chọn số sao!");
            return;
          }

          // Lấy productId từ data attribute
          const productId = document.querySelector(".product-extra").dataset.productId;

          // gọi AJAX tới ReviewServlet
          fetch('${pageContext.request.contextPath}/ReviewServlet', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: new URLSearchParams({
              action: 'add',
              rating: selectedRating,
              reviewText: comment,
              productId: productId
            })
          })
          .then(res => {
            if (!res.ok) throw new Error("Network response was not ok");
            return res.text();
          })
          .then(text => {
            if (text === 'success') {
              alert("Cảm ơn bạn đã đánh giá!");
              // làm mới trang để hiển thị review mới
              location.reload();
            } else {
              alert("Có lỗi xảy ra, vui lòng thử lại.");
            }
          })
          .catch(err => {
            console.error(err);
            alert("Không thể kết nối tới server.");
          });

          // Sau khi gọi xong, reset lại form
          selectedRating = 0;
          stars.forEach(s => s.innerText = '☆');
          commentInput.value = "";
        });
      });
    </script>
</body>
</html>