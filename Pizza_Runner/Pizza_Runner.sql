SELECT *
FROM customer_orders;

SELECT *
FROM pizza_names;

SELECT *
FROM pizza_recipes;

SELECT *
FROM pizza_toppings;

SELECT *
FROM runner_orders;

SELECT *
FROM runners;

# PART A - Pizza Metrics

# 1. How many pizzas were ordered?

SELECT COUNT(*) AS pizza_ordered
FROM customer_orders;

# 2. How many unique customer orders were made?

SELECT COUNT(DISTINCT(order_id)) AS unique_orders
FROM customer_orders;

# 3. How many successful orders were delivered by each runner?

SELECT runner_id AS runner, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation NOT IN ("Restaurant Cancellation", "Customer Cancellation")
      #OR cancellation != "null" 
      #OR cancellation IS NULL
GROUP BY runner_id;


# 4. How many of each type of pizza was delivered?

SELECT pizza_id, COUNT(*) AS total_delivered
FROM customer_orders
GROUP BY pizza_id;

# 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT c.customer_id, 
       p.pizza_name, 
       COUNT(*) AS total_delivered
FROM pizza_names p
INNER JOIN customer_orders c
USING (pizza_id)
#WHERE p.pizza_name IN ('Vegetarian', 'Meatlovers')
GROUP BY customer_id, pizza_name
ORDER BY customer_id;

# 6. What was the maximum number of pizzas delivered in a single order?

SELECT MAX(no_of_pizza) as max_pizza_delivered
FROM(
SELECT order_id, COUNT(*) AS no_of_pizza
FROM runner_orders
INNER JOIN customer_orders
USING (order_id)
WHERE cancellation IS NULL
	  OR cancellation = ''
	  OR cancellation = 'null'
GROUP BY order_id) AS total_pizza;

# 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT *
FROM customer_orders;

SELECT c.customer_id,
	   COUNT(CASE WHEN (c.exclusions IS NOT NULL AND c.exclusions != "" AND c.exclusions != "null") OR (c.extras IS NOT NULL AND extras != "" AND c.extras != "null") THEN 1
			END) AS pizza_delivered
FROM customer_orders c
INNER JOIN runner_orders r
USING (order_id)
WHERE r.cancellation IS NULL
	  OR r.cancellation = ""
	  OR r.cancellation = "null"
GROUP BY c.customer_id;
      
# 8. How many pizzas were delivered that had both exclusions and extras?

SELECT c.customer_id,
	   COUNT(CASE WHEN (c.exclusions IS NOT NULL AND c.exclusions != "" AND c.exclusions != "null") AND (c.extras IS NOT NULL AND extras != "" AND c.extras != "null") THEN 1
			END) AS pizza_delivered
FROM customer_orders c
INNER JOIN runner_orders r
USING (order_id)
WHERE r.cancellation IS NULL
	  OR r.cancellation = ""
	  OR r.cancellation = "null"
GROUP BY c.customer_id;

# 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT HOUR(order_time) AS each_hour,
       COUNT(*) AS total_pizza
FROM customer_orders
GROUP BY each_hour
ORDER BY each_hour DESC;


# 10. What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS each_day,
       COUNT(*) AS total_pizza
FROM customer_orders
GROUP BY each_day
ORDER BY total_pizza DESC;


# B. Runner and Customer Experience

# 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT *
FROM runner_orders;

SELECT *
FROM customer_orders;

SELECT 
    DATE_ADD('2021-01-01', INTERVAL 7 DAY) AS week_start,
    COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week_start
ORDER BY week_start;

SELECT 
    DATE_ADD('2021-01-01', INTERVAL FLOOR(DATEDIFF(registration_date, '2021-01-01')/7)*7 DAY) AS week_start,
    COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week_start
ORDER BY week_start;

# 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT runner_id, ROUND(AVG(duration),0) AS avg_time
FROM runner_orders ro
WHERE ro.cancellation IS NULL
	  OR ro.cancellation = ""
	  OR ro.cancellation = "null"
GROUP BY runner_id;

# 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT 
    c.order_id,
    COUNT(c.pizza_id) AS pizza_count,
    TIMESTAMPDIFF(
        MINUTE,
        MIN(c.order_time),      -- order placed
        MIN(r.pickup_time)      -- runner picked it up
    ) AS prep_time_minutes
FROM customer_orders c
JOIN runner_orders r 
    ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
   OR r.cancellation = ''
   OR r.cancellation = 'null'
GROUP BY c.order_id
ORDER BY pizza_count, prep_time_minutes;

# 4. What was the average distance travelled for each customer?

SELECT c.customer_id, ROUND(AVG(distance),0) AS avg_dist_travelled
FROM runner_orders ro
INNER JOIN customer_orders c
USING(order_id)
WHERE ro.cancellation IS NULL
	  OR ro.cancellation = ""
	  OR ro.cancellation = "null"
GROUP BY c.customer_id
ORDER BY avg_dist_travelled DESC;

# 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT order_id, MAX(distance)- MIN(distance) AS diff_delivery
FROM runner_orders ro
INNER JOIN customer_orders 
USING(order_id)
WHERE ro.cancellation IS NULL
	  OR ro.cancellation = ""
	  OR ro.cancellation = "null"
GROUP BY order_id;

# 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT runner_id,
       ROUND(AVG(distance/duration),2) AS avg_speed
FROM runner_orders
WHERE cancellation IS NULL
	  OR cancellation = ""
	  OR cancellation = "null"
GROUP BY runner_id;


# 7. What is the successful delivery percentage for each runner?

SELECT runner_id,
	   ROUND((SUM(CASE WHEN (cancellation IS NULL OR cancellation = "" OR cancellation = "null") THEN 1
		   ELSE 0
           END)/COUNT(*)) *100, 2) AS percent_delivery
FROM runner_orders
GROUP BY runner_id;

# C. Ingredient Optimisation

SELECT *
FROM pizza_recipes;

SELECT *
FROM pizza_toppings;

# 1. What are the standard ingredients for each pizza?

SELECT DISTINCT(topping_name) AS ingredient
FROM pizza_toppings;

# 2. What was the most commonly added extra?

SELECT t.topping_id,
       t.topping_name,
       COUNT(*) AS times_added
FROM pizza_toppings t
INNER JOIN customer_orders c
  ON FIND_IN_SET(t.topping_id, c.extras) > 0
WHERE c.extras IS NOT NULL
  AND c.extras != ''
  AND c.extras != 'null'
GROUP BY t.topping_id, t.topping_name
ORDER BY times_added DESC
LIMIT 1;

# 3. Generate an order item for each record in the customers_orders table in the format of one of the following:
# Meat Lovers
# Meat Lovers - Exclude Beef
# Meat Lovers - Extra Bacon
# Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

SELECT *
FROM customer_orders;

SELECT *
FROM pizza_names;

SELECT *
FROM pizza_toppings;

SELECT order_id,
       pizza_id,
       CONCAT(
         'Pizza ', pizza_id,
         CASE 
           WHEN exclusions IS NOT NULL AND exclusions NOT IN ('', 'null')
           THEN CONCAT(' - Exclude ', exclusions)
           ELSE ''
         END,
         CASE 
           WHEN extras IS NOT NULL AND extras NOT IN ('', 'null')
           THEN CONCAT(' - Extra ', extras)
           ELSE ''
         END
       ) AS order_item
FROM customer_orders;

SELECT c.order_id,
       p.pizza_name,
       CONCAT(
         p.pizza_name,
         CASE 
           WHEN c.exclusions IS NOT NULL 
                AND c.exclusions NOT IN ('', 'null') 
           THEN CONCAT(' - Exclude ', 
                       GROUP_CONCAT(DISTINCT t1.topping_name ORDER BY t1.topping_name SEPARATOR ', '))
           ELSE ''
         END,
         CASE 
           WHEN c.extras IS NOT NULL 
                AND c.extras NOT IN ('', 'null') 
           THEN CONCAT(' - Extra ', 
                       GROUP_CONCAT(DISTINCT t2.topping_name ORDER BY t2.topping_name SEPARATOR ', '))
           ELSE ''
         END
       ) AS order_item
FROM customer_orders c
JOIN pizza_names p
  ON c.pizza_id = p.pizza_id
LEFT JOIN pizza_toppings t1
  ON FIND_IN_SET(t1.topping_id, c.exclusions) > 0
LEFT JOIN pizza_toppings t2
  ON FIND_IN_SET(t2.topping_id, c.extras) > 0
GROUP BY c.order_id, p.pizza_name, c.exclusions, c.extras;

# 4. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
# For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

with order_base as (
    select 
        co.order_id,
        co.pizza_id,
        pn.pizza_name,
        co.extras
    from customer_orders co
    join pizza_names pn on co.pizza_id = pn.pizza_id
),
topping_list as (
    select 
        ob.order_id,
        ob.pizza_name,
        pt.topping_name,
        case 
            when find_in_set(pt.topping_id, ob.extras) then concat('2x', pt.topping_name)
            else pt.topping_name
        end as final_topping
    from order_base ob
    join pizza_recipes pr on ob.pizza_id = pr.pizza_id
    join pizza_toppings pt 
      on find_in_set(pt.topping_id, pr.toppings)
)
select 
    order_id,
    concat(
        pizza_name, ': ',
        group_concat(final_topping order by final_topping separator ', ')
    ) as ingredient_list
from topping_list
group by order_id, pizza_name
order by order_id;

# 5. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

SELECT t.topping_name, COUNT(*) AS total_used
FROM customer_orders c
INNER JOIN runner_orders r 
USING(order_id) INNER JOIN pizza_recipes pr 
USING(pizza_id) INNER JOIN pizza_toppings t 
ON FIND_IN_SET(t.topping_id, pr.toppings)
WHERE r.distance IS NOT NULL
GROUP BY t.topping_name
ORDER BY total_used DESC;

# D. Pricing and Ratings

# 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

SELECT pizza_id,
	   SUM(CASE WHEN pizza_name = "Meatlovers" THEN 12
                ELSE 10
			END) AS total_amount
FROM pizza_names p
INNER JOIN customer_orders c
USING (pizza_id)
GROUP BY pizza_id;

# 2. What if there was an additional $1 charge for any pizza extras?
# Add cheese is $1 extra

SELECT c.pizza_id,
       p.pizza_name,
       SUM(
         CASE 
           WHEN p.pizza_name = 'Meatlovers' THEN 12
           WHEN p.pizza_name = 'Vegetarian' THEN 10
         END
         +
         -- Add $1 per extra topping
         CASE 
           WHEN c.extras IS NOT NULL AND c.extras NOT IN ('', 'null')
           THEN LENGTH(c.extras) - LENGTH(REPLACE(c.extras, ',', '')) + 1
           ELSE 0
         END
       ) AS total_amount
FROM customer_orders c
JOIN pizza_names p USING (pizza_id)
GROUP BY c.pizza_id, p.pizza_name;



# 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
# how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

CREATE TABLE runner_ratingss (
  order_id INT PRIMARY KEY,
  runner_id INT,
  customer_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5)
);

-- Example insert
INSERT INTO runner_ratingss VALUES
(1, 1, 101, 5),
(2, 1, 101, 4),
(3, 1, 102, 5),
(4, 2, 103, 4),
(5, 3, 104, 5),
(7, 2, 105, 3),
(8, 2, 102, 5),
(10, 1, 104, 4);

select * from runner_ratingss;
   


# 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
# customer_id
# order_id
# runner_id
# rating
# order_time
# pickup_time
# Time between order and pickup
# Delivery duration
# Average speed
# Total number of pizzas

SELECT 
    c.customer_id,
    c.order_id,
    r.runner_id,
    rr.rating,
    c.order_time,
    r.pickup_time,
    TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) AS time_to_pickup,
    r.duration AS delivery_duration,
    ROUND(
        CAST(REPLACE(REPLACE(r.distance, 'km', ''), ' ', '') AS DECIMAL(5,2)) /
        NULLIF(CAST(REPLACE(REPLACE(REPLACE(r.duration, 'minutes', ''), 'mins', ''), 'minute', '') AS DECIMAL(5,2)), 0)
    , 2) AS avg_speed_km_per_minute,
    COUNT(c.pizza_id) AS total_pizzas
FROM customer_orders c
JOIN runner_orders r 
    ON c.order_id = r.order_id
JOIN runner_ratingss rr
    ON c.order_id = rr.order_id
WHERE r.cancellation IS NULL 
   OR r.cancellation = '' 
   OR r.cancellation = 'null'
GROUP BY c.customer_id, c.order_id, r.runner_id, rr.rating, c.order_time, r.pickup_time, r.duration, r.distance
ORDER BY c.customer_id, c.order_id;


# 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

SELECT pizza_id,
	   ROUND(SUM((CASE WHEN pizza_name = "Meatlovers" THEN 12
                ELSE 10 END) - (ro.distance * 0.30)),2) AS net_profit
FROM pizza_names p
INNER JOIN customer_orders c
USING (pizza_id)
INNER JOIN runner_orders ro
ON c.order_id = ro.order_id
WHERE ro.distance IS NOT NULL
GROUP BY pizza_id;

SELECT ROUND(SUM((CASE WHEN pizza_name = "Meatlovers" THEN 12
                ELSE 10 END) - (ro.distance * 0.30)),2) AS net_profit
FROM pizza_names p
INNER JOIN customer_orders c
USING (pizza_id)
INNER JOIN runner_orders ro
ON c.order_id = ro.order_id
WHERE ro.distance IS NOT NULL;


