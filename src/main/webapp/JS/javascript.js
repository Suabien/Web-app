let slideIndex = 0;

// Kiểm tra nếu có slide thì mới chạy slideshow
const slides = document.getElementsByClassName("slide");
if (slides.length > 0) {
    showSlides();
}

// Chạy slideshow
function showSlides() {
    if (slides.length === 0) return;

    for (let i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }

    slideIndex++;
    if (slideIndex > slides.length) slideIndex = 1;
    slides[slideIndex - 1].style.display = "block";
    setTimeout(showSlides, 3000); // Đổi ảnh mỗi 3 giây
}

// Chuyển slide thủ công
function changeSlide(n) {
    if (slides.length === 0) return;

    slideIndex += n;
    if (slideIndex > slides.length) slideIndex = 1;
    if (slideIndex < 1) slideIndex = slides.length;

    for (let i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }
    slides[slideIndex - 1].style.display = "block";
}

// Nút cuộn lên đầu trang
const scrollToTopBtn = document.getElementById('scroll');
if (scrollToTopBtn) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            scrollToTopBtn.classList.add('show');
        } else {
            scrollToTopBtn.classList.remove('show');
        }
    });

    scrollToTopBtn.addEventListener('click', () => {
        window.scrollTo({ 
            top: 0, 
            behavior: 'smooth' 
        });
        
        // Thêm hiệu ứng nhấn
        scrollToTopBtn.style.transform = 'scale(0.95)';
        setTimeout(() => {
            scrollToTopBtn.style.transform = '';
        }, 200);
    });
    
    // Hiệu ứng khi di chuột vào
    scrollToTopBtn.addEventListener('mouseenter', () => {
        scrollToTopBtn.style.opacity = '1';
    });
    
    scrollToTopBtn.addEventListener('mouseleave', () => {
        scrollToTopBtn.style.opacity = '0.9';
    });
}

// Đóng popup
function closePopup() {
    const popup = document.querySelector('.popup-overlay');
    if (popup) popup.style.display = 'none';
}

// Tự động đóng popup sau 3 giây
setTimeout(() => closePopup(), 3000);

// Cuộn mượt tới phần liên hệ
const contactLink = document.querySelector('a[href="#contact"]');
if (contactLink) {
    contactLink.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector('#contact');
        if (target) {
            const headerOffset = 10;
            const offsetPosition = target.getBoundingClientRect().top + window.scrollY - headerOffset;
            window.scrollTo({ top: offsetPosition, behavior: 'smooth' });
        }
    });
}

// Xử lý cuộn khi click vào danh mục sản phẩm
document.querySelectorAll('.sidebar a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        
        const targetId = this.getAttribute('href');
        const targetElement = document.querySelector(targetId);
        
        if (targetElement) {
            const headerOffset = 250; // Chiều cao của header
            const elementPosition = targetElement.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
            
            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            });
            
            // Thêm hiệu ứng highlight (tùy chọn)
            targetElement.style.animation = 'highlight 1.5s';
            setTimeout(() => {
                targetElement.style.animation = '';
            }, 1500);
        }
    });
});

