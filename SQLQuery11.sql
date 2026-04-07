--retrieve only 3 customers

SELECT TOP 3*
FROM customers


--retrieve top 3 customers with the highest scores

SELECT *
FROM customers 
ORDER BY score DESC



--RETRIEVE LOWEST 2 CUSTOMERS BASED ON THE SCORE


SELECT *
FROM customers 
ORDER BY score ASC


--GET THE TWO MOST  RECENT  ORDERS 


SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC