/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Home Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Slideshow functionality
    let slideIndex = 0;
    const slides = document.getElementsByClassName("slide");
    const dots = document.getElementsByClassName("dot");
    
    if (slides.length > 0) {
        showSlides();
    }

    function showSlides() {
        if (slides.length === 0) return;

        for (let i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
            dots[i].classList.remove("active");
        }

        slideIndex++;
        if (slideIndex > slides.length) slideIndex = 1;

        slides[slideIndex - 1].style.display = "block";
        dots[slideIndex - 1].classList.add("active");

        setTimeout(showSlides, 4000);
    }

    // Chuyển slide thủ công
    window.changeSlide = function(n) {
        if (slides.length === 0) return;

        slideIndex += n;
        if (slideIndex > slides.length) slideIndex = 1;
        if (slideIndex < 1) slideIndex = slides.length;

        for (let i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
            dots[i].classList.remove("active");
        }
        slides[slideIndex - 1].style.display = "block";
        dots[slideIndex - 1].classList.add("active");
    }

    // Chuyển đến slide cụ thể
    window.currentSlide = function(n) {
        if (slides.length === 0) return;

        slideIndex = n;
        for (let i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
            dots[i].classList.remove("active");
        }
        slides[slideIndex - 1].style.display = "block";
        dots[slideIndex - 1].classList.add("active");
    }

    // ===== FILTER SELECT FUNCTIONALITY =====
    const filterSelect = document.querySelector('.filter-select');
    if (filterSelect) {
        filterSelect.addEventListener('change', function() {
            const selectedValue = this.value;
            
            // Hiệu ứng loading
            const productGrids = document.querySelectorAll('.product-grid');
            productGrids.forEach(grid => {
                grid.style.opacity = '0.6';
                grid.style.transition = 'opacity 0.3s ease';
            });

            setTimeout(() => {
                // Sắp xếp sản phẩm theo giá
                sortProducts(selectedValue);
                
                // Khôi phục opacity
                productGrids.forEach(grid => {
                    grid.style.opacity = '1';
                });
                
                showNotification(`Đã sắp xếp theo: ${this.options[this.selectedIndex].text}`);
            }, 500);
        });
    }

    // Hàm sắp xếp sản phẩm
    function sortProducts(sortType) {
        const productSections = document.querySelectorAll('.product-section');
        
        productSections.forEach(section => {
            const productGrid = section.querySelector('.product-grid');
            const products = Array.from(productGrid.querySelectorAll('.product-card'));
            
            products.sort((a, b) => {
                const priceA = getPriceValue(a);
                const priceB = getPriceValue(b);
                
                switch(sortType) {
                    case 'low':
                        return priceA - priceB;
                    case 'high':
                        return priceB - priceA;
                    default:
                        return 0; // Mặc định - giữ nguyên thứ tự
                }
            });
            
            // Xóa sản phẩm hiện tại
            while (productGrid.firstChild) {
                productGrid.removeChild(productGrid.firstChild);
            }
            
            // Thêm sản phẩm đã sắp xếp
            products.forEach(product => {
                productGrid.appendChild(product);
            });
        });
    }

    // Hàm lấy giá trị giá từ sản phẩm
    function getPriceValue(productElement) {
        const priceText = productElement.querySelector('.current-price').textContent;
        // Chuyển "1.500.000đ" thành 1500000
        return parseInt(priceText.replace(/[^\d]/g, ''));
    }

    // ===== VIEW ALL LINKS FUNCTIONALITY =====
    const viewAllLinks = document.querySelectorAll('.view-all');
    viewAllLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Lấy section cha
            const productSection = this.closest('.product-section');
            const categoryName = productSection.querySelector('.section-title').textContent;
            const categoryId = productSection.id.replace('type-', '');
            
            // Tìm tất cả sản phẩm thuộc category này
            const allProductsInCategory = Array.from(productSection.querySelectorAll('.product-card'));
            const productIds = allProductsInCategory.map(product => {
                return product.querySelector('.add-to-cart').getAttribute('data-id');
            });
            
            // Lưu vào sessionStorage để trang category có thể đọc
            sessionStorage.setItem('currentCategory', JSON.stringify({
                id: categoryId,
                name: categoryName,
                productIds: productIds
            }));
            
            // Chuyển hướng đến trang danh mục
            window.location.href = `/2274820014_NguyenThuHienn/View/category.jsp?categoryId=${categoryId}&categoryName=${encodeURIComponent(categoryName)}`;
        });
    });

    // ===== FILTER BUTTONS FUNCTIONALITY =====
    const filterButtons = document.querySelectorAll('.filter-btn');
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remove active class from all buttons
            filterButtons.forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked button
            this.classList.add('active');
            
            const filterType = this.textContent.trim();
            filterProductsByType(filterType);
        });
    });

    // Hàm lọc sản phẩm theo loại
    function filterProductsByType(filterType) {
        const productGrids = document.querySelectorAll('.product-grid');
        
        // Hiệu ứng loading
        productGrids.forEach(grid => {
            grid.style.opacity = '0.5';
        });

        setTimeout(() => {
            let hasVisibleProducts = false;
            
            productGrids.forEach(grid => {
                const products = grid.querySelectorAll('.product-card');
                let visibleInGrid = false;
                
                products.forEach(product => {
                    let shouldShow = true;
                    
                    switch(filterType) {
                        case 'Phổ biến':
                            // Hiển thị tất cả
                            shouldShow = true;
                            break;
                        case 'Bán chạy':
                            // Hiển thị sản phẩm có số lượng bán cao (giả lập)
                            const soldText = product.querySelector('.sold').textContent;
                            const soldCount = parseInt(soldText.replace(/[^\d]/g, '')) || 0;
                            shouldShow = soldCount > 30;
                            break;
                        case 'Mới nhất':
                            // Hiển thị 4 sản phẩm đầu tiên như "mới nhất" (giả lập)
                            const productIndex = Array.from(products).indexOf(product);
                            shouldShow = productIndex < 4;
                            break;
                        default:
                            shouldShow = true;
                    }
                    
                    product.style.display = shouldShow ? 'block' : 'none';
                    if (shouldShow) {
                        visibleInGrid = true;
                        hasVisibleProducts = true;
                    }
                });
                
                // Hiển thị thông báo nếu không có sản phẩm nào
                if (!visibleInGrid) {
                    const noProductsMsg = grid.querySelector('.no-products-message') || createNoProductsMessage();
                    if (!grid.querySelector('.no-products-message')) {
                        grid.appendChild(noProductsMsg);
                    }
                } else {
                    const noProductsMsg = grid.querySelector('.no-products-message');
                    if (noProductsMsg) {
                        noProductsMsg.remove();
                    }
                }
                
                grid.style.opacity = '1';
            });
            
            if (!hasVisibleProducts) {
                showNotification('Không có sản phẩm nào phù hợp với bộ lọc!', 'info');
            } else {
                showNotification(`Đã lọc theo: ${filterType}`);
            }
        }, 300);
    }

    // Tạo thông báo không có sản phẩm
    function createNoProductsMessage() {
        const message = document.createElement('div');
        message.className = 'no-products-message';
        message.innerHTML = `
            <div style="text-align: center; padding: 40px; color: #718096;">
                <i class="fas fa-search" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                <p>Không tìm thấy sản phẩm phù hợp</p>
            </div>
        `;
        return message;
    }

    // ===== CATEGORY SIDEBAR LINKS =====
    document.querySelectorAll('.category-list a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                const headerOffset = 120;
                const elementPosition = targetElement.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
                
                // Highlight category được chọn
                document.querySelectorAll('.category-list a').forEach(link => {
                    link.style.background = 'transparent';
                    link.style.color = '#4a5568';
                });
                this.style.background = 'linear-gradient(135deg, #FF99B8, #FF6B8B)';
                this.style.color = 'white';
            }
        });
    });

    // Quick view functionality
    const quickViewButtons = document.querySelectorAll('.quick-view');
    quickViewButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const productId = this.getAttribute('data-id');
            // Mở modal quick view
            openQuickViewModal(productId);
        });
    });

    // Add to cart functionality
    const addToCartButtons = document.querySelectorAll('.add-to-cart');
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const productId = this.getAttribute('data-id');
            const productName = this.closest('.product-card').querySelector('.product-name').textContent;
            const productPrice = this.closest('.product-card').querySelector('.current-price').textContent;
            const productImage = this.closest('.product-card').querySelector('.product-image img').src;
            
            // Animation effect
            this.style.transform = 'scale(1.2)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 300);
            
            // Thêm vào giỏ hàng
            addToCart(productId, productName, productPrice, productImage);
        });
    });

    // Hàm thêm vào giỏ hàng
    function addToCart(productId, productName, productPrice, productImage) {
        // Lấy giỏ hàng hiện tại từ localStorage
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        
        // Kiểm tra xem sản phẩm đã có trong giỏ chưa
        const existingItem = cart.find(item => item.id === productId);
        
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            cart.push({
                id: productId,
                name: productName,
                price: productPrice,
                image: productImage,
                quantity: 1
            });
        }
        
        // Lưu lại vào localStorage
        localStorage.setItem('cart', JSON.stringify(cart));
        
        // Cập nhật giao diện
        updateCartCount();
        showNotification('Đã thêm sản phẩm vào giỏ hàng!');
        
        // Log để debug
        console.log('Cart updated:', cart);
    }

    // Hàm cập nhật số lượng giỏ hàng
    function updateCartCount() {
        const cart = JSON.parse(localStorage.getItem('cart')) || [];
        const totalItems = cart.reduce((total, item) => total + item.quantity, 0);
        
        const cartCountElements = document.querySelectorAll('.cart-count');
        cartCountElements.forEach(element => {
            element.textContent = totalItems;
            
            // Animation
            element.style.transform = 'scale(1.3)';
            setTimeout(() => {
                element.style.transform = 'scale(1)';
            }, 300);
        });
    }

    // Khởi tạo số lượng giỏ hàng khi trang load
    updateCartCount();

    // Hàm mở modal quick view
    function openQuickViewModal(productId) {
        // Tìm sản phẩm tương ứng
        const productCard = document.querySelector(`.add-to-cart[data-id="${productId}"]`).closest('.product-card');
        const productName = productCard.querySelector('.product-name').textContent;
        const productPrice = productCard.querySelector('.current-price').textContent;
        const productImage = productCard.querySelector('.product-image img').src;
        const productRating = productCard.querySelector('.rating span').textContent;
        const productSold = productCard.querySelector('.sold').textContent;
        
        // Tạo modal quick view
        const modal = document.createElement('div');
        modal.className = 'quick-view-modal';
        modal.innerHTML = `
            <div class="modal-content">
                <span class="close-modal">&times;</span>
                <div class="modal-body">
                    <div class="product-image-modal">
                        <img src="${productImage}" alt="${productName}">
                    </div>
                    <div class="product-info-modal">
                        <h3>${productName}</h3>
                        <div class="product-price">${productPrice}</div>
                        <div class="product-meta">
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <span>${productRating}</span>
                            </div>
                            <div class="sold">${productSold}</div>
                        </div>
                        <p class="product-description">Sản phẩm chất lượng cao, thiết kế tinh xảo, phù hợp với mọi dịp.</p>
                        <div class="modal-actions">
                            <button class="btn-secondary">
                                <i class="far fa-heart"></i> Yêu thích
                            </button>
                            <button class="btn-primary add-to-cart-modal" data-id="${productId}">
                                <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Thêm styles
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            opacity: 0;
            transition: opacity 0.3s ease;
        `;
        
        document.body.appendChild(modal);
        
        // Hiệu ứng xuất hiện
        setTimeout(() => {
            modal.style.opacity = '1';
        }, 10);
        
        // Đóng modal
        modal.querySelector('.close-modal').addEventListener('click', () => {
            modal.style.opacity = '0';
            setTimeout(() => {
                if (document.body.contains(modal)) {
                    document.body.removeChild(modal);
                }
            }, 300);
        });
        
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.style.opacity = '0';
                setTimeout(() => {
                    if (document.body.contains(modal)) {
                        document.body.removeChild(modal);
                    }
                }, 300);
            }
        });
        
        // Thêm vào giỏ hàng từ modal
        modal.querySelector('.add-to-cart-modal').addEventListener('click', function() {
            addToCart(productId, productName, productPrice, productImage);
            modal.style.opacity = '0';
            setTimeout(() => {
                if (document.body.contains(modal)) {
                    document.body.removeChild(modal);
                }
            }, 300);
        });
    }

    // Notification function
    function showNotification(message, type = 'success') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas ${type === 'success' ? 'fa-check-circle' : 
                              type === 'error' ? 'fa-exclamation-circle' : 
                              'fa-info-circle'}"></i>
                <span>${message}</span>
            </div>
        `;
        
        // Add styles
        const backgroundColor = type === 'success' ? '#4CAF50' : 
                              type === 'error' ? '#f44336' : '#2196F3';
        
        notification.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            background: ${backgroundColor};
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 10000;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        `;
        
        document.body.appendChild(notification);
        
        // Show notification
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 100);
        
        // Hide after 3 seconds
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }

    // Scroll to top functionality
    const scrollToTopBtn = document.getElementById('scrollToTop');
    if (scrollToTopBtn) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 300) {
                scrollToTopBtn.classList.add('show');
            } else {
                scrollToTopBtn.classList.remove('show');
            }
        });

        scrollToTopBtn.addEventListener('click', () => {
            window.scrollTo({ 
                top: 0, 
                behavior: 'smooth' 
            });
        });
    }

    // Special offer button
    document.querySelector('.offer-btn')?.addEventListener('click', function() {
        // Scroll to first product section
        const firstSection = document.querySelector('.product-section');
        if (firstSection) {
            firstSection.scrollIntoView({ behavior: 'smooth' });
        }
    });

    // Newsletter form submission
    const newsletterForm = document.querySelector('.newsletter-form');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const email = this.querySelector('input[type="email"]').value;
            
            // Simple validation
            if (email && email.includes('@')) {
                // Lưu email vào localStorage (trong thực tế sẽ gửi đến server)
                let newsletters = JSON.parse(localStorage.getItem('newsletters')) || [];
                if (!newsletters.includes(email)) {
                    newsletters.push(email);
                    localStorage.setItem('newsletters', JSON.stringify(newsletters));
                }
                
                showNotification('Cảm ơn bạn đã đăng ký nhận tin!');
                this.reset();
            } else {
                showNotification('Vui lòng nhập email hợp lệ!', 'error');
            }
        });
    }

    // Sidebar banner button
    document.querySelector('.banner-btn')?.addEventListener('click', function() {
        // Scroll to special offers
        const specialOffers = document.querySelector('.special-offers');
        if (specialOffers) {
            specialOffers.scrollIntoView({ behavior: 'smooth' });
        }
    });

    // Product card hover effects
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });

    // Initialize any animations when elements come into view
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe elements for animation
    document.querySelectorAll('.category-card, .product-section').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});

// Add some global styles for notifications and modal
const style = document.createElement('style');
style.textContent = `
    .notification-content {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .notification-content i {
        font-size: 1.2rem;
    }
    
    .quick-view-modal .modal-content {
        background: white;
        padding: 0;
        border-radius: 15px;
        max-width: 800px;
        width: 90%;
        position: relative;
        max-height: 90vh;
        overflow-y: auto;
    }
    
    .close-modal {
        position: absolute;
        top: 15px;
        right: 15px;
        font-size: 24px;
        cursor: pointer;
        color: #666;
        z-index: 1;
        background: rgba(255,255,255,0.9);
        border-radius: 50%;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .modal-body {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 30px;
        padding: 30px;
    }
    
    .product-image-modal {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .product-image-modal img {
        width: 100%;
        height: 300px;
        object-fit: cover;
    }
    
    .product-info-modal h3 {
        font-size: 1.5rem;
        margin-bottom: 15px;
        color: #2d3748;
    }
    
    .product-info-modal .product-price {
        font-size: 1.8rem;
        font-weight: bold;
        color: #FF6B8B;
        margin-bottom: 15px;
    }
    
    .product-description {
        color: #718096;
        line-height: 1.6;
        margin: 20px 0;
    }
    
    .modal-actions {
        display: flex;
        gap: 15px;
        margin-top: 25px;
    }
    
    .btn-primary, .btn-secondary {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #FF99B8, #FF6B8B);
        color: white;
        flex: 2;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(255, 107, 139, 0.4);
    }
    
    .btn-secondary {
        background: #f8f9fa;
        color: #4a5568;
        border: 2px solid #e2e8f0;
        flex: 1;
    }
    
    .btn-secondary:hover {
        background: #e2e8f0;
    }
    
    .no-products-message {
        grid-column: 1 / -1;
        text-align: center;
    }
    
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
        }
        to {
            transform: translateX(0);
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
        }
        to {
            transform: translateX(100%);
        }
    }
    
    @media (max-width: 768px) {
        .modal-body {
            grid-template-columns: 1fr;
            gap: 20px;
        }
        
        .modal-actions {
            flex-direction: column;
        }
    }
`;
document.head.appendChild(style);

// ===== PAGINATION FUNCTIONALITY =====
function handlePagination() {
    // Lấy tham số từ URL
    const urlParams = new URLSearchParams(window.location.search);
    const currentPage = parseInt(urlParams.get('page')) || 1;
    const currentCategory = urlParams.get('category');
    
    // Nếu có phân trang, cuộn đến danh mục tương ứng
    if (currentCategory && currentPage > 1) {
        setTimeout(() => {
            const targetSection = document.getElementById(currentCategory);
            if (targetSection) {
                const headerOffset = 120;
                const elementPosition = targetSection.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
            }
        }, 100);
    }
}

// Gọi hàm xử lý phân trang khi trang load
handlePagination();

// Cập nhật URL khi chuyển trang mà không reload (nếu cần)
function updateURL(page, category) {
    const newUrl = `${window.location.pathname}?page=${page}&category=${category}`;
    window.history.pushState({}, '', newUrl);
}

// Xử lý sự kiện popstate để hỗ trợ nút back/forward
window.addEventListener('popstate', function() {
    handlePagination();
});

function enhancePagination() {
    const pageLinks = document.querySelectorAll('.page-link, .page-number');
    
    pageLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.getAttribute('href') && !this.classList.contains('active')) {
                // Thêm hiệu ứng loading
                const productSection = this.closest('.product-section');
                if (productSection) {
                    productSection.classList.add('page-changing');
                }
                
                // Thêm hiệu ứng cho nút được click
                this.classList.add('pagination-loading');
                
                // Cho phép chuyển hướng bình thường
                // Hiệu ứng sẽ được thực thi
            }
        });
    });
    
    // Xử lý khi trang load xong
    window.addEventListener('load', function() {
        document.querySelectorAll('.product-section.page-changing').forEach(section => {
            section.classList.remove('page-changing');
        });
        
        document.querySelectorAll('.pagination-loading').forEach(btn => {
            btn.classList.remove('pagination-loading');
        });
    });
}

// Gọi hàm khi DOM ready
document.addEventListener('DOMContentLoaded', function() {
    enhancePagination();
    
    // Thêm hiệu ứng xuất hiện cho phân trang
    const paginationContainers = document.querySelectorAll('.pagination-container');
    paginationContainers.forEach(container => {
        container.style.opacity = '0';
        container.style.transform = 'translateY(20px)';
        container.style.transition = 'all 0.6s ease';
        
        setTimeout(() => {
            container.style.opacity = '1';
            container.style.transform = 'translateY(0)';
        }, 300);
    });
});