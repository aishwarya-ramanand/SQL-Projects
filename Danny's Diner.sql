USE Dannys_Diner;

SELECT *
FROM members;

SELECT *
FROM menu;

SELECT *
FROM sales; 

-- 1. What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(price) AS total_sales
FROM sales s
INNER JOIN menu m
USING (product_id)
GROUP BY customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) AS total_days
FROM sales
GROUP BY customer_id;

SELECT customer_id, COUNT(customer_id) AS total_days
FROM sales
GROUP BY customer_id;

-- 3.1 What was the first item from the menu purchased by each customer?

SELECT customer_id, product_name 
FROM (
SELECT *,
	    ROW_NUMBER() OVER(PARTITION BY customer_id) AS rn
FROM sales AS s
INNER JOIN menu m
USING (product_id)) AS t
WHERE rn = 1;

-- 3.2 What was the last order from the menu purchased by each customer?
SELECT customer_id, product_name 
FROM (
SELECT *,
	    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS rn
FROM sales AS s
INNER JOIN menu m
USING (product_id)) AS t
WHERE rn = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name, COUNT(product_name) AS cnt_name
FROM menu m
INNER JOIN sales s
USING (product_id)
GROUP BY product_name
ORDER BY cnt_name DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
SELECT *
FROM (
      SELECT customer_id, product_name, 
			 MAX(product_name) AS max_item, 
             COUNT(*) AS popular_item, 
             DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(*)) AS drnk
FROM sales s
INNER JOIN menu m 
USING(product_id)
GROUP BY customer_id, product_name) AS t
WHERE drnk = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT *
FROM (
SELECT s.customer_id,
       order_date,
       join_date,
       product_name,
       ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rn
FROM sales s
INNER JOIN menu m1
USING (product_id)
INNER JOIN members m2
ON s.customer_id = m2.customer_id
AND join_date < order_date) AS t
WHERE rn = 1;

-- 7. Which item was purchased just before the customer became a member?
SELECT *
FROM (
SELECT s.customer_id,
       order_date,
       join_date,
       product_name,
       RANK() OVER(PARTITION BY s.customer_id ORDER BY order_date DESC) AS rn
FROM sales s
INNER JOIN menu m1
USING (product_id)
INNER JOIN members m2
ON s.customer_id = m2.customer_id
AND join_date > order_date) AS t
WHERE rn = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(s.customer_id) AS total_items, SUM(price) AS TOTAL_AMOUNT_SPENT
FROM sales s
INNER JOIN menu m
USING (product_id)
INNER JOIN members m1
ON s.customer_id = m1.customer_id
AND order_date < join_date
GROUP BY s.customer_id;



/* SELECT customer_id, order_date
FROM (
SELECT *,
	    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS rn
FROM sales AS s
INNER JOIN members m
USING (customer_id)) AS t
WHERE rn = 1; */

/*SELECT customer_id, product_name 
FROM (
SELECT *,
	    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS rn
FROM sales AS s
INNER JOIN menu m
USING (product_id)) AS t
WHERE rn = 1; */


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT customer_id, SUM(
       CASE WHEN product_name = "Sushi" THEN price*20 
       ELSE price*10
       END) AS TOTAL_POINTS
FROM sales s
INNER JOIN menu m
USING (product_id)
GROUP BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?*/
SELECT 
  s.customer_id,
  SUM(
    CASE 
      WHEN s.order_date BETWEEN m.join_date AND DATE_ADD(m.join_date, INTERVAL 6 DAY)
      THEN 2 * me.price
      ELSE me.price
    END
  ) AS total_points
FROM Sales s
JOIN Members m ON s.customer_id = m.customer_id
JOIN Menu me ON s.product_id = me.product_id
WHERE s.order_date BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY s.customer_id;




















