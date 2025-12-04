/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

/**
 *
 * @author Gigabyte
 */
public class Order {
    private Integer orderId;
    private Integer userId;
    private String customerName;
    private String address;
    private String phone;
    private Date orderDate;
    private String paymentMethod;
    private Integer quantity;
    private BigDecimal totalAmount;
    private String status;
    List<OrderItem> items;
    private String productName;
    private String productImage;
    private int itemCount;

    public Order() {
    }

    public Order(Integer orderId, Integer userId, String customerName, String address, String phone, Date orderDate, String paymentMethod, Integer quantity, BigDecimal totalAmount, String status, List<OrderItem> items, String productName) {
        this.orderId = orderId;
        this.userId = userId;
        this.customerName = customerName;
        this.address = address;
        this.phone = phone;
        this.orderDate = orderDate;
        this.paymentMethod = paymentMethod;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.status = status;
        this.items = items;
        this.productName = productName;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getItemCount() {
        return itemCount;
    }
    
    public void setItemCount(int itemCount) {
        this.itemCount = itemCount;
    }
}
