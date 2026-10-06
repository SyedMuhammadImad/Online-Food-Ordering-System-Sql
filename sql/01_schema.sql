-- Online Food Ordering System — Schema (DDL)
-- Creates all tables with primary keys, foreign keys, and constraints.

-- Drop tables if they exist (safe re-run order: children before parents)
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Menu_Items;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
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
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    category VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Preparing', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(50) CHECK (method IN ('Cash', 'Credit Card', 'Debit Card', 'Online')),
    payment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- SQLite validation: an item must belong to the restaurant receiving the order.
CREATE TRIGGER order_item_restaurant_insert BEFORE INSERT ON Order_Items
WHEN (SELECT restaurant_id FROM Orders WHERE order_id=NEW.order_id)
  != (SELECT restaurant_id FROM Menu_Items WHERE item_id=NEW.item_id)
BEGIN SELECT RAISE(ABORT, 'Item restaurant does not match order restaurant'); END;
CREATE TRIGGER order_item_restaurant_update BEFORE UPDATE ON Order_Items
WHEN (SELECT restaurant_id FROM Orders WHERE order_id=NEW.order_id)
  != (SELECT restaurant_id FROM Menu_Items WHERE item_id=NEW.item_id)
BEGIN SELECT RAISE(ABORT, 'Item restaurant does not match order restaurant'); END;
