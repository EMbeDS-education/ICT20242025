CREATE TABLE Teachers (
	code CHAR(4) PRIMARY KEY, 
	name VARCHAR(20) NOT NULL,  
 	surname VARCHAR(20) NOT NULL,  
	role CHAR(15),
	department CHAR(10)	
); 

CREATE TABLE Students ( 
	studentID integer PRIMARY KEY, 
	surname varchar(20) NOT NULL, 
	name varchar(20) NOT NULL, 
	program char(20), 
	year integer, 
	supervisor char(4) 
	  REFERENCES Teachers(code)
);

CREATE TABLE Courses ( 
	code char(3) PRIMARY KEY, 
	title varchar(20) NOT NULL,
	program char(20), 
	teacher char(4) 
	  REFERENCES Teachers(code) 
);

CREATE TABLE Exams(
	student integer, 
	course CHAR(3),
	mark integer,
	laud bool,  
	CHECK (mark>=18 and mark<=30),
	CHECK ( (not laud) or (mark=30) ),

	
	
	PRIMARY KEY (student, course),
	FOREIGN KEY (course) REFERENCES Courses(code),
	FOREIGN KEY (student) REFERENCES Students(studentID)
	);