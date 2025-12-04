// Xử lý menu dọc
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

// Xóa tài khoản
function deleteItem(id) {
    if(confirm('Bạn có chắc chắn muốn xoá tài khoản có ID ' + id + '?\nHành động này không thể hoàn tác.')) {
        fetch('AccountServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=delete&id=' + id
        })
        .then(response => {
            if(response.ok) {
                showNotification('✅ Xóa tài khoản thành công!', 'success');
                setTimeout(() => location.reload(), 1000);
            } else {
                showNotification('❌ Có lỗi xảy ra khi xóa tài khoản!', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('❌ Lỗi kết nối!', 'error');
        });
    }
}

// Hàm mở modal chỉnh sửa tài khoản
function openEditModal(id, username, password, role, fullName, email, phone, address, dob, imagePath) {
    document.getElementById("edit-id").value = id;
    document.getElementById("edit-username").value = username;
    document.getElementById("edit-password").value = password;
    document.getElementById("edit-role").value = role || 'Khách hàng';
    document.getElementById("edit-fullname").value = fullName || '';
    document.getElementById("edit-email").value = email || '';
    document.getElementById("edit-phone").value = phone || '';
    document.getElementById("edit-address").value = address || '';
    document.getElementById("edit-dob").value = dob || '';
    document.getElementById("edit-existing-image").value = imagePath || '';
    
    const preview = document.getElementById('edit-image-preview');
    const placeholder = document.getElementById('no-image-placeholder');
    
    if (imagePath && imagePath !== 'null' && imagePath !== '') {
        preview.src = imagePath;
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
    
    openModal('editAccountModal');
}

// Xử lý preview ảnh khi chọn file
function previewImage(input) {
    const preview = document.getElementById('edit-image-preview');
    const placeholder = document.getElementById('no-image-placeholder');
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
        preview.src = '';
        preview.style.display = 'none';
        if (placeholder) placeholder.style.display = 'block';
    }
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

// Xử lý form sửa tài khoản
document.addEventListener('DOMContentLoaded', function() {
    const editForm = document.getElementById('editAccountForm');
    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate required fields
            const username = document.getElementById('edit-username').value;
            const password = document.getElementById('edit-password').value;
            const role = document.getElementById('edit-role').value;
            
            if (!username || !password || !role) {
                showNotification('❌ Vui lòng điền đầy đủ thông tin bắt buộc!', 'error');
                return;
            }
            
            const formData = new FormData(this);
            
            // Show loading state
            const submitBtn = this.querySelector('.btn-submit');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';
            submitBtn.disabled = true;
            
            fetch('AccountServlet', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if(response.ok) {
                    showNotification('✅ Cập nhật tài khoản thành công!', 'success');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showNotification('❌ Có lỗi xảy ra khi cập nhật!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('❌ Lỗi kết nối!', 'error');
            })
            .finally(() => {
                // Restore button state
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });
    }
    
    // Xử lý form thêm tài khoản
    const addForm = document.getElementById('addAccountForm');
    if (addForm) {
        addForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate required fields
            const username = this.querySelector('input[name="username"]').value;
            const password = this.querySelector('input[name="password"]').value;
            const role = this.querySelector('select[name="role"]').value;
            
            if (!username || !password || !role) {
                showNotification('❌ Vui lòng điền đầy đủ thông tin bắt buộc!', 'error');
                return;
            }
            
            // Validate username length
            if (username.length < 5) {
                showNotification('❌ Tên tài khoản phải có ít nhất 5 ký tự!', 'error');
                return;
            }
            
            // Validate password length
            if (password.length < 8) {
                showNotification('❌ Mật khẩu phải có ít nhất 8 ký tự!', 'error');
                return;
            }
            
            const formData = new URLSearchParams(new FormData(addForm));
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';
            submitBtn.disabled = true;
            
            fetch('AccountServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => {
                if(response.ok) {
                    showNotification('✅ Thêm tài khoản thành công!', 'success');
                    setTimeout(() => {
                        closeModal('addAccountModal');
                        location.reload();
                    }, 1000);
                } else {
                    showNotification('❌ Có lỗi xảy ra khi thêm tài khoản!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('❌ Lỗi kết nối!', 'error');
            })
            .finally(() => {
                // Restore button state
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });
        
        // Reset form khi đóng modal
        document.getElementById('addAccountModal').addEventListener('click', function(e) {
            if (e.target === this) {
                addForm.reset();
            }
        });
        
        // Reset form khi click nút đóng
        document.querySelector('#addAccountModal .close-modal').addEventListener('click', function() {
            addForm.reset();
        });
    }

    // Add auto-focus to first input in modal when opened
    document.addEventListener('modalOpened', function(e) {
        const modal = document.getElementById(e.detail.modalId);
        if (modal) {
            const firstInput = modal.querySelector('input, select, textarea');
            if (firstInput) {
                setTimeout(() => firstInput.focus(), 300);
            }
        }
    });
});

// Enhanced modal open function with event
function openModal(modalId) {
    document.getElementById(modalId).style.display = 'block';
    document.body.style.overflow = 'hidden';
    
    // Dispatch custom event
    const event = new CustomEvent('modalOpened', { detail: { modalId } });
    document.dispatchEvent(event);
}

// Form validation helper
function validateForm(form) {
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#f44336';
            isValid = false;
        } else {
            input.style.borderColor = '';
        }
    });
    
    return isValid;
}

// Reset form validation styles
function resetFormValidation(form) {
    const inputs = form.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
        input.style.borderColor = '';
    });
}

// Thêm CSS animation cho notification và các style khác
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
    
    /* Loading spinner */
    .fa-spinner {
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    /* Form validation styles */
    .form-control.error {
        border-color: #f44336 !important;
        box-shadow: 0 0 0 3px rgba(244, 67, 54, 0.1) !important;
    }
    
    .error-message {
        color: #f44336;
        font-size: 12px;
        margin-top: 5px;
        display: block;
    }
`;
document.head.appendChild(style);

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