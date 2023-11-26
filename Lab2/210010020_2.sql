
--Q1
-- Selecting sections with maximum number of students. Using takes tables we get total number of students in particular year and semester
-- in each section. Finding max count of this gives us the section with max number of students.
SELECT MAX(counts) ,MIN(counts) from (SELECT count(id) as counts FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , year) as counts;


--Q2
-- SELECT THE STUDENTS who were in the section with maximum enrollments in it, i.e in 2017 Fall 
select sec_id ,course_id,semester,year from SECTION Natural Join takes GROUP BY sec_id , course_id , semester , year Having count(id) 
>=  ALL(SELECT count(id) as counts FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , year);


--Q3
-- To replace the counts which have null value use coalesce
SELECT  sec_id , course_id , semester , year,
COALESCE(count(id),0) as counts FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , year;

--a] 
--scalar subquery MAX
select (SELECT  count(id) as Max_enrollments FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , 
year Having count(id)>=ALL(SELECT COUNT(ID) FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , year));
--scalar subquery MIN
select (SELECT  count(id) as Max_enrollments FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , 
year Having count(id)<=ALL(SELECT COUNT(ID) FROM SECTION Natural Join takes GROUP BY sec_id , course_id , semester , year));

--b]
SELECT min(cnt),max(cnt) FROM 
    (
        SELECT count(ID) as cnt 
        FROM section NATURAL LEFT JOIN takes 
        GROUP BY course_id,sec_id,semester,year
    ) as tab;

-- -- Q4. Find all courses whose identifier starts with the string ”CS-1”
SELECT course_id from course where course_id LIKE 'CS-1%';

-- --Q5 Find instructors who have taught all the above courses (obtained as answer for previous question)

SELECT DISTINCT i.name FROM instructor as i, course as c, teaches as t where t.course_id = c.course_id and t.ID = i.ID and c.course_id in (SELECT course_id from course where course_id LIKE 'CS-1%');

-- a] Using the ”not exists ... except ...” structure
SELECT DISTINCT i.name FROM instructor as i, course as c, teaches as t where i.ID = t.ID and  t.course_id = c.course_id and NOT exists 
(( SELECT course_id from course where course_id LIKE 'CS-1%' )
EXCEPT 
(SELECT course_id FROM instructor as i,teaches as t where t.course_id = c.course_id ));

--b] Using Scalar Subquery
SELECT DISTINCT i.name FROM instructor as i, course as c, teaches as t where t.course_id = c.course_id and t.ID = i.ID AND 
c.course_id LIKE 'CS-1%' GROUP BY I.NAME Having COUNT(Distinct c.course_id) = (SELECT COUNT(course_id) 
from course where course_id LIKE 'CS-1%');


--Q6 . Insert each instructor as a student, with tot creds = 0, in the same department to which the instructor belongs.

-- Please check for primary key constraint
SELECT  id,name,dept_name from instructor;
INSERT INTO student (SELECT id, name,dept_name,0 from instructor);

--P7 
-- Assuming there is no instructor and student with the same name department and id;
DELETE FROM student as s  WHERE ID in (SELECT s.ID FROM instructor as i, student as s where s.name = i.name and s.ID = i.ID and tot_cred = 0);

--p8 I have just calculated number of sections that he has taught since sction course id is ambiguous
UPDATE instructor as inst SET SALARY = 10000 * (SELECT COUNT(s.sec_ID) FROM instructor AS i, course AS c,department AS d, section AS s WHERE I.dept_name = d.dept_name and c.dept_name = d.dept_name and s.course_id = c.course_id and i.id = inst. id)  ;

--P9
-- Create a view that lists information about all fail grades (grade = F in takes table) of all students along with their id, course id, sec id,
-- semester, year and grade (the view should contain all attributes from
-- the takes relation
CREATE VIEW Failed_students AS SELECT * FROM TAKES as t WHERE t.grade = 'F';


--P10 Not working when using the view
-- Using the view defined in the previous query, find all students who have
-- 2 or more F grades and list the student ids.
SELECT id FROM Failed_students GROUP BY id HAVING COUNT(course_id)>=2;



--P11
create table grade_map
	(grade		varchar(20),  
	 points		numeric(12,2)
	);
        -- INSERT INTO TABLE
insert into grade_map values ('A',10);
insert into grade_map values ('B',8);
insert into grade_map values ('C',6);
insert into grade_map values ('D',4);
insert into grade_map values ('F',0); 
insert into grade_map values ('A-',10);
insert into grade_map values ('B-',8);
insert into grade_map values ('C-',6);
insert into grade_map values ('D-',4);
insert into grade_map values ('F-',0); 


--P12
-- . Using the table created previously (and other relavent tables), write
-- a query to find the Cumulative Grade Point Average of each student,
-- using this table.
Alter table takes ADD COLUMN points numeric ;
update takes set points = (SELECT POINTS FROM grade_map as gm where gm.grade = takes.grade);
SELECT id,AVG(points) from takes group by id;
ALTER TABLE TAKES DROP COLUMN points;

--p13
SELECT course_id,sec_id,semester,year,room_number,time_slot_id
FROM section WHERE (room_number,time_slot_id) IN (SELECT room_number,time_slot_id FROM section GROUP BY room_number,time_slot_id HAVING count(*) >1) ;


--P14
CREATE VIEW FACULTY AS SELECT ID, NAME, DEPT_NAME FROM INSTRUCTOR;


--P15
CREATE VIEW CSinstructor as select * from instructor where dept_name='Comp. Sci.';


--P16
INSERT INTO CSinstructor VALUES ('21001','ABC','Physics',30000);
INSERT INTO CSinstructor VALUES ('31001','XYZ','Comp. Sci.',30000);
INSERT INTO FACULTY VALUES ('41001','pqr','Comp. Sci.');


--P17
\c postgres
CREATE USER user1 with encrypted password 'user1234';
\c universitydb;
GRANT SELECT on student to user1;
-- to view the privileges use \l