-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.44 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.12.0.7122
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for trangsuc_db
CREATE DATABASE IF NOT EXISTS `trangsuc_db` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `trangsuc_db`;

-- Dumping structure for table trangsuc_db.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `customer_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `payment_method` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  `status` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT 'Chờ duyệt',
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.orders: ~6 rows (approximately)
INSERT INTO `orders` (`order_id`, `user_id`, `customer_name`, `address`, `phone`, `order_date`, `payment_method`, `total_amount`, `status`) VALUES
	(21, 3, 'Nguyenthuhien', '123 Đường ABC', '0123456789', '2025-05-29', 'COD', 15000000.00, 'Đã huỷ'),
	(23, 3, 'Nguyenthuhien', '123 Đường ABC', '0123456789', '2025-05-29', 'Credit', 13500000.00, 'Đã giao'),
	(30, 3, 'Bùi Thị C', 'Số 123 Đường ABC, Quận CD, Phường EF', '0123456789', '2025-06-17', 'Credit', 10000000.00, 'Đang giao'),
	(34, 3, 'Mai Văn A', 'Số 123, Đường ABC, Hà Nội', '0123456789', '2025-06-24', 'COD', 3200000.00, 'Chờ duyệt'),
	(40, 3, 'Bùi Thị C', '123 Đường ABC', '0123456789', '2025-11-26', 'COD', 19500000.00, 'Đã giao'),
	(48, 2, 'Bùi Thị C', '123', '0123456789', '2025-12-01', 'COD', 2000000.00, 'Chờ duyệt');

-- Dumping structure for table trangsuc_db.order_items
CREATE TABLE IF NOT EXISTS `order_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `option_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.order_items: ~16 rows (approximately)
INSERT INTO `order_items` (`item_id`, `order_id`, `product_id`, `quantity`, `price`, `option_name`) VALUES
	(32, 21, 1, 1, 10000000, 'Full bộ'),
	(33, 21, 1, 1, 5000000, 'Dây chuyền'),
	(36, 23, 1, 1, 10000000, 'Full bộ'),
	(37, 23, 5, 1, 2500000, 'Dây chuyền'),
	(38, 23, 5, 1, 1000000, 'Nhẫn'),
	(50, 30, 1, 1, 2000000, 'Khuyên tai'),
	(51, 30, 1, 1, 3000000, 'Nhẫn'),
	(52, 30, 5, 1, 5000000, 'Full bộ'),
	(60, 34, 14, 1, 1700000, 'Rắn'),
	(61, 34, 6, 1, 1500000, 'Khuyên tai'),
	(67, 40, 1, 1, 2000000, 'Khuyên tai'),
	(68, 40, 48, 1, 5000000, '1 cặp nhẫn'),
	(69, 40, 22, 1, 5000000, 'Full bộ'),
	(70, 40, 10, 1, 7500000, 'Full bộ'),
	(78, 48, 1, 1, 2000000, 'Khuyên tai');

-- Dumping structure for table trangsuc_db.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `quantity` int NOT NULL,
  `rating` float DEFAULT '0',
  `sold` int DEFAULT '0',
  `type_id` int DEFAULT NULL,
  `option_id` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `origin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'Việt Nam',
  `rate_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_products_type` (`type_id`),
  KEY `fk_product_options` (`option_id`),
  CONSTRAINT `fk_product_options` FOREIGN KEY (`option_id`) REFERENCES `product_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_products_type` FOREIGN KEY (`type_id`) REFERENCES `type_product` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table trangsuc_db.products: ~24 rows (approximately)
INSERT INTO `products` (`id`, `name`, `image_url`, `price`, `quantity`, `rating`, `sold`, `type_id`, `option_id`, `description`, `origin`, `rate_count`) VALUES
	(1, 'Bộ trang sức bạc Gift For You (1)', '/2274820014_NguyenThuHienn/Images/sanpham1.jpg', '10.000.000', 398, 4.09011, 2, 1, NULL, 'Bộ trang sức bao gồm dây chuyền bạc, bông tai và nhẫn. Do được chế tác từ chất liệu bạc Ý 925 phủ xi bạch kim cao cấp và nạm đá CZ nên hầu như các món đồ nữ trang nào cũng hạn chế được xỉn đen và tránh hỏng hóc.', 'Việt Nam', 13),
	(2, 'Bộ trang sức bạc Gift For You (2)', '/2274820014_NguyenThuHienn/Images/sanpham1.jpg', '12.000.000', 400, 0, 0, 1, NULL, 'Bộ trang sức bao gồm dây chuyền bạc, bông tai và nhẫn. Do được chế tác từ chất liệu bạc Ý 925 phủ xi bạch kim cao cấp và nạm đá CZ nên hầu như các món đồ nữ trang nào cũng hạn chế được xỉn đen và tránh hỏng hóc.', 'Việt Nam', 0),
	(3, 'Bộ trang sức bạc Gift For You (3)', '/2274820014_NguyenThuHienn/Images/sanpham1.jpg', '10.000.000', 400, 0, 0, 1, NULL, 'Bộ trang sức bao gồm dây chuyền bạc, bông tai và nhẫn. Do được chế tác từ chất liệu bạc Ý 925 phủ xi bạch kim cao cấp và nạm đá CZ nên hầu như các món đồ nữ trang nào cũng hạn chế được xỉn đen và tránh hỏng hóc.', 'Việt Nam', 0),
	(4, 'Bộ trang sức bạc Gift For You (4)', '/2274820014_NguyenThuHienn/Images/sanpham1.jpg', '10.000.000', 400, 0, 0, 1, NULL, 'Bộ trang sức bao gồm dây chuyền bạc, bông tai và nhẫn. Do được chế tác từ chất liệu bạc Ý 925 phủ xi bạch kim cao cấp và nạm đá CZ nên hầu như các món đồ nữ trang nào cũng hạn chế được xỉn đen và tránh hỏng hóc.', 'Việt Nam', 0),
	(5, 'Trang sức ESME ES092 bạc 925 cao cấp đính đá Swarovski (1)', '/2274820014_NguyenThuHienn/Images/sanpham2.jpg', '5.000.000', 398, 4, 2, 2, NULL, 'Bộ trang sức này bao gồm vòng cổ, bông tai, vòng tay và nhẫn, tất cả đều được thiết kế với họa tiết chim ruồi đính đá màu xanh lá cây lấp lánh và các chi tiết lấp lánh, tạo nên vẻ đẹp thanh lịch và tinh tế.', 'Việt Nam', 1),
	(6, 'Trang sức ESME ES092 bạc 925 cao cấp đính đá Swarovski (2)', '/2274820014_NguyenThuHienn/Images/sanpham2.jpg', '5.000.000', 400, 0, 0, 2, NULL, 'Bộ trang sức này bao gồm vòng cổ, bông tai, vòng tay và nhẫn, tất cả đều được thiết kế với họa tiết chim ruồi đính đá màu xanh lá cây lấp lánh và các chi tiết lấp lánh, tạo nên vẻ đẹp thanh lịch và tinh tế.', 'Việt Nam', 0),
	(7, 'Trang sức ESME ES092 bạc 925 cao cấp đính đá Swarovski (3)', '/2274820014_NguyenThuHienn/Images/sanpham2.jpg', '5.000.000', 400, 0, 0, 2, NULL, 'Bộ trang sức này bao gồm vòng cổ, bông tai, vòng tay và nhẫn, tất cả đều được thiết kế với họa tiết chim ruồi đính đá màu xanh lá cây lấp lánh và các chi tiết lấp lánh, tạo nên vẻ đẹp thanh lịch và tinh tế.', 'Việt Nam', 0),
	(8, 'Trang sức ESME ES092 bạc 925 cao cấp đính đá Swarovski (4)', '/2274820014_NguyenThuHienn/Images/sanpham2.jpg', '5.000.000', 400, 0, 0, 2, NULL, 'Bộ trang sức này bao gồm vòng cổ, bông tai, vòng tay và nhẫn, tất cả đều được thiết kế với họa tiết chim ruồi đính đá màu xanh lá cây lấp lánh và các chi tiết lấp lánh, tạo nên vẻ đẹp thanh lịch và tinh tế.', 'Việt Nam', 0),
	(9, 'Bộ trang sức Bạc 925 đính đá xanh Emerald & Pha lê ánh trăng (1)', '/2274820014_NguyenThuHienn/Images/sanpham3.webp', '7.500.000', 400, 3, 0, 3, NULL, 'Bộ trang sức bạc 925 này bao gồm một vòng cổ và một vòng tay, nổi bật với sự kết hợp tinh tế của đá Emerald xanh lục bảo và pha lê ánh trăng lấp lánh, mang đến vẻ đẹp sang trọng và huyền bí.', 'Việt Nam', 1),
	(10, 'Bộ trang sức Bạc 925 đính đá xanh Emerald & Pha lê ánh trăng (2)', '/2274820014_NguyenThuHienn/Images/sanpham3.webp', '7.500.000', 299, 0, 1, 3, NULL, 'Bộ trang sức bạc 925 này bao gồm một vòng cổ và một vòng tay, nổi bật với sự kết hợp tinh tế của đá Emerald xanh lục bảo và pha lê ánh trăng lấp lánh, mang đến vẻ đẹp sang trọng và huyền bí.', 'Việt Nam', 0),
	(11, 'Bộ trang sức Bạc 925 đính đá xanh Emerald & Pha lê ánh trăng (3)', '/2274820014_NguyenThuHienn/Images/sanpham3.webp', '7.500.000', 300, 0, 0, 3, NULL, 'Bộ trang sức bạc 925 này bao gồm một vòng cổ và một vòng tay, nổi bật với sự kết hợp tinh tế của đá Emerald xanh lục bảo và pha lê ánh trăng lấp lánh, mang đến vẻ đẹp sang trọng và huyền bí.', 'Việt Nam', 0),
	(12, 'Bộ trang sức Bạc 925 đính đá xanh Emerald & Pha lê ánh trăng (4)', '/2274820014_NguyenThuHienn/Images/sanpham3.webp', '7.500.000', 300, 0, 0, 3, NULL, 'Bộ trang sức bạc 925 này bao gồm một vòng cổ và một vòng tay, nổi bật với sự kết hợp tinh tế của đá Emerald xanh lục bảo và pha lê ánh trăng lấp lánh, mang đến vẻ đẹp sang trọng và huyền bí.', 'Việt Nam', 0),
	(13, 'Cặp nhẫn cưới Bạc 925 đính đá CZ Vĩnh Cửu Thanh Lịch (1)', '/2274820014_NguyenThuHienn/Images/sanpham4.webp', '5.000.000', 100, 0, 0, 4, NULL, 'Cặp nhẫn cưới bạc 925 này bao gồm một chiếc nhẫn được đính đá CZ vĩnh cửu lấp lánh và một chiếc nhẫn trơn thanh lịch, tượng trưng cho tình yêu đôi lứa bền chặt và vĩnh cửu.', 'Việt Nam', 0),
	(14, 'Bộ 3 bông tai bằng vàng dạng móc hình rắn phong cách Vintage cho nữ (1)', '/2274820014_NguyenThuHienn/Images/sanpham5.jpg', '5.000.000', 400, 0, 0, 5, NULL, 'Bộ 3 bông tai vàng phong cách vintage này gồm một chiếc bông tai móc độc đáo, một khuyên tai dạng kẹp và một khuyên tai hình rắn quấn đầy cá tính, mang đến vẻ ngoài ấn tượng và thời thượng.', 'Việt Nam', 0),
	(15, 'Bộ 3 bông tai bằng vàng dạng móc hình rắn phong cách Vintage cho nữ (2)', '/2274820014_NguyenThuHienn/Images/sanpham5.jpg', '5.000.000', 400, 0, 0, 5, NULL, 'Bộ 3 bông tai vàng phong cách vintage này gồm một chiếc bông tai móc độc đáo, một khuyên tai dạng kẹp và một khuyên tai hình rắn quấn đầy cá tính, mang đến vẻ ngoài ấn tượng và thời thượng.', 'Việt Nam', 0),
	(16, 'Bộ 3 bông tai bằng vàng dạng móc hình rắn phong cách Vintage cho nữ (3)', '/2274820014_NguyenThuHienn/Images/sanpham5.jpg', '5.000.000', 400, 0, 0, 5, NULL, 'Bộ 3 bông tai vàng phong cách vintage này gồm một chiếc bông tai móc độc đáo, một khuyên tai dạng kẹp và một khuyên tai hình rắn quấn đầy cá tính, mang đến vẻ ngoài ấn tượng và thời thượng.', 'Việt Nam', 0),
	(17, 'Bộ trang sức vàng hồng 14K khắc tên cá nhân hóa - Nhẫn & Dây chuyền (1)', '/2274820014_NguyenThuHienn/Images/sanpham6.jpg', '5.500.000', 300, 0, 0, 6, NULL, 'Bộ trang sức vàng hồng 14K (nhẫn & dây chuyền) khắc tên cá nhân hóa, mang vẻ đẹp độc đáo, ý nghĩa. Chất liệu cao cấp, thiết kế tinh xảo, là món quà hoàn hảo thể hiện phong cách riêng và tình cảm đặc biệt.', 'Việt Nam', 0),
	(18, 'Bộ trang sức vàng hồng 14K khắc tên cá nhân hóa - Nhẫn & Dây chuyền (2)', '/2274820014_NguyenThuHienn/Images/sanpham6.jpg', '5.500.000', 300, 0, 0, 6, NULL, 'Bộ trang sức vàng hồng 14K (nhẫn & dây chuyền) khắc tên cá nhân hóa, mang vẻ đẹp độc đáo, ý nghĩa. Chất liệu cao cấp, thiết kế tinh xảo, là món quà hoàn hảo thể hiện phong cách riêng và tình cảm đặc biệt.', 'Việt Nam', 0),
	(19, 'Bộ trang sức vàng hồng 14K khắc tên cá nhân hóa - Nhẫn & Dây chuyền (3)', '/2274820014_NguyenThuHienn/Images/sanpham6.jpg', '5.500.000', 300, 0, 0, 6, NULL, 'Bộ trang sức vàng hồng 14K (nhẫn & dây chuyền) khắc tên cá nhân hóa, mang vẻ đẹp độc đáo, ý nghĩa. Chất liệu cao cấp, thiết kế tinh xảo, là món quà hoàn hảo thể hiện phong cách riêng và tình cảm đặc biệt.', 'Việt Nam', 0),
	(20, 'Bộ trang sức vàng hồng 14K khắc tên cá nhân hóa - Nhẫn & Dây chuyền (4)', '/2274820014_NguyenThuHienn/Images/sanpham6.jpg', '5.500.000', 300, 0, 0, 6, NULL, 'Bộ trang sức vàng hồng 14K (nhẫn & dây chuyền) khắc tên cá nhân hóa, mang vẻ đẹp độc đáo, ý nghĩa. Chất liệu cao cấp, thiết kế tinh xảo, là món quà hoàn hảo thể hiện phong cách riêng và tình cảm đặc biệt.', 'Việt Nam', 0),
	(22, 'Bộ 3 bông tai bằng vàng dạng móc hình rắn phong cách Vintage cho nữ (4)', '/2274820014_NguyenThuHienn/Images/sanpham5.jpg', '5.000.000', 400, 0, 0, 5, NULL, 'Bộ 3 bông tai vàng phong cách vintage này gồm một chiếc bông tai móc độc đáo, một khuyên tai dạng kẹp và một khuyên tai hình rắn quấn đầy cá tính, mang đến vẻ ngoài ấn tượng và thời thượng.', 'Việt Nam', 0),
	(46, 'Cặp nhẫn cưới Bạc 925 đính đá CZ Vĩnh Cửu Thanh Lịch (2)', '/2274820014_NguyenThuHienn/Images/sanpham4.webp', '5.000.000', 100, 0, 0, 4, NULL, 'Cặp nhẫn cưới bạc 925 này bao gồm một chiếc nhẫn được đính đá CZ vĩnh cửu lấp lánh và một chiếc nhẫn trơn thanh lịch, tượng trưng cho tình yêu đôi lứa bền chặt và vĩnh cửu.', 'Việt Nam', 0),
	(47, 'Cặp nhẫn cưới Bạc 925 đính đá CZ Vĩnh Cửu Thanh Lịch (3)', '/2274820014_NguyenThuHienn/Images/sanpham4.webp', '5.000.000', 100, 0, 0, 4, NULL, 'Cặp nhẫn cưới bạc 925 này bao gồm một chiếc nhẫn được đính đá CZ vĩnh cửu lấp lánh và một chiếc nhẫn trơn thanh lịch, tượng trưng cho tình yêu đôi lứa bền chặt và vĩnh cửu.', 'Việt Nam', 0),
	(48, 'Cặp nhẫn cưới Bạc 925 đính đá CZ Vĩnh Cửu Thanh Lịch (4)', '/2274820014_NguyenThuHienn/Images/sanpham4.webp', '5.000.000', 99, 0, 1, 4, NULL, 'Cặp nhẫn cưới bạc 925 này bao gồm một chiếc nhẫn được đính đá CZ vĩnh cửu lấp lánh và một chiếc nhẫn trơn thanh lịch, tượng trưng cho tình yêu đôi lứa bền chặt và vĩnh cửu.', 'Việt Nam', 0),
	(63, 'Set nhẫn kim cương bạc ép vàng trắng – Elegance Shine', '/2274820014_NguyenThuHienn/Images/sanpham10.jpg', '2.500.000', 100, 0, 0, 1, NULL, 'Bộ ba nhẫn thiết kế tinh xảo với đá chủ kim cương nhân tạo sáng lấp lánh, kết hợp đai nhẫn bạc ép vàng trắng sang trọng. Phù hợp làm quà tặng hoặc dùng cho các dịp đặc biệt, tôn lên vẻ đẹp thanh lịch và hiện đại.', 'Việt Nam', 0),
	(64, 'Set nhẫn kim cương bạc ép vàng trắng – Elegance Shine', '/2274820014_NguyenThuHienn/Images/sanpham10.jpg', '2.500.000', 100, 0, 0, 1, NULL, 'Bộ ba nhẫn thiết kế tinh xảo với đá chủ kim cương nhân tạo sáng lấp lánh, kết hợp đai nhẫn bạc ép vàng trắng sang trọng. Phù hợp làm quà tặng hoặc dùng cho các dịp đặc biệt, tôn lên vẻ đẹp thanh lịch và hiện đại.', 'Việt Nam', 0),
	(65, 'Set nhẫn kim cương bạc ép vàng trắng – Elegance Shine', '/2274820014_NguyenThuHienn/Images/sanpham10.jpg', '2.500.000', 100, 0, 0, 1, NULL, 'Bộ ba nhẫn thiết kế tinh xảo với đá chủ kim cương nhân tạo sáng lấp lánh, kết hợp đai nhẫn bạc ép vàng trắng sang trọng. Phù hợp làm quà tặng hoặc dùng cho các dịp đặc biệt, tôn lên vẻ đẹp thanh lịch và hiện đại.', 'Việt Nam', 0);

-- Dumping structure for table trangsuc_db.product_option
CREATE TABLE IF NOT EXISTS `product_option` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `option_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `price` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_option_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.product_option: ~76 rows (approximately)
INSERT INTO `product_option` (`id`, `product_id`, `option_name`, `price`, `quantity`, `image`) VALUES
	(1, 1, 'Khuyên tai', '2.000.000', 100, 'Images/sanpham1.jpg'),
	(2, 1, 'Nhẫn', '3.000.000', 100, 'Images/sanpham1a.jpg'),
	(3, 1, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham1.jpg'),
	(4, 1, 'Full bộ', '10.000.000', 100, 'Images/sanpham1a.jpg'),
	(8, 5, 'Khuyên tai', '1.500.000', 100, 'Images/sanpham2.jpg'),
	(9, 5, 'Nhẫn', '1.000.000', 100, 'Images/sanpham2a.jpeg'),
	(10, 5, 'Dây chuyền', '2.500.000', 100, 'Images/sanpham2.jpg'),
	(11, 5, 'Full bộ', '5.000.000', 100, 'Images/sanpham2a.jpeg'),
	(12, 9, 'Vòng tay', '2.500.000', 100, 'Images/sanpham3.webp'),
	(13, 9, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham3.webp'),
	(14, 9, 'Full bộ', '7.500.000', 100, 'Images/sanpham3.webp'),
	(15, 2, 'Khuyên tai', '2.000.000', 100, 'Images/sanpham1a.jpg'),
	(16, 2, 'Nhẫn', '3.000.000', 100, 'Images/sanpham1.jpg'),
	(17, 2, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham1a.jpg'),
	(18, 2, 'Full bộ', '10.000.000', 100, 'Images/sanpham1.jpg'),
	(19, 3, 'Khuyên tai', '2.000.000', 100, 'Images/sanpham1.jpg'),
	(20, 3, 'Nhẫn', '3.000.000', 100, 'Images/sanpham1a.jpg'),
	(21, 3, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham1a.jpg'),
	(22, 3, 'Full bộ', '10.000.000', 100, 'Images/sanpham1.jpg'),
	(23, 4, 'Khuyên tai', '2.000.000', 100, 'Images/sanpham1a.jpg'),
	(24, 4, 'Nhẫn', '3.000.000', 100, 'Images/sanpham1.jpg'),
	(25, 4, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham1a.jpg'),
	(26, 4, 'Full bộ', '10.000.000', 100, 'Images/sanpham1.jpg'),
	(27, 6, 'Khuyên tai', '1.500.000', 100, 'Images/sanpham2.jpg'),
	(28, 6, 'Nhẫn', '1.000.000', 100, 'Images/sanpham2a.jpeg'),
	(29, 6, 'Dây chuyền', '2.500.000', 100, 'Images/sanpham2.jpg'),
	(30, 6, 'Full bộ', '5.000.000', 100, 'Images/sanpham2a.jpeg'),
	(31, 7, 'Khuyên tai', '1.500.000', 100, 'Images/sanpham2.jpg'),
	(32, 7, 'Nhẫn', '1.000.000', 100, 'Images/sanpham2a.jpeg'),
	(33, 7, 'Dây chuyền', '2.500.000', 100, 'Images/sanpham2.jpg'),
	(34, 7, 'Full bộ', '5.000.000', 100, 'Images/sanpham2a.jpeg'),
	(35, 8, 'Khuyên tai', '1.500.000', 100, 'Images/sanpham2.jpg'),
	(36, 8, 'Nhẫn', '1.000.000', 100, 'Images/sanpham2a.jpeg'),
	(37, 8, 'Dây chuyền', '2.500.000', 100, 'Images/sanpham2.jpg'),
	(38, 8, 'Full bộ', '5.000.000', 100, 'Images/sanpham2a.jpeg'),
	(39, 10, 'Vòng tay', '2.500.000', 100, 'Images/sanpham3.webp'),
	(40, 10, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham3.webp'),
	(41, 10, 'Full bộ', '7.500.000', 100, 'Images/sanpham3.webp'),
	(42, 11, 'Vòng tay', '2.500.000', 100, 'Images/sanpham3.webp'),
	(43, 11, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham3.webp'),
	(44, 11, 'Full bộ', '7.500.000', 100, 'Images/sanpham3.webp'),
	(45, 12, 'Vòng tay', '2.500.000', 100, 'Images/sanpham3.webp'),
	(46, 12, 'Dây chuyền', '5.000.000', 100, 'Images/sanpham3.webp'),
	(47, 12, 'Full bộ', '7.500.000', 100, 'Images/sanpham3.webp'),
	(48, 13, '1 cặp nhẫn', '5.000.000', 100, 'Images/sanpham4.webp'),
	(49, 46, '1 cặp nhẫn', '5.000.000', 100, 'Images/sanpham4.webp'),
	(50, 47, '1 cặp nhẫn', '5.000.000', 100, 'Images/sanpham4.webp'),
	(51, 48, '1 cặp nhẫn', '5.000.000', 100, 'Images/sanpham4.webp'),
	(52, 14, 'Mắt xích', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(53, 14, 'Rắn', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(54, 14, 'Xoắn ốc', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(55, 14, 'Full bộ', '5.000.000', 100, 'Images/sanpham5.jpg'),
	(56, 15, 'Mắt xích', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(57, 15, 'Rắn', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(58, 15, 'Xoắn ốc', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(59, 15, 'Full bộ', '5.000.000', 100, 'Images/sanpham5.jpg'),
	(60, 16, 'Mắt xích', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(61, 16, 'Rắn', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(62, 16, 'Xoắn ốc', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(65, 16, 'Full bộ', '5.000.000', 100, 'Images/sanpham5.jpg'),
	(66, 22, 'Mắt xích', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(67, 22, 'Rắn', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(68, 22, 'Xoắn ốc', '1.700.000', 100, 'Images/sanpham5.jpg'),
	(69, 22, 'Full bộ', '5.000.000', 100, 'Images/sanpham5.jpg'),
	(70, 17, 'Dây chuyền', '3.000.000', 100, 'Images/sanpham6.jpg'),
	(71, 17, 'Nhẫn', '2.500.000', 100, 'Images/sanpham6.jpg'),
	(72, 17, 'Full bộ', '5.500.000', 100, 'Images/sanpham6.jpg'),
	(73, 18, 'Dây chuyền', '3.000.000', 100, 'Images/sanpham6.jpg'),
	(74, 18, 'Nhẫn', '2.500.000', 100, 'Images/sanpham6.jpg'),
	(75, 18, 'Full bộ', '5.500.000', 100, 'Images/sanpham6.jpg'),
	(76, 19, 'Dây chuyền', '3.000.000', 100, 'Images/sanpham6.jpg'),
	(77, 19, 'Nhẫn', '2.500.000', 100, 'Images/sanpham6.jpg'),
	(78, 19, 'Full bộ', '5.500.000', 100, 'Images/sanpham6.jpg'),
	(79, 20, 'Dây chuyền', '3.000.000', 100, 'Images/sanpham6.jpg'),
	(80, 20, 'Nhẫn', '2.500.000', 100, 'Images/sanpham6.jpg'),
	(81, 20, 'Full bộ', '5.500.000', 100, 'Images/sanpham6.jpg'),
	(84, 63, 'Full bộ 3 chiếc', '2.500.000', 100, 'uploads/option_1764235435125.jpg'),
	(85, 64, 'Full bộ 3 chiếc', '2.500.000', 100, 'uploads/option_1764235453985.jpg'),
	(86, 65, 'Full bộ 3 chiếc', '2.500.000', 100, 'uploads/option_1764235466993.jpg');

-- Dumping structure for table trangsuc_db.product_set_details
CREATE TABLE IF NOT EXISTS `product_set_details` (
  `option_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`option_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_set_details_ibfk_1` FOREIGN KEY (`option_id`) REFERENCES `product_option` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_set_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.product_set_details: ~0 rows (approximately)

-- Dumping structure for table trangsuc_db.reviews
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int NOT NULL,
  `rating` float NOT NULL DEFAULT (0),
  `review_text` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `fk_user` (`user_id`),
  CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table trangsuc_db.reviews: ~15 rows (approximately)
INSERT INTO `reviews` (`id`, `user_id`, `product_id`, `rating`, `review_text`, `created_at`) VALUES
	(1, 1, 1, 5, 'Sản phẩm rất tốt!', '2025-05-03 19:23:00'),
	(2, 2, 5, 4, 'Giao hàng nhanh, chất lượng ổn.', '2025-05-03 19:23:00'),
	(3, 4, 9, 3, 'Tạm được, giá hơi cao.', '2025-05-03 19:23:00'),
	(10, 1, 1, 5, 'Sản phẩm rất tốt!', '2025-05-04 17:31:34'),
	(11, 1, 1, 5, 'Sản phẩm rất tốt!', '2025-05-04 17:32:27'),
	(12, 1, 1, 5, 'Sản phẩm rất tốt!', '2025-05-04 17:37:49'),
	(13, 1, 1, 4, 'Sản phẩm rất tốt!', '2025-05-04 17:38:42'),
	(14, 1, 1, 1, 'Sản phẩm rất tốt!', '2025-05-04 17:38:52'),
	(15, 3, 1, 4, 'san pham tuyet ca la voi', '2025-05-04 22:53:48'),
	(17, 3, 1, 5, 'aishiba :))', '2025-05-24 17:02:49'),
	(18, 3, 1, 1, 'Không thích lắm :((', '2025-05-24 17:57:57'),
	(19, 1, 1, 3, 'Cũng tạm tạm à', '2025-05-24 17:59:34'),
	(20, 3, 1, 5, 'Hmmm.....', '2025-05-25 17:58:01'),
	(21, 3, 1, 5, 'sản phẩm khá đẹp nha', '2025-05-29 21:20:45'),
	(22, 3, 1, 5, 'Dịch vụ tốt, sản phẩm tuyệt vời!', '2025-06-16 23:28:39');

-- Dumping structure for table trangsuc_db.type_product
CREATE TABLE IF NOT EXISTS `type_product` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci NOT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.type_product: ~6 rows (approximately)
INSERT INTO `type_product` (`type_id`, `type_name`) VALUES
	(1, 'Cao cấp'),
	(2, 'Thời trang'),
	(3, 'Phong thủy'),
	(4, 'Tối giản'),
	(5, 'Vintage/retro'),
	(6, 'Cá nhân hóa');

-- Dumping structure for table trangsuc_db.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT 'Khách hàng',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.users: ~8 rows (approximately)
INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
	(1, 'suabien', 'Abc1234567@', 'Khách hàng'),
	(2, 'hien01234', '1234567891011', 'Khách hàng'),
	(3, 'admin', 'admin1234567@', 'admin'),
	(4, 'nguyen0124', '88888888888', 'Khách hàng'),
	(5, 'hien5555', '1234567891011', 'Khách hàng'),
	(32, 'thuhien0975', 'Abc01234567@', 'Khách hàng'),
	(37, 'nguoibantz10', 'Abc12345678@', 'Người bán'),
	(38, 'kieuthuha11', 'Abc12345678@', 'Nhà cung cấp');

-- Dumping structure for table trangsuc_db.user_profiles
CREATE TABLE IF NOT EXISTS `user_profiles` (
  `profile_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `image_info` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `phone` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_vietnamese_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`profile_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_vietnamese_ci;

-- Dumping data for table trangsuc_db.user_profiles: ~8 rows (approximately)
INSERT INTO `user_profiles` (`profile_id`, `user_id`, `image_info`, `full_name`, `email`, `address`, `phone`, `dob`) VALUES
	(1, 1, 'Images/default-avatar.jpg', 'Nguyễn Văn A', 'vana@example.com', '123 Lê Lợi, Hà Nội', '0912345678', '2000-05-12'),
	(2, 2, 'Images/default-avatar.jpg', 'Trần Thị B', 'tranb@gmail.com', '123 Hoàn Kiến, Hà Nội', '0123456789', '2025-11-24'),
	(11, 3, 'Images/admin-avatar.jpg', 'Nguyễn Thu Hiền', 'vanc@example.com', '123 Đường ABC', '0123456789', '2003-03-30'),
	(12, 32, 'Images/default-avatar.jpg', 'Suyễn Chi', 'suyenchi11@gmail.com', 'Số 15, Đường 98, Phường BB', '0123456789', '2000-07-18'),
	(13, 4, 'Images/default-avatar.jpg', 'Bính Ngạo', 'binhngao@gmail.com', '123 Đường ABC', '0123456789', '2025-06-05'),
	(14, 5, 'Images/default-avatar.jpg', 'Hạ Anh', 'haanh@gmail.com', '123 Lê Lợi, Hà Nội', '0912345678', '2003-06-09'),
	(16, 37, 'Images/default-avatar.jpg', 'Lê Thị Thu Trang', 'letrang2408@gmail.com', '123 Đường ABC', '0123456789', '2004-08-24'),
	(17, 38, 'Images/default-avatar.jpg', 'Kiều Hà Thu', 'thukho123@gmail.com', '123 Đội Cấn', '0123456789', '2004-08-11');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
