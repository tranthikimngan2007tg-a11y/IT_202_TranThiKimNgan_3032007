CREATE DATABASE SalesManagement;
USE SalesManagement;

CREATE TABLE product (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    manufaturer VARCHAR(100),
    price DECIMAL (10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

CREATE TABLE customer (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(250)
);

CREATE TABLE orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    total_amount DECIMAL (12, 2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE order_detail (
	order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_at_time DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY  (order_id,product_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);

ALTER TABLE orders
ADD COLUMN note TEXT;

ALTER TABLE product
RENAME COLUMN manufaturer TO nha_sx;

DROP TABLE orders;
DROP TABLE order_detail;

INSERT INTO customer (full_name, email, phone, address) VALUES 
('Nguyen Van A', 'NguyenVanA@gmail.com', '0123456789', 'HCM'),
('Tran Thi B', 'TranThiB@gmail.com', '0234567891', 'Tiền Giang'),
('Le Thi C', 'LeThiC@gmail.com', '0124353412', 'Nha Trang'),
('Luu Van D', 'LuuVanD@gmail.com', '0298365731', 'Hà Nội'),
('Luong Thi E', 'LuongThiE@gmail.com', '0286496258', 'Đồng Tháp');

INSERT INTO product (product_name, nha_sx, price, stock_quantity) VALUES 
('iphone 14 pro max', 'Apple', 20000000, 10),
('MacBook Air M2', 'Apple', 10000000, 5),
('Galaxy S23', 'Samsung', 30000000, 8),
('Dell XPS 13', 'Dell', 30000000,7),
('iPad Gen 10', 'Apple', 4000000, 6);

INSERT INTO orders(order_date, total_amount, customer_id) VALUES 
('2026-01-01', 200000000, 1),
('2026-02-02', 300000000, 2),
('2026-03-03', 400000000, 3),
('2026-04-04', 500000000, 4),
('2026-04-05', 600000000, 5);

INSERT INTO order_detail(order_id, product_id, quantity, price_at_time) VALUES
(1, 1, 1, 2000000),
(2, 2, 1, 10000000),
(3, 3, 1, 3000000),
(4, 4, 1, 4000000),
(5, 5, 1, 5000000);

UPDATE product
SET price = price * 1.1
WHERE nha_sx = 'Apple';

DELETE FROM customer
WHERE phone IS NULL;

SELECT *
FROM product
WHERE price BETWEEN 10000000 AND 20000000;

SELECT *
FROM orders
WHERE order_id ='1';

SELECT *
FROM customer
WHERE address = 'HCM';