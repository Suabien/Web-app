/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;

/**
 *
 * @author hathuu24
 */

public class OrderView {
    private int id;
    private String orderDate;   // yyyy-MM-dd (đã format trong SQL)
    private int total;          // số lượng
    private String status;      // đúng chuỗi TV trong DB
    private String reason;      // có thể null

    // shops
    private String shopName;
    private String sellerName;
    private String address;
    private String phone;

    // product + option
    private String productName;
    private String productImage;
    private String optionName;
    private String optionPrice;

    // ===== getters/setters =====
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public String getOptionName() { return optionName; }
    public void setOptionName(String optionName) { this.optionName = optionName; }

    public String getOptionPrice() { return optionPrice; }
    public void setOptionPrice(String optionPrice) { this.optionPrice = optionPrice; }
}
