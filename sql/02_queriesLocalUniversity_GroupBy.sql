INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (111, 'Rossi', 'Mario', 'bachelor', 3, 'AV');

INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (115, 'Verdi', 'Marta', 'bachelor', 3, 'AV');

INSERT INTO Exams(student, course,mark,laud)
VALUES (111, 'PR1', 18, false);

INSERT INTO Exams(student, course,mark,laud)
VALUES (114, 'PR1', 30, true);

INSERT INTO Exams(student, course,mark,laud)
VALUES (115, 'PR1', 29, false);
INSERT INTO Exams(student, course,mark,laud)
VALUES (115, 'PR2', 30, false);


SELECT AVG(mark), COUNT(*)
	FROM Exams
	
SELECT AVG(mark), COUNT(*)
	FROM Exams
	WHERE student = 115	
	
--Avg mark and number of exams for bachelor courses
SELECT AVG(mark), COUNT(*)
	FROM Courses c JOIN Exams e ON c.code  = e.course 
	WHERE c.program = 'bachelor';

SELECT AVG(mark), COUNT(*)
	FROM Courses c JOIN Exams e ON c.code  = e.course 
	WHERE c.program = 'master';

SELECT AVG(mark), COUNT(*)
	--FROM Courses c JOIN Exams e ON c.code  = e.course;
	FROM Exams ;






/*
 * What if we want the avg marks and number of exams of each student?
 * Intuitively, we want something like these 'copy-pasting'
 * - but copy pasting is bad! 
 * - we can use a keyword groupby that implicitly does this
 */
SELECT AVG(mark), COUNT(*)
	FROM Exams
	WHERE student = 115	
	
SELECT AVG(mark), COUNT(*)
	FROM Exams
	WHERE student = 111	
	
SELECT AVG(mark), COUNT(*)
	FROM Exams
	WHERE student = 114	
	
SELECT e.student, AVG(mark) AS AVG_mark 
FROM Exams e 
GROUP BY e.student;

	
SELECT Year, COUNT(*) AS NumStud
FROM Students
WHERE Program='bachelor'
GROUP BY Year;

--only info about PR1
SELECT Course, AVG(Mark) AS AVG_Mark
FROM Exams
GROUP BY Course
HAVING COUNT(mark)>1


INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (116, 'Verdi', 'Marcella', 'master', 2, 'AV');

INSERT INTO Exams(student, course,mark,laud)
VALUES (116, 'PR2', 30, true);


/*
Max and min mark per program
- program is in studnets
- mark is exmas
*/
SELECT s.program AS 'Program', MIN(e.mark) AS 'min_Mark', 
		AVG(e.mark) AS 'avg_mark',  MAX(e.mark) AS 'max_Mark' 
FROM Students s JOIN Exams e ON
	s.studentID = e.student 
GROUP BY s.program 


/* same but only bachelor */
SELECT s.program AS 'Program', MIN(e.mark) AS 'min_Mark', 
		AVG(e.mark) AS 'avg_mark',  MAX(e.mark) AS 'max_Mark' 
FROM Students s JOIN Exams e ON
	s.studentID = e.student 
WHERE s.program = 'bachelor'
GROUP BY s.program 

--ok, but better go for WHERE when possible: you save computation
SELECT s.program AS 'Program', MIN(e.mark) AS 'min_Mark', 
		AVG(e.mark) AS 'avg_mark',  MAX(e.mark) AS 'max_Mark' 
FROM Students s JOIN Exams e ON
	s.studentID = e.student 
GROUP BY s.program 
HAVING s.program = 'bachelor'
