/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/* ================== User popup ================== */
function toggleUserInfo() {
  const popup = document.getElementById("userInfoPopup");
  if (!popup) return;
  const shown = popup.classList.contains("show") || popup.style.display === "block";
  popup.style.display = shown ? "none" : "block";
  popup.classList.toggle("show", !shown);
}

document.addEventListener("click", (e) => {
  const avatar = document.querySelector(".user-avatar");
  const popup  = document.getElementById("userInfoPopup");
  if (!popup) return;
  if (avatar && (avatar.contains(e.target) || popup.contains(e.target))) return;
  popup.style.display = "none";
  popup.classList.remove("show");
});

window.addEventListener("scroll", () => {
  const popup = document.getElementById("userInfoPopup");
  if (popup && (popup.classList.contains("show") || popup.style.display === "block")) {
    popup.style.display = "none";
    popup.classList.remove("show");
  }
});

/* ================== Helpers ================== */
const $      = (sel, root) => (root || document).querySelector(sel);
const byId   = (id) => document.getElementById(id);
const setVal = (id, v) => { const el = byId(id); if (el) el.value = (v ?? ""); };

function ensureSelectValue(selectEl){
  if (!selectEl) return;
  if (!selectEl.value) {
    const idx = Array.from(selectEl.options).findIndex(o => o.value && !o.disabled);
    if (idx > -1) selectEl.selectedIndex = idx;
  }
}

/* ================== Modal ================== */
function openModal(id) {
  const el = byId(id);
  if (!el) return;
  el.style.display = "block";              // nếu CSS dùng flex thì đổi thành "flex"
  el.classList.add("show");

  if (id === "addProductModal") {
    const sel = $("#addProductModal select[name='type_id']");
    ensureSelectValue(sel);
  }
}

function closeModal(id) {
  const el = byId(id);
  if (!el) return;
  el.style.display = "none";
  el.classList.remove("show");
}

/* 
 * Click nền / ngoài modal để đóng
 * >>> FIX: bỏ đóng khi click vào nút .btn-add / .btn-edit để tránh vừa mở đã tắt
 */
document.addEventListener("click", (e) => {
  // Nếu click trong modal-content hoặc nút mở modal thì bỏ qua
  if (e.target.closest(".modal-content") ||
      e.target.closest(".btn-add") ||
      e.target.closest(".btn-edit")) {
    return;
  }

  document.querySelectorAll(".modal.show").forEach((m) => {
    // đóng khi click trực tiếp lên overlay hoặc ngoài toàn bộ modal
    if (m === e.target || !m.contains(e.target)) {
      closeModal(m.id);
    }
  });
});

// ESC để đóng tất cả modal
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    document.querySelectorAll(".modal").forEach((m) => {
      if (m.classList.contains("show")) closeModal(m.id);
    });
  }
});

/* ================== Preview ảnh ================== */
function previewImage(input, previewId) {
  const file = input && input.files && input.files[0];
  const img  = byId(previewId);
  if (!img) return;

  if (file) {
    const r = new FileReader();
    r.onload = (e) => { img.src = e.target.result; img.style.display = "block"; };
    r.readAsDataURL(file);
  } else {
    img.src = ""; 
    img.style.display = "none";
  }
}

/* ================== XÓA (POST form ẩn) ================== */
// Không hiện confirm, submit thẳng về servlet
function deleteItem(id) {
  if (!id) return;
  const form = byId("deleteForm");
  const hid  = byId("delete-id");
  if (!form || !hid) { 
    console.error("Thiếu deleteForm/delete-id"); 
    return; 
  }
  hid.value = id;
  form.submit(); // POST -> /NccProductServlet?action=delete&id=...
}

/* ================== Tính tồn kho hiển thị (optional) ================== */
function updateComputedStock() {
  const qEl = byId("edit-quantity");
  const sEl = byId("edit-sold");          // hidden/readonly input (không name) để lưu sold
  const soldView  = byId("edit-sold-view");
  const stockView = byId("edit-stock-view");

  if (!qEl || !sEl) return;

  const q = Number(qEl.value || 0);
  const s = Number(sEl.value || 0);
  const stock = Math.max(0, q - s);

  if (soldView)  soldView.textContent  = s;
  if (stockView) stockView.textContent = stock;
}

// Tự cập nhật khi nhập quantity
document.addEventListener("input", (e) => {
  if (e.target && e.target.id === "edit-quantity") {
    updateComputedStock();
  }
});

/* ================== SỬA (fill modal) ================== */
/**
 * JSP gọi:
 * openEditModal(id, name, price, qtyOrStock, typeId, desc, imgUrl, sold)
 */
function openEditModal(id, name, price, qtyOrStock, typeId, desc, imgUrl, sold) {
  // Suy luận quantity an toàn
  let quantity = Number(qtyOrStock);
  const hasSold = sold !== undefined && sold !== null && sold !== "" && !isNaN(Number(sold));
  if (hasSold) {
    const soldNum = Number(sold);
    if (!isNaN(quantity) && quantity >= 0 && quantity < soldNum) {
      // qtyOrStock có vẻ là stock -> convert sang quantity
      const stockNum = isNaN(Number(qtyOrStock)) ? 0 : Number(qtyOrStock);
      quantity = soldNum + stockNum;
    }
  }

  setVal("edit-id", id);
  setVal("edit-name", name);
  setVal("edit-price", price);
  setVal("edit-quantity", isNaN(quantity) ? 0 : quantity);
  setVal("edit-description", desc);

  // Lưu sold (để tính stock hiển thị). KHÔNG đặt name cho input này.
  const soldInput = byId("edit-sold");
  if (soldInput) soldInput.value = hasSold ? Number(sold) : 0;

  // Loại sản phẩm
  const typeField = byId("edit-type-id");
  if (typeField) {
    if (typeId !== undefined && typeId !== null) {
      typeField.value = typeId;
    } else {
      typeField.value = "";
    }
    if (typeField.tagName === "SELECT") {
      const ok = Array.from(typeField.options).some(o => o.value == typeId);
      if (!ok) ensureSelectValue(typeField);
    }
  }

  // Ảnh preview
  const prev = byId("edit-image-preview");
  if (prev) {
    if (imgUrl) { 
      prev.src = imgUrl; 
      prev.style.display = "block"; 
    } else { 
      prev.src = "";     
      prev.style.display = "none";  
    }
  }

  openModal("editProductModal");
  updateComputedStock(); // hiển thị sold & stock ngay khi mở
}

/* ================== Expose global ================== */
window.toggleUserInfo      = toggleUserInfo;
window.openModal           = openModal;
window.closeModal          = closeModal;
window.previewImage        = previewImage;
window.deleteItem          = deleteItem;
window.openEditModal       = openEditModal;
window.updateComputedStock = updateComputedStock;
