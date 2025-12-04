/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
document.addEventListener('DOMContentLoaded', () => {
  const buyBtn = document.querySelector('.buy-btn');
  const modal = document.getElementById('buyModal');
  const closeBtn = modal.querySelector('.modal-close');
  const cancelBtn = modal.querySelector('.cancel-btn');
  const qtyInput = document.querySelector('.product-quantity input[type="number"]');
  const priceEl = document.querySelector('.price');
  const optionField = document.getElementById('optionNameField');
  const productId = document.querySelector('.product-extra')?.dataset.productId || document.getElementById('productId')?.value;
  const userId = document.getElementById('userId').value;
  const paymentMethod = document.getElementById('paymentMethod');
  const qrContainer = document.getElementById('qrContainer');

  // Ẩn modal khi tải trang
  modal.style.display = 'none';

  // Xử lý thay đổi phương thức thanh toán
  paymentMethod.addEventListener('change', function() {
    if (this.value === 'Bank') {
      qrContainer.style.display = 'block';
    } else {
      qrContainer.style.display = 'none';
    }
  });

  // Mở modal khi nhấn nút "Mua ngay"
  buyBtn.addEventListener('click', () => {
    const qty = parseInt(qtyInput.value, 10);
    document.getElementById('modalQuantity').textContent = qty;

    // Lấy giá sản phẩm
    let basePrice;
    const activeOption = document.querySelector('.option-btn.active');
    if (activeOption) {
      const optionName = activeOption.dataset.optionName || activeOption.textContent.trim();
      const priceText = priceEl.dataset.optionPrices ? 
        JSON.parse(priceEl.dataset.optionPrices)[optionName] : 
        priceEl.textContent;
      basePrice = parseInt(priceText.replace(/\D/g, '')) || 0;
    } else {
      basePrice = parseInt(priceEl.textContent.replace(/\D/g, '')) || 0;
    }

    const shipFee = 30000;
    const total = (basePrice * qty) + shipFee;
    
    // Cập nhật thông tin thanh toán
    document.getElementById('modalTotalPrice').textContent = total.toLocaleString('vi') + 'đ';
    document.getElementById('productPrice').value = basePrice;

    const today = new Date();
    const formattedDate = today.toLocaleDateString('vi-VN');
    document.getElementById('modalDate').textContent = formattedDate;

    // Reset QR code về trạng thái ẩn khi mở modal
    qrContainer.style.display = 'none';
    modal.style.display = 'flex';
  });

  // Đóng modal
  closeBtn.addEventListener('click', () => modal.style.display = 'none');
  cancelBtn.addEventListener('click', () => modal.style.display = 'none');
  modal.addEventListener('click', e => e.target === modal && (modal.style.display = 'none'));

  // ===== HỢP NHẤT xử lý đặt hàng =====
  document.getElementById('buyForm').addEventListener('submit', async (e) => {
    e.preventDefault();

    const activeBtn = document.querySelector('.option-btn.active');
    const optionName = activeBtn
      ? activeBtn.dataset.optionName || activeBtn.textContent.trim()
      : optionField.value;

    // Tính toán tổng tiền (bao gồm phí ship)
    const quantity = parseInt(document.getElementById('modalQuantity').textContent);
    const basePrice = parseInt(document.getElementById('productPrice').value);
    const shipFee = 30000;
    const totalAmount = (basePrice * quantity) + shipFee;

    const formData = {
      action: 'create',
      user_id: document.getElementById('userId').value,
      customer_name: document.getElementById('customerName').value,
      address: document.getElementById('address').value,
      phone: document.getElementById('phone').value,
      payment_method: document.getElementById('paymentMethod').value,
      product_id: productId,
      product_name: document.querySelector('.product-details h1').textContent,
      quantity: quantity,
      price: basePrice,
      option_name: optionName,
      order_date: new Date().toISOString().split('T')[0],
      total_amount: totalAmount,
      status: 'Chờ duyệt'
    };

    try {
      const response = await fetch('/2274820014_NguyenThuHienn/OrdersServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams(formData)
      });

      const result = await response.text();

      if (result === 'success') {
        alert('✅ Đặt hàng thành công!');
        modal.style.display = 'none';
        // Reset form
        document.getElementById('buyForm').reset();
      } else {
        alert('Lỗi: ' + result);
      }
    } catch (error) {
      console.error('Error:', error);
      alert('Lỗi kết nối đến server');
    }
  });

  // ===== Xử lý mẫu (option) và cập nhật giá =====
  document.querySelectorAll('.option-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.option-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const name = btn.dataset.optionName || btn.textContent.trim();
      optionField.value = name;

      // Cập nhật giá khi chọn option
      if (priceEl.dataset.optionPrices) {
        const prices = JSON.parse(priceEl.dataset.optionPrices);
        if (prices[name]) {
          priceEl.textContent = prices[name];
        }
      }
    });
  });

  // ===== Xử lý tăng/giảm số lượng và cập nhật giá =====
  const minusBtn = document.querySelector('.qty-btn.minus');
  const plusBtn = document.querySelector('.qty-btn.plus');

  if (minusBtn && plusBtn) {
    minusBtn.addEventListener('click', () => {
      let currentValue = parseInt(qtyInput.value);
      if (currentValue > 1) {
        qtyInput.value = currentValue - 1;
        updateTotalPrice();
      }
    });

    plusBtn.addEventListener('click', () => {
      let currentValue = parseInt(qtyInput.value);
      const stock = parseInt(document.querySelector('.stock').textContent) || 100;
      if (currentValue < stock) {
        qtyInput.value = currentValue + 1;
        updateTotalPrice();
      }
    });

    qtyInput.addEventListener('change', () => {
      updateTotalPrice();
    });
  }

  // Hàm cập nhật tổng giá khi thay đổi số lượng
  function updateTotalPrice() {
    if (modal.style.display === 'flex') {
      const qty = parseInt(qtyInput.value);
      document.getElementById('modalQuantity').textContent = qty;

      const basePrice = parseInt(document.getElementById('productPrice').value);
      const shipFee = 30000;
      const total = (basePrice * qty) + shipFee;
      document.getElementById('modalTotalPrice').textContent = total.toLocaleString('vi') + 'đ';
    }
  }

  // ===== Xóa review =====
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const reviewItem = btn.closest('.review-item');
      const reviewId = btn.dataset.reviewId;

      if (confirm('Bạn có chắc muốn xóa đánh giá này không?')) {
        fetch('ReviewServlet', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: `action=delete&reviewId=${encodeURIComponent(reviewId)}`
        })
          .then(res => res.text())
          .then(text => {
            if (text === 'deleted') {
              reviewItem.remove();
              // Cập nhật số lượng đánh giá
              updateReviewCount(-1);
            } else {
              alert('Không thể xóa đánh giá.');
            }
          });
      }
    });
  });

  // ===== Sửa review =====
  document.querySelectorAll('.edit-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const reviewItem = btn.closest('.review-item');
      const reviewTextP = reviewItem.querySelector('.review-text');
      const reviewId = btn.dataset.reviewId;

      if (reviewItem.querySelector('textarea')) return;

      const currentText = reviewTextP.textContent;
      const textarea = document.createElement('textarea');
      textarea.className = 'edit-textarea';
      textarea.value = currentText;

      const btnSave = document.createElement('button');
      btnSave.textContent = 'Lưu';

      const btnCancel = document.createElement('button');
      btnCancel.textContent = 'Hủy';

      const btnGroup = document.createElement('div');
      btnGroup.className = 'edit-buttons';
      btnGroup.appendChild(btnSave);
      btnGroup.appendChild(btnCancel);

      reviewTextP.style.display = 'none';
      reviewTextP.parentNode.insertBefore(textarea, reviewTextP.nextSibling);
      reviewTextP.parentNode.insertBefore(btnGroup, textarea.nextSibling);

      btnSave.addEventListener('click', () => {
        const newText = textarea.value.trim();
        if (newText === '') {
          alert('Vui lòng nhập nội dung đánh giá');
          return;
        }

        fetch('ReviewServlet', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: `action=edit&reviewId=${reviewId}&newText=${encodeURIComponent(newText)}`
        })
          .then(res => res.text())
          .then(text => {
            if (text === 'updated') {
              reviewTextP.textContent = newText;
              cleanup();
            } else {
              alert('Không thể cập nhật đánh giá.');
            }
          });
      });

      btnCancel.addEventListener('click', cleanup);

      function cleanup() {
        textarea.remove();
        btnGroup.remove();
        reviewTextP.style.display = 'block';
      }
    });
  });

  // Hàm cập nhật số lượng đánh giá
  function updateReviewCount(change) {
    const ratingCountElement = document.querySelector('.rating-count');
    if (ratingCountElement) {
      const currentText = ratingCountElement.textContent;
      const match = currentText.match(/(\d+)/);
      if (match) {
        const currentCount = parseInt(match[1]);
        const newCount = Math.max(0, currentCount + change);
        ratingCountElement.textContent = currentText.replace(/\d+/, newCount);
      }
    }
  }

  // Xử lý hiển thị ảnh khi hover vào thumbnail
  const thumbnails = document.querySelectorAll('.thumbnail img');
  const mainImage = document.querySelector('.main-image img');

  thumbnails.forEach(thumbnail => {
    thumbnail.addEventListener('mouseover', () => {
      const originalSrc = mainImage.src;
      thumbnail.dataset.originalSrc = originalSrc;
      mainImage.src = thumbnail.src;
    });

    thumbnail.addEventListener('mouseout', () => {
      if (thumbnail.dataset.originalSrc) {
        mainImage.src = thumbnail.dataset.originalSrc;
      }
    });

    thumbnail.addEventListener('click', () => {
      mainImage.src = thumbnail.src;
      // Cập nhật ảnh chính hiện tại
      mainImage.dataset.currentSrc = thumbnail.src;
    });
  });
});