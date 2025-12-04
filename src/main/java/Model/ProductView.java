package Model;

public class ProductView {
    private int id;
    private String name;
    private String imageUrl;
    private String description;
    private String price;
    private int typeId;
    private String typeName; // Tên phân loại (Cao cấp, Thời trang...)
    private int totalStock;  // Tổng tồn kho (từ bảng options)
    private String variantList; // Chuỗi danh sách biến thể

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public int getTotalStock() { return totalStock; }
    public void setTotalStock(int totalStock) { this.totalStock = totalStock; }

    public String getVariantList() { return variantList; }
    public void setVariantList(String variantList) { this.variantList = variantList; }
}