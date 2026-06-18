/* 1. calculate total revenue for each game */
SELECT
gd.game_name,
(gr.Number_of_Purchases * gr.Unit_Price) As Total_Revenue
FROM games_description gd
JOIN games_revenue gr ON gd.game_id=gr.game_id
ORDER BY Total_Revenue DESC;

/* TOP 5 GAMES BY REVENUE */
SELECT d.game_name, (r.Number_of_Purchases * r.Unit_Price) AS Total_Revenue 
FROM games_description d JOIN games_revenue r 
ON d.game_id = r.game_id 
ORDER BY Total_Revenue DESC LIMIT 5;

/*Top 3 by genre */
SELECT
gd.genre,
sum(gr.Number_of_Purchases * gr.Unit_Price) AS TotalRevenue
FROM games_description gd
JOIN games_revenue gr ON gd.game_id=gr.game_id
GROUP BY gd.genre
ORDER BY TotalRevenue DESC
LIMIT 3;

/* YEAR GENERATED MOST OF REVENUE */
SELECT d.year_released, sum(r.Number_of_Purchases * r.Unit_Price) as Total_Revenue
FROM games_description d JOIN games_revenue r
ON d.game_id = r.game_id
GROUP BY d.year_released ORDER BY Total_Revenue DESC LIMIT 1;


/* Percentage of customers who left reviews out of total purchase */
-- Total Reviews Percentage out of total purchase
SELECT 
sum(re.number_of_reviews_from_purchased_people) AS total_customer_reviews,
sum(r.Number_of_Purchases) AS total_purchase, 
CONCAT(ROUND(sum(re.number_of_reviews_from_purchased_people) / sum(r.Number_of_Purchases) * 100, 2), "%") AS Review_Percentage
FROM games_reviews re JOIN games_revenue r
ON re.game_id = r.game_id;

-- Customer Reviews Percentage out of total purchases in each game
SELECT 
re.game_name, 
r.Number_of_Purchases, 
re.number_of_reviews_from_purchased_people, 
CONCAT(ROUND(re.number_of_reviews_from_purchased_people / r.Number_of_Purchases * 100, 2), "%") AS Review_Percentage
FROM games_reviews re JOIN games_revenue r
ON re.game_id = r.game_id
ORDER BY Review_Percentage DESC;

/* English Review Analysis */
SELECT 
game_name, 
ROUND(number_of_english_reviews / number_of_reviews_from_purchased_people * 100, 2) AS English_Reivew_Percentage
FROM games_reviews ORDER BY English_Reivew_Percentage DESC;

/* Percentage of Games with English reviews as major out of total number of games */
SELECT
COUNT(*) AS total_games,
(SELECT COUNT(number_of_english_reviews / number_of_reviews_from_purchased_people * 100) FROM games_reviews WHERE number_of_english_reviews / number_of_reviews_from_purchased_people * 100 > 50) AS games_with_eng_reviews_major,
ROUND((SELECT COUNT(number_of_english_reviews / number_of_reviews_from_purchased_people * 100) FROM games_reviews WHERE number_of_english_reviews / number_of_reviews_from_purchased_people * 100 > 50) / COUNT(*) * 100, 2) AS English_Reivew_Percentage 
FROM games_reviews;



/* find top 5 publishers by total revenue */
SELECT
gd.publisher,
sum(gr.Number_of_Purchases * gr.Unit_Price)
AS Total_Revenue
FROM games_description gd
JOIN games_revenue gr
ON gd.game_id = gr.game_id
GROUP BY gd.publisher
ORDER BY Total_Revenue DESC
LIMIT 5;


/* Engagement Ratios */
/* Percentage of Helpful and Funny Tags */
SELECT game_name, 
CONCAT(ROUND(Helpful / number_of_reviews_from_purchased_people * 100, 2), "%") AS Helpful_Percentage, 
CONCAT(ROUND(Funny / number_of_reviews_from_purchased_people * 100, 2), "%") AS Funny_Percentage
FROM games_reviews;

/* Highest and Lowest Percentage of Helpful Tags In Movies */
SELECT 
game_name, 
Helpful, 
number_of_reviews_from_purchased_people, 
ROUND(Helpful / number_of_reviews_from_purchased_people * 100, 2) AS Helpful_Percentage
FROM games_reviews 
WHERE (Helpful / number_of_reviews_from_purchased_people * 100) = (SELECT MAX(Helpful / number_of_reviews_from_purchased_people * 100) FROM games_reviews)
OR (Helpful / number_of_reviews_from_purchased_people * 100) = (SELECT MIN(Helpful / number_of_reviews_from_purchased_people * 100) FROM games_reviews)
ORDER BY Helpful_Percentage DESC;



/* Highest and Lowest Percentage of Funny Tags In Movies */
SELECT 
game_name, 
Funny, 
number_of_reviews_from_purchased_people, 
ROUND(Funny / number_of_reviews_from_purchased_people * 100, 2) AS Funny_Percentage
FROM games_reviews 
WHERE (Funny / number_of_reviews_from_purchased_people * 100) = (SELECT MAX(Funny / number_of_reviews_from_purchased_people * 100) FROM games_reviews)
OR (Funny / number_of_reviews_from_purchased_people * 100) = (SELECT MIN(Funny / number_of_reviews_from_purchased_people * 100) FROM games_reviews) 
ORDER BY Funny_Percentage DESC;

/* Highest and Lowest Percentage of Helpful Tags In Genres */
(SELECT 
d.genre, 
sum(r.Helpful) AS total_helpful_in_each_genre, 
sum(r.number_of_reviews_from_purchased_people) AS total_reviews_in_each_genre, 
ROUND(sum(r.Helpful) / sum(r.number_of_reviews_from_purchased_people) * 100, 2) AS Helpful_Percentage
FROM games_description d JOIN games_reviews r 
ON d.game_id = r.game_id
GROUP BY d.genre
ORDER BY Helpful_Percentage DESC 
LIMIT 1)
UNION 
(SELECT 
d.genre, 
sum(r.Helpful) AS total_helpful_in_each_genre, 
sum(r.number_of_reviews_from_purchased_people) AS total_reviews_in_each_genre, 
ROUND(sum(r.Helpful) / sum(r.number_of_reviews_from_purchased_people) * 100, 2) AS Helpful_Percentage
FROM games_description d JOIN games_reviews r 
ON d.game_id = r.game_id
GROUP BY d.genre
ORDER BY Helpful_Percentage ASC 
LIMIT 1);


/* Highest and Lowest Percentage of Funny Tags In Genres */
(SELECT 
d.genre, 
sum(r.Funny) AS total_funny_in_each_genre, 
sum(r.number_of_reviews_from_purchased_people) AS total_reviews_in_each_genre, 
ROUND(sum(r.Funny) / sum(r.number_of_reviews_from_purchased_people) * 100, 2) AS Funny_Percentage
FROM games_description d JOIN games_reviews r 
ON d.game_id = r.game_id
GROUP BY d.genre
ORDER BY Funny_Percentage DESC 
LIMIT 1)
UNION
(SELECT 
d.genre, 
sum(r.Funny) AS total_funny_in_each_genre, 
sum(r.number_of_reviews_from_purchased_people) AS total_reviews_in_each_genre, 
ROUND(sum(r.Funny) / sum(r.number_of_reviews_from_purchased_people) * 100, 2) AS Funny_Percentage
FROM games_description d JOIN games_reviews r 
ON d.game_id = r.game_id
GROUP BY d.genre
ORDER BY Funny_Percentage ASC 
LIMIT 1);



-- Task 4
/* Rank games by their total revenue within each genre */
SELECT 
d.game_name, 
d.genre, 
(r.Number_of_Purchases * r.Unit_Price) AS Total_Revenue, 
RANK() OVER (PARTITION BY d.genre ORDER BY r.Number_of_Purchases * r.Unit_Price DESC) AS Ranking
FROM games_description d JOIN games_revenue r 
ON d.game_id = r.game_id;


/* rank games by total Reviews within each genre */
SELECT
gd.game_name,
gd.genre,
gr.number_of_reviews_from_purchased_people as Total_Reviews,
RANK() OVER (PARTITION BY gd.genre ORDER BY gr.number_of_reviews_from_purchased_people DESC) AS Review_Rank
FROM games_description gd
JOIN games_reviews gr
ON gd.game_id=gr.game_id;