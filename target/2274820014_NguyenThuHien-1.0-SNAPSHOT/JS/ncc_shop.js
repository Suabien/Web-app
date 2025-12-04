/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* ================== User Popup ================== */
function toggleUserInfo() {
  const popup = document.getElementById("userInfoPopup");
  if (!popup) return;
  const isShown = popup.classList.contains("show") || popup.style.display === "block";
  if (isShown) {
    popup.style.display = "none";
    popup.classList.remove("show");
  } else {
    popup.style.display = "block";
    popup.classList.add("show");
  }
}

// Ẩn popup khi click ra ngoài
document.addEventListener("click", function (event) {
  const avatar = document.querySelector(".user-avatar");
  const popup = document.getElementById("userInfoPopup");
  if (!popup) return;
  if (avatar && (avatar.contains(event.target) || (popup && popup.contains(event.target)))) return;
  popup.style.display = "none";
  popup.classList.remove("show");
});

// Đóng popup khi scroll 
window.addEventListener("scroll", function () {
  const popup = document.getElementById("userInfoPopup");
  if (popup && (popup.classList.contains("show") || popup.style.display === "block")) {
    popup.style.display = "none";
    popup.classList.remove("show");
  }
});

/* ================== Sidebar active ================== */
document.addEventListener('DOMContentLoaded', function () {
  const currentPath = window.location.pathname;
  document.querySelectorAll('.sidebar-menu a').forEach(link => {
    const href = link.getAttribute('href') || '';
    // Đánh dấu active khi trùng endpoint (bỏ query/context)
    if (href && currentPath.endsWith(href.replace(/^.*\//,''))) {
      link.classList.add('active');
    } else {
      link.classList.remove('active');
    }
  });
});

/* ================== Modal helpers ================== */
function openModal(modalId) {
  const el = document.getElementById(modalId);
  if (!el) return;
  el.style.display = 'block';
  el.classList.add('show');
  // Nếu trang bạn không muốn khóa scroll thì comment dòng sau
  // document.body.style.overflow = 'hidden';
}

function closeModal(modalId) {
  const el = document.getElementById(modalId);
  if (!el) return;
  el.style.display = 'none';
  el.classList.remove('show');
  // document.body.style.overflow = 'auto';
}

// Đóng modal khi click nền
window.addEventListener('click', function (event) {
  document.querySelectorAll('.modal').forEach(modal => {
    if (event.target === modal) {
      closeModal(modal.id);
    }
  });
});

// Đóng modal bằng phím ESC
document.addEventListener('keydown', function (event) {
  if (event.key === 'Escape') {
    document.querySelectorAll('.modal').forEach(modal => {
      if (modal.style.display === 'block') {
        closeModal(modal.id);
      }
    });
  }
});

/* ================== CRUD: Delete (POST Form) ================== */
// Xóa cửa hàng qua form ẩn -> ShopServlet
function deleteItem(id) {
  if (!id) return;
  if (confirm('Bạn có chắc chắn muốn xoá cửa hàng có ID ' + id + '?\nHành động này không thể hoàn tác.')) {
    const f = document.getElementById('deleteForm');
    const i = document.getElementById('delete-id');
    if (!f || !i) {
      showNotification('❌ Thiếu form xoá (deleteForm) hoặc input (delete-id)!', 'error');
      return;
    }
    i.value = id;
    f.submit(); // POST tới <ctx>/ShopServlet (đã cấu hình trong JSP)
  }
}

/* ================== CRUD: Edit (fill modal) ================== */
// (id, shopName, sellerName, email, phone, imagePath)
function openEditModal(id, shopName, sellerName, email, phone, imagePath) {
  // Đồng bộ đúng ID của input trong JSP
  setValue('edit-id', id);
  setValue('edit-shop-name', shopName || '');
  setValue('edit-seller-name', sellerName || '');
  setValue('edit-email', email || '');
  setValue('edit-phone', phone || '');
  setValue('edit-existing-image', imagePath || '');

  // Hỗ trợ cả hai ID preview: editPreview (mới) và edit-image-preview (cũ)
  const prev = document.getElementById('editPreview') || document.getElementById('edit-image-preview');
  if (prev) {
    if (imagePath) {
      prev.src = imagePath;
      prev.style.display = 'block';
    } else {
      prev.src = '';
      prev.style.display = 'none';
    }
  }
  openModal('editShopModal');
}

function setValue(id, v) {
  const el = document.getElementById(id);
  if (el) el.value = v;
}

/* ================== Image preview ================== */
// Cho phép truyền id preview; nếu không truyền thì tự đoán theo input id
function previewImage(input, previewId) {
  const file = input && input.files ? input.files[0] : null;
  let preview =
    (previewId && document.getElementById(previewId)) ||
    // fallback theo id quen dùng
    document.getElementById('editPreview') ||
    document.getElementById('edit-image-preview') ||
    document.getElementById('addPreview') ||
    document.getElementById('add-image-preview');

  if (!preview) return;

  if (file) {
    const reader = new FileReader();
    reader.onloadend = function () {
      preview.src = reader.result;
      preview.style.display = 'block';
    };
    reader.readAsDataURL(file);
  } else {
    preview.src = '';
    preview.style.display = 'none';
  }
}

/* ================== Notification ================== */
function showNotification(message, type) {
  const notification = document.createElement('div');
  notification.className = `notification ${type}`;
  notification.innerHTML = `
    <span>${message}</span>
    <button type="button" aria-label="close" onclick="this.parentElement.remove()">&times;</button>
  `;
  Object.assign(notification.style, {
    position: 'fixed',
    top: '100px',
    right: '20px',
    background: (type === 'success' ? '#4CAF50' : '#f44336'),
    color: '#fff',
    padding: '15px 20px',
    borderRadius: '8px',
    boxShadow: '0 4px 12px rgba(0,0,0,0.2)',
    zIndex: 1001,
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
    animation: 'slideInRight 0.3s ease-out'
  });
  document.body.appendChild(notification);
  setTimeout(() => notification.remove(), 3000);
}

// CSS animation cho notification
(function injectNotifKeyframes(){
  if (document.getElementById('notif-anim-style')) return;
  const style = document.createElement('style');
  style.id = 'notif-anim-style';
  style.textContent = `
    @keyframes slideInRight {
      from { transform: translateX(100%); opacity: 0; }
      to   { transform: translateX(0);    opacity: 1; }
    }
    .notification button {
      background: none; border: none; color: white; font-size: 18px; cursor: pointer;
      padding: 0; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center;
    }
  `;
  document.head.appendChild(style);
})();

/* ================== Form submit ================== */

document.addEventListener('DOMContentLoaded', function () {
  // Nếu vẫn đang giữ id form: addShopForm / editShopForm, KHÔNG preventDefault -> cho submit bình thường
  const addForm = document.getElementById('addShopForm');
  const editForm = document.getElementById('editShopForm');
  // Không can thiệp để tránh xung đột layout/redirect server
  // (Nếu muốn chỉ validation client, thêm ở đây mà không preventDefault)
});
