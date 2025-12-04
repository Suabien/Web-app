/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-bar input');
    
    if (searchInput) {
        // Tự động focus vào ô tìm kiếm khi nhấn Ctrl + K
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'k') {
                e.preventDefault();
                searchInput.focus();
            }
        });
        
        // Gợi ý tìm kiếm (có thể kết nối với API nếu cần)
        searchInput.addEventListener('input', function() {
            // Có thể thêm logic gợi ý ở đây
        });
    }
});