-- A JOIN is used to combine rows from two or more tables based on a related column.

--0. NO JOIN

--Return data from tables without combining them.
SELECT *
FROM Customers;

SELECT *
FROM Orders;


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

----------------------------------------

SELECT
    Customers.customer_name,
    Orders.product
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id;

---------------------------------------

--3.RIGHT JOIN

--Returns all records from the right table and matching records from the left table.

-------------------------------------


SELECT
    Customers.customer_name,
    Orders.product
FROM Customers
RIGHT JOIN Orders
ON Customers.customer_id = Orders.customer_id;


----------------------------------

--4.FULL JOIN
--Returns all rows from both tables.

---------------------------------

SELECT Customers.customer_name,
       Orders.product
FROM Customers
FULL JOIN Orders
ON Customers.customer_id = Orders.customer_id;

---------------------------------------

-- INNER JOIN
-- A ∩ B
-- Only common records


-- LEFT JOIN
-- A + common records
-- (All rows from left)


-- RIGHT JOIN
-- B + common records
-- (All rows from right)


-- FULL JOIN
-- A + B
-- (All rows from both)


-- CROSS JOIN
-- A × B
-- Cartesian Product


-- SELF JOIN
-- A joined with itself



---------------------------------------

--TRICK TO REMEMBER

-- INNER JOIN  → Match Only
-- LEFT JOIN   → Left All + Match
-- RIGHT JOIN  → Right All + Match
-- FULL JOIN   → Everything
-- CROSS JOIN  → Every Combination
-- SELF JOIN   → Same Table with Itself