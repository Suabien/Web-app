package Controller;

import Model.Product;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;

/**
 *
 * @author Gigabyte
 */
@MultipartConfig
@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> productList = new ArrayList<>();
        String dbURL = "jdbc:mysql://localhost:3306/trangsuc_db";
        String dbUser = "root";
        String dbPassword = "hien031204";

        String query = "SELECT p.*, t.type_name FROM products p JOIN type_product t ON p.type_id = t.type_id";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("image_url"),
                    rs.getString("price"),
                    rs.getInt("quantity"),
                    rs.getFloat("rating"),
                    rs.getInt("rate_count"),
                    rs.getInt("sold"),
                    rs.getInt("type_id"),
                    rs.getString("type_name"),
                    rs.getString("description"),
                    rs.getString("origin") 
                );
                productList.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set the product list as a request attribute
        request.setAttribute("products", productList);

        // Forward the request to manage.jsp
        request.getRequestDispatcher("/Admin/manage2.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addProduct(request, response);
        } else if ("edit".equals(action)) {
            editProduct(request, response);
        } else if ("delete".equals(action)) {
            deleteProduct(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int typeId = Integer.parseInt(request.getParameter("type_id"));
        String description = request.getParameter("description");
        String origin = request.getParameter("origin"); 
        
        // Xử lý upload ảnh
        Part filePart = request.getPart("image");
        String imageUrl = "";
        
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            imageUrl = "uploads/" + fileName;
            filePart.write(uploadPath + File.separator + fileName);
        }

        String dbURL = "jdbc:mysql://localhost:3306/trangsuc_db";
        String dbUser = "root";
        String dbPassword = "hien031204";
        String query = "INSERT INTO products (name, image_url, price, quantity, rating, sold, type_id, description, origin) VALUES (?, ?, ?, ?, 0, 0, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setString(2, imageUrl);
            ps.setString(3, price);
            ps.setInt(4, quantity);
            ps.setInt(5, typeId);
            ps.setString(6, description);
            ps.setString(7, origin);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ProductServlet");
    }

    private void editProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int typeId = Integer.parseInt(request.getParameter("type_id"));
        String description = request.getParameter("description");
        String origin = request.getParameter("origin"); 
        
        // Xử lý upload ảnh mới (nếu có)
        Part filePart = request.getPart("image");
        String imageUrl = "";
        
        String dbURL = "jdbc:mysql://localhost:3306/trangsuc_db";
        String dbUser = "root";
        String dbPassword = "hien031204";
        
        // Nếu có ảnh mới được upload
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            imageUrl = "uploads/" + fileName;
            filePart.write(uploadPath + File.separator + fileName);
            
            // Cập nhật cả ảnh mới
            String query = "UPDATE products SET name = ?, image_url = ?, price = ?, quantity = ?, type_id = ?, description = ?, origin = ? WHERE id = ?";
            
            try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, name);
                ps.setString(2, imageUrl);
                ps.setString(3, price);
                ps.setInt(4, quantity);
                ps.setInt(5, typeId);
                ps.setString(6, description);
                ps.setString(7, origin); // Thêm xuất xứ
                ps.setInt(8, id);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Không cập nhật ảnh
            String query = "UPDATE products SET name = ?, price = ?, quantity = ?, type_id = ?, description = ?, origin = ? WHERE id = ?";
            
            try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, name);
                ps.setString(2, price);
                ps.setInt(3, quantity);
                ps.setInt(4, typeId);
                ps.setString(5, description);
                ps.setString(6, origin); // Thêm xuất xứ
                ps.setInt(7, id);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("ProductServlet");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        String dbURL = "jdbc:mysql://localhost:3306/trangsuc_db";
        String dbUser = "root";
        String dbPassword = "hien031204";
        String query = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ProductServlet");
    }

    @Override
    public String getServletInfo() {
        return "ProductServlet handles product management";
    }
}
