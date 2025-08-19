RENAME TABLE `womens clothing e-commerce reviews` TO `womens_ecommerce`;

SELECT *
FROM womens_ecommerce
LIMIT 10;


ALTER TABLE womens_ecommerce
CHANGE `Review Text` review_text VARCHAR(255),
CHANGE `Clothing ID` clothing_id INT,
CHANGE `Recommended IND` recommended_ind INT,
CHANGE `Positive Feedback Count` positive_feedback_count INT,
CHANGE `Division Name` division_name VARCHAR(255),
CHANGE `Department Name` department_name VARCHAR(255),
CHANGE `Class Name` class_name VARCHAR(255),
CHANGE `Rating` rating INT,
CHANGE `Age` age INT;



SHOW COLUMNS FROM womens_ecommerce;

-- EDA
SELECT
	SUM(CASE WHEN clothing_id IS NULL OR clothing_id = '' THEN 1 ELSE 0 END) AS missing_age,
	SUM(CASE WHEN age IS NULL OR age = '' THEN 1 ELSE 0 END) AS missing_age,
	SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS missing_review_text,
	SUM(CASE WHEN recommended_ind IS NULL OR recommended_ind = '' THEN 1 ELSE 0 END) AS missing_recommended_ind,
	SUM(CASE WHEN positive_feedback_count IS NULL OR positive_feedback_count = '' THEN 1 ELSE 0 END) AS missing_positive_feedback_count,
	SUM(CASE WHEN division_name IS NULL OR division_name = '' THEN 1 ELSE 0 END) AS missing_division_name,
	SUM(CASE WHEN department_name IS NULL OR department_name = '' THEN 1 ELSE 0 END) AS missing_department_name,
	SUM(CASE WHEN class_name IS NULL OR class_name = '' THEN 1 ELSE 0 END) AS missing_class_name
FROM womens_ecommerce;

-- To avoid going in the wrong direction in Power BI analyses, I checked how I could fill department_name, class_name and division_name. 
-- But since the missing rows were the same across these columns (if one was missing, all were missing), I decided to delete them.

UPDATE womens_ecommerce
SET department_name = 'Unknown'
WHERE department_name IS NULL OR department_name = '';

UPDATE womens_ecommerce
SET division_name = 'Unknown'
WHERE division_name IS NULL OR division_name = '';

UPDATE womens_ecommerce
SET class_name = 'Unknown'
WHERE class_name IS NULL OR class_name = '';

-- age value check - unlogical values are deleted
SELECT MAX(age) as max_age, MIN(age) as min_age 
FROM womens_ecommerce;

SELECT MAX(rating) 
FROM womens_ecommerce;

-- Let's see the population over the columns and categories

SELECT AVG(age) as ave_age 
FROM womens_ecommerce;

-- Distribution of DEPARTMENT NAME
SELECT department_name, COUNT(*) as count_depart_name 
FROM womens_ecommerce
GROUP BY department_name
ORDER BY count_depart_name;

-- Distribution of rating 
SELECT rating, COUNT(*) AS count
FROM womens_ecommerce
GROUP BY rating
ORDER BY rating;


-- ------------------ POWER BI ANALYSIS PART

SELECT FLOOR(AGE/10)*10 AS age_group,
COUNT(*) as review_count
FROM womens_ecommerce
GROUP BY age_group
ORDER BY age_group ASC;


SELECT 
    FLOOR(age/10)*10 AS age_group,
    ROUND(SUM(recommended_ind)/COUNT(*)*100,2) AS recommendation_rate
FROM womens_ecommerce
GROUP BY age_group
ORDER BY age_group;

-- average feedback count by age group
SELECT 
    FLOOR(age/10)*10 AS age_group,
    ROUND(AVG(positive_feedback_count),2) AS avg_feedback
FROM womens_ecommerce
GROUP BY age_group
ORDER BY age_group;

SELECT 
    department_name,
    ROUND(AVG(age),1) AS avg_age,
    ROUND(AVG(rating),2) AS avg_rating,
    ROUND(SUM(recommended_ind)/COUNT(*)*100,2) AS recommendation_rate
FROM womens_ecommerce
GROUP BY department_name
ORDER BY avg_age;




SELECT 
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS age_group,
    COUNT(*) AS review_count
FROM womens_ecommerce
GROUP BY age_group
ORDER BY MIN(age);


SELECT DISTINCT department_name
FROM womens_ecommerce;

SELECT *
FROM womens_ecommerce
WHERE class_name= '' or class_name IS null;
/*
SELECT *
FROM womens_ecommerce
WHERE review_text LIKE '%hoodie%';

SELECT review_text, department_name, class_name
FROM womens_ecommerce
WHERE review_text LIKE '%hoodie%'
  AND department_name = 'Intimate';
*/

-- POWER BI VIEW CREATION
-- AGE
CREATE OR REPLACE VIEW age_group_view AS
SELECT 
    CASE
        WHEN age BETWEEN 10 AND 19 THEN '10s'
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        WHEN age BETWEEN 50 AND 59 THEN '50s'
        WHEN age BETWEEN 60 AND 69 THEN '60s'
        WHEN age BETWEEN 70 AND 79 THEN '70s'
        WHEN age >= 80 THEN '80+'
        ELSE 'Unknown'
    END AS age_group,
    CASE
        WHEN age BETWEEN 10 AND 19 THEN 1
        WHEN age BETWEEN 20 AND 29 THEN 2
        WHEN age BETWEEN 30 AND 39 THEN 3
        WHEN age BETWEEN 40 AND 49 THEN 4
        WHEN age BETWEEN 50 AND 59 THEN 5
        WHEN age BETWEEN 60 AND 69 THEN 6
        WHEN age BETWEEN 70 AND 79 THEN 7
        WHEN age >= 80 THEN 8
        ELSE 9
    END AS age_group_order
FROM womens_ecommerce
WHERE age IS NOT NULL AND age BETWEEN 10 AND 120;


-- number of reviews by age distribution
CREATE OR REPLACE VIEW age_distribution_view AS
SELECT 
    age_group, 
    age_group_order, 
    COUNT(*) AS review_count
FROM age_group_view
GROUP BY age_group, age_group_order
ORDER BY age_group_order;

SELECT *
FROM age_distribution_view;


-- departments with highest number of comments
CREATE OR REPLACE VIEW department_review_view AS
	SELECT department_name,	
	COUNT(*) AS review_count
	FROM womens_ecommerce
    GROUP BY department_name
	ORDER BY review_count DESC;
    
SELECT *
FROM department_review_view;

-- Top 10 reviews with the most feedback
SELECT clothing_id, positive_feedback_count, title, department_name, age
FROM womens_ecommerce
ORDER BY positive_feedback_count DESC
LIMIT 10;

CREATE OR REPLACE VIEW recommended_item_view AS
SELECT clothing_id, positive_feedback_count, review_text, department_name, age
FROM womens_ecommerce
ORDER BY positive_feedback_count DESC
LIMIT 10;

SELECT * 
from recommended_item_view;

-- Product level: number of reviews, total feedback, average rating
CREATE OR REPLACE VIEW product_engagement_view AS
SELECT
  clothing_id,
  department_name,
  COUNT(*)                           AS review_count,
  SUM(positive_feedback_count)       AS total_feedback,
  ROUND(AVG(rating),2)               AS avg_rating
FROM womens_ecommerce
GROUP BY clothing_id, department_name;

SELECT *
FROM product_engagement_view;

CREATE OR REPLACE VIEW product_engagement_view_quad AS
WITH agg AS (
  SELECT * 
  FROM product_engagement_view
),
avgvals AS (
  SELECT AVG(review_count)  AS avg_reviews,
         AVG(total_feedback) AS avg_feedback
  FROM agg
)
SELECT
  a.*,
  CASE
    WHEN a.review_count >= v.avg_reviews AND a.total_feedback <  v.avg_feedback THEN 'High reviews, Low feedback'
    WHEN a.review_count <  v.avg_reviews AND a.total_feedback >= v.avg_feedback THEN 'Low reviews, High feedback'
    WHEN a.review_count >= v.avg_reviews AND a.total_feedback >= v.avg_feedback THEN 'High-High'
    ELSE 'Low-Low'
  END AS quadrant
FROM agg a
CROSS JOIN avgvals v;

-- to find averages for Power BI

-- Average number of reviews (per product)
SELECT AVG(review_count) AS avg_reviews
FROM (
    SELECT clothing_id, COUNT(*) AS review_count
    FROM womens_ecommerce
    GROUP BY clothing_id
) t;

-- Average number of positive feedback (per product)
SELECT AVG(total_feedback) AS avg_feedback
FROM (
    SELECT clothing_id, SUM(positive_feedback_count) AS total_feedback
    FROM womens_ecommerce
    GROUP BY clothing_id
) t;
