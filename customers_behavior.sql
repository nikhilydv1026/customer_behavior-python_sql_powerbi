select * from customer

-- what is the total revenue genrate by male vs female customers ?
SELECT 
    gender,
    SUM(purshase_amount) AS total_revenue
FROM 
    customer
GROUP BY 
    gender;

-- which customer used a discount but stil spent more than the average purchase amount??
SELECT 
    customer_id,
    purshase_amount,
    discount_applied
FROM 
    customer
WHERE 
    discount_applied = 'Yes'
    AND purshase_amount > (
        SELECT AVG(purshase_amount) FROM customer
    );
--which are the top 5 products with the highest average review rating 
SELECT 
    item_purchased,
    ROUND(AVG(review_rating)::numeric, 2) AS avg_review_rating
FROM 
    customer
GROUP BY 
    item_purchased
ORDER BY 
    avg_review_rating DESC
LIMIT 5;

-- compare the average purchase amount between standard and express shiping 
SELECT 
    shipping_type,
    ROUND(AVG(purshase_amount)::numeric, 2) AS avg_purchase_amount
FROM 
    customer
GROUP BY 
    shipping_type;
-- do subscribed customers spend more ? compare average spend and total revenue between subscribers and non-subscribed.

	SELECT 
    subscription_status,
    ROUND(AVG(purshase_amount)::numeric, 2) AS avg_purchase_amount,
    ROUND(SUM(purshase_amount)::numeric, 2) AS total_revenue
FROM 
    customer
GROUP BY 
    subscription_status;
--which 5 products have the highest percentage of purchase with discount applied ?
SELECT 
    item_purchased,
    ROUND(
        (SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)::numeric 
         / COUNT(*) * 100), 2
    ) AS discount_percentage
FROM 
    customer
GROUP BY 
    item_purchased
ORDER BY 
    discount_percentage DESC
LIMIT 5;
-- segment customers into new, returning, and loyal based on their total numers of previous purchased, and show the count of each segment. 
WITH customer_type AS (
    SELECT 
        customer_id, 
        previous_purchases,
        CASE
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM 
        customer
)
SELECT 
    customer_segment, 
    COUNT(*) AS "Number of Customers"
FROM 
    customer_type
GROUP BY 
    customer_segment
ORDER BY 
    "Number of Customers" DESC;

--what are the top 3 most purchased products within each category 
SELECT 
    category,
    item_purchased,
    total_purchases
FROM (
    SELECT 
        category,
        item_purchased,
        COUNT(*) AS total_purchases,
        RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rank_within_category
    FROM 
        customer
    GROUP BY 
        category, item_purchased
) ranked_products
WHERE 
    rank_within_category <= 3
ORDER BY 
    category, rank_within_category;

-- are customers who are repeat buyers (more the 5 previous purchases) also likely to subscribe 	
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

-- what is the revenue contribution of each age group 	

SELECT 
    age_group,
    SUM(purshase_amount) AS total_revenue
FROM 
    customer
GROUP BY 
    age_group
ORDER BY 
    total_revenue DESC;



