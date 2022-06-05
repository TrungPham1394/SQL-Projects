-- Filtering out the data that has null values to make it easier to work with. We will create a view for this one in order to not edit any original values.

CREATE VIEW info AS
SELECT titles.id, title, person_id, name, character, role, type, description, release_year, age_certification, runtime, genres, production_countries, seasons, imdb_score, imdb_votes, tmdb_popularity, tmdb_score
FROM titles
FULL OUTER JOIN credits ON titles.id = credits.id
WHERE titles.id IS NOT NULL AND title is NOT NULL AND person_id IS NOT NULL AND name is NOT NULL AND character IS NOT NULL AND role IS NOT NULL AND type IS NOT NULL AND description IS NOT NULL AND release_year IS NOT NULL AND age_certification is NOT NULL AND runtime is NOT NULL AND genres is NOT NULL AND production_countries is NOT NULL AND seasons is NOT NULL AND imdb_score is NOT NULL AND tmdb_popularity is NOT NULL AND tmdb_score is NOT NULL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How can we see the top 15 titles of animes that have TV-14 on their age certification while scoring 8 or above on IMDB and TMDB?

SELECT TOP 15 title, age_certification, imdb_score, tmdb_score 
FROM info
WHERE imdb_score >= 8 AND tmdb_score >= 8 AND age_certification = 'TV-14'
GROUP BY title, age_certification, imdb_score, tmdb_score
ORDER BY imdb_score DESC, tmdb_score DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How can we look for anime titles that have the genres of horror, action, and comedy and also scored 7 or above on IMDB?

SELECT title, genres, imdb_score
FROM info
WHERE genres LIKE '%horror%' AND genres LIKE '%action%' AND genres LIKE '%comedy%' AND imdb_score >= 7
GROUP BY title, genres, imdb_score
ORDER BY imdb_score DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which voice actors did voice acting for animes that scored 8 or more on both IMDB and TMDB? The total IMDB votes have to be more than 50,000.

SELECT name, role, AVG(imdb_score) AS average_imdb_score, AVG(tmdb_score) as average_tmdb_score, imdb_votes
FROM info
WHERE role = 'Actor' AND imdb_votes > 50000
GROUP BY name, role, imdb_votes
HAVING AVG(imdb_score) >= 8 AND AVG(tmdb_score) >= 8
ORDER BY AVG(imdb_score) DESC, AVG(tmdb_score) DESC, name, imdb_votes

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which voice actors have done voice acting in more than 30 animes?

SELECT name, COUNT(DISTINCT title) AS number_of_times_actor_participated
FROM info
GROUP BY name
HAVING COUNT(DISTINCT title) > 30
ORDER BY COUNT(DISTINCT title) DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- What are the person IDs and the voice actor names that have made less than 5 appearances in animes? The person IDs have to be under 50000 and their first name has to start with the letter H, J, and T.

SELECT person_id, name, COUNT(DISTINCT title) AS appearances_count
FROM info
WHERE person_id < 50000 AND name LIKE '[HJT]%'
GROUP BY person_id, name
HAVING COUNT(DISTINCT title) <= 5
ORDER BY COUNT(DISTINCT title) DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How can we find out which animes were released between the year of 2015 and 2022, have 2 or more seasons, and the genre is sci-fi?

SELECT title, release_year, genres, seasons
FROM info
WHERE release_year BETWEEN 2015 AND 2022 AND seasons >= 2 AND genres LIKE '%scifi%'
GROUP BY title, release_year, genres, seasons
ORDER BY release_year DESC, title, seasons DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- This will show which animes have TV-MA and PG-13 in the age certification, have horror genre, and the runtime is less than 5 minutes. 

SELECT title, runtime, genres
FROM titles
WHERE age_certification IN ('TV-MA', 'PG-13') AND genres LIKE '%horror%' AND runtime < 5
ORDER BY title, runtime DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- What can I query to get the anime that has the 2nd highest IMDB votes?

SELECT TOP 1 title, MAX(imdb_votes) AS Second_Highest_IMDB_Votes
FROM titles
WHERE imdb_votes != (SELECT MAX(imdb_votes) FROM titles)
GROUP BY title, imdb_votes
ORDER BY imdb_votes DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How many animes were not produced in Japan? And which animes are they?

SELECT COUNT(production_countries) AS numbers_of_animes_not_produced_in_Japan
FROM titles
WHERE production_countries NOT LIKE '%JP%'

SELECT title, production_countries
FROM titles
WHERE production_countries NOT LIKE '%JP%'
ORDER BY production_countries

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How can we use the case statement for each anime titles to show if their IMDB score is greater, lesser, or equal to 8?

SELECT title, imdb_score,
CASE
    WHEN imdb_score > 8 THEN 'The score is greater than 8'
    WHEN imdb_score = 8 THEN 'The score is 8'
    ELSE 'The score is under 8'
END AS ScoreText
FROM info
GROUP BY title, imdb_score
ORDER BY imdb_score DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which Gundam series has the most voice actors in it? 

SELECT TOP 1 title, COUNT(c.name) AS number_of_voice_actors
FROM titles t
INNER JOIN credits c ON t.id = c.id
WHERE title LIKE '%gundam%'
GROUP BY title
ORDER BY COUNT(DISTINCT c.name) DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which anime has the most seasons and has less than 5 voice actors?

SELECT TOP 1 title, MAX(seasons) as most_amount_of_seasons, COUNT(name) as number_of_voice_actors
FROM info
GROUP BY title, seasons
HAVING COUNT(name) < 5
ORDER BY seasons DESC, COUNT(name)


