/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// Hiển thị popup nếu có thông báo
document.addEventListener('DOMContentLoaded', function() {
    initRoleSelection();
    const popup = document.getElementById('popup');
    if (popup) {
        popup.classList.add('active');
    }
    
    // Slideshow background
    const slides = document.querySelectorAll('.bg-slide');
    let currentSlide = 0;
    
    function nextSlide() {
        slides[currentSlide].classList.remove('active');
        currentSlide = (currentSlide + 1) % slides.length;
        slides[currentSlide].classList.add('active');
    }
    
    setInterval(nextSlide, 5000);
});

function closePopup() {
    const popup = document.getElementById('popup');
    if (popup) {
        popup.classList.remove('active');
    }
}

function showRegister() {
    document.getElementById('loginForm').style.display = 'none';
    document.getElementById('registerForm').style.display = 'block';
}

function showLogin() {
    document.getElementById('registerForm').style.display = 'none';
    document.getElementById('loginForm').style.display = 'block';
}

// Hiển thị form đúng theo action từ server (nếu có)
document.addEventListener('DOMContentLoaded', function() {
    const action = '<%= request.getAttribute("action") != null ? request.getAttribute("action") : "" %>';
    if (action === 'register') {
        showRegister();
    } else if (action === 'login') {
        showLogin();
    }
});

// Role Selection Functionality
function initRoleSelection() {
    const roleOptions = document.querySelectorAll('.role-option');
    const roleInput = document.getElementById('selectedRole');
    
    if (roleOptions.length > 0 && roleInput) {
        roleOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Remove selected class from all options
                roleOptions.forEach(opt => opt.classList.remove('selected'));
                
                // Add selected class to clicked option
                this.classList.add('selected');
                
                // Update hidden input value
                const selectedRole = this.getAttribute('data-role');
                roleInput.value = selectedRole;
            });
        });
    }
}