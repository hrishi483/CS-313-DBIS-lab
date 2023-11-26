import csv
import psycopg2

conn = psycopg2.connect(database='collegedb',
                        host="localhost",
                        user="postgres",
                        password="1234",
                        port=5432) 
                        
mycursor = conn.cursor()
with open("studentData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO student VALUES(%s,%s,%s,%s)"
        values = (int(record[0]),record[1],record[2],float(record[3]))
        mycursor.execute(line,values)

with open("departmentData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO department VALUES(%s,%s)"
        values = (record[0],int(record[1]))
        mycursor.execute(line,values)

with open("professorData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO professor VALUES(%s,%s)"
        values = (record[0],record[1])
        mycursor.execute(line,values)

with open("departmentData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO department VALUES(%s,%s)"
        values = (record[0],int(record[1]))
        mycursor.execute(line,values)

with open("courseData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO course VALUES(%s,%s,%s)"
        values = (int(record[0]),record[2],record[1])
        mycursor.execute(line,values)

with open("majorData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO major VALUES(%s,%s)"
        values = (record[0],int(record[1]))
        mycursor.execute(line,values)



with open("enrollData.csv","r")as ip:
    csv_reader=csv.reader(ip)
    for record in csv_reader:
        line="INSERT INTO enroll VALUES(%s,%s,%s,%s)"
        values = (int(record[0]),record[1],record[2],int(record[3]))
        mycursor.execute(line,values)
conn.commit()
conn.close()
mycursor.close()