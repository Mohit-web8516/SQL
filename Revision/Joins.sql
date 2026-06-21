-- A JOIN is used to combine rows from two or more tables based on a related column.


--1. INNER JOIN

-- Returns only the matching records from both tables.

-------------------------------------------

SELECT
    Customers.customer_id,
    Customers.customer_name,
    Orders.product
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id;

------------------------------------------

-- 2. LEFT JOIN

-- Returns all records from the left table and matching records from the right table.

SELECT
    Customers.customer_name,
    Orders.product
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id;

