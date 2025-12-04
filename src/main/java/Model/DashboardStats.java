/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;

public class DashboardStats {
    private int totalUsers;
    private int totalProducts;
    private int totalOrders;
    private BigDecimal totalRevenue;
    private BigDecimal monthlyRevenue;
    private int pendingOrders;
    private int completedOrders;
    private int newCustomers;
    
    // Constructors
    public DashboardStats() {}
    
    public DashboardStats(int totalUsers, int totalProducts, int totalOrders, 
                         BigDecimal totalRevenue, BigDecimal monthlyRevenue, 
                         int pendingOrders, int completedOrders, int newCustomers) {
        this.totalUsers = totalUsers;
        this.totalProducts = totalProducts;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
        this.monthlyRevenue = monthlyRevenue;
        this.pendingOrders = pendingOrders;
        this.completedOrders = completedOrders;
        this.newCustomers = newCustomers;
    }
    
    // Getters and Setters
    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
    
    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
    
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    
    public BigDecimal getMonthlyRevenue() { return monthlyRevenue; }
    public void setMonthlyRevenue(BigDecimal monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
    
    public int getPendingOrders() { return pendingOrders; }
    public void setPendingOrders(int pendingOrders) { this.pendingOrders = pendingOrders; }
    
    public int getCompletedOrders() { return completedOrders; }
    public void setCompletedOrders(int completedOrders) { this.completedOrders = completedOrders; }
    
    public int getNewCustomers() { return newCustomers; }
    public void setNewCustomers(int newCustomers) { this.newCustomers = newCustomers; }
}

