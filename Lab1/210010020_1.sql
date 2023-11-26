\c collegedb
--P1
SELECT pname from professor as p,department as d where p.dname=d.dname and numphds<50;

--P2
 SELECT distinct sname,gpa FROM STUDENT where gpa = (select MAX(gpa) from student);

--p3
SELECT AVG(gpa),e.cno FROM student as s,enroll as e,course as c WHERE c.dname='Computer Sciences' and c.cno = e.cno 
and e.sid=s.sid Group by e.cno;

--P4
SELECT sid , sname from student natural join enroll GROUP BY sid HAVING count(*) >= ALL(SELECT count(*) 
from student natural join enroll GROUP BY sid);

--P5
 SELECT dname,count(pname) from professor GROUP BY dname 
 HAVING COUNT(pname) >= ALL(SELECT count(pname) from professor GROUP BY (dname));

--P6
SELECT m.dname,s.sname from major as m,course as c,student as s, enroll as e where s.sid=m.sid and e.sid=s.sid and c.cno=e.cno and c.cname='Thermodynamics';

--P7
SELECT DISTINCT d.dname
FROM department as d
WHERE NOT EXISTS (
    SELECT 1
    FROM student as s
    JOIN major as m ON s.sid = m.sid
    JOIN enroll as e ON m.sid = e.sid
    JOIN course as c ON e.cno = c.cno
    WHERE m.dname = d.dname
      AND c.cname = 'Compiler Construction'
);



--P8
SELECT s.sname AS Student_Nam
FROM student s
WHERE ( 
    SELECT count(*) FROM enroll e
    JOIN course c ON e.cno=c.cno AND e.dname=c.dname
    WHERE e.sid=s.sid AND c.dname='Mathematics'
)<=2 
AND 
(   SELECT count(*) FROM enroll e
    JOIN course c ON e.cno=c.cno AND e.dname=c.dname
    WHERE e.sid=s.sid AND c.dname='Civil Engineering'
)>=1;


--P9
SELECT d.dname, avg(s.gpa) AS avgGPA
FROM department AS d JOIN major AS m ON m.dname = d.dname
JOIN  student AS s ON s.sid = m.sid
GROUP BY d.dname
HAVING min(s.gpa) < 1.5
ORDER BY d.dname;

--P10
SELECT s.sid, s.sname, s.gpa
FROM student as s
WHERE NOT EXISTS (
    SELECT c.cno
    FROM course as c
    WHERE c.dname = 'Civil Engineering'
    EXCEPT
    SELECT e.cno
    FROM enroll as e 
    WHERE e.sid = s.sid
);

-- Change DataBase
--P1

CREATE DATABASE salesdb;
\c salesdb

--P2
\i tableSales.sql
SET DATESTYLE = "ISO , MDY";

--P3
\i dataSales.sql

--p4
SELECT cust_name from customer where grade=2;

--P5
SELECT ord_num, ord_date ,ord_description from orders Order by ord_date ASC;

-- --P6
SELECT ord_num,ord_date,ord_amount from orders where ord_amount>800 order by ord_amount  DESC;

-- --p7
SELECT * FROM customer ORDER BY working_area,cust_name DESC;

--P8
SELECT cust_name FROM customer where cust_name LIKE 'S%';

--p9
SELECT ord_num from orders where EXTRACT(YEAR FROM ord_date) = 2008 and EXTRACT(MONTH FROM ord_date) = 3;

--P10 Doubt in 10% ,should this be SET or just returned
SELECT 1.1*ord_amount AS UPDATED_AMOUNT FROM orders;

-- P11
SELECT ord_num,ord_amount-advance_amount as BALANCE_AMOUNT from orders where ord_amount Between 2000 and 4000; 

--P12 Do we need to select C0022 AGAIN?
SELECT ord_num,cust_code,ord_amount FROM customer NATURAL JOIN orders where 
ord_amount IN (SELECT ord_amount FROM customer NATURAL JOIN orders where cust_code='C00022') and
cust_code != 'C00022';

--P13 VERIFY FOR >= OR JUST >
SELECT agent_code,agent_name FROM agents where commission > ALL(SELECT commission
from agents where working_area='Bangalore');

--P14
SELECT agent_code,agent_name FROM agents where commission > SOME(SELECT commission
from agents where working_area='Bangalore');

--P15
SELECT DISTINCT agents.agent_code FROM agents NATURAL JOIN orders ;

--P16 Do using joins
-- SELECT cust_name FROM customer WHERE customer.cust_code NOT IN  (SELECT c.cust_code FROM customer as c JOIN orders on c.cust_code);
SELECT cust_name FROM customer WHERE cust_code NOT IN  (SELECT orders.cust_code FROM orders,customer where orders.cust_code=customer.cust_code);

--P17
SELECT DISTINCT agent_code from agents NATURAL JOIN orders where agents.agent_code=orders.agent_code and ord_amount>=800;

--P18
SELECT DISTINCT agent_name from agents NATURAL JOIN orders where agents.agent_code=orders.agent_code and ord_amount>=800;

--P19
SELECT cust_name,cust_code FROM customer WHERE working_area IN ('Paris','New York','Bangalore');

--P20
SELECT DISTINCT agent_name FROM agents NATURAL JOIN orders where ord_amount=1000;

--P21
SELECT SUM(ord_amount),AVG(ord_amount),MIN(ord_amount),MAX(ord_amount) FROM orders;

--P22
SELECT COUNT(cust_code) FROM customer WHERE working_area='New York';

-- P23
SELECT COUNT(*) from (SELECT DISTINCT ord_amount FROM orders) as temp;

--P24 
select DISTINCT agent_name,agents.agent_code from agents NATURAL JOIN orders where agent_code in (select agent_code from agents NATURAL JOIN orders GROUP BY agent_code Having Count(*)>=2);

--P25
SELECT COUNT(agent_code),working_area from agents GROUP by working_area;

--P26
SELECT DISTINCT working_area from agents where working_area in (SELECT cust_city from customer Natural Join orders group by cust_city Having count(cust_code)>2);

--P27 Try to select the agent name and AVG amount
SELECT orders.agent_code,AVG(ord_amount) from agents Natural Join orders group by orders.agent_code;

--P28
DELETE FROM ORDERS WHERE cust_code in (SELECT c.cust_code from customer as c,agents as a,orders as o where a.agent_code=c.agent_code and a.agent_code=o.agent_code and c.cust_code=o.cust_code and a.working_area = 'Bangalore');
DELETE FROM customer WHERE cust_code in (SELECT c.cust_code  from customer as c,agents as a,orders as o where a.agent_code=c.agent_code and a.working_area = 'Bangalore');
DELETE FROM agents where working_area='Bangalore';

--P29
ALTER TABLE customer ADD Address VARCHAR(50) default NULL;
UPDATE customer SET ADDRESS='KOTHRUD' WHERE cust_code='C00013';

-- P30
ALTER TABLE agents DROP Column Country; 

--P31
DROP TABLE Orders;

--P32
Drop TABLE customer ;

