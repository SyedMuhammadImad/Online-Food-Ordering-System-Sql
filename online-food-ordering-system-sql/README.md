# Online Food Ordering System (SQL)

A relational database design for an online food ordering platform — covering
users, restaurants, menus, orders, payments, and reviews — along with a set
of analytical queries for reporting on sales, ratings, and order activity.

## Schema Overview

| Table | Purpose |
|---|---|
| `Users` | Registered customers |
| `Restaurants` | Partner restaurants and their operating hours |
| `Menu_Items` | Dishes offered by each restaurant |
| `Orders` | Customer orders, linked to a user and restaurant |
| `Order_Items` | Line items within each order (item + quantity) |
| `Payments` | Payment records for each order |
| `Reviews` | Customer ratings and comments per restaurant |

**Relationships:**
- A `Restaurant` has many `Menu_Items`
- A `User` places many `Orders`; each `Order` belongs to one `Restaurant`
- An `Order` has many `Order_Items`, each referencing a `Menu_Item`
- An `Order` has one `Payment`
- A `User` can leave many `Reviews` for different `Restaurants`

All foreign keys enforce referential integrity, and `CHECK` constraints
validate order status, payment method, price, quantity, and rating ranges.

## Files

```
sql/
├── 01_schema.sql        # Table definitions (DDL) with keys and constraints
├── 02_sample_data.sql   # Sample rows for every table (DML)
└── 03_queries.sql       # 10 analytical queries for reporting
```

## How to Run

Using any standard SQL client (MySQL, PostgreSQL*, SQLite, etc.):

```bash
mysql -u your_user -p your_database < sql/01_schema.sql
mysql -u your_user -p your_database < sql/02_sample_data.sql
mysql -u your_user -p your_database < sql/03_queries.sql
```

*If using PostgreSQL, change `TIME`/`DATE` defaults as needed — this script
was written against MySQL syntax (`CURRENT_DATE` as a column default).

## Example Queries Included

- Full order history with customer and restaurant names
- Total sales per restaurant
- Top-rated restaurants by average review rating
- Users who've ordered more than once (repeat customers)
- Revenue breakdown by payment method
- Per-order itemized totals

## Tech

- Standard SQL (DDL + DML + analytical SELECT queries with JOINs, GROUP BY, HAVING)
