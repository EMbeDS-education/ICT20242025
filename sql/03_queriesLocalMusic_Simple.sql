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




