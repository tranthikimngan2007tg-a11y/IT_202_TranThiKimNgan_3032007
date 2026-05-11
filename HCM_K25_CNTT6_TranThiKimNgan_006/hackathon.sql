CREATE DATABASE de006;
USE de006;
DROP DATABASE de006;
CREATE TABLE users (
	user_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE categories (
	category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE books (
	book_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(100) NOT NULL UNIQUE,
    category_id VARCHAR(5) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    CONSTRAINT refs_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE borrows (
	borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(5) NOT NULL,
    book_id VARCHAR(5) NOT NULL,
    status VARCHAR(20) NOT NULL,
    borrow_date DATE NOT NULL,
    CONSTRAINT refs_users FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT refs_books FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO users VALUES 
('U01', 'Nguyễn Văn An', 'a@m.com', '0912345678'),
('U02', 'Trần Thị Bích', 'b@m.com', '0923456789'),
('U03', 'Lê Hoàng Minh', 'mi@m.com', '0934567890'),
('U04', 'Phạm Thu Hà', 'h@m.com', '0945678901'),
('U05', 'Võ Quốc Huy', 'hu@m.com', '0956789012');

INSERT INTO categories VALUES 
('C01', 'IT'),
('C02', 'Literature'),
('C03', 'Science'),
('C04', 'History');

INSERT INTO books VALUES
('B01', 'Clean Code', 'C01', 250000, 10),
('B02', 'Design Pattem', 'C01', 300000, 5),
('B03', 'Tat Den', 'C02', 50000, 20),
('B04', 'Universe', 'C03', 150000, 8),
('B05', 'Sapiens', 'C04', 200000, 15);

INSERT INTO borrows VALUES
(1, 'U01', 'B01', 'Borrowing', '2025-10-01'),
(2, 'U02', 'B03', 'Returned', '2025-10-02'),
(3, 'U01', 'B02', 'Returned', '2025-10-03'),
(4, 'U04', 'B05', 'Lost', '2025-10-04'),
(5, 'U05', 'B01', 'Borrowing', '2025-10-05');

UPDATE books
SET stock = stock + 10 
WHERE title = 'Sapiens';

UPDATE books
SET price = price * 1.05
WHERE title = 'Sapiens';

UPDATE users
SET phone = '0999999999'
WHERE user_id = 'U03';

DELETE FROM borrows
WHERE status = 'Returned' AND borrow_date = '2025-10-03';

SELECT book_id, title, price 
FROM books 
WHERE (price BETWEEN 100000 AND 250000) AND stock > 0;

SELECT full_name, email
FROM users 
WHERE full_name LIKE'Nguyen%';

SELECT borrow_id, user_id, borrow_date
FROM borrows
ORDER BY borrow_date DESC;

SELECT *
FROM books
ORDER BY price DESC
LIMIT 3;

SELECT title, stock 
FROM books
LIMIT 2 OFFSET 2;

SELECT borrow_id, full_name, borrow_date 
FROM borrows 
INNER JOIN users
ON borrows.user_id = users.user_id
WHERE status = 'Borrowing' ;

SELECT category_name, title 
FROM categories AS c
LEFT JOIN books AS b
ON c.category_id = b.category_id;

SELECT status, COUNT(status) AS total_borrows
FROM borrows
GROUP BY status;


SELECT full_name , COUNT(user_id) AS 'lượt mượn'
FROM users
GROUP BY user_id
HAVING COUNT(user_id) > 2;

SELECT book_id, title, price, AVG(price)
FROM books
GROUP BY title
HAVING price <  AVG(price);

SELECT full_name, phone
FROM users
WHERE user_id IN  
(SELECT user_id 
FROM borrows AS br
INNER JOIN books AS b
ON br.book_id = b.book_id 
WHERE title = 'Clean Code');