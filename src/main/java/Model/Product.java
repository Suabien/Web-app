/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Gigabyte
 */
public class Product {
    private int id;
    private String name;
    private String image_url;
    private String price;
    private int quantity;
    private float rating;
    private int rate_count;
    private int sold;
    private int type_id;
    private String type_name;
    private String description;
    private String origin; 

    public Product() {
    }

    // Constructor đầy đủ với origin
    public Product(int id, String name, String image_url, String price, int quantity, float rating, int rate_count, int sold, int type_id, String type_name, String description, String origin) {
        this.id = id;
        this.name = name;
        this.image_url = image_url;
        this.price = price;
        this.quantity = quantity;
        this.rating = rating;
        this.rate_count = rate_count;
        this.sold = sold;
        this.type_id = type_id;
        this.type_name = type_name;
        this.description = description;
        this.origin = origin;
    }

    // Constructor không có origin (cho tương thích)
    public Product(int id, String name, String image_url, String price, int quantity, float rating, int rate_count, int sold, int type_id, String type_name, String description) {
        this(id, name, image_url, price, quantity, rating, rate_count, sold, type_id, type_name, description, "Việt Nam");
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public int getRate_count() {
        return rate_count;
    }

    public void setRate_count(int rate_count) {
        this.rate_count = rate_count;
    }

    public int getSold() {
        return sold;
    }

    public void setSold(int sold) {
        this.sold = sold;
    }

    public int getType_id() {
        return type_id;
    }

    public void setType_id(int type_id) {
        this.type_id = type_id;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }
}