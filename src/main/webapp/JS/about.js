/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Scroll to about section when clicking hero scroll button
    const heroScroll = document.querySelector('.hero-scroll');
    if (heroScroll) {
        heroScroll.addEventListener('click', function() {
            const aboutSection = document.querySelector('.about-section');
            if (aboutSection) {
                window.scrollTo({
                    top: aboutSection.offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    }
    
    // Animate elements when scrolling
    const animateOnScroll = function() {
        const elements = document.querySelectorAll('.value-card, .gallery-item, .craft-grid > div');
        
        elements.forEach(element => {
            const elementPosition = element.getBoundingClientRect().top;
            const windowHeight = window.innerHeight;
            
            if (elementPosition < windowHeight - 100) {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }
        });
    };
    
    // Set initial state for animated elements
    const animatedElements = document.querySelectorAll('.value-card, .gallery-item, .craft-grid > div');
    animatedElements.forEach(element => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(30px)';
        element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    });
    
    // Run once on load
    animateOnScroll();
    
    // Then on scroll
    window.addEventListener('scroll', animateOnScroll);
    
    // Gallery item click effect
    const galleryItems = document.querySelectorAll('.gallery-item');
    galleryItems.forEach(item => {
        item.addEventListener('click', function() {
            // Here you could add a lightbox effect or navigation
            console.log('Gallery item clicked:', this.querySelector('h3').textContent);
        });
    });
});