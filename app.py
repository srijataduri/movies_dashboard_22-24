from flask import Flask, render_template
from db import query

app = Flask(__name__)

@app.route("/")
def index():
    # 1. Movies by Genre (top 30 with percentage)
    sql_genre_count = """
        WITH Counts AS (
            SELECT genre AS category, COUNT(*) AS total_count
            FROM Genres
            GROUP BY genre
        ),
        Total AS (
            SELECT SUM(total_count) AS grand_total FROM Counts
        ),
        TopCounts AS (
            SELECT * FROM Counts ORDER BY total_count DESC LIMIT 30
        )
        SELECT c.category, c.total_count, ROUND((c.total_count / t.grand_total) * 100, 2) AS percentage
        FROM TopCounts c, Total t;
    """
    data_genre_count = query(sql_genre_count)

    # 2. Movies Per Year (with cumulative)
    sql_movies_year = """
        WITH YearlyCounts AS (
            SELECT startYear AS year, COUNT(*) AS total_count
            FROM Movies
            WHERE startYear IS NOT NULL AND startYear >= 2000
            GROUP BY startYear
            ORDER BY startYear
        )
        SELECT 
            year, 
            total_count,
            SUM(total_count) OVER (ORDER BY year) AS cumulative
        FROM YearlyCounts;
    """
    data_movies_year = query(sql_movies_year)

    # 3. Top 10 Highest-Rated Movies (with >=500k votes)
    sql_top_rated = """
        SELECT m.primaryTitle AS title, r.averageRating AS rating
        FROM Movies m
        JOIN Ratings r ON m.movieID = r.movieID
        WHERE r.numVotes >= 500000
        ORDER BY r.averageRating DESC
        LIMIT 10;
    """
    data_top_rated = query(sql_top_rated)

    # 4. Distribution of Movie Ratings (new pie chart)
    sql_rating_dist = """
        WITH Buckets AS (
            SELECT 
                CASE 
                    WHEN averageRating <= 2 THEN '0-2'
                    WHEN averageRating <= 4 THEN '2-4'
                    WHEN averageRating <= 6 THEN '4-6'
                    WHEN averageRating <= 8 THEN '6-8'
                    ELSE '8-10'
                END AS bucket,
                COUNT(*) AS count
            FROM Ratings
            GROUP BY bucket
        ),
        Total AS (
            SELECT SUM(count) AS grand_total FROM Buckets
        )
        SELECT b.bucket, b.count, ROUND((b.count / t.grand_total) * 100, 2) AS percentage
        FROM Buckets b, Total t
        ORDER BY bucket;
    """
    data_rating_dist = query(sql_rating_dist)

    # 5. Top 10 Directors by Avg Rating (min 10 movies)
    sql_top_directors = """
        SELECT n.primaryName AS name, ROUND(AVG(r.averageRating), 2) AS avg_rating
        FROM Directors d
        JOIN Names n ON d.nameID = n.nameID
        JOIN Ratings r ON d.movieID = r.movieID
        GROUP BY n.primaryName
        HAVING COUNT(*) >= 10
        ORDER BY avg_rating DESC
        LIMIT 10;
    """
    data_top_directors = query(sql_top_directors)

    return render_template(
        "dashboard.html",
        data_genre_count=data_genre_count,
        data_movies_year=data_movies_year,
        data_top_rated=data_top_rated,
        data_rating_dist=data_rating_dist,
        data_top_directors=data_top_directors
    )

if __name__ == "__main__":
    app.run(debug=True)