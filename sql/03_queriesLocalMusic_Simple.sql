/*
 * List of album titles starting with S
*/
SELECT Title
FROM Album a 
WHERE a.Title LIKE "S%"

/*
 * List of album titles, together with artist name, for albums starting with S
*/
SELECT al.Title, ar.Name 
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId 
WHERE al.Title LIKE "S%"

/*
 * List of album titles, together with artist name, for albums containing S?
*/
SELECT al.Title, ar.Name 
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId 
WHERE al.Title LIKE "%S%"

/*
 * List of album titles, together with artist name, 
 * for albums having a in second position?
*/
SELECT al.Title, ar.Name 
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId 
WHERE al.Title LIKE "_a%"

/*
 * List of album titles, together with artist name, 
 * for albums having a in third position, b in 5th?
*/
SELECT al.Title, ar.Name 
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId 
WHERE al.Title LIKE "__a_b%"


/*
 * How many albums with title starting with S 
 * 		have been published by each artist
*/
SELECT ar.ArtistId , ar.Name , COUNT(*) as NAlbums 
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId
WHERE al.Title LIKE "S%"
GROUP BY ar.ArtistId , ar.Name 

/*
 * For each album, count the number of songs in the album
*/
SELECT al.Title as AlbumName , COUNT(*) as NSongs
FROM Album al join Track t on al.AlbumId = t.AlbumId 
GROUP BY al.AlbumId , al.Title 


/*
 * For each album with at least 10 songs, 
 * 	count the number of songs in the album
*/
SELECT al.Title as AlbumName , COUNT(*) as NSongs
FROM Album al join Track t on al.AlbumId = t.AlbumId 
GROUP BY al.AlbumId , al.Title 
HAVING COUNT(*) >= 10


/*
 * RESTRCTING ONLY TO SONGS WITH TITLE STARTING WITH S:
 * 	For each album with at least 5 songs (sarting with S), 
 * 		count the number of songs (starting with S) in the album
*/
SELECT al.Title as AlbumName , COUNT(*) as NSongs
FROM Album al join Track t on al.AlbumId = t.AlbumId 
WHERE t.Name LIKE "S%"
GROUP BY al.AlbumId , al.Title 
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) ASC 




/**
 * All albums, 
 * 	- containing at least one song that lasts 3 minutes or more
 */
SELECT DISTINCT al.Title  
FROM Album al JOIN Track tr on al.AlbumId = tr.AlbumId 
WHERE tr.Milliseconds >= 180000
ORDER BY al.Title 

/**
 * All albums, 
 * 	- containing at least one song that lasts 3 minutes or less
 * Qgood_bad
 */
SELECT DISTINCT al.Title  
FROM Album al JOIN Track tr on al.AlbumId = tr.AlbumId 
WHERE tr.Milliseconds <= 180000
ORDER BY al.Title 

/**
 * All albums, 
 * 	- containing ONLY songs that lasts 3 minutes or less
 */
-- Intermediated query
-- these are the albums that we don't want
-- q_bad
SELECT DISTINCT al.AlbumId  --al.Title  
FROM Album al JOIN Track tr on al.AlbumId = tr.AlbumId 
WHERE tr.Milliseconds > 180000
ORDER BY al.Title 


SELECT DISTINCT al.Title  
FROM Album al JOIN Track tr on al.AlbumId = tr.AlbumId 
WHERE tr.Milliseconds <= 180000 AND 
		al.AlbumId NOT IN (
		 -- bad ids
		 SELECT DISTINCT al.AlbumId  --al.Title  
		 FROM Album al JOIN Track tr on al.AlbumId = tr.AlbumId 
		 WHERE tr.Milliseconds > 180000)
ORDER BY al.Title 


/**
For each album, calculate overall/min/max/avg length of songs
**/
SELECT al.Title , SUM(tr.Milliseconds)/1000 as 'Over',  
				  MIN(tr.Milliseconds)/1000 as 'Min',
				  MAX(tr.Milliseconds)/1000 as 'Max',
				  AVG(tr.Milliseconds)/1000 as 'Avg'
FROM Track tr JOIN Album al on al.AlbumId =tr.AlbumId 
GROUP BY al.AlbumId , al.Title 

/**
For each album with more than 10 songs,
   compute avg length of songs
**/
SELECT al.Title as AlbumName , 
				COUNT(*) as NSongs, 
				AVG(t.Milliseconds) as AvgLegnth 
FROM Album al join Track t on al.AlbumId = t.AlbumId 
GROUP BY al.AlbumId , al.Title 
HAVING COUNT(*) >= 10
