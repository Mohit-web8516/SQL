--FIND THE TOTAL SCORE FOR EACH COUNTRY

/*
SELECT 
	country,
	first_name,
	SUM(score) AS total_score
FROM customers
GROUP BY Country,first_name*/




SELECT 
	country,
	
	SUM(score) AS total_score
FROM customers
GROUP BY Country

/*find the total score and total numbwer of 
customer for each country*/


SELECT 
	country,
	
	SUM(score) AS total_score,
	COUNT(id) AS total_customers
FROM customers
GROUP BY Country