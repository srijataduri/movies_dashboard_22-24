USE db;

CREATE INDEX idx_genres_genre ON Genres(genre);
CREATE INDEX idx_movies_startYear ON Movies(startYear);
CREATE INDEX idx_ratings_numVotes ON Ratings(numVotes);

-- Basic queries
-- Question 1: Who are the directors of the movies having the word 'thanksgiving' in their title?
SELECT n.primaryName, m.primaryTitle
FROM Directors d
JOIN Names n ON d.nameID = n.nameID
JOIN Movies m ON d.movieID = m.movieID
WHERE m.primaryTitle LIKE '%thanksgiving%';

-- Question 2: What are the top 5 highest-rated movies having at least 500000 votes?
SELECT m.primaryTitle, r.averageRating, r.numVotes
FROM Movies m
JOIN Ratings r ON m.movieID = r.movieID
WHERE r.numVotes >= 500000
ORDER BY r.averageRating DESC
LIMIT 5;

-- Advanced queries
-- Question 3: What is the average rating for movies longer than 2 hours, compared to the overall average? (Subquery)
SELECT AVG(r.averageRating) AS longMovieAvg
FROM Movies m
JOIN Ratings r ON m.movieID = r.movieID
WHERE m.runtimeMinutes > 120
HAVING longMovieAvg > (
	SELECT AVG(averageRating) 
    FROM Ratings
);

-- Question 4: Find movies directed by Christopher Nolan that have higher ratings than the average for action movies. (Subquery)
SELECT m.primaryTitle, r.averageRating
FROM Movies m
JOIN Ratings r ON m.movieID = r.movieID
JOIN Directors d ON m.movieID = d.movieID
JOIN Names n ON d.nameID = n.nameID
WHERE 
	n.primaryName = 'Christopher Nolan'
	AND r.averageRating > (
		SELECT AVG(r2.averageRating)
		FROM Ratings r2
		JOIN Genres g ON r2.movieID = g.movieID
		WHERE g.genre = 'Action'
);

-- Question 5: List the top 3 genres by average rating in 2024. (CTE)
WITH RecentMovies AS (
    SELECT m.movieID, g.genre, r.averageRating, m.startYear
    FROM Movies m
    JOIN Genres g ON m.movieID = g.movieID
    JOIN Ratings r ON m.movieID = r.movieID
    WHERE m.startYear = 2024
)
SELECT 
	genre, 
    ROUND(AVG(averageRating), 2) AS avgRating,
    startYear
FROM RecentMovies
GROUP BY genre
ORDER BY avgRating DESC
LIMIT 3;

-- Question 6: Calculate the cumulative number of movies per year, showing growth over time. (CTE)
WITH YearlyCounts AS (
    SELECT startYear, COUNT(*) AS numMovies
    FROM Movies
    GROUP BY startYear
    ORDER BY startYear
)
SELECT 
	startYear, 
    numMovies,
    SUM(numMovies) OVER (
		ORDER BY startYear
	) AS cumulativeCount
FROM YearlyCounts;

-- Question 7: Partition movies by genre and rank them by number of votes that 
-- are bigger than 200000 within each genre. (Window function)
SELECT 
	g.genre, 
    m.primaryTitle, 
    r.numVotes,
    ROW_NUMBER() OVER (
		PARTITION BY g.genre 
        ORDER BY r.numVotes DESC
	) AS rankInGenre
FROM Genres g
JOIN Movies m ON g.movieID = m.movieID
JOIN Ratings r ON m.movieID = r.movieID
WHERE r.numVotes > 200000;

-- Question 8: Create a view for top-rated directors and explain its performance 
-- with indexing. (View creation, then EXPLAIN and EXPLAIN ANALYZE on a query using it to compare performance)
CREATE VIEW TopRatedDirectors AS
SELECT 
	n.primaryName, 
    ROUND(AVG(r.averageRating), 2) AS avgRating,
    COUNT(*) AS numMovies
FROM Directors d
JOIN Names n ON d.nameID = n.nameID
JOIN Movies m ON d.movieID = m.movieID
JOIN Ratings r ON m.movieID = r.movieID
GROUP BY n.primaryName HAVING COUNT(*) >= 10
ORDER BY avgRating DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT * FROM TopRatedDirectors;

CREATE INDEX idx_ratings_averageRating ON Ratings(averageRating);
CREATE INDEX idx_ratings_movieID ON Ratings(movieID);
CREATE INDEX idx_directors_nameID ON Directors(nameID);
CREATE INDEX idx_directors_movieID ON Directors(movieID);

EXPLAIN ANALYZE
SELECT * FROM TopRatedDirectors;

EXPLAIN 
SELECT * FROM TopRatedDirectors;
