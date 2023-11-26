CREATE TABLE student(
sid INT NOT NULL PRIMARY KEY,
sname VARCHAR(20),
gender CHAR(1),
gpa FLOAT(4)

);
   

CREATE TABLE  department (
        dname VARCHAR(50) NOT NULL PRIMARY KEY,
        numphds INT
        );
       

CREATE TABLE  professor (
           pname VARCHAR(50) NOT NULL PRIMARY KEY,
           dname VARCHAR(50),
           CONSTRAINT C4 FOREIGN KEY (dname) REFERENCES department(dname)
           );
           
CREATE TABLE course (
               cno INT ,
               dname VARCHAR(50),
               cname VARCHAR(50),
  PRIMARY KEY (cno,dname),
               CONSTRAINT C1 FOREIGN KEY (dname) REFERENCES department(dname)
               );
CREATE TABLE  major (
        dname VARCHAR(50),
        sid INT,
    PRIMARY KEY (sid,dname),
  CONSTRAINT C2 FOREIGN KEY (dname) REFERENCES department(dname),
  CONSTRAINT C3 FOREIGN KEY (sid) REFERENCES student(sid)
 
        );
 CREATE TABLE  enroll (
          sid INT NOT NULL,
          grade VARCHAR(10), 
          dname VARCHAR(50),
          cno INT,
          PRIMARY KEY (sid,dname,cno),
          CONSTRAINT C5 FOREIGN KEY (sid) REFERENCES student(sid),
          CONSTRAINT C6 FOREIGN KEY (cno,dname) REFERENCES course(cno,dname)

      
        )
