/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// manage2.js - JavaScript cho trang quản lý sản phẩm

document.addEventListener('DOMContentLoaded', function() {
    // Active menu item based on current page
    const currentPath = window.location.pathname;
    const menuLinks = document.querySelectorAll('.sidebar-menu a');
    
    menuLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });

    // Khởi tạo form tabs
    initFormTabs();
    
    // Xử lý form thêm sản phẩm
    const addForm = document.getElementById('addProductForm');
    if (addForm) {
        addForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (validateProductForm(this)) {
                this.submit();
            }
        });
    }
    
    // Xử lý form sửa sản phẩm
    const editForm = document.getElementById('editProductForm');
    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (validateProductForm(this)) {
                this.submit();
            }
        });
    }
});

// ===== FORM TABS FUNCTIONALITY =====
function initFormTabs() {
    const tabs = document.querySelectorAll('.form-tab');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            const targetTab = this.getAttribute('data-tab');
            
            // Remove active class from all tabs and contents
            tabs.forEach(t => t.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to current tab and content
            this.classList.add('active');
            document.getElementById(`${targetTab}-tab`).classList.add('active');
        });
    });
}

// Hàm mở/đóng Modal
function openModal(modalId) {
    document.getElementById(modalId).style.display = 'block';
    document.body.style.overflow = 'hidden';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Đóng modal khi click bên ngoài
window.onclick = function(event) {
    document.querySelectorAll('.modal').forEach(modal => {
        if (event.target === modal) {
            closeModal(modal.id);
        }
    });
}

// Đóng modal bằng phím ESC
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        document.querySelectorAll('.modal').forEach(modal => {
            if (modal.style.display === 'block') {
                closeModal(modal.id);
            }
        });
    }
});

// Xóa sản phẩm
function deleteProduct(id) {
    if(confirm('Bạn có chắc chắn muốn xoá sản phẩm có ID ' + id + '?\nHành động này không thể hoàn tác.')) {
        fetch('ProductServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=delete&id=' + id
        })
        .then(response => {
            if(response.ok) {
                showNotification('✅ Xóa sản phẩm thành công!', 'success');
                setTimeout(() => location.reload(), 1000);
            } else {
                showNotification('❌ Có lỗi xảy ra khi xóa sản phẩm!', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('❌ Lỗi kết nối!', 'error');
        });
    }
}

// Hàm mở modal chỉnh sửa sản phẩm
function openEditModal(id, name, description, image_url, price, quantity, type_id) {
    document.getElementById("edit-id").value = id;
    document.getElementById("edit-name").value = name;
    document.getElementById("edit-description").value = description || '';
    document.getElementById("edit-price").value = price;
    document.getElementById("edit-quantity").value = quantity;
    document.getElementById("edit-type").value = type_id || '1';
    document.getElementById("edit-origin").value = origin || 'Việt Nam';
    
    const preview = document.getElementById('edit-image-preview');
    const placeholder = document.getElementById('no-image-placeholder-edit');
    
    if (image_url && image_url !== 'null' && image_url !== '') {
        preview.src = image_url;
        preview.style.display = 'block';
        if (placeholder) placeholder.style.display = 'none';
    } else {
        preview.style.display = 'none';
        if (placeholder) placeholder.style.display = 'block';
    }
    
    // Reset to first tab
    const tabs = document.querySelectorAll('.form-tab');
    const tabContents = document.querySelectorAll('.tab-content');
    
    if (tabs.length > 0 && tabContents.length > 0) {
        tabs.forEach(tab => tab.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));
        
        tabs[0].classList.add('active');
        tabContents[0].classList.add('active');
    }
    
    openModal('editProductModal');
}

// Xử lý preview ảnh khi chọn file
function previewImage(input, previewId, placeholderId) {
    const preview = document.getElementById(previewId);
    const placeholder = document.getElementById(placeholderId);
    const file = input.files[0];
    const reader = new FileReader();

    reader.onloadend = function() {
        preview.src = reader.result;
        preview.style.display = 'block';
        if (placeholder) placeholder.style.display = 'none';
    }

    if (file) {
        reader.readAsDataURL(file);
    } else {
        // Nếu không có file mới, giữ ảnh hiện tại
        if (!preview.src || preview.src === '') {
            preview.style.display = 'none';
            if (placeholder) placeholder.style.display = 'block';
        }
    }
}

// Validate form sản phẩm
function validateProductForm(form) {
    let isValid = true;
    
    // Reset previous errors
    const errorElements = form.querySelectorAll('.error-message');
    errorElements.forEach(el => el.remove());
    
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            showFieldError(input, 'Trường này là bắt buộc');
            isValid = false;
        } else {
            // Validate specific fields
            if (input.name === 'price') {
                if (!/^\d+$/.test(input.value.replace(/\./g, ''))) {
                    showFieldError(input, 'Giá phải là số nguyên dương');
                    isValid = false;
                }
            }
            
            if (input.name === 'quantity') {
                if (parseInt(input.value) < 0) {
                    showFieldError(input, 'Số lượng không được âm');
                    isValid = false;
                }
            }
        }
    });
    
    return isValid;
}

// Hiển thị lỗi cho trường cụ thể
function showFieldError(input, message) {
    input.style.borderColor = '#f44336';
    
    const errorElement = document.createElement('div');
    errorElement.className = 'error-message';
    errorElement.textContent = message;
    errorElement.style.cssText = 'color: #f44336; font-size: 12px; margin-top: 5px;';
    
    input.parentNode.appendChild(errorElement);
}

// Hiển thị thông báo
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
        background: ${type === 'success' ? '#4CAF50' : '#f44336'};
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
    
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 3000);
}

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

// Thêm CSS animation cho notification
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