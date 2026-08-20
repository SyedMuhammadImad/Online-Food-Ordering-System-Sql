-- Online Food Ordering System — Sample Data (DML)
-- Run after 01_schema.sql. Populates every table with a small, connected
-- dataset so the queries in 03_queries.sql return meaningful results.

-- Users
INSERT INTO Users VALUES (1, 'foodie_01', 'foodie01@example.com', 'pass123', '03001234567', 'Karachi', '2025-06-01');
INSERT INTO Users VALUES (2, 'hungry_hana', 'hana@example.com', 'hana456', '03007654321', 'Lahore', '2025-06-03');
INSERT INTO Users VALUES (3, 'quick_bites', 'quickbites@example.com', 'qb321', '03111222333', 'Islamabad', '2025-06-05');

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
