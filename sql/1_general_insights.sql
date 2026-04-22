-- General business overview

-- monthly revenue and order volume
-- dataset starts Sep 2016 but Nov 2016 is missing entirely
-- Sep/Oct/Dec 2016 had 4, 324, 1 orders -- filtered out with HAVING > 500
SELECT 
    (DATE_TRUNC('month', o.order_purchase_timestamp)::date) AS month,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
HAVING COUNT(o.order_id) > 500
ORDER BY 1;


-- top 10 states by revenue
SELECT 
    c.customer_state AS region,
    ROUND(SUM(oi.price)::numeric, 2) AS state_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- top 5 product categories by revenue
SELECT 
    pcnt.product_category_name_english AS product_category,
    COUNT(oi.order_id) AS number_of_orders,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation pcnt ON pcnt.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;
