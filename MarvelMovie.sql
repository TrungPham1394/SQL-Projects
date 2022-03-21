--First, we will create a view that stores all of these information into our database as a shortcut.

CREATE VIEW Marvel_Info AS
SELECT Marvel1.Title,
	Distributor,
	ReleaseDateUS,
	Budget,
	OpeningWeekendNorthAmerica,
	OtherTerritories,
	Worldwide,
	[RottenTomatoesIn%],
	Metacritic,
	CinemaScore,
	CinemaScore1
FROM Marvel1
INNER JOIN Marvel2 ON Marvel1.Title = Marvel2.Film


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Querying this will allow us to see which Marvel movies didn't meet the expectations and made less revenue than their budgets. 

SELECT Title, Budget, Worldwide
FROM Marvel_Info
WHERE Budget > Worldwide 


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--We can see which movies that were released from 01/01/2000 to 01/01/2010 made the most revenue for the opening weekend in USA. 

SELECT Title, ReleaseDateUS, OpeningWeekendNorthAmerica
FROM Marvel_Info
WHERE ReleaseDateUS BETWEEN '01-01-2000' AND '01-01-2010'
ORDER BY OpeningWeekendNorthAmerica DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--For the Spider-Man series, we can see which movie made the least revenue in this series. 

SELECT Title
FROM Marvel_Info
WHERE Worldwide = (SELECT MIN(Worldwide) FROM Marvel_Info WHERE Title LIKE '%Spider-Man%')


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--We can compare the total revenue of both series of Avengers and Spider-Man. 

SELECT SUM(Worldwide) AS TotalRevenueForSpiderManSeries, (SELECT SUM(Worldwide) FROM Marvel_Info WHERE Title LIKE '%Avengers%') AS TotalRevenueForAvengerSeries
FROM Marvel_Info
WHERE Title LIKE '%Spider-Man%' 


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This will allow us to see which top 5 movies made the highest revenue and aren't in the Spider-Man and Avengers series 

SELECT TOP 5 Title, Worldwide
FROM Marvel_Info
WHERE Title NOT LIKE '%Spider-Man%' AND Title NOT LIKE '%Avengers%'
ORDER BY Worldwide DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--By ordering the rotten tomatoes percentage score in descending order, this will show which movies are rated from highest to lowest. In this case, I'm only interested in seeing the top 10.
--We can also see the top 10 worst movies according by rotten tomatoes by taking out the DESC and execute it. 

SELECT TOP 10 *
FROM Marvel_Info
ORDER BY [RottenTomatoesIn%] DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--We can see which top 10 movie titles made the most revenue from highest to lowest. 

SELECT TOP 10 title, SUM(Worldwide) AS TotalRevenue
FROM Marvel_Info
GROUP BY title
ORDER BY SUM(Worldwide) DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Likewise, we can also see which movie distributor made the most revenue from highest to lowest as well. 

SELECT distributor, SUM(Worldwide) AS TotalRevenue
FROM Marvel_Info
GROUP BY distributor
ORDER BY SUM(Worldwide) DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--In this query, we can see which movie made the 2nd highest revenue from all of the other movies.

SELECT TOP 1 Title, Worldwide AS SecondHighestRevenue
FROM Marvel_Info
WHERE Worldwide < (SELECT MAX(Worldwide) FROM Marvel_Info)
ORDER BY Worldwide DESC 


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This is another way to get the 2nd highest revenue.

SELECT TOP 1 Title, MAX(Worldwide) AS SecondHighestRevenue
FROM Marvel_Info
WHERE Worldwide != (SELECT MAX(Worldwide) FROM Marvel_Info)
GROUP BY Title, Worldwide
ORDER BY Worldwide DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Using both SUM and CASE can help me count how many movies these distributors gave out.

SELECT 
	SUM(CASE Distributor
		WHEN 'Walt Disney Studios Motion Pictures' THEN 1
		ELSE 0
		END) AS NumberOfFilmsWaltDisneyStudiosDistributed,
	SUM(Case Distributor
		WHEN 'Sony Pictures' THEN 1
		ELSE 0
		END) AS NumberOfFilmsSonyPicturesDistributed,
	SUM(CASE Distributor
		WHEN '20th Century Fox' THEN 1
		ELSE 0
		END) AS NumberOfFilms20thCenturyFoxDistributed
FROM Marvel_Info


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Categorizing movies that have more than 1 sequels or spinoffs. We will create a view for this as a shortcut. 

CREATE VIEW MarvelSeries AS
SELECT Title,
CASE 
	WHEN (Title LIKE '%Blade%') THEN 'Blade Series'
	WHEN (Title LIKE '%Spider-Man%') THEN 'Spider-Man Series'
	WHEN (Title LIKE '%Hulk%') THEN 'Hulk Series'
	When (Title LIKE '%Avengers%') THEN 'Avengers Series'
	WHEN (Title LIKE '%Iron Man%') THEN 'Iron Man Series'
	WHEN (Title LIKE '%Ghost Rider%') THEN 'Ghost Rider Series'
	WHEN (Title LIKE '%Captain America%') THEN 'Captain America Series'
	WHEN (Title LIKE '%Venom%') THEN 'Venom Series'
	WHEN (Title LIKE '%Thor%') THEN 'Thor Series'
	WHEN (Title LIKE '%Guardians of the Galaxy%') THEN 'Guardians of the Galaxy Series'
	WHEN (Title LIKE '%Deadpool%') THEN 'Deadpool Series'
	WHEN (Title LIKE '%Ant-Man%') THEN 'Ant-Man Series'
	WHEN (Title LIKE '%X-Men%') THEN 'X-Men Series'
	WHEN (Title IN ('X2', 'Dark Phoenix', 'Logan', 'The New Mutants', 'The Wolverine')) THEN 'X-Men Series'
	ELSE 'Misc.'
END AS SeriesName, Worldwide
FROM Marvel_Info


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--In order to determine which series made the most revenue, we can query it like this and use the view that we previously made. 

SELECT DISTINCT TOP (1) SeriesName, SUM(Worldwide) AS TotalRevenue
FROM MarvelSeries
GROUP BY SeriesName
ORDER BY TotalRevenue DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Additionally, we can see which movies made less revenue than the total average revenue that have 90 or higher review score from rotten tomatoes.

SELECT Title, Worldwide, [RottenTomatoesIn%]
FROM Marvel_Info
WHERE Worldwide < (SELECT AVG(Worldwide) FROM Marvel_Info) AND ([RottenTomatoesIn%] > 90)
ORDER BY [RottenTomatoesIn%] DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Similarly, this will let us see which movies made less revenue than the total average revenue that have the score of A from CinemaScore

SELECT Title, Worldwide, CinemaScore
FROM Marvel_Info
WHERE (Worldwide < (SELECT AVG(Worldwide) FROM Marvel_Info)) AND (CinemaScore NOT IN ('B', 'C', 'NA'))










