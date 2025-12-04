/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.HomeProduct;
import Model.Product;
import DAO.DatabaseConnection; 

public class ProductDAO {
    
    // Lấy danh sách sản phẩm theo type_id (category)
    public List<HomeProduct> getProductsByCategory(int categoryId) {
        List<HomeProduct> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                HomeProduct product = new HomeProduct();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImage_url(rs.getString("image_url"));
                product.setPrice(rs.getString("price"));  
                product.setRating(rs.getFloat("rating"));
                product.setSold(rs.getInt("sold"));
                product.setType_id(rs.getInt("type_id"));
                
                products.add(product);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    // Lấy sản phẩm theo ID
    public HomeProduct getProductById(int productId) {
        HomeProduct product = null;
        String sql = "SELECT * FROM products WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                product = new HomeProduct();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImage_url(rs.getString("image_url"));
                product.setPrice(rs.getString("price"));
                product.setRating(rs.getFloat("rating"));
                product.setSold(rs.getInt("sold"));
                product.setType_id(rs.getInt("type_id"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return product;
    }

    // THÊM MỚI: Lấy tất cả sản phẩm (cho dropdown trong quản lý option)
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImage_url(rs.getString("image_url"));
                product.setPrice(rs.getString("price"));
                product.setQuantity(rs.getInt("quantity"));
                product.setRating(rs.getFloat("rating"));
                product.setRate_count(rs.getInt("rate_count"));
                product.setSold(rs.getInt("sold"));
                product.setType_id(rs.getInt("type_id"));
                product.setDescription(rs.getString("description"));
                product.setOrigin(rs.getString("origin"));
                
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // THÊM MỚI: Lấy sản phẩm theo ID (cho Model.Product)
    public Product getProductByIdFull(int productId) {
        Product product = null;
        String sql = "SELECT * FROM products WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImage_url(rs.getString("image_url"));
                product.setPrice(rs.getString("price"));
                product.setQuantity(rs.getInt("quantity"));
                product.setRating(rs.getFloat("rating"));
                product.setRate_count(rs.getInt("rate_count"));
                product.setSold(rs.getInt("sold"));
                product.setType_id(rs.getInt("type_id"));
                product.setDescription(rs.getString("description"));
                product.setOrigin(rs.getString("origin"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return product;
    }

    // THÊM MỚI: Thêm sản phẩm mới
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, image_url, price, quantity, rating, sold, type_id, description, origin, rate_count) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getImage_url());
            stmt.setString(3, product.getPrice());
            stmt.setInt(4, product.getQuantity());
            stmt.setFloat(5, product.getRating());
            stmt.setInt(6, product.getSold());
            stmt.setInt(7, product.getType_id());
            stmt.setString(8, product.getDescription());
            stmt.setString(9, product.getOrigin());
            stmt.setInt(10, product.getRate_count());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // THÊM MỚI: Cập nhật sản phẩm
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, image_url = ?, price = ?, quantity = ?, rating = ?, sold = ?, type_id = ?, description = ?, origin = ?, rate_count = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getImage_url());
            stmt.setString(3, product.getPrice());
            stmt.setInt(4, product.getQuantity());
            stmt.setFloat(5, product.getRating());
            stmt.setInt(6, product.getSold());
            stmt.setInt(7, product.getType_id());
            stmt.setString(8, product.getDescription());
            stmt.setString(9, product.getOrigin());
            stmt.setInt(10, product.getRate_count());
            stmt.setInt(11, product.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // THÊM MỚI: Xóa sản phẩm
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // THÊM MỚI: Tìm kiếm sản phẩm theo tên
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? ORDER BY id DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImage_url(rs.getString("image_url"));
                product.setPrice(rs.getString("price"));
                product.setQuantity(rs.getInt("quantity"));
                product.setRating(rs.getFloat("rating"));
                product.setRate_count(rs.getInt("rate_count"));
                product.setSold(rs.getInt("sold"));
                product.setType_id(rs.getInt("type_id"));
                product.setDescription(rs.getString("description"));
                product.setOrigin(rs.getString("origin"));
                
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // THÊM MỚI: Lấy sản phẩm theo loại (type_id)
    public List<Product> getProductsByType(int typeId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type_id = ? ORDER BY id DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, typeId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImage_url(rs.getString("image_url"));
                product.setPrice(rs.getString("price"));
                product.setQuantity(rs.getInt("quantity"));
                product.setRating(rs.getFloat("rating"));
                product.setRate_count(rs.getInt("rate_count"));
                product.setSold(rs.getInt("sold"));
                product.setType_id(rs.getInt("type_id"));
                product.setDescription(rs.getString("description"));
                product.setOrigin(rs.getString("origin"));
                
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}