/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener('DOMContentLoaded', function() {
    // Chế độ chỉnh sửa
    const editBtn = document.querySelector('.btn-edit');
    const inputs = document.querySelectorAll('.profile-form input, .profile-form textarea');
    
    // Ban đầu disable tất cả input
    inputs.forEach(input => {
        input.disabled = true;
    });
    
    // Bật chế độ chỉnh sửa
    editBtn.addEventListener('click', function() {
        inputs.forEach(input => {
            input.disabled = false;
            input.focus();
        });
        
        // Hiệu ứng focus vào field đầu tiên
        if (inputs.length > 0) {
            inputs[0].focus();
        }
    });
    
    // Xử lý upload ảnh đại diện
    const avatar = document.querySelector('.profile-avatar');
    const avatarInput = document.createElement('input');
    avatarInput.type = 'file';
    avatarInput.accept = 'image/*';
    avatarInput.style.display = 'none';
    
    avatar.addEventListener('click', function() {
        avatarInput.click();
    });
    
    avatarInput.addEventListener('change', function(e) {
        if (e.target.files && e.target.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(event) {
                avatar.querySelector('img').src = event.target.result;
                
                // Hiệu ứng khi thay đổi ảnh
                avatar.style.transform = 'scale(1.1)';
                setTimeout(() => {
                    avatar.style.transform = 'scale(1)';
                }, 300);
            }
            
            reader.readAsDataURL(e.target.files[0]);
        }
    });
});