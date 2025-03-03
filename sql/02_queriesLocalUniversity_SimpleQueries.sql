SELECT s.surname 
FROM Students s
WHERE s."year" = 3


SELECT s.surname, s.name
FROM Students s
WHERE s."year" = 3

SELECT DISTINCT s.Surname
FROM Students s
WHERE s.program = 'bachelor'


SELECT s.Surname
FROM Students s
WHERE s.Surname = 'Rossi' OR s."year" =3

SELECT s.Surname
FROM Students s
WHERE s.Surname = 'Rossi' AND s."year" =3

--all surnames starting with Ro 
SELECT s.Surname
FROM Students s
WHERE s.Surname LIKE 'Ro%'

--all surnames ending with i
SELECT s.Surname
FROM Students s
WHERE s.Surname LIKE '%i'

--all surnames containing a
SELECT s.Surname
FROM Students s
WHERE s.Surname LIKE '%o%'

--all surnames containing i as second letter
SELECT s.Surname
FROM Students s
WHERE s.Surname LIKE '_i%'

--all columns for surnames containing i as second letter
SELECT s.Surname as Last_name
FROM Students s
WHERE s.Surname LIKE '_i%'

--all columns from students 
--					whose surname ends with i and
--					are in year 3 or 1
SELECT *
FROM Students s
WHERE s.Surname LIKE '%i' AND (s."year"=3 OR s."year"=1)

--all columns for surnames of length 3, containing R as first letter, s as the third
SELECT *
FROM Students s
WHERE s.Surname LIKE 'R_s'
			--		  Ras, Res, Ris, Rus.. 

--all columns for surnames, containing R as first letter, s as the third
SELECT *
FROM Students s
WHERE s.Surname LIKE 'R_s%'

-- name, surname of students without supervisor
SELECT s.surname , s.name 
FROM Students s
WHERE s.supervisor ISNULL

-- name, surname of students with supervisor
SELECT s.surname , s.name 
FROM Students s
WHERE s.supervisor NOTNULL

-- name, surname, with different sortings
SELECT s.surname , s.name 
FROM Students s
ORDER BY s.surname ASC, s."year"  --s.name  ASC  




---
--- Now we start talking about JOIN
---
-- Get surname of students and of their supervisor
SELECT s.surname as StudSurname, t.surname as TeachSurname 
From Students s , Teachers t 
WHERE s.supervisor = t.code 

-- The same as before
SELECT s.surname as StudSurname, t.surname as TeachSurname 
FROM Students s JOIN Teachers t  ON s.supervisor =t.code 


--- Add some exams
INSERT INTO Exams (student, course, mark, laud)
VALUES (111,'PR1',  30, True);

INSERT INTO Exams (student, course, mark, laud)
VALUES (112,'PR1',  18, False);

INSERT INTO Exams (student, course, mark, laud)
VALUES (115,'PR1',  26, False);

-- Extract surname, name of students, title of course, mark obtained
SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s, Courses c, Exams e
WHERE s.studentID = e.student  and c.code = e.course
-- same
SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course


-- as before, but filtering on exames > 21		
SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course
WHERE e.mark > 21

-- same as before, but sorting
SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course
WHERE e.mark > 21
ORDER BY s.surname 






--
-- Now we talk about set operations
--

SELECT s.surname 
FROM Students s
WHERE s."year" = 1

UNION

SELECT s.surname 
FROM Students s
WHERE s."year" = 3

-- same as union above
-- SELECT s.surname 
-- FROM Students s
-- WHERE s."year" = 1 OR s."year" = 3



SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course
WHERE e.mark > 21 

INTERSECT

SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course
WHERE e.mark < 30

-- same as intersect above
-- SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
-- FROM Students s JOIN Exams e on s.studentID = e.student
-- 		JOIN Courses c on  c.code = e.course
-- WHERE e.mark > 21 AND e.mark < 30

-- Ex1 All students (name, surname) that did NOT pass programmazione 1
--

-- Ex1.1 all students that passed pr1
SELECT s.surname as StudSurname, s.name as StudName, c.title as Title, e.mark 
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course
WHERE c.title = 'Programmazione1'

-- Ex1.2 all IDs of students that passed pr1
SELECT s.studentID  
FROM Students s JOIN Exams e on s.studentID = e.student
		JOIN Courses c on  c.code = e.course
WHERE c.title = 'Programmazione1'

-- Ex1.3 I can compute: all students 
SELECT s.name , s.surname 
FROM Students s  

-- Ex1.4 Finally, I can compute all students that did not pass pr1
SELECT s.name , s.surname 
FROM Students s  
WHERE s.studentID NOT IN(
		SELECT s.studentID  
		FROM Students s JOIN Exams e on s.studentID = e.student
			JOIN Courses c on  c.code = e.course
		WHERE c.title = 'Programmazione1'
	)

