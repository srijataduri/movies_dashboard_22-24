DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

CREATE USER IF NOT EXISTS 'flaskuser'@'localhost' 
IDENTIFIED WITH mysql_native_password BY 'flaskpass123!';

GRANT ALL PRIVILEGES ON db.* TO 'flaskuser'@'localhost';

FLUSH PRIVILEGES;

CREATE TABLE Movies (
    movieID VARCHAR(10) PRIMARY KEY,
    primaryTitle VARCHAR(255),
    isAdult INT,
    startYear INT,
    runtimeMinutes INT
) ENGINE=InnoDB;

CREATE TABLE Genres (
    movieID VARCHAR(10),
    genre VARCHAR(255),
    PRIMARY KEY (movieID, genre),
    FOREIGN KEY (movieID) REFERENCES Movies(movieID)
) ENGINE=InnoDB;

CREATE TABLE Names (
    nameID VARCHAR(10) PRIMARY KEY,
    primaryName VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE Directors (
    movieID VARCHAR(10),
    nameID VARCHAR(10),
    PRIMARY KEY (movieID, nameID),
    FOREIGN KEY (movieID) REFERENCES Movies(movieID),
    FOREIGN KEY (nameID) REFERENCES Names(nameID)
) ENGINE=InnoDB;

CREATE TABLE Writers (
    movieID VARCHAR(10),
    nameID VARCHAR(10),
    PRIMARY KEY (movieID, nameID),
    FOREIGN KEY (movieID) REFERENCES Movies(movieID),
    FOREIGN KEY (nameID) REFERENCES Names(nameID)
) ENGINE=InnoDB;

CREATE TABLE Ratings (
    movieID VARCHAR(10) PRIMARY KEY,
    averageRating DECIMAL(3,1),
    numVotes INT,
    FOREIGN KEY (movieID) REFERENCES Movies(movieID)
) ENGINE=InnoDB;

SET GLOBAL local_infile = true;

LOAD DATA LOCAL INFILE '~/Desktop/movies_dashboard_22_24/data/movies.csv'
INTO TABLE Movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(movieID, primaryTitle, isAdult, startYear, runtimeMinutes);

LOAD DATA LOCAL INFILE '~/Desktop/movies_dashboard_22_24/data/genres.csv'
INTO TABLE Genres
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(movieID, genre);

LOAD DATA LOCAL INFILE '~/Desktop/movies_dashboard_22_24/data/names.csv'
INTO TABLE Names
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(nameID, primaryName);

LOAD DATA LOCAL INFILE '~/Desktop/movies_dashboard_22_24/data/directors.csv'
INTO TABLE Directors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(movieID, nameID);

LOAD DATA LOCAL INFILE '~/Desktop/movies_dashboard_22_24/data/writers.csv'
INTO TABLE Writers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(movieID, nameID);

LOAD DATA LOCAL INFILE '~/Desktop/movies_dashboard_22_24/data/ratings.csv'
INTO TABLE Ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(movieID, averageRating, numVotes);
