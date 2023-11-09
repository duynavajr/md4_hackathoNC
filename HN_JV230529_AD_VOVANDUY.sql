CREATE DATABASE IF NOT EXISTS quanlybanhang;

USE quanlybanhang;

CREATE TABLE customers (
    customer_id VARCHAR(4) PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(25) NOT NULL,
    address VARCHAR(255) NOT NULL
);
CREATE TABLE products (
    product_id VARCHAR(4) PRIMARY KEY NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    status BIT DEFAULT 1
);

CREATE TABLE orders (
    order_id VARCHAR(4) PRIMARY KEY NOT NULL,
    customer_id VARCHAR(4) NOT NULL,
    order_date DATE NOT NULL,
    total_amount DOUBLE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);



CREATE TABLE orders_details (
    order_id VARCHAR(4) NOT NULL,
    product_id VARCHAR(4) NOT NULL,
    quantity INT(11) NOT NULL,
    price DOUBLE NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- thêm dữ liệu vào các bảng 
-- Thêm dữ liệu vào bảng customers
INSERT INTO customers (customer_id, name, email, phone, address) VALUES
    ("C001", "Nguyễn Trung Mạnh", "manhnt@gmail.com", "984756322", "Cầy Giấy, Hà Nội"),
    ("C002", "Hồ Hải Nam", "namhh@gmail.com", "984875926", "Ba Vì, Hà Nội"),
    ("C003", "Tô Ngọc Vũ", "vutn@gmail.com", "904725784", "Mộc Châu, Sơn La"),
    ("C004", "Phạm Ngọc Anh", "anhpn@gmail.com", "984635365", "Vinh, Nghệ An"),
    ("C005", "Trương Minh Cường", "cuongtm@gmail.com", "9897356242", "Hai Bà Trưng, Hà Nội");

-- Thêm dữ liệu vào bảng products
INSERT INTO products (product_id, name, description, price) VALUES
    ("P001", "Iphone 13proMax", "Bản 512GB, xanh lá", 22999999),
    ("P002", "Dell Vostro V3510", "Core i5, RAM 8GB", 14999999),
    ("P003", "Macbook Pro M2", "8CPU 10GPU 8GB 256GB", 28999999),
    ("P004", "Apple Watch Ultra", "Titanium Alpine loop Small", 18999999),
    ("P005", "Airpods 2 2022", "Spatial Audio", 4090000);

-- Thêm dữ liệu vào bảng ORDERS
INSERT INTO orders (order_id, customer_id, total_amount, order_date) VALUES
    ("H001", "C001", 52999997, "2023-02-22"),
    ("H002", "C001", 80999997, "2023-03-11"),
    ("H003", "C002", 54359998, "2023-01-22"),
    ("H004", "C003", 102999995, "2023-03-14"),
    ("H005", "C003", 80999997, "2022-03-12"),
    ("H006", "C004", 110449994, "2023-02-01"),
    ("H007", "C004", 79999996, "2023-03-29"),
    ("H008", "C005", 29999998, "2023-02-14"),
    ("H009", "C005", 28999999, "2023-01-10"),
    ("H010", "C005", 149999994, "2023-04-01");

-- Thêm dữ liệu vào bảng ORDERS_DETAILS
INSERT INTO orders_details (order_id, product_id, price, quantity) VALUES
    ("H001", "P002", 14999999, 1),
    ("H001", "P004", 18999999, 2),
    ("H002", "P001", 22999999, 1),
    ("H002", "P003", 28999999, 2),
    ("H003", "P004", 18999999, 2),
    ("H003", "P005", 4090000, 4),
    ("H004", "P002", 14999999, 3),
    ("H004", "P003", 28999999, 2),
    ("H005", "P001", 12999999, 1),
    ("H005", "P003", 28999999, 2),
    ("H006", "P005", 4090000, 5),
    ("H006", "P002", 14999999, 6),
    ("H007", "P004", 18999999, 3),
    ("H007", "P001", 22999999, 1),
    ("H008", "P002", 14999999, 2),
    ("H009", "P003", 28999999, 1),
    ("H010", "P003", 28999999, 2),
    ("H010", "P001", 22999999, 4);
-- Bài 3: Truy vấn dữ liệu
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
SELECT name, email, phone, address FROM customers;
-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
SELECT c.name, c.phone, c.address
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023 AND MONTH(o.order_date) = 3;
-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ).
SELECT 
MONTH(order_date) AS month,SUM(total_amount) AS total_revenue
FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(order_date);
-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
SELECT c.name, c.address, c.email, c.phone
FROM customers c
WHERE c.customer_id NOT IN (
SELECT DISTINCT o.customer_id
FROM orders o
WHERE YEAR(o.order_date) = 2023 AND MONTH(o.order_date) = 2
);
-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).
SELECT od.product_id,p.name AS product_name, SUM(od.quantity) AS total_quantity_sold
FROM orders_details od
JOIN orders o ON od.order_id = o.order_id
JOIN products p ON od.product_id = p.product_id
WHERE YEAR(o.order_date) = 2023 AND MONTH(o.order_date) = 3
GROUP BY od.product_id, p.name;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần
-- theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
SELECT c.customer_id, c.name AS customer_name, SUM(o.total_amount) AS total_spending
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
GROUP BY c.customer_id, c.name
ORDER BY total_spending DESC;

--  7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
SELECT c.name AS customer_name, o.total_amount, o.order_date, 
SUM(od.quantity) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN orders_details od ON o.order_id = od.order_id
GROUP BY o.order_id
HAVING SUM(od.quantity) >=5;

-- Bài 4: Tạo View, Procedure
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn
CREATE VIEW info AS
SELECT c.name AS customer_name, c.phone, c.address, o.total_amount,o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
SELECT * FROM info;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt.
CREATE VIEW CustomerInfo AS
SELECT c.name AS customer_name, c.address, c.phone, 
COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
SELECT * FROM CustomerInfo;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
CREATE VIEW ProductInfo AS
SELECT p.name AS product_name, p.description,p.price, 
SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN orders_details od ON p.product_id = od.product_id
GROUP BY p.product_id;
SELECT * FROM ProductInfo;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer.
CREATE INDEX idx_phone ON customers(phone);
CREATE INDEX idx_email ON customers(email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.-- 
DELIMITER //
CREATE PROCEDURE GetCustomerInfo(IN customerId VARCHAR(4))
BEGIN
    SELECT * FROM customers WHERE customer_id = customerId;
END//
DELIMITER ;
CALL GetCustomerInfo('C001');

-- 
DELIMITER //

-- 6 Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM products;
END//

DELIMITER ;
CALL GetAllProducts()

-- 7 Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER //
CREATE PROCEDURE OrdersByCustomerId(IN input_customer_id VARCHAR(4))
BEGIN
    SELECT * FROM orders WHERE customer_id = input_customer_id;
END//
DELIMITER ;
CALL OrdersByCustomerId('C001');

-- 8 Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng,
 -- tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
 
DELIMITER //

CREATE PROCEDURE CreateNewOrder(
    IN input_customer_id VARCHAR(4),
    IN input_total_amount DOUBLE,
    IN input_order_date DATE
)
BEGIN
    DECLARE new_order_id VARCHAR(4);
    SET new_order_id = CONCAT('H', LPAD((SELECT COUNT(*) FROM orders) + 1, 3, '0'));
    INSERT INTO orders (order_id, customer_id, total_amount, order_date)
    VALUES (new_order_id, input_customer_id, input_total_amount, input_order_date);
    SELECT new_order_id AS new_order_id;
END//

DELIMITER ;
CALL CreateNewOrder('C002', 1500000, '2023-11-09');

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
DELIMITER //
CREATE PROCEDURE CountProduct(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT p.product_id, p.name AS product_name, SUM(od.quantity) AS total_quantity_sold
    FROM products p
    JOIN orders_details od ON p.product_id = od.product_id
    JOIN orders o ON od.order_id = o.order_id
    WHERE o.order_date BETWEEN start_date AND end_date
    GROUP BY p.product_id, p.name;
END//
DELIMITER ;
CALL CountProduct('2023-01-01', '2023-12-31');

-- 10 Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
DELIMITER //
CREATE PROCEDURE CountProductByMonth(
    IN input_month INT,
    IN input_year INT
)
BEGIN
    SELECT 
        p.product_id,
        p.name AS product_name,
        SUM(od.quantity) AS total_quantity_sold
    FROM
        products p
    JOIN
        orders_details od ON p.product_id = od.product_id
    JOIN
        orders o ON od.order_id = o.order_id
    WHERE
        MONTH(o.order_date) = input_month AND YEAR(o.order_date) = input_year
    GROUP BY
        p.product_id, p.name
    ORDER BY
        total_quantity_sold DESC;
END//
DELIMITER ;
CALL CountProductByMonth(3, 2023);













 


