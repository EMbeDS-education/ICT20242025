SELECT s.surname , s.name , t.surname  
FROM Students s JOIN Teachers t ON 
s.supervisor = t.code

SELECT s.surname , s.name , t.surname  
FROM Students s FULL OUTER JOIN Teachers t ON 
s.supervisor = t.code


SELECT s.surname , s.name , t.surname  
FROM Students s LEFT OUTER JOIN Teachers t ON 
s.supervisor = t.code

SELECT s.surname , s.name , t.surname  
FROM Students s RIGHT OUTER JOIN Teachers t ON 
s.supervisor = t.code