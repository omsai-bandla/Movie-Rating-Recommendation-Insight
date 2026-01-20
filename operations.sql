use movies_data;

select * from ratings;
select * from users;
select * from movies;
select * from links;

desc users;

CREATE TABLE movie_genres (
    movieId INT,
    genre   VARCHAR(100)
);

INSERT INTO movie_genres (movieId, genre)
SELECT 
    m.movieId,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(m.genres, '|', n.n), '|', -1)) AS genre
FROM movies m
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) AS n
  ON n.n <= 1 + LENGTH(m.genres) - LENGTH(REPLACE(m.genres, '|', ''));
  
  
  
USE movies_data;

TRUNCATE TABLE movie_genres;

INSERT INTO movie_genres (movieId, genre)
SELECT 
    m.movieId,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(m.genres, '|', numbers.n),
        '|', -1)
    ) AS genre
FROM movies m
JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 n UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
    SELECT 9 n
) AS numbers
ON numbers.n <= 1 + LENGTH(m.genres) - LENGTH(REPLACE(m.genres, '|', ''));



SELECT * FROM movie_genres LIMIT 20;






/* 1..Top-rated genres by age group*/

WITH age_groups AS (
    SELECT
        userId,
        CASE
            WHEN age BETWEEN 1 AND 17 THEN '0-17'
            WHEN age BETWEEN 18 AND 24 THEN '18-24'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group
    FROM users
)
SELECT
    ag.age_group,
    mg.genre,
    AVG(r.rating) AS avg_rating,
    COUNT(*)      AS num_ratings
FROM ratings r
JOIN age_groups  ag ON r.userId  = ag.userId
JOIN movie_genres mg ON r.movieId = mg.movieId
GROUP BY ag.age_group, mg.genre
HAVING COUNT(*) >= 50
ORDER BY ag.age_group, avg_rating DESC;


/* 2..Find top 10 highest-rated movies.*/
SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS avg_rating,
    COUNT(*)      AS num_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY m.movieId, m.title
HAVING COUNT(*) >= 50
ORDER BY avg_rating DESC, num_ratings DESC
LIMIT 10;


/* 3..List most active users by number of ratings.*/
SELECT
    userId,
    COUNT(*) AS num_ratings
FROM ratings
GROUP BY userId
ORDER BY num_ratings DESC
LIMIT 20;


/* 4..Identify top-rated genres by age/gender.*/
WITH age_groups AS (
    SELECT
        userId,
        gender,
        CASE
            WHEN age BETWEEN 1 AND 17 THEN '0-17'
            WHEN age BETWEEN 18 AND 24 THEN '18-24'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group
    FROM users
)
SELECT
    ag.age_group,
    ag.gender,
    mg.genre,
    AVG(r.rating) AS avg_rating,
    COUNT(*)      AS num_ratings
FROM ratings r
JOIN age_groups  ag ON r.userId  = ag.userId
JOIN movie_genres mg ON r.movieId = mg.movieId
GROUP BY ag.age_group, ag.gender, mg.genre
HAVING COUNT(*) >= 30
ORDER BY ag.age_group, ag.gender, avg_rating DESC;

/* 5..Count users who rated >500 movies. */
SELECT COUNT(*) AS users_above_500
FROM (
    SELECT userId, COUNT(*) AS num_ratings
    FROM ratings
    GROUP BY userId
    HAVING COUNT(*) > 500
) AS t;


/* 6..Calculate average rating per movie.*/
SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS avg_rating,
    COUNT(*)      AS num_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY m.movieId, m.title
ORDER BY avg_rating DESC;

/* 7..Retrieve most common genre combinations.*/
SELECT
    genres,
    COUNT(*) AS frequency
FROM movies
GROUP BY genres
ORDER BY frequency DESC;


/* 8..Identify movies rated above 4.5 last year.*/
SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS avg_rating,
    COUNT(*) AS num_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
WHERE FROM_UNIXTIME(r.timestamp) >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY m.movieId, m.title
HAVING AVG(r.rating) > 4.5
   AND COUNT(*) >= 10
ORDER BY avg_rating DESC;

/*max average rating*/
SELECT 
    MAX(avg_rating) AS max_avg_rating
FROM (
    SELECT AVG(rating) AS avg_rating
    FROM ratings
    GROUP BY movieId
) AS t;

/*AVG > 4.5, Without COUNT condition*/
SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS avg_rating,
    COUNT(*)      AS num_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY m.movieId, m.title
HAVING AVG(r.rating) > 4.5
ORDER BY avg_rating DESC;

/* No movies found above 4.5 avg rating with 10+ ratings, 
   so a practical threshold of 4.3 is used to get meaningful results. */

SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS avg_rating,
    COUNT(*)      AS num_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY m.movieId, m.title
HAVING AVG(r.rating) >= 4.3      -- thoda kam threshold
   AND COUNT(*) >= 10            -- minimum ratings
ORDER BY avg_rating DESC, num_ratings DESC;
