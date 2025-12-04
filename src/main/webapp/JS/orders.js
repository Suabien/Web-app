document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo các biến cần thiết
    const filterBtns = document.querySelectorAll('.filter-btn');
    const orderCards = document.querySelectorAll('.order-card');
    const orderList = document.querySelector('.orders-list');
    
    // Hiển thị thông báo khi không có đơn hàng
    const showNoOrdersMessage = (message) => {
        const oldMessage = document.querySelector('.no-orders');
        if (oldMessage) oldMessage.remove();

        const noOrdersDiv = document.createElement('div');
        noOrdersDiv.className = 'no-orders';
        noOrdersDiv.innerHTML = `
            <img src="/2274820014_NguyenThuHienn/Images/no-order.png" alt="Không có đơn hàng">
            <h3>${message}</h3>
            <p>Hãy mua sắm ngay để trải nghiệm những sản phẩm tuyệt vời của chúng tôi</p>
            <a href="/2274820014_NguyenThuHienn/HomeProductServlet" class="shop-now">Mua sắm ngay</a>
        `;
        orderList.appendChild(noOrdersDiv);
    };

    // Xóa thông báo không có đơn hàng
    const removeNoOrdersMessage = () => {
        const message = document.querySelector('.no-orders');
        if (message) message.remove();
    };

    // Xử lý filter đơn hàng
    const handleFilter = (status) => {
        let visibleCount = 0;
        
        orderCards.forEach(card => {
            const cardStatus = card.querySelector('.order-status').textContent.trim();
            
            if (status === 'Tất cả' || cardStatus.includes(status)) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        removeNoOrdersMessage();
        if (visibleCount === 0) {
            const message = status === 'Tất cả' 
                ? 'Bạn chưa có đơn hàng nào' 
                : `Không có đơn hàng ${status.toLowerCase()}`;
            showNoOrdersMessage(message);
        }
    };

    // Xử lý hủy đơn hàng
    const handleCancelOrder = (button) => {
        const orderCard = button.closest('.order-card');
        const orderId = button.getAttribute('data-order-id');
        
        if (confirm(`Bạn có chắc muốn hủy đơn hàng #${orderId}?`)) {
            // Thay đổi giao diện ngay lập tức
            const statusElement = orderCard.querySelector('.order-status');
            statusElement.innerHTML = '<i class="fas fa-times-circle"></i> Đã hủy';
            statusElement.className = 'order-status cancelled';
            
            // Cập nhật tiến trình
            const progressSteps = orderCard.querySelectorAll('.step');
            progressSteps.forEach(step => step.classList.remove('current', 'completed'));
            
            // Thêm bước hủy đơn
            progressSteps[1].innerHTML = `
                <div class="step-icon"><i class="fas fa-times"></i></div>
                <div class="step-label">Đã hủy</div>
                <div class="step-date">${new Date().toLocaleDateString()}</div>
            `;
            progressSteps[1].classList.add('cancelled');
            
            // Thêm lý do hủy
            const reason = prompt("Vui lòng nhập lý do hủy đơn hàng:");
            if (reason) {
                const summary = orderCard.querySelector('.order-summary');
                if (!summary.querySelector('.cancellation-reason')) {
                    const reasonDiv = document.createElement('div');
                    reasonDiv.className = 'cancellation-reason';
                    reasonDiv.innerHTML = `<p><strong>Lý do hủy:</strong> ${reason}</p>`;
                    summary.appendChild(reasonDiv);
                }
            }
            
            // Thay đổi nút
            const footer = orderCard.querySelector('.order-footer');
            footer.innerHTML = `
                <button class="order-btn reorder">
                    <i class="fas fa-shopping-cart"></i> Mua lại
                </button>
                <button class="order-btn contact">
                    <i class="fas fa-headset"></i> Liên hệ hỗ trợ
                </button>
            `;
            
            // Gửi yêu cầu hủy đến server
            cancelOrderToServer(orderId);
        }
    };

    // Gửi yêu cầu hủy đơn hàng đến server
    const cancelOrderToServer = (orderId) => {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'CancelOrderServlet';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'orderId';
        input.value = orderId;
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    };

    // Xử lý các nút chức năng
    const handleButtonClick = (button) => {
        if (button.classList.contains('cancel')) {
            handleCancelOrder(button);
        } else if (button.classList.contains('reorder')) {
            alert('Chức năng mua lại sẽ thêm các sản phẩm vào giỏ hàng của bạn.');
        } else if (button.classList.contains('contact')) {
            alert('Liên hệ hỗ trợ: Hotline 1800 1234 (miễn phí)');
        }
    };

    // Khởi tạo sự kiện
    const initEvents = () => {
        // Filter đơn hàng
        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                handleFilter(this.textContent.trim());
            });
        });
        
        // Xử lý các nút chức năng
        document.addEventListener('click', (e) => {
            const button = e.target.closest('.order-btn');
            if (button) {
                handleButtonClick(button);
            }
        });
        
        // Kiểm tra nếu không có đơn hàng khi tải trang
        if (orderCards.length === 0) {
            showNoOrdersMessage('Bạn chưa có đơn hàng nào');
        }
    };

    // Khởi chạy
    initEvents();
});