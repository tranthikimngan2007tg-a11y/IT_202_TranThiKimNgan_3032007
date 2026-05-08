CREATE DATABASE bookstoreDB;
USE bookstoreDB;

CREATE TABLE category (
	category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE book (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE DEFAULT (CURRENT_DATE),
    price DECIMAL (10, 2) DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE bookorder (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
	book_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE,
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

ALTER TABLE book
ADD COLUMN author_name VARCHAR (100) NOT NULL;

ALTER TABLE bookorder
MODIFY customer_name VARCHAR(200);

ALTER TABLE bookorder
ADD CHECK (delivery_date >= order_date);

INSERT INTO category(category_name, description) VALUES
('IT & Tech', 'Sách lập trình'),
('Business', 'Sách kinh doanh'),
('Novel', 'Tiểu thuyết');

INSERT INTO book VALUES
(1, 'Clean Code', 1, '2020-05-10', 500000, 1, 'Robert C.Martin'),
(2, 'Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
(3, 'JavaScript Nâng cao', 1, '2023-01-15', 350000, 1, 'Kyle Simpson'),
(4, 'Nhà Giả Kim', 0, '2015-11-25', 120000,3, 'Paulo Coelho');

INSERT INTO bookorder VALUES
(101, 'Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
(102, 'Tran Bao Ngoc', 3, '2025-02-05','2025-02-10'),
(103, 'Le Hoang Yen', 4, '2025-03-12', NULL);

UPDATE book 
SET price = price + 50000
WHERE category_id = 1;

UPDATE bookorder 
SET delivery_date = '2025-12-31'
WHERE delivery_date IS NULL ;

DELETE FROM bookorder 
WHERE order_date < '2025-02-01';

SELECT title, author_name ,
CASE status 
WHEN 1 THEN 'Còn hàng'
ELSE 'Hết hàng'
END AS status_name
FROM book;

SELECT UPPER(title) AS title,
       TIMESTAMPDIFF(YEAR, publish_date, CURDATE()) AS years_since_publish
FROM book;

SELECT title, price, category_name
FROM category
INNER JOIN book
ON category.category_id = book.category_id;

SELECT *
FROM book
ORDER BY price DESC
LIMIT 2;

SELECT category_name, COUNT(*) AS cnt
FROM book
INNER JOIN category
ON category.category_id = book.category_id
GROUP BY category_name
HAVING COUNT(*) >= 2
ORDER BY cnt DESC; 

SELECT *
FROM book
WHERE price > (SELECT AVG(price) FROM book);
