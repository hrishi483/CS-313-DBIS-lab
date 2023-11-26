--We can directly run this sql file from postgres by typing the command "\i 210010016_1.sql"
\c collegedb

-- Question 1



SELECT pname
FROM professor as p
NATURAL JOIN
department as d
WHERE d.numphds<50;
----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 2

SELECT sname
FROM student as d
WHERE d.gpa=(SELECT max(s.gpa) FROM student as s);

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 3

SELECT c.cno,avg(gpa)
FROM student as s NATURAL JOIN enroll NATURAL JOIN course as c NATURAL JOIN department as d 
WHERE c.dname = 'Computer Sciences'
GROUP BY c.cno; 

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 4

SELECT sname,sid
FROM student as s NATURAL JOIN enroll as e 
GROUP BY sname,sid
HAVING count(e.cno)=
(
SELECT max(d.count) FROM
(SELECT count(e.cno)
FROM student as s NATURAL JOIN enroll as e 
GROUP BY sname

) as d
);


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 5

SELECT dname
FROM professor as p NATURAL JOIN department as d
GROUP BY dname
HAVING count(p.pname)=
(SELECT max(d.count)
FROM
(
SELECT count(pname) FROM professor as p NATURAL JOIN department as d
GROUP BY dname
) as d);

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 6

SELECT sname,m.dname
FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c, major as m
WHERE  s.sid=m.sid AND c.cname='Thermodynamics';

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 7


SELECT DISTINCT m.dname
FROM major as m
WHERE NOT EXISTS (
    SELECT *
    FROM student as s
    NATURAL JOIN enroll as e
    NATURAL JOIN course as c
    WHERE c.cname = 'Compiler Construction'
    and s.sid = m.sid

);


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 8
-- SELECT sname,cname
-- FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
-- WHERE EXISTS
-- (
-- SELECT c1.cno
-- FROM course as c1
-- WHERE dname='Mathematics' and c.cno= c1.cno);

(SELECT sname
FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
WHERE e.dname='Mathematics'
GROUP BY sname
HAVING count(cname)<=2)
INTERSECT
(
SELECT sname FROM student WHERE sname = SOME(
SELECT sname
FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
WHERE e.dname='Civil Engineering'
GROUP BY sname));




----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 9

-- SELECT dname, avg(gpa)
-- FROM student as s NATURAL JOIN major as m NATURAL JOIN department as d
-- WHERE gpa < 1.5
-- GROUP BY dname;

SELECT d.dname, avg(s.gpa) AS average_gpa
FROM student AS s
JOIN major AS m ON s.sid = m.sid
JOIN department AS d ON m.dname = d.dname
GROUP BY d.dname
HAVING min(s.gpa) < 1.5;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 10

-- SELECT cno
-- FROM course
-- WHERE dname='Civil Engineering';

-- SELECT s.sid,sname,gpa
-- FROM student as s NATURAL JOIN enroll as e
-- WHERE e.cno = ALL (SELECT cno
-- FROM course
-- WHERE dname='Civil Engineering');

SELECT DISTINCT s.sid,sname,gpa
FROM student as s NATURAL JOIN enroll as e
WHERE NOT EXISTS
(
    (SELECT cno
    FROM course
    WHERE dname='Civil Engineering')
    EXCEPT
    (
    SELECT p.cno
    FROM enroll as p
    WHERE p.sid=s.sid
    )

);
----------------------------------------------------------------------------
----------------------------------------------------------------------------


-- DATABASE CHANGED

--Question 1

 CREATE DATABASE salesdb;
\c salesdb

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 2

\i tableSales.sql

 
----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 3
SET DATESTYLE = "ISO,MDY";

\i dataSales.sql


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 4

SELECT cust_name 
FROM customer 
WHERE grade = 2;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 5

SELECT ord_num,ord_date,ord_description 
FROM orders
ORDER BY ord_date;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 6

SELECT ord_num,ord_date,ord_amount
FROM orders
WHERE ord_amount >=800
ORDER BY ord_amount DESC;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 7

SELECT * 
FROM customer
ORDER BY working_area ASC,cust_name DESC; 

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 8

SELECT cust_name
FROM customer
WHERE cust_name LIKE 'S%';

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 9

SELECT ord_num
FROM orders
WHERE ord_date between '03/01/2008' and '03/31/2008';

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 10

SELECT ord_num,ord_amount*1.1
FROM orders;


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 11

SELECT ord_num,(ord_amount-advance_amount)
FROM orders
WHERE ord_amount between 2000 and 4000;


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 12

SELECT ord_num,cust_code,ord_amount
FROM orders
WHERE ord_amount IN
(SELECT ord_amount
FROM orders
WHERE cust_code='C00022');
----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 13
SELECT agent_name, agent_code
FROM agents
WHERE commission > all
(SELECT commission
FROM agents
WHERE working_area='Bangalore');


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 14
SELECT agent_name, agent_code
FROM agents
WHERE commission > some
(SELECT commission
FROM agents
WHERE working_area='Bangalore');

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 15

SELECT DISTINCT agent_code
FROM orders;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 16

SELECT cust_name
FROM customer
WHERE cust_code NOT IN
(SELECT DISTINCT cust_code FROM orders);

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 17
-- SELECT agent_code
-- FROM agents NATURAL JOIN orders
-- WHERE ord_amount >=800;

-- If needed unique agent codes , use distinct key word 

SELECT DISTINCT agent_code
FROM agents NATURAL JOIN orders
WHERE ord_amount >=800;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 18

SELECT DISTINCT agent_name
FROM agents NATURAL JOIN orders
WHERE ord_amount >=800;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 19

SELECT cust_code,cust_name
FROM customer
WHERE cust_city = 'Paris' OR cust_city='New York' OR 
cust_city='Bangalore' ;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 20

SELECT agent_name
FROM agents NATURAL JOIN orders
WHERE ord_amount=1000;


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 21

SELECT sum(ord_amount),avg(ord_amount),min(ord_amount)
,max(ord_amount)
FROM orders;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 22
SELECT count(*)
FROM customer
WHERE cust_city = 'New York';

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 23

SELECT count(DISTINCT ord_amount)
FROM orders;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 24

SELECT agent_name,agent_code
FROM agents NATURAL JOIN orders
GROUP BY agent_name,agent_code
HAVING count(ord_num)>=2;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 25

SELECT working_area, count(agent_code)
FROM agents
GROUP BY working_area;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 26

SELECT working_area
FROM agents NATURAL JOIN orders
GROUP BY working_area
HAVING count(ord_num)>=2;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 27

SELECT agent_name, avg(ord_amount)
FROM agents NATURAL JOIN orders
GROUP BY agent_name;


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 28

INSERT INTO agents VALUES ('0000',0,0,0,0);

UPDATE customer
SET agent_code = '0000'
WHERE agent_code IN (SELECT agent_code FROM
agents WHERE working_area = 'Bangalore'
);

UPDATE orders
SET agent_code = '0000'
WHERE agent_code IN (SELECT agent_code FROM
agents WHERE working_area = 'Bangalore');

DELETE FROM agents
WHERE working_area='Bangalore';

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 29

ALTER TABLE customer
ADD COLUMN Address varchar(50) NULL;

INSERT INTO customer VALUES 
('C0013','Duddu Hriday','Hyderabad','Dharwad','India',
10,2000,5000,25000,50000,'9876543210','0000');


UPDATE customer
SET Address = 'IIT Dharwad,Karntaka'
WHERE cust_code='C00013';


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 30

ALTER TABLE agents
DROP COLUMN country;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 31

DELETE FROM orders;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 32

DROP TABLE customer CASCADE;