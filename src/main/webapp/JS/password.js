/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener('DOMContentLoaded', function () {
    // Toggle password visibility
    document.querySelectorAll('.toggle-password').forEach(icon => {
        icon.addEventListener('click', function () {
            const target = document.getElementById(this.dataset.target);
            const isPassword = target.type === 'password';

            target.type = isPassword ? 'text' : 'password';
            this.classList.toggle('fa-eye', !isPassword);
            this.classList.toggle('fa-eye-slash', isPassword);
        });
    });

    const newPasswordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const strengthBars = document.querySelectorAll('.strength-bar');
    const strengthText = document.querySelector('.strength-text');
    const passwordMatch = document.querySelector('.password-match');
    const form = document.getElementById('changePasswordForm');

    // Evaluate password strength
    newPasswordInput.addEventListener('input', function () {
        const password = this.value;
        const strength = evaluateStrength(password);

        strengthBars.forEach((bar, index) => {
            bar.style.backgroundColor = index < strength ? getStrengthColor(strength) : '#eee';
        });

        strengthText.textContent = getStrengthText(strength);
        strengthText.style.color = getStrengthColor(strength);
    });

    // Confirm password match
    confirmPasswordInput.addEventListener('input', function () {
        const match = this.value === newPasswordInput.value;

        if (this.value.length === 0) {
            passwordMatch.classList.remove('show');
        } else {
            passwordMatch.innerHTML = match
                ? '<i class="fas fa-check-circle"></i> Mật khẩu khớp'
                : '<i class="fas fa-times-circle"></i> Mật khẩu không khớp';
            passwordMatch.style.color = match ? '#28a745' : '#dc3545';
            passwordMatch.classList.add('show');
        }
    });

    // Form submission
    form.addEventListener('submit', function (e) {
        e.preventDefault();

        const currentPassword = document.getElementById('currentPassword').value;
        const newPassword = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        // Kiểm tra client-side
        if (!currentPassword.trim()) {
            alert('Vui lòng nhập mật khẩu hiện tại');
            return;
        }

        if (newPassword.length < 8) {
            alert('Mật khẩu mới phải có ít nhất 8 ký tự');
            return;
        }

        if (newPassword !== confirmPassword) {
            alert('Mật khẩu xác nhận không khớp');
            return;
        }

        // Xác định context path (nếu đã khai báo trong JSP), nếu không dùng giá trị mặc định
        const base = (typeof contextPath !== 'undefined')
            ? contextPath
            : '/2274820014_NguyenThuHienn';
        const url = base + '/ChangePasswordServlet';

        // Gửi yêu cầu đổi mật khẩu đến server
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `currentPassword=${encodeURIComponent(currentPassword)}&newPassword=${encodeURIComponent(newPassword)}&confirmPassword=${encodeURIComponent(confirmPassword)}`
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(html => { throw new Error('Server error'); });
            }
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                form.reset();
                // Reset indicators
                strengthBars.forEach(bar => bar.style.backgroundColor = '#eee');
                strengthText.textContent = 'Độ mạnh mật khẩu';
                strengthText.style.color = '#999';
                passwordMatch.classList.remove('show');
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert(error.message || 'Lỗi khi đổi mật khẩu');
        });
    });

    // Helper functions
    function evaluateStrength(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;
        return strength;
    }

    function getStrengthColor(strength) {
        return ['#999', '#dc3545', '#fd7e14', '#ffc107', '#28a745'][strength] || '#999';
    }

    function getStrengthText(strength) {
        return ['Độ mạnh mật khẩu', 'Yếu', 'Trung bình', 'Tốt', 'Mạnh'][strength] || 'Độ mạnh mật khẩu';
    }
});
