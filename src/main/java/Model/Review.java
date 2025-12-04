/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Date;

public class Review {
    private int id, userId, productId;
    private float rating;
    private String review_text;
    private Date created_at;
    private int roundedRating;
    private String username;

    public Review() {
    }

    public Review(int id, int userId, int productId, float rating, String review_text, Date created_at, int roundedRating, String username) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.review_text = review_text;
        this.created_at = created_at;
        this.roundedRating = roundedRating;
        this.username = username;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public String getReview_text() {
        return review_text;
    }

    public void setReview_text(String review_text) {
        this.review_text = review_text;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public int getRoundedRating() {
        return roundedRating;
    }

    public void setRoundedRating(int roundedRating) {
        this.roundedRating = roundedRating;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
