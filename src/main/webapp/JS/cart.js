/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", () => {
    const cartBtn = document.querySelector(".cart-btn");
    const optionButtons = document.querySelectorAll(".option-btn");
    let selectedOption = document.querySelector(".option-btn.active")?.textContent || "Mặc định";

    // Cập nhật option khi nhấn nút
    optionButtons.forEach(button => {
        button.addEventListener("click", () => {
            optionButtons.forEach(btn => btn.classList.remove("active"));
            button.classList.add("active");
            selectedOption = button.textContent;
            updatePrice();
        });
    });

    function updatePrice() {
        const priceElement = document.querySelector(".price");
        if (!priceElement) return;
        const basePrice = parseInt(priceElement.getAttribute("data-base-price")) || 0;
        const optionPrices = JSON.parse(priceElement.getAttribute("data-option-prices") || "{}");
        const newPrice = optionPrices[selectedOption] || basePrice;
        priceElement.textContent = newPrice.toLocaleString("vi-VN") + "đ";
    }

    function updateCartCount() {
        const cart = JSON.parse(localStorage.getItem("cart")) || [];
        const count = cart.reduce((sum, itm) => sum + itm.quantity, 0);
        document.querySelectorAll('.cart-count').forEach(el => el.textContent = count);
    }

    function updateTotal() {
        const cart = JSON.parse(localStorage.getItem("cart")) || [];
        let subtotal = 0;
        const discountRate = 0, shippingFee = 30000;

        document.querySelectorAll('.product-item input[type="checkbox"]').forEach(cb => {
            if (cb.checked) {
                const i = parseInt(cb.dataset.index);
                const it = cart[i];
                const pr = parseInt(it.price.replace(/\D/g, '')) || 0;
                subtotal += pr * it.quantity;
            }
        });

        document.getElementById('subtotal').textContent = subtotal.toLocaleString('vi-VN') + 'đ';
        document.getElementById('shipping-fee').textContent = shippingFee.toLocaleString('vi-VN') + 'đ';
        document.getElementById('savings').textContent = (0).toLocaleString('vi-VN') + 'đ';

        const totEl = document.querySelector('.total-price span');
        if (totEl) totEl.textContent = (subtotal + shippingFee).toLocaleString('vi-VN') + 'đ';
    }

    function updateModalSummary() {
        const cart = JSON.parse(localStorage.getItem("cart")) || [];
        let totalItems = 0;
        let subtotal = 0;
        const shippingFee = 30000;
        const discount = 0;

        document.querySelectorAll('.product-item input[type="checkbox"]').forEach(cb => {
            if (cb.checked) {
                const i = parseInt(cb.dataset.index);
                const item = cart[i];
                const price = parseInt(item.price.replace(/\D/g, "")) || 0;
                totalItems += item.quantity;
                subtotal += price * item.quantity;
            }
        });

        document.getElementById("modalTotalItems").textContent = totalItems;
        document.getElementById("modalSubtotal").textContent = subtotal.toLocaleString("vi-VN") + "đ";
        document.getElementById("modalShipFee").textContent = shippingFee.toLocaleString("vi-VN") + "đ";
        document.getElementById("modalDiscount").textContent = "-" + discount.toLocaleString("vi-VN") + "đ";
        document.getElementById("modalTotalPrice").textContent = (subtotal + shippingFee - discount).toLocaleString("vi-VN") + "đ";
    }

    function changeQuantity(e) {
        const idx = parseInt(e.currentTarget.dataset.index);
        const delta = parseInt(e.currentTarget.dataset.delta);
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        cart[idx].quantity = Math.max(1, cart[idx].quantity + delta);
        localStorage.setItem('cart', JSON.stringify(cart));
        document.querySelector(`.qty-input[data-index="${idx}"]`).value = cart[idx].quantity;
        updateCartCount();
        updateTotal();
        updateModalSummary();
    }

    function removeItem(e) {
        const idx = parseInt(e.currentTarget.dataset.index);
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        cart.splice(idx, 1);
        localStorage.setItem('cart', JSON.stringify(cart));
        updateCartCount();
        renderCartItems();
    }

    function updateOption(e) {
        const idx = parseInt(e.currentTarget.dataset.index);
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        cart[idx].option = e.currentTarget.value;
        localStorage.setItem('cart', JSON.stringify(cart));
    }

    function renderCartItems() {
        const cartContainer = document.getElementById("cart-items");
        const cart = JSON.parse(localStorage.getItem("cart")) || [];
        if (!cartContainer) return;
        if (cart.length === 0) {
            cartContainer.innerHTML = `
                <div class="empty-cart">
                    <img src="/2274820014_NguyenThuHienn/Images/no-order.png" alt="Giỏ hàng trống">
                    <h2>Giỏ hàng của bạn trống!</h2>
                    <p>Hãy thêm sản phẩm yêu thích vào giỏ hàng để thanh toán nhé!</p>
                    <a href="/2274820014_NguyenThuHienn/HomeProductServlet" class="shop-now">Mua sắm ngay</a>
                </div>
            `;
        } else {
            cartContainer.innerHTML = cart.map((item, index) => `
                <div class="product-item">
                    <input type="checkbox" checked data-index="${index}">
                    <a href="${item.image}"><img src="${item.image}" alt="${item.name}"></a>
                    <div class="product-details">
                        <div class="product-title"><a href="/2274820014_NguyenThuHienn/ProductDetailServlet?id=${item.id}">${item.name}</a></div>
                        <div class="product-option">
                            <select data-index="${index}" class="option-select">
                                ${item.optionsList.map(opt => `<option value="${opt}" ${opt===item.option? 'selected':''}>${opt}</option>`).join('')}
                            </select>
                        </div>
                        <div class="price">${item.price}</div>
                        <div class="quantity">
                            <button class="qty-btn" data-index="${index}" data-delta="-1">-</button>
                            <input type="text" value="${item.quantity}" data-index="${index}" class="qty-input" readonly>
                            <button class="qty-btn" data-index="${index}" data-delta="1">+</button>
                        </div>
                        <div class="trash-container">
                            <button class="delete-btn" data-index="${index}">🗑️</button>
                        </div>
                    </div>
                </div>
            `).join('');

            document.querySelectorAll('.qty-btn').forEach(btn => btn.addEventListener('click', changeQuantity));
            document.querySelectorAll('.delete-btn').forEach(btn => btn.addEventListener('click', removeItem));
            document.querySelectorAll('.option-select').forEach(sel => sel.addEventListener('change', updateOption));
            document.querySelectorAll('.product-item input[type="checkbox"]').forEach(cb => cb.addEventListener('change', () => {
                updateTotal();
                updateModalSummary();
            }));
        }
        updateTotal();
        updateModalSummary();
    }

    updatePrice();

    if (cartBtn) {
        cartBtn.addEventListener("click", () => {
            const imageUrl = document.getElementById("product-image")?.value || "/default.jpg";
            const product = {
                id: document.querySelector(".product-extra").dataset.productId,
                name: document.querySelector(".product-details h1").textContent,
                price: document.querySelector(".price").textContent,
                quantity: parseInt(document.querySelector(".product-quantity input").value),
                image: imageUrl,
                option: selectedOption,
                optionsList: Array.from(optionButtons).map(btn => btn.textContent)
            };

            let cart = JSON.parse(localStorage.getItem("cart")) || [];
            const idx = cart.findIndex(item => item.name === product.name && item.option === product.option);
            if (idx !== -1) cart[idx].quantity += product.quantity;
            else cart.push(product);

            localStorage.setItem("cart", JSON.stringify(cart));
            alert("✅ Đã thêm vào giỏ hàng!");
            updateCartCount();
            renderCartItems();
        });
    }

    document.getElementById('select-all')?.addEventListener('change', e => {
        document.querySelectorAll('.product-item input[type="checkbox"]').forEach(cb => cb.checked = e.target.checked);
        updateTotal();
        updateModalSummary();
    });

    // Hiển thị ngày hiện tại
    const dateElement = document.getElementById("order-date");
    if (dateElement) {
        const today = new Date();
        const formatted = today.toLocaleDateString("vi-VN", {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
        dateElement.textContent = formatted;
    }

    updateCartCount();
    renderCartItems();

    // Modal checkout events
    function openCheckoutModal() {
        document.getElementById('checkoutModal').style.display = 'block';
        document.body.style.overflow = 'hidden';
        updateModalSummary();
        
        // Reset và chọn mặc định COD
        resetPaymentMethods();
        document.querySelector('input[value="COD"]').checked = true;
        document.querySelector('input[value="COD"]').closest('.payment-option').classList.add('selected');
        hideQRCode();
    }

    function closeCheckoutModal() {
        document.getElementById('checkoutModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    // Quản lý phương thức thanh toán
    function setupPaymentMethods() {
        const paymentOptions = document.querySelectorAll('.payment-option input[type="radio"]');
        
        paymentOptions.forEach(option => {
            option.addEventListener('change', function() {
                // Cập nhật trạng thái selected
                document.querySelectorAll('.payment-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                this.closest('.payment-option').classList.add('selected');
                
                // Xử lý hiển thị QR code
                if (this.value === 'Bank') {
                    showQRCode();
                } else {
                    hideQRCode();
                }
            });
        });
    }

    function resetPaymentMethods() {
        document.querySelectorAll('.payment-option').forEach(opt => {
            opt.classList.remove('selected');
        });
    }

    function showQRCode() {
        const qrContainer = document.getElementById('qrCodeContainer');
        qrContainer.classList.add('show');
    }

    function hideQRCode() {
        const qrContainer = document.getElementById('qrCodeContainer');
        qrContainer.classList.remove('show');
    }

    // Thiết lập phương thức thanh toán
    setupPaymentMethods();

    const checkoutBtn = document.querySelector('.checkout-btn');
    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', openCheckoutModal);
    }

    const modalClose = document.querySelector('.modal-close');
    if (modalClose) {
        modalClose.addEventListener('click', closeCheckoutModal);
    }

    const cancelBtn = document.querySelector('.cancel-btn');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', closeCheckoutModal);
    }

    window.addEventListener('click', (e) => {
        if (e.target === document.getElementById('checkoutModal')) {
            closeCheckoutModal();
        }
    });

    // Submit đơn hàng
    document.getElementById('checkoutForm').addEventListener('submit', async e => {
        e.preventDefault();

        // Lấy thông tin khách
        const customerName = document.getElementById('modalCustomerName').value.trim();
        const phone        = document.getElementById('modalPhone').value.trim();
        const address      = document.getElementById('modalAddress').value.trim();
        const payment      = document.querySelector('input[name="paymentMethod"]:checked').value; // Lấy từ radio button
        const orderDate    = document.getElementById('order-date').textContent; // dd/mm/yyyy

        // Lấy giỏ hàng từ localStorage
        const cart = JSON.parse(localStorage.getItem('cart')) || [];
        if (cart.length === 0) {
            alert('Giỏ hàng trống!');
            return;
        }

        // Chuẩn bị body dạng x-www-form-urlencoded
        const params = new URLSearchParams();
        params.append('action',       'create');
        params.append('customer_name',customerName);
        params.append('phone',        phone);
        params.append('address',      address);
        params.append('payment_method', payment);
        params.append('order_date',   orderDate);

        cart.forEach(item => {
            params.append('product_id',   item.id);
            params.append('quantity',     item.quantity);
            params.append('price',        item.price.replace(/\D/g, ''));
            params.append('option_name',  item.option);
        });

        try {
            const res = await fetch('/2274820014_NguyenThuHienn/Orders3Servlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });
            const text = await res.text();
            if (text.trim() === 'success') {
                alert('Đặt hàng thành công!');
                // Lấy giỏ hàng hiện tại
                let cart = JSON.parse(localStorage.getItem('cart')) || [];

                // Lấy danh sách các chỉ số sản phẩm được chọn (checkbox checked)
                const checkedIndexes = [];
                document.querySelectorAll('.product-item input[type="checkbox"]').forEach((cb, idx) => {
                    if (cb.checked) checkedIndexes.push(idx);
                });

                // Lọc lại giỏ hàng loại bỏ sản phẩm được chọn (đã đặt)
                cart = cart.filter((_, idx) => !checkedIndexes.includes(idx));

                // Lưu lại giỏ hàng mới (chỉ còn sản phẩm chưa đặt)
                localStorage.setItem('cart', JSON.stringify(cart));
                closeCheckoutModal();
                updateCartCount();
                renderCartItems();
            } else {
                alert('Lỗi khi lưu đơn hàng: ' + text);
            }
        } catch (err) {
            console.error(err);
            alert('Không thể kết nối đến server.');
        }
    });
});

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