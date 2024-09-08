# **Netflix Content Data Analysis using SQL**

![](https://github.com/varmakvm789/Netflix_Content_Analysis-SQL-Project/blob/main/i582969.jpeg)

## **Overview**

This project analyzes Netflix’s movies and TV shows dataset using SQL. The objective is to extract key insights and answer various business questions based on the data set through SQL. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions

## Objectives

- Determine the distribution of content types (Movies vs. TV Shows).
- Identify key trends in content production, ratings, and genres.
- Explore and categorize content based on countries, directors, and specific keywords.

## Dataset

The dataset used in this project was sourced from Kaggle:

- [Netflix Movies and TV Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Table Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## SQL Queries and Business Solutions

### 1. Count the Number of Movies vs TV Shows

   ```sql
   SELECT
        type,
        COUNT(*) as content_count
   FROM netflix 
   GROUP BY type;
   ```

   **Purpose:** Analyze the distribution of content types (Movies vs TV Shows).

---

### 2. Find the Most Common Rating for Movies and TV Shows

   ```sql
WITH RatingSummary AS (
    SELECT
          type,
          rating,
          COUNT(*) AS rating_count 
    FROM netflix 
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
   ```

   **Purpose:** Identify the predominant rating for content on Netflix to understand audience targeting.

---

### 3. How Many Shows and Movies Were Released in Each Year?

   ```sql
   SELECT
        release_year,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY release_year 
   ORDER BY release_year;
   ```

   **Purpose:** Track the number of movies and shows released per year to observe trends and spikes in content production.

---

### 4. Which Countries Have Produced the Most Content on Netflix?

   ```sql
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
   ```

   **Purpose:** Identify the top content-producing countries on Netflix to understand regional content production.

---

### 5. What Are the Top 5 Most Common Genres in the Dataset?

   ```sql
   SELECT
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        COUNT(*) AS total_content 
   FROM Netflix 
   GROUP BY genre 
   ORDER BY total_content DESC 
   LIMIT 5;
   ```

   **Purpose:** Highlight the most popular genres on Netflix and provide insights into content preferences.

---

### 6. Find the Content Added in the Last 5 Years?

   ```sql
   SELECT * 
   FROM netflix 
   WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
   ```

   **Purpose:** Analyze how recent the content in the dataset is by filtering for content added in the last 5 years.

---

### 7. What Is the Distribution of Content by Rating (e.g., PG, PG-13)?

   ```sql
   SELECT
        rating,
        COUNT(*) AS total_content 
   FROM netflix 
   GROUP BY rating 
   ORDER BY total_content DESC;
   ```

   **Purpose:** Analyze the distribution of Netflix content based on ratings to understand audience segmentation.

---

### 8. Who Are the Top 5 Directors with the Most Content on Netflix?

   ```sql
   SELECT
        TRIM(UNNEST(STRING_TO_ARRAY(director, ','))) AS director,
        COUNT(*) AS total_content 
   FROM netflix 
   GROUP BY director 
   ORDER BY total_content DESC 
   LIMIT 5;
   ```

   **Purpose:** Identify directors who consistently contribute to Netflix’s catalog.

---

### 9. How Many Shows or Movies Have Been Released by Each Country Every Year?

   ```sql
   SELECT
        country,
        release_year,
        COUNT(*) AS total_content 
   FROM (
       SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country 
       FROM netflix
   ) AS t 
   WHERE country IS NOT NULL 
   GROUP BY country, release_year 
   ORDER BY country, release_year;
   ```

   **Purpose:** Track content production by country over time to understand how regional content evolves.

---

### 10. Find the Top 5 Years with the Highest Average Content Release in India.

   ```sql
   SELECT
        release_year,
        COUNT(show_id) AS total_releases, 
        ROUND(AVG(COUNT(show_id)) OVER (PARTITION BY release_year), 2) AS avg_releases
   FROM netflix 
   WHERE country ILIKE '%India%' 
   GROUP BY release_year 
   ORDER BY avg_releases DESC 
   LIMIT 5;
   ```

   **Purpose:** Understand content production trends in India and identify years of significant content growth.

---

### 11. What Is the Average Duration of Netflix Movies?

   ```sql
   SELECT ROUND(AVG(SPLIT_PART(duration, ' ', 1)::INT), 2) AS avg_duration 
   FROM netflix 
   WHERE type = 'Movie';
   ```

   **Purpose:** Analyze the average duration of movies to assess user engagement and content length.

---

### 12. What Are the Trends in Content Production Over Time for Movies vs. TV Shows?

   ```sql
   SELECT
        release_year, type,
        COUNT(*) AS total_content 
   FROM netflix 
   GROUP BY release_year, type 
   ORDER BY release_year, type;
   ```

   **Purpose:** Compare content production trends between movies and TV shows over time to understand platform focus.

---

### 13. What Are the Most Popular Genres Each Year?

   ```sql
   SELECT
         release_year,
         UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS total_content 
   FROM netflix 
   GROUP BY release_year, genre 
   ORDER BY release_year, total_content DESC;
   ```

   **Purpose:** Identify shifts in genre popularity over time to understand evolving audience preferences.

---

### 14. Which Genres Are Most Popular in Each Country?

   ```sql
   SELECT
        country,
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        COUNT(*) AS total_content 
   FROM netflix 
   GROUP BY country, genre 
   ORDER BY country, total_content DESC;
   ```

   **Purpose:** Analyze the most popular genres across different countries to provide regional content insights.

---

### 15. When Did Netflix Experience the Largest Growth in Content Production?

   ```sql
   SELECT
        release_year,
        COUNT(*) AS total_content 
   FROM netflix 
   GROUP BY release_year 
   ORDER BY total_content DESC 
   LIMIT 1;
   ```

   **Purpose:** Pinpoint the year with the largest content growth on Netflix to identify platform expansion efforts.

---

### 16. Group Netflix Content by Release Year, Type, Genre, and Country

   ```sql
   SELECT
        release_year,
        type,
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        country 
   FROM netflix;
   ```

   **Purpose:** Segment Netflix content to gain deeper insights into how content performs across different regions, types, and genres.

---

### 17. Find the Top 10 Actors Who Have Appeared in the Most Movies Produced in India

   ```sql
   SELECT
        UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
        COUNT(*) AS total_movies 
   FROM netflix 
   WHERE country ILIKE '%India%' 
   GROUP BY actor 
   ORDER BY total_movies DESC 
   LIMIT 10;
   ```

   **Purpose:** Identify top actors in Indian-produced Netflix movies to assess their impact on the platform.

---

### 18. Categorize Content Based on the Presence of Keywords 'Kill' and 'Violence' in the Description

   ```sql
   SELECT category,
          COUNT(*) AS content_count 
   FROM (
       SELECT CASE 
               WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
               ELSE 'Good' 
             END AS category 
       FROM netflix
   ) AS categorized_content 
   GROUP BY category;
   ```

   **Purpose:** Classify content into 'Good' or 'Bad' categories based on the presence of violent keywords, useful for content moderation and filtering.

---

## **Findings and Conclusion**

- **Content Distribution:** Netflix offers a balanced range of both movies and TV shows, with an increase in TV shows over recent years.
- **Genre Insights:** The most common genres and ratings highlight Netflix's content strategy to target specific audiences.
- **Regional Trends:** Countries like the U.S., India, and the U.K. are leading contributors to Netflix's content catalog.

---

This README is designed to demonstrate SQL analysis of Netflix's content data, providing insights into content trends, popular genres, regional content, and more.
