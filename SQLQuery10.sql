/*change the score of customer 10 to 0 
and update the country to uk */



UPDATE customers
SET score = 0,
  country = 'UK'
WHERE  id = 6



SELECT *
FROM customers
WHERE id = 6