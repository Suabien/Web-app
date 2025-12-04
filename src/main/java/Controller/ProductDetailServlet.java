/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Review;
import Model.Product;
import Model.ProductDetail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Gigabyte
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/ProductDetailServlet"})
public class ProductDetailServlet extends HttpServlet {
    private final String JDBC_URL = "jdbc:mysql://localhost:3306/trangsuc_db";
    private final String JDBC_USER = "root";
    private final String JDBC_PASS = "hien031204";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id"); // id của sản phẩm
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("View/sanpham.jsp");
            return;
        }

        int productId = Integer.parseInt(idParam);

        Connection conn = null;
        PreparedStatement psProduct = null;
        PreparedStatement psOptions = null;
        ResultSet rsProduct = null;
        ResultSet rsOptions = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            // Lấy thông tin sản phẩm từ bảng `products`
            String productQuery = "SELECT * FROM products WHERE id = ?";
            psProduct = conn.prepareStatement(productQuery);
            psProduct.setInt(1, productId);
            rsProduct = psProduct.executeQuery();

            Product product = null;
            if (rsProduct.next()) {
                product = new Product();
                product.setId(rsProduct.getInt("id"));
                product.setName(rsProduct.getString("name"));
                product.setImage_url(rsProduct.getString("image_url"));
                product.setPrice(rsProduct.getString("price"));
                product.setQuantity(rsProduct.getInt("quantity"));
                product.setRating(rsProduct.getFloat("rating"));
                product.setRate_count(rsProduct.getInt("rate_count"));
                product.setSold(rsProduct.getInt("sold"));
                product.setDescription(rsProduct.getString("description"));
            }

            if (product == null) {
                response.sendRedirect("notfound.jsp");
                return;
            }
            
            // --- BẮT ĐẦU: Lấy thống kê đánh giá từ bảng `reviews` để cập nhật rating và rate_count ---
            String statsSql = "SELECT COUNT(*) AS cnt, AVG(rating) AS avgRating " +
                              "FROM reviews WHERE product_id = ?";
            try (PreparedStatement psStats = conn.prepareStatement(statsSql)) {
                psStats.setInt(1, productId);
                try (ResultSet rsStats = psStats.executeQuery()) {
                    if (rsStats.next()) {
                        int cnt = rsStats.getInt("cnt");
                        product.setRate_count(cnt);
                        float avg = rsStats.getFloat("avgRating");
                        if (!rsStats.wasNull()) {
                            product.setRating(avg);
                        }
                    }
                }
            }
            // --- KẾT THÚC: Cập nhật thông tin đánh giá cho đối tượng product ---
            
            // DANH SÁCH ĐÁNH GIÁ
            String reviewQuery = "SELECT r.*, up.full_name AS display_name FROM reviews r " +
                               "LEFT JOIN user_profiles up ON r.user_id = up.user_id " +
                               "WHERE r.product_id = ? ORDER BY r.created_at DESC";
            try (PreparedStatement psReviews = conn.prepareStatement(reviewQuery)) {
                psReviews.setInt(1, productId);
                try (ResultSet rsReviews = psReviews.executeQuery()) {
                    List<Review> reviewList = new ArrayList<>();
                    while (rsReviews.next()) {
                        Review review = new Review();
                        review.setId(rsReviews.getInt("id"));
                        review.setUserId(rsReviews.getInt("user_id"));
                        review.setProductId(rsReviews.getInt("product_id"));
                        review.setRating(rsReviews.getFloat("rating"));
                        review.setReview_text(rsReviews.getString("review_text"));
                        review.setCreated_at(rsReviews.getDate("created_at"));
                        review.setUsername(rsReviews.getString("display_name"));
                        // Tính toán roundedRating
                        float rating = review.getRating();
                        review.setRoundedRating(Math.round(rating));

                        reviewList.add(review);
                    }
                    request.setAttribute("reviewList", reviewList);
                }
            }

            // Lấy các tùy chọn mẫu từ bảng `product_option`
            String optionQuery = "SELECT * FROM product_option WHERE product_id = ?";
            psOptions = conn.prepareStatement(optionQuery);
            psOptions.setInt(1, productId);
            rsOptions = psOptions.executeQuery();

            List<ProductDetail> optionList = new ArrayList<>();
            List<String> optionNames = new ArrayList<>();
            List<String> optionImages = new ArrayList<>();

            while (rsOptions.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rsOptions.getInt("id"));
                pd.setProduct_id(rsOptions.getInt("product_id"));
                pd.setOption_name(rsOptions.getString("option_name"));
                pd.setPrice(rsOptions.getString("price"));
                pd.setQuantity(rsOptions.getInt("quantity"));
                pd.setImage(rsOptions.getString("image"));
                pd.setProduct(product);

                optionList.add(pd);
                optionNames.add(pd.getOption_name());
                optionImages.add(pd.getImage());
            }

            // Gửi dữ liệu sang JSP
            request.setAttribute("product", product);
            request.setAttribute("optionList", optionList);
            request.setAttribute("optionNames", optionNames);
            request.setAttribute("optionImages", optionImages);
            
            Map<String, String> optionPricesMap = new HashMap<>();
            Map<String, String> optionImageMap = new HashMap<>();

            for (ProductDetail pd : optionList) {
                optionPricesMap.put(pd.getOption_name(), pd.getPrice());
                optionImageMap.put(pd.getOption_name(), pd.getImage());
            }

            // Chuyển Map thành chuỗi JSON
            Gson gson = new Gson();
            String optionPricesJson = gson.toJson(optionPricesMap);
            String optionImagesJson = gson.toJson(optionImageMap);

            request.setAttribute("optionPricesJson", optionPricesJson);
            request.setAttribute("optionImagesJson", optionImagesJson);

            request.getRequestDispatcher("/View/sanpham.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("View/sanpham.jsp");
        } finally {
            try {
                if (rsProduct != null) rsProduct.close();
                if (rsOptions != null) rsOptions.close();
                if (psProduct != null) psProduct.close();
                if (psOptions != null) psOptions.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
