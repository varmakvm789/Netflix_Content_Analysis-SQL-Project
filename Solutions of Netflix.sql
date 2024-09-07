-- SQL Business Queries Solutions of Netflix Project --

SELECT * FROM Netflix ;

1. How many movies and TV shows are in the dataset?

   SELECT
        type,
        COUNT(*) as content_count
   FROM Netflix 
   GROUP BY type;

2. Find the most common rating for movies and TV shows

WITH RatingSummary AS (
    SELECT
          type,
          rating,
          COUNT(*) AS rating_count 
    FROM Netflix 
    GROUP BY type, rating
),
RankedSummary AS (
    SELECT
           type,
           rating,
           rating_count, 
           DENSE_RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS dense_rank 
    FROM RatingSummary
)
SELECT
      type,
      rating AS most_frequent_rating 
FROM RankedSummary 
WHERE dense_rank = 1;


3. How many shows and movies were released in each year?

   SELECT
        release_year,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY release_year 
   ORDER BY release_year;


4. Which countries have produced the most content on Netflix? 

   SELECT
        country,
        COUNT(*) AS total_content 
   FROM (
       SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country 
       FROM Netflix
   ) AS t 
   WHERE country IS NOT NULL 
   GROUP BY country 
   ORDER BY total_content DESC;


5. What are the top 5 most common genres in the dataset?

   SELECT
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY genre 
   ORDER BY total_content DESC 
   LIMIT 5;


6. Find the content added in the last 5 years ?

   SELECT * 
   FROM Netflix 
   WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


7. What is the distribution of content by rating (e.g., PG, PG-13)?

   SELECT
        rating,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY rating 
   ORDER BY total_content DESC;


8. Who are the top 5 directors with the most content on Netflix?

   SELECT
        TRIM(UNNEST(STRING_TO_ARRAY(director, ','))) AS director,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY director 
   ORDER BY total_content DESC 
   LIMIT 5;


9. How many shows or movies have been released by each country every year?

   SELECT
        country,
        release_year,
        COUNT(*) AS total_content 
   FROM (
       SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country 
       FROM Netflix
   ) AS t 
   WHERE country IS NOT NULL 
   GROUP BY country, release_year 
   ORDER BY country, release_year;


10. Find each year and the average numbers of content release in India on Netflix, return top 5 year with highest avg content release!

   SELECT
        release_year,
        COUNT(show_id) AS total_releases, 
        ROUND(AVG(COUNT(show_id)) OVER (PARTITION BY release_year), 2) AS avg_releases
   FROM Netflix 
   WHERE country ILIKE '%India%' 
   GROUP BY release_year 
   ORDER BY avg_releases DESC 
   LIMIT 5;


11. What is the average duration of Netflix movies?

   SELECT ROUND(AVG(SPLIT_PART(duration, ' ', 1)::INT), 2) AS avg_duration 
   FROM Netflix 
   WHERE type = 'Movie';


12. What are the trends in content production over time for movies vs. TV shows?

   SELECT
        release_year, type,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY release_year, type 
   ORDER BY release_year, type;


13. What are the most popular genres each year?

   SELECT
         release_year,
         UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY release_year, genre 
   ORDER BY release_year, total_content DESC;


14. Which genres are most popular in each country?

   SELECT
        country,
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY country, genre 
   ORDER BY country, total_content DESC;


15. When did Netflix experience the largest growth in content production?

   SELECT
        release_year,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY release_year 
   ORDER BY total_content DESC 
   LIMIT 1;


16. Group Netflix content based on release year, type, genre, and country

   SELECT
        release_year,
        type,
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        country 
   FROM Netflix;


17. Find the top 10 actors who have appeared in the highest number of movies produced in India.

   SELECT
        UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
        COUNT(*) AS total_movies 
   FROM Netflix 
   WHERE country ILIKE '%India%' 
   GROUP BY actor 
   ORDER BY total_movies DESC 
   LIMIT 10;
	
	
18. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other 
    content as 'Good'. Count how many items fall into each category.

SELECT 
    category,
    COUNT(*) AS content_count 
FROM (
       SELECT CASE 
               WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
               ELSE 'Good' 
             END AS category 
       FROM Netflix
     ) AS categorized_content 
GROUP BY category;
