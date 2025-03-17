SELECT a.Title
from Album a 

SELECT DISTINCT a.Title
from Album a 


SELECT a.Title
from Album a 
where a.Title like "S%"

-- album title and artist name for slbums starting with S
SELECT al.Title , ar.Name
from Album al JOIN Artist ar on al.ArtistId = ar.ArtistId
where al.Title like "S%"


-- album title and artist name for albums containing
-- S
SELECT al.Title , ar.Name
from Album al JOIN Artist ar on al.ArtistId = ar.ArtistId
where al.Title like "%S%"

-- album title and artist name for albums containing
-- a in second position
SELECT al.Title , ar.Name
from Album al JOIN Artist ar on al.ArtistId = ar.ArtistId
where al.Title like "_a%"


-- album title and artist name for albums containing
-- a in third position, b in 5th
SELECT al.Title , ar.Name
from Album al JOIN Artist ar on al.ArtistId = ar.ArtistId
where al.Title like "__a_b%"
--where al.Title like "__a%" and where al.Title like "____b%"


-- Names of artists that did at least one rock song
SELECT DISTINCT ar.Name
FROM Artist ar JOIN Album al on ar.ArtistId =al.ArtistId
		JOIN Track t on al.AlbumId = t.AlbumId
		JOIN Genre g on t.GenreId = g.GenreId
WHERE g.Name = "Rock"

-- Names of artists that did NOT do  rock songs

SELECT ar.Name
FROM Artist ar
where ar.ArtistID not in(
	SELECT DISTINCT ar.ArtistId 
	FROM Artist ar JOIN Album al on ar.ArtistId =al.ArtistId
			JOIN Track t on al.AlbumId = t.AlbumId
			JOIN Genre g on t.GenreId = g.GenreId
	WHERE g.Name = "Rock")
	
SELECT DISTINCT ar.ArtistId , ar.Name , g.Name , al.Title
	FROM Artist ar JOIN Album al on ar.ArtistId =al.ArtistId
			JOIN Track t on al.AlbumId = t.AlbumId
			JOIN Genre g on t.GenreId = g.GenreId
	WHERE ar.Name = "Green Day"
	