
/*
 * How many albums have been published by each artist
*/
SELECT a.ArtistId AS Artist, COUNT(*) AS NumAlbums
FROM Album a 
GROUP BY a.ArtistId
ORDER BY NumAlbums DESC;

/*
 * How many albums have been published by each artist
 * 	with name of artists
*/
SELECT a.ArtistId AS ArtistID, ar.Name , COUNT(*) AS NumAlbums
FROM Album a JOIN Artist ar on ar.ArtistId = a.ArtistId 
GROUP BY a.ArtistId
ORDER BY NumAlbums DESC;


/*
 * How many albums have been published by each artist
 * 	with name of artists
 * restricting to artists with more than 3 albums
*/
SELECT a.ArtistId AS ArtistID, ar.Name , COUNT(*) AS NumAlbums
FROM Album a JOIN Artist ar on ar.ArtistId = a.ArtistId 
GROUP BY a.ArtistId
HAVING NumAlbums > 3
ORDER BY NumAlbums DESC;


/*
 * Number of songs that each artist 
 * has in each of its albums
 */

SELECT ar.Name , al.AlbumId ,al.Title , COUNT(*)
FROM Album al JOIN Track t on al.AlbumId = t.AlbumId 
		JOIN Artist ar on ar.ArtistId = al.ArtistId 
GROUP BY al.AlbumId , al.ArtistId , ar.Name

/*
 * Average number of songs that each artist 
 * has in its albums
 */
SELECT	ar.Name , 
		COUNT(*) as OverallSongs , 
		COUNT(DISTINCT al.AlbumId) as NumberOfAlbums ,
		(COUNT(*) / COUNT(DISTINCT al.AlbumId)) AS AvgSongsPerAlbum
FROM Album al JOIN Track t on al.AlbumId = t.AlbumId 
		JOIN Artist ar on ar.ArtistId = al.ArtistId 
GROUP BY al.ArtistId , ar.Name


/**
 * All albums, 
 * 	containing at least 1 song that lasts more than 2 minutes
 */
-- intermediate solution
-- SELECT al.AlbumId , al.Title as Album, t.Name as Song , t.Milliseconds
-- FROM Album al JOIN Track t on t.AlbumId = al.AlbumId 
-- WHERE t.Milliseconds > 120000

-- First option
SELECT DISTINCT al.Title as Album
FROM Album al JOIN Track t on t.AlbumId = al.AlbumId 
WHERE t.Milliseconds > 120000

-- Second option
SELECT al.AlbumId , al.Title as Album  
FROM Album al JOIN Track t on t.AlbumId = al.AlbumId 
WHERE t.Milliseconds > 120000
GROUP BY al.AlbumId , al.Title



/**
 * All albums, 
 * 	- containing at least 1 song that lasts more than 2 minutes
 *  - number of tracks that last more than 2 minutes
 *  - minimum length of its songs
 *  - maximum length of its songs 
 */














--------------------------------------
-- more examples from previous years --
--------------------------------------

/*
 * How many albums have been published by each artist
*/
SELECT a.ArtistId AS Artist, COUNT(*) AS NumAlbums
FROM Album a 
GROUP BY a.ArtistId
ORDER BY NumAlbums DESC;

-- now I want also the name!
SELECT ar.ArtistId AS Artist, ar.Name AS Name ,
		COUNT(*) AS NumAlbums
FROM Album al JOIN Artist ar 
	ON al.ArtistId = ar.ArtistId 
GROUP BY ar.ArtistId, ar.Name 
ORDER BY NumAlbums DESC;



--- Now I want only artists that did at least 10 albums
SELECT ar.ArtistId AS Artist, ar.Name AS Name ,
		COUNT(*) AS NumAlbums
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId 
--WHERE ...
GROUP BY ar.ArtistId, ar.Name 
HAVING NumAlbums > 9
ORDER BY NumAlbums DESC;


--- Now I want only artists that did at least 10 albums
SELECT ar.ArtistId AS Artist, ar.Name AS Name ,
		COUNT(*) AS NumAlbums
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId 
WHERE (ar.Name LIKE 'D%') OR (ar.Name LIKE 'U%')
GROUP BY ar.ArtistId, ar.Name 
HAVING NumAlbums > 9
ORDER BY NumAlbums DESC;

/**
 * All albums, 
 * 	containing at least 1 song that lasts more than 2 minutes
 */
SELECT DISTINCT al.Title 
FROM Album al JOIN Track tr ON al.AlbumId = tr.AlbumId  
WHERE tr.Milliseconds > 120000


/**
 * All albums, 
 * 	- containing at least 1 song that lasts more than 2 minutes
 *  - number of tracks that last more than 2 minutes
 *  - minimum length of its songs
 *  - maximum length of its songs 
 */
SELECT DISTINCT al.Title , COUNT(*) AS NumSongsMoreThanTwoMinutes , 
		MIN(tr.Milliseconds) AS MinLenght ,MAX(tr.Milliseconds)  AS MaxLenght
FROM Album al JOIN Track tr ON al.AlbumId = tr.AlbumId  
WHERE tr.Milliseconds > 120000
GROUP BY al.AlbumId
ORDER BY NumSongs ASC 

/**
 * All albums, 
 * 	- containing ONLY songs that last less than 3 minutes
 */
--We start making a query for: All albums with at least 1 song longer than 3 minutes
--bottom potato
SELECT DISTINCT al.Title 
FROM Album al JOIN Track tr ON al.AlbumId = tr.AlbumId
WHERE tr.Milliseconds > 180000
GROUP BY al.AlbumId

--top potato
SELECT DISTINCT al.Title 
FROM Album al JOIN Track tr ON al.AlbumId = tr.AlbumId  
WHERE tr.Milliseconds < 180000
GROUP BY al.AlbumId

--This is the solution: top potato minus bottom potato
SELECT DISTINCT al.Title 
FROM Album al JOIN Track tr ON al.AlbumId = tr.AlbumId  
WHERE tr.Milliseconds < 180000
GROUP BY al.AlbumId
HAVING al.Title NOT IN(
		SELECT DISTINCT al.Title 
			FROM Album al JOIN Track tr ON al.AlbumId = tr.AlbumId
			WHERE tr.Milliseconds > 180000
)

/**
 * all songs in album with id 12
 * to chech that the previous query works
 */
--all songs from album with id 12
SELECT al.Title AS Album , tr.TrackId , tr.Name AS Song , tr.Milliseconds MS , tr.Milliseconds/1000 AS Seconds , tr.Milliseconds/60000 AS Minutes
FROM Album al JOIN Track tr
	on al.AlbumId = tr.AlbumId 
WHERE al.AlbumId = 12





/**
For all albums, calculate overall/min/max/avg length of songs
**/
SELECT al.Title , 
	SUM(tr.Milliseconds) AS Overall_length , 
	MIN(tr.Milliseconds) AS min_length ,
	MAX(tr.Milliseconds) AS max_length , 
	AVG(tr.Milliseconds) AS avg_length
FROM Album al JOIN Track tr 
	on al.AlbumId = tr.AlbumId 
-- WHERE 
GROUP BY al.AlbumId , al.Title 

/**
For each album with more than 10 songs,
   compute avg length of songs
**/
SELECT al.Title , 
	AVG(tr.Milliseconds) AS avg_length ,
	COUNT(*) AS NumSongs
FROM Album al JOIN Track tr 
	on al.AlbumId = tr.AlbumId 
-- WHERE 
GROUP BY al.AlbumId , al.Title 
HAVING NumSongs > 10
ORDER BY NumSongs ASC

/**
 * All artists with at least (one album with at least) one song of genre rock
 */
SELECT DISTINCT ar.Name 
FROM 
( ( (Artist ar JOIN Album al on ar.ArtistId = al.ArtistId)
					JOIN Track tr on al.AlbumId = tr.AlbumId )
						JOIN Genre g on g.GenreId = tr.GenreId )
WHERE g.Name = 'Rock'