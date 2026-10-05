-- SQL Script for Online Food Ordering System
-- Created by a top-performing student

-- =========================================
-- Part 1: DROP TABLES IF THEY EXIST (To prevent errors)
-- =========================================

DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Menu_Items;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Users;

-- =========================================
-- Part 1: CREATE TABLES (DDL)
-- =========================================

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    address TEXT,
    created_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    phone_number VARCHAR(15),
    opening_time TIME,
    closing_time TIME
);

CREATE TABLE Menu_Items (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) CHECK (price > 0),
    category VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    restaurant_id INT,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Preparing', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10, 2),
    method VARCHAR(50) CHECK (method IN ('Cash', 'Credit Card', 'Debit Card', 'Online')),
    payment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    user_id INT,
    restaurant_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- =========================================
-- Part 2: INSERT SAMPLE DATA (DML)
-- =========================================

-- Users
INSERT INTO Users VALUES (1, 'imad_01', 'imad@gmail.com', 'pass123', '03001234567', 'Karachi', '2025-06-01');
INSERT INTO Users VALUES (2, 'sana_92', 'sana@hotmail.com', 'sana456', '03007654321', 'Lahore', '2025-06-03');
INSERT INTO Users VALUES (3, 'ali_k', 'ali@yahoo.com', 'ali321', '03111222333', 'Islamabad', '2025-06-05');

-- Restaurants
INSERT INTO Restaurants VALUES (1, 'Pizza Palace', 'Karachi', '0213456789', '11:00:00', '23:00:00');
INSERT INTO Restaurants VALUES (2, 'Burger Town', 'Lahore', '0429876543', '10:00:00', '22:00:00');

-- Menu Items
INSERT INTO Menu_Items VALUES (1, 1, 'Pepperoni Pizza', 'Large pizza with extra cheese', 1200.00, 'Pizza');
INSERT INTO Menu_Items VALUES (2, 1, 'Veggie Pizza', 'Loaded with vegetables', 1000.00, 'Pizza');
INSERT INTO Menu_Items VALUES (3, 2, 'Cheese Burger', 'Grilled beef with cheddar', 550.00, 'Burger');
INSERT INTO Menu_Items VALUES (4, 2, 'Chicken Burger', 'Crispy chicken with mayo', 500.00, 'Burger');

-- Orders
INSERT INTO Orders VALUES (1, 1, 1, '2025-06-10', 'Delivered', 2200.00);
INSERT INTO Orders VALUES (2, 2, 2, '2025-06-12', 'Preparing', 1050.00);

-- Order Items
INSERT INTO Order_Items VALUES (1, 1, 1, 1);
INSERT INTO Order_Items VALUES (2, 1, 2, 1);
INSERT INTO Order_Items VALUES (3, 2, 3, 1);
INSERT INTO Order_Items VALUES (4, 2, 4, 1);

-- Payments
INSERT INTO Payments VALUES (1, 1, 2200.00, 'Credit Card', '2025-06-10');
INSERT INTO Payments VALUES (2, 2, 1050.00, 'Cash', '2025-06-12');

-- Reviews
INSERT INTO Reviews VALUES (1, 1, 1, 5, 'Best pizza ever!', '2025-06-11');
INSERT INTO Reviews VALUES (2, 2, 2, 4, 'Burger was tasty and fresh.', '2025-06-13');

-- =========================================
-- Part 3: Complex SELECT Queries
-- =========================================

-- 1. Get all orders with customer name and restaurant name
SELECT Orders.order_id, Users.username, Restaurants.name AS restaurant_name, Orders.order_date, Orders.status, Orders.total_amount
FROM Orders
JOIN Users ON Orders.user_id = Users.user_id
JOIN Restaurants ON Orders.restaurant_id = Restaurants.restaurant_id;

-- 2. Find total sales by each restaurant
SELECT Restaurants.name AS restaurant_name, SUM(Orders.total_amount) AS total_sales
FROM Restaurants
JOIN Orders ON Restaurants.restaurant_id = Orders.restaurant_id
GROUP BY Restaurants.name;

-- 3. List menu items along with restaurant name and category
SELECT Menu_Items.name AS item_name, Restaurants.name AS restaurant_name, Menu_Items.category, Menu_Items.price
FROM Menu_Items
JOIN Restaurants ON Menu_Items.restaurant_id = Restaurants.restaurant_id;

-- 4. Top-rated restaurants (average rating)
SELECT Restaurants.name AS restaurant_name, ROUND(AVG(Reviews.rating),2) AS avg_rating
FROM Restaurants
JOIN Reviews ON Restaurants.restaurant_id = Reviews.restaurant_id
GROUP BY Restaurants.name
ORDER BY avg_rating DESC;

-- 5. Get orders by a specific user (e.g., 'imad_01')
SELECT Orders.order_id, Orders.order_date, Orders.status, Orders.total_amount
FROM Orders
JOIN Users ON Orders.user_id = Users.user_id
WHERE Users.username = 'imad_01';

-- 6. Find users who ordered more than once
SELECT Users.username, COUNT(Orders.order_id) AS order_count
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
GROUP BY Users.username
HAVING COUNT(Orders.order_id) > 1;

-- 7. List items in each order with their quantity and total price
SELECT Order_Items.order_id, Menu_Items.name AS item_name, Order_Items.quantity, (Order_Items.quantity * Menu_Items.price) AS item_total
FROM Order_Items
JOIN Menu_Items ON Order_Items.item_id = Menu_Items.item_id;

-- 8. Get latest reviews with user and restaurant info
SELECT Users.username, Restaurants.name AS restaurant_name, Reviews.rating, Reviews.comment, Reviews.review_date
FROM Reviews
JOIN Users ON Reviews.user_id = Users.user_id
JOIN Restaurants ON Reviews.restaurant_id = Restaurants.restaurant_id
ORDER BY Reviews.review_date DESC;

-- 9. Count of total orders by status
SELECT status, COUNT(*) AS total_orders
FROM Orders
GROUP BY status;

-- 10. Total revenue by payment method
SELECT method, SUM(amount) AS total_revenue
FROM Payments
GROUP BY method;
