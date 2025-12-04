/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
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
(() => {
  "use strict";

  // ===== Shortcuts =====
  const $  = (sel) => document.querySelector(sel);
  const $$ = (sel) => Array.from(document.querySelectorAll(sel));
  const byId = (id) => document.getElementById(id);

  // ===== Modal helpers =====
  function openModal(id) {
    const el = byId(id);
    if (el) el.style.display = "block";
  }
  function closeModal(id) {
    const el = byId(id);
    if (el) el.style.display = "none";
  }

  // ===== Image preview =====
  function previewImage(input, previewBoxId) {
    const file = input?.files?.[0];
    const box  = byId(previewBoxId);
    if (!box) return;

    // Nếu khung preview là <img>
    if (box.tagName.toLowerCase() === "img") {
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          box.src = e.target.result;
          box.style.display = "block";
        };
        reader.readAsDataURL(file);
      } else {
        box.src = "";
        box.style.display = "none";
      }
      return;
    }

    // Nếu khung preview là <div class="image-preview"> chứa <span>
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        box.innerHTML = `<img alt="Preview" style="max-width:100%;max-height:150px;border-radius:8px;" src="${e.target.result}">`;
      };
      reader.readAsDataURL(file);
    } else {
      box.innerHTML = `<span>Chưa có ảnh được chọn</span>`;
    }
  }

  // ===== Fill edit modal & open =====
  // JSP gọi: openEditModal(id, optionName, price, quantity, imageUrl, productId)
  function openEditModal(id, name, price, quantity, imageUrl, productId) {
    // Hidden id
    const idEl = byId("edit-id");
    if (idEl) idEl.value = id || "";

    // Fields
    const nameEl = byId("edit-option-name");
    const priceEl = byId("edit-price");
    const qtyEl = byId("edit-quantity");
    const prodEl = byId("edit-product-id");
    if (nameEl) nameEl.value = name || "";
    if (priceEl) priceEl.value = price || "";
    if (qtyEl) qtyEl.value = quantity || 0;
    if (prodEl) prodEl.value = productId || "";

    // Current image preview (img tag)
    const imgPrev = byId("current-image-preview") || byId("edit-image-preview");
    if (imgPrev) {
      if (imageUrl) {
        imgPrev.src = imageUrl;
        imgPrev.style.display = "block";
      } else {
        imgPrev.removeAttribute("src");
        imgPrev.style.display = "none";
      }
    }

    openModal("editOptionModal");
  }

  // ===== Delete flow =====
  function deleteItem(id) {
    if (!id) return;
    if (confirm("Xác nhận xoá loại sản phẩm #" + id + " ?")) {
      const form = byId("deleteForm");
      const delId = byId("delete-id");
      if (form && delId) {
        delId.value = id;
        form.submit();
      }
    }
  }

  // ===== Optional: sanitize price input to digits only (keeps last non-digit removed) =====
  function attachPriceSanitizer() {
    const priceInputs = $$("#addOptionForm input[name='price'], #editOptionForm input[name='price']");
    priceInputs.forEach(inp => {
      inp.addEventListener("input", () => {
        // Cho phép số và dấu chấm/phẩy, loại ký tự khác
        let v = inp.value.replace(/[^\d.,]/g, "");
        // Chuẩn hoá phẩy -> chấm (tuỳ DB)
        v = v.replace(/,/g, ".");
        inp.value = v;
      });
    });
  }

  // ===== Expose to global for JSP inline onclick =====
  window.toggleUserInfo = toggleUserInfo;
  window.openModal = openModal;
  window.closeModal = closeModal;
  window.previewImage = previewImage;
  window.openEditModal = openEditModal;
  window.deleteItem = deleteItem;

  // ===== Init =====
  document.addEventListener("click", handleDocClick);
  document.addEventListener("DOMContentLoaded", attachPriceSanitizer);
})();


