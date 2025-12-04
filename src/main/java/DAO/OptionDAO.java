/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Option;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OptionDAO {
    private Connection connection;

    public OptionDAO() {
        this.connection = DatabaseConnection.getConnection();
    }

    public List<Option> getAllOptions() {
        List<Option> options = new ArrayList<>();
        String sql = "SELECT po.*, p.name as product_name " +
                    "FROM product_option po " +
                    "LEFT JOIN products p ON po.product_id = p.id " +
                    "ORDER BY po.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Option option = new Option();
                option.setId(rs.getInt("id"));
                option.setProduct_id(rs.getInt("product_id"));
                option.setProduct_name(rs.getString("product_name"));
                option.setOption_name(rs.getString("option_name"));
                option.setPrice(rs.getString("price"));
                option.setQuantity(rs.getInt("quantity"));
                option.setImage(rs.getString("image"));
                
                options.add(option);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }

    public Option getOptionById(int id) {
        Option option = null;
        String sql = "SELECT po.*, p.name as product_name " +
                    "FROM product_option po " +
                    "LEFT JOIN products p ON po.product_id = p.id " +
                    "WHERE po.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    option = new Option();
                    option.setId(rs.getInt("id"));
                    option.setProduct_id(rs.getInt("product_id"));
                    option.setProduct_name(rs.getString("product_name"));
                    option.setOption_name(rs.getString("option_name"));
                    option.setPrice(rs.getString("price"));
                    option.setQuantity(rs.getInt("quantity"));
                    option.setImage(rs.getString("image"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return option;
    }

    public boolean addOption(Option option) {
        String sql = "INSERT INTO product_option (product_id, option_name, price, quantity, image) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, option.getProduct_id());
            stmt.setString(2, option.getOption_name());
            stmt.setString(3, option.getPrice());
            stmt.setInt(4, option.getQuantity());
            stmt.setString(5, option.getImage());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateOption(Option option) {
        String sql = "UPDATE product_option SET product_id = ?, option_name = ?, price = ?, quantity = ?, image = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, option.getProduct_id());
            stmt.setString(2, option.getOption_name());
            stmt.setString(3, option.getPrice());
            stmt.setInt(4, option.getQuantity());
            stmt.setString(5, option.getImage());
            stmt.setInt(6, option.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteOption(int id) {
        String sql = "DELETE FROM product_option WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Option> getOptionsByProductId(int productId) {
        List<Option> options = new ArrayList<>();
        String sql = "SELECT * FROM product_option WHERE product_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Option option = new Option();
                    option.setId(rs.getInt("id"));
                    option.setProduct_id(rs.getInt("product_id"));
                    option.setOption_name(rs.getString("option_name"));
                    option.setPrice(rs.getString("price"));
                    option.setQuantity(rs.getInt("quantity"));
                    option.setImage(rs.getString("image"));
                    
                    options.add(option);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }
}