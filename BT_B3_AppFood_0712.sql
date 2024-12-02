-- 1. Tạo database, table, column và dữ liệu theo sơ đồ như hình
DROP DATABASE IF EXISTS app_food;
CREATE DATABASE app_food;
USE app_food;

CREATE TABLE users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    pass_word VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (full_name, email, pass_word) VALUES
	('Ha Nguyen', 'ha.nguyen@email.com', 'password123'),
	('Minh Tran', 'minh.tran@email.com', 'minh@123'),
	('Bao Le', 'bao.le@email.com', 'bao!password'),
	('Thanh Hoang', 'thanh.hoang@email.com', 'thanh@2024'),
	('Linh Nguyen', 'linh.nguyen@email.com', 'linhsecure!'),
	('Nam Vu', 'nam.vu@email.com', 'nam12345');

CREATE TABLE restaurants (
    res_id INT AUTO_INCREMENT PRIMARY KEY,
    res_name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    description VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO restaurants (res_name, image, description) VALUES
	('The Hungry Chef', 'img1.jpg', 'Fine dining restaurant'),
	('Pizza Delight', 'img2.jpg', 'Authentic Italian pizzas'),
	('Sushi World', 'img3.jpg', 'Fresh and delicious sushi'),
	('BBQ Nation', 'img4.jpg', 'BBQ grills and more'),
	('Veggie Haven', 'img5.jpg', 'Fresh vegetarian meals'),
	('Café Latte', 'img6.jpg', 'Cozy coffee shop');

CREATE TABLE food_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO food_types (type_name) VALUES
	('Appetizer'),
	('Main Course'),
	('Dessert'),
	('Beverage');

CREATE TABLE foods (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    price FLOAT,
    description VARCHAR(500),
    type_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (type_id) REFERENCES food_types(type_id)
);

INSERT INTO foods (food_name, image, price, description, type_id) VALUES
	('Margherita', 'food1.jpg', 8.99, 'Classic pizza with cheese', 2),
	('Caesar Salad', 'food2.jpg', 5.99, 'Fresh and healthy salad', 1),
	('Chocolate Cake', 'food3.jpg', 6.49, 'Rich chocolate dessert', 3),
	('Latte', 'food4.jpg', 4.99, 'Creamy coffee latte', 4),
	('BBQ Ribs', 'food5.jpg', 14.99, 'Juicy BBQ pork ribs', 2),
	('Sushi Platter', 'food6.jpg', 19.99, 'Assorted sushi platter', 2);

CREATE TABLE sub_foods (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    sub_name VARCHAR(255) NOT NULL,
    sub_price FLOAT NOT NULL,
    food_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (food_id) REFERENCES foods(food_id)
);

INSERT INTO sub_foods (sub_name, sub_price, food_id) VALUES
	('Extra Cheese', 1.50, 9),
	('Croutons', 0.75, 7),
	('Whipped Cream', 0.50, 8),
	('Soy Milk', 0.50, 9),
	('Spicy Sauce', 1.00, 10),
	('Wasabi', 0.25, 12);


CREATE TABLE orders (
	PRIMARY KEY (user_id, food_id),
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(50),
    arr_sub_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (food_id) REFERENCES foods(food_id)
);


INSERT INTO orders (user_id, food_id, amount, code, arr_sub_id) VALUES
	(1, 7, 2, 'ORD001', '1'),
	(1, 8, 1, 'ORD002', '5'),
	(2, 8, 1, 'ORD003', '2'),
	(2, 9, 1, 'ORD004', '6'),
	(3, 10, 3, 'ORD005', '3'),
	(4, 11, 2, 'ORD006', '4'),
	(5, 7, 1, 'ORD007', '1'),
	(5, 8, 1, 'ORD008', '5'),
	(6, 9, 1, 'ORD009', '6');



CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, res_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
);

INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
	(1, 1, 5, '2024-11-30 10:00:00'),
	(2, 2, 4, '2024-11-29 12:30:00'),
	(3, 3, 5, '2024-11-28 08:45:00'),
	(4, 4, 3, '2024-11-27 14:20:00'),
	(5, 5, 4, '2024-11-26 09:50:00'),
	(6, 6, 5, '2024-11-25 18:15:00');

CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, res_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
);

INSERT INTO like_res (user_id, res_id, date_like) VALUES
	(1, 6, '2024-11-30 10:30:00'),
	(1, 4, '2024-11-29 11:45:00'),
	(1, 5, '2024-11-28 13:15:00'),
	(4, 3, '2024-11-27 16:40:00'),
	(4, 6, '2024-11-26 19:00:00'),
	(3, 4, '2024-11-25 20:50:00');


-- 2. Bài tập SQL yêu cầu
-- Tìm 5 người đã like nhà hàng nhiều nhất
SELECT
	u.user_id, 
    u.full_name,
    COUNT(*) total_likes
FROM users u
INNER JOIN like_res lr ON lr.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_likes DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT
	r.res_id,
	r.res_name,
	COUNT(*) total_like_res
FROM restaurants r
INNER JOIN like_res lr ON lr.res_id = r.res_id
GROUP BY r.res_id
ORDER BY total_like_res DESC
LIMIT 2;

-- Tìm người đã đặt hàng nhiều nhất
SELECT
	u.user_id,
	u.full_name,
	COUNT(*) total_like
FROM users u
INNER JOIN orders o ON o.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_like DESC
LIMIT 1;

-- Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng).
SELECT
	u.user_id,
	u.full_name
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id
LEFT JOIN like_res lr ON lr.user_id = u.user_id
LEFT JOIN rate_res rr ON rr.user_id = u.user_id
WHERE o.user_id IS NULL AND lr.user_id IS NULL AND rr.user_id IS NULL;