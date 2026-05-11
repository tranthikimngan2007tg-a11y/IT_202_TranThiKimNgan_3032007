CREATE DATABASE ss05;
USE ss05;

-- tạo bảng products có ~ thuộc tính(id, tên, giá tiền, số lượng, ngày nhập, mô tả)

CREATE TABLE products (
	pro_id VARCHAR(15) PRIMARY KEY,
    pro_name VARCHAR(150) NOT NULL,
    pro_price DECIMAL(10, 2) NOT NULL CHECK(pro_price>=0),
    quantity INT DEFAULT 0,
    pro_date DATE DEFAULT (CURRENT_DATE),
    pro_descripstion TEXT
);

INSERT INTO products VALUES
('P001', 'TV', 10000000, 10, '2026-03-30','Ti vi siêu mỏng'),
('P002', 'Tủ lạnh', 30000000, 10, '2026-06-25','Tủ lạnh rất lạnh'),
('P003', 'Máy giặt', 20000000, 10, default,'Máy giặt rất sạch'),
('P004', 'Máy lạnh', 10000000, 10, default,'Máy lạnh rất lạnh'),
('P005', 'Máy rửa chén', 10000000, 10, default,'Máy rửa chén rất sạch');
INSERT INTO products VALUES
('P006', 'Máy rửa xe' ,10000000, 10, default,'Không có'),
('P007', 'Máy rửa dép', 10000000, 10, default,'Không có');

-- Lấy ra tất cả sản phẩm như hiển thị tên và giá
-- Dùng as để đặt tên

SELECT pro_name, pro_price
FROM products;

SELECT p.pro_name AS 'Tên sản phẩm', p.pro_price
FROM products AS p;

-- Sử dụng CASE WHEN

SELECT pro_name, pro_price,
case
	when pro_price >20000000 THEN 'Gia cao'
    when pro_price between 15000000 and 20000000 THEN 'Trung bình'
    else 'Thấp'
end as 'price_level'
from products;
-- Cách 2
SELECT pro_name, pro_price,
case pro_price
	when 30000000 THEN 'Gia cao'
    when 20000000 THEN 'Trung bình'
    else 'Thấp'
end as 'price_level'
from products;

-- Lấy ra danh sách sản phẩm có giá tiền lớn hơn 15tr
-- Lấy ra danh sách sản phẩm không có mô tả

select *
from products where pro_price > 15000000;

select *
from products where pro_descripstion = 'không có';

-- Lấy ra danh sách sản phẩm có giá tiền trong khoảng 15tr-30tr và có số kượng = 10

select *
from products where (pro_price between 15000000 and 30000000) and quantity = 10 ;

-- Lấy ra ds trong ngày và không null 

select *
from products where pro_date = DATE(current_date) and pro_descripstion is not null;

-- Lấy ra ds sp có tên bắt đầu bằng chữ 'T'
select *
from products where pro_name LIKE 'T%';

-- Lấy ra ds sp có chữ 'may' nằm trong tên 
select *
from products where pro_name LIKE '%máy%';

-- Lấy ra ds sp có chữ kết thúc là 'nh' hoặc 'n'
select *
from products where pro_name LIKE '%nh' or pro_name LIKE '%n';

-- Lấy ra ds sp có giá lớn hơn 20tr và có số lượng bé hơn 20 , sắp xếp danh sách tăng dần theo giá tiền nếu = giá tiền thì sx dựa trên số lượng 
select *
from products where pro_price > 20000000 and quantity < 20
order by pro_price asc, quantity asc;