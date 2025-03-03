INSERT INTO Teachers (code, surname, name, role, department)
VALUES ('FT','Pedreschi',  'Dino', 'full professor', 'Computer Science'); 

INSERT INTO Teachers (code, surname, name, role)
VALUES ('AV','Vandin',  'Andrea', 'associate professor');

--INSERT INTO Teachers (surname,code,  name, role, department)
--VALUES ('Pedreschi','FT',  'Dino', 'full professor', 'Computer Science'); 

/*
 * Multirow comment
 */

INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (111, 'Rossi', 'Mario', 'bachelor', 3, NULL);
INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (112, 'Rossi', 'Piero', 'bachelor', 2, NULL);

INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (113, 'Rosso', 'Luca', 'bachelor', 1, NULL);

INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (114, 'Ri', 'Matteo', 'bachelor', 3, 'AV');

INSERT INTO Students(StudentID, surname, name, Program, year, supervisor)
VALUES (115, 'Carli', 'Carlo', 'bachelor', 3, 'FT');


/*ERROR! Double student
INSERT INTO Students(StudentID, surname, name, Program, year)
VALUES (111, 'Rossi', 'Mario', 'bachelor', 3);
*/

INSERT INTO Courses(code, title, Program, teacher)
VALUES ('PR1', 'Programmazione1', 'bachelor', 'AV');