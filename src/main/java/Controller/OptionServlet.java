/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Option;
import Model.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(name = "OptionServlet", urlPatterns = {"/OptionServlet"})
public class OptionServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Option> listOption = new ArrayList<>();
        List<Product> productList = new ArrayList<>();

        String dbURL = "jdbc:mysql://localhost:3306/trangsuc_db";
        String dbUser = "root";
        String dbPassword = "hien031204";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
            // Lấy danh sách option - SẮP XẾP THEO ID TĂNG DẦN
            String query = "SELECT o.*, p.name AS product_name FROM product_option o JOIN products p ON o.product_id = p.id ORDER BY o.id ASC";
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Option opt = new Option(
                        rs.getInt("id"),
                        rs.getString("product_name"),
                        rs.getInt("product_id"),
                        rs.getString("option_name"),
                        rs.getString("price"),
                        rs.getInt("quantity"),
                        formatImagePath(rs.getString("image"))
                    );
                    listOption.add(opt);
                }
            }

            // Lấy danh sách sản phẩm
            String productQuery = "SELECT id, name FROM products ORDER BY name";
            try (PreparedStatement ps2 = conn.prepareStatement(productQuery);
                 ResultSet rs2 = ps2.executeQuery()) {
                while (rs2.next()) {
                    Product product = new Product();
                    product.setId(rs2.getInt("id"));
                    product.setName(rs2.getString("name"));
                    productList.add(product);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
        }

        request.setAttribute("listOption", listOption);
        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/Admin/manage3.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            doGet(request, response);
            return;
        }

        switch (action) {
            case "add":
                addOption(request, response);
                break;
            case "edit":
                editOption(request, response);
                break;
            case "delete":
                deleteOption(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    private void addOption(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String option_name = request.getParameter("option_name");
        String price = request.getParameter("price");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int product_id = Integer.parseInt(request.getParameter("product_id"));
        
        String imagePath = handleImageUpload(request);

        String query = "INSERT INTO product_option (option_name, price, quantity, image, product_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/trangsuc_db", "root", "hien031204");
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, option_name);
            ps.setString(2, price);
            ps.setInt(3, quantity);
            ps.setString(4, imagePath);
            ps.setInt(5, product_id);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                request.getSession().setAttribute("successMessage", "Thêm loại sản phẩm thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Thêm loại sản phẩm thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/OptionServlet");
    }

    private void editOption(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String option_name = request.getParameter("option_name");
        String price = request.getParameter("price");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int product_id = Integer.parseInt(request.getParameter("product_id"));
        
        Part filePart = request.getPart("image");
        String imagePath = null;
        
        String query;
        if (filePart != null && filePart.getSize() > 0) {
            // Có ảnh mới - upload và cập nhật
            imagePath = handleImageUpload(request);
            query = "UPDATE product_option SET option_name = ?, price = ?, quantity = ?, image = ?, product_id = ? WHERE id = ?";
        } else {
            // Không có ảnh mới - giữ ảnh cũ
            query = "UPDATE product_option SET option_name = ?, price = ?, quantity = ?, product_id = ? WHERE id = ?";
        }

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/trangsuc_db", "root", "hien031204");
             PreparedStatement ps = conn.prepareStatement(query)) {

            int paramIndex = 1;
            ps.setString(paramIndex++, option_name);
            ps.setString(paramIndex++, price);
            ps.setInt(paramIndex++, quantity);
            
            if (filePart != null && filePart.getSize() > 0) {
                ps.setString(paramIndex++, imagePath);
            }
            
            ps.setInt(paramIndex++, product_id);
            ps.setInt(paramIndex, id);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                request.getSession().setAttribute("successMessage", "Cập nhật loại sản phẩm thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Cập nhật loại sản phẩm thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/OptionServlet");
    }

    private void deleteOption(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));

        String query = "DELETE FROM product_option WHERE id = ?";

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/trangsuc_db", "root", "hien031204");
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, id);
            int result = ps.executeUpdate();
            
            if (result > 0) {
                request.getSession().setAttribute("successMessage", "Xóa loại sản phẩm thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Xóa loại sản phẩm thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/OptionServlet");
    }
    
    /**
     * PHƯƠNG THỨC UPLOAD ĐƠN GIẢN VÀ HIỆU QUẢ
     */
    private String handleImageUpload(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("image");
            
            // Kiểm tra có file được upload không
            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("No file uploaded");
                return "Images/default-option.jpg";
            }
            
            // Lấy tên file gốc
            String fileName = getFileName(filePart);
            if (fileName == null || fileName.isEmpty()) {
                System.out.println("File name is empty");
                return "Images/default-option.jpg";
            }
            
            System.out.println("Uploading file: " + fileName);
            System.out.println("File size: " + filePart.getSize() + " bytes");
            
            // Tạo tên file duy nhất
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = "option_" + System.currentTimeMillis() + fileExtension;
            
            // ĐƯỜNG DẪN QUAN TRỌNG: Lưu trực tiếp vào thư mục webapp/uploads
            String webAppPath = getServletContext().getRealPath("");
            String uploadPath = webAppPath + UPLOAD_DIR;
            
            System.out.println("WebApp path: " + webAppPath);
            System.out.println("Upload path: " + uploadPath);
            
            // Tạo thư mục nếu chưa tồn tại
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("Created upload directory: " + created);
            }
            
            // Kiểm tra quyền ghi
            if (!uploadDir.canWrite()) {
                System.out.println("Cannot write to directory: " + uploadPath);
                // Thử tạo trong thư mục dự án
                uploadPath = System.getProperty("user.dir") + File.separator + "web" + File.separator + UPLOAD_DIR;
                uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                System.out.println("Trying alternative path: " + uploadPath);
            }
            
            // Đường dẫn đầy đủ đến file
            String filePath = uploadPath + File.separator + newFileName;
            System.out.println("Saving to: " + filePath);
            
            // LƯU FILE - Sử dụng FileOutputStream đơn giản
            try (InputStream fileContent = filePart.getInputStream();
                 FileOutputStream out = new FileOutputStream(filePath)) {
                
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                
                System.out.println("File saved successfully!");
                
                // Kiểm tra file đã được lưu
                File savedFile = new File(filePath);
                if (savedFile.exists()) {
                    System.out.println("File exists: " + savedFile.getAbsolutePath());
                    System.out.println("File size: " + savedFile.length() + " bytes");
                } else {
                    System.out.println("ERROR: File not found after saving!");
                    return "Images/default-option.jpg";
                }
            }
            
            // Trả về đường dẫn để lưu trong database
            String dbPath = UPLOAD_DIR + "/" + newFileName;
            System.out.println("Database path: " + dbPath);
            
            return dbPath;
            
        } catch (Exception e) {
            System.out.println("ERROR in handleImageUpload: " + e.getMessage());
            e.printStackTrace();
            return "Images/default-option.jpg";
        }
    }
    
    private String formatImagePath(String imagePath) {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return "Images/default-option.jpg";
        }
        return imagePath.replace("\\", "/");
    }
    
    private String getFileName(Part part) {
        if (part == null) return null;
        
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                // Chỉ lấy tên file
                if (fileName.contains("\\")) {
                    fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
                }
                if (fileName.contains("/")) {
                    fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
                }
                return fileName.trim();
            }
        }
        return null;
    }

    @Override
    public String getServletInfo() {
        return "Servlet quản lý loại sản phẩm";
    }
}