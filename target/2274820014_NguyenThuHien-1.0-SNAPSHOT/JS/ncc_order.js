/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* Popup avatar */
function toggleUserInfo() {
  const p = document.getElementById("userInfoPopup");
  if (!p) return;
  const shown = p.classList.contains("show") || p.style.display === "block";
  p.style.display = shown ? "none" : "block";
  p.classList.toggle("show", !shown);
}

/* Gửi form đổi trạng thái */
function advanceStatus(id, viStatus) {
  const f = document.getElementById("orderActionForm");
  if (!f) return;
  document.getElementById("oa-action").value = "advance";
  document.getElementById("oa-id").value     = String(id);
  document.getElementById("oa-status").value = String(viStatus);
  f.submit();
}

/* Helpers */
function ctxPath() {
  const ctx = (document.body && document.body.dataset && document.body.dataset.ctx) || "";
  return ctx;
}
function setTxt(id, v) {
  const el = document.getElementById(id);
  if (el) el.textContent = v ?? "";
}

/* Mở modal (lấy dữ liệu từ data-*) */
function openOrderModal(btn) {
  const m = document.getElementById("orderDetailModal");
  if (!m || !btn) return;

  const d = btn.dataset;
  const get = (k, def="") => {
    const v = d[k];
    return (v && String(v).trim().length>0) ? v : def;
  };

  setTxt("odm-id",        "#" + get("id"));
  setTxt("odm-shop",      get("shop"));
  setTxt("odm-seller",    get("seller"));
  setTxt("odm-address",   get("address"));
  setTxt("odm-phone",     get("phone"));
  setTxt("odm-orderdate", get("orderdate"));
  setTxt("odm-status",    get("status"));
  setTxt("odm-qty",       get("total"));
  setTxt("odm-reason",    get("reason") || "—");

  setTxt("odm-product",       get("product"));
  setTxt("odm-option",        get("option"));
  setTxt("odm-option-price",  get("optionprice"));

  const img = document.getElementById("odm-product-img");
  if (img) {
    const fallback = ctxPath() + "/Images/sanpham1.jpg";
    img.src = get("productimg", fallback) || fallback;
  }

  m.style.display = "flex";
}
function closeOrderModal(){
  const m = document.getElementById("orderDetailModal");
  if (m) m.style.display = "none";
}

/* Tự bind tất cả nút .btn-view[data-id] */
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".btn-view[data-id]").forEach(btn => {
    btn.addEventListener("click", () => openOrderModal(btn));
  });
});

/* Đóng avatar khi click ra ngoài */
document.addEventListener("click", (e) => {
  const popup  = document.getElementById("userInfoPopup");
  const avatar = document.querySelector(".user-avatar");
  if (!popup) return;
  if (avatar && (avatar.contains(e.target) || popup.contains(e.target))) return;
  popup.style.display = "none";
  popup.classList.remove("show");
});

/* Đóng avatar khi cuộn */
window.addEventListener("scroll", () => {
  const popup = document.getElementById("userInfoPopup");
  if (popup && (popup.classList.contains("show") || popup.style.display === "block")) {
    popup.style.display = "none";
    popup.classList.remove("show");
  }
});

/* expose */
window.toggleUserInfo  = toggleUserInfo;
window.advanceStatus   = advanceStatus;
window.openOrderModal  = openOrderModal;
window.closeOrderModal = closeOrderModal;
