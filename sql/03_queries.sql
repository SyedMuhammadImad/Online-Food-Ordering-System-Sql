-- Online Food Ordering System — Analytical Queries
-- Run after 01_schema.sql and 02_sample_data.sql.
-- Each query is labeled with what it answers.

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

-- 5. Get orders by a specific user (e.g., 'foodie_01')
SELECT Orders.order_id, Orders.order_date, Orders.status, Orders.total_amount
FROM Orders
JOIN Users ON Orders.user_id = Users.user_id
WHERE Users.username = 'foodie_01';

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
