import psycopg2
conn = psycopg2.connect(dbname="moviedb", user="postgres", password="1234",host="localhost")
# conn.autocommit = True
cursor=conn.cursor()
cursor.execute("SELECT * FROM actor")
result = cursor.fetchall()
# print(result)

cursor.execute("Select act_id from actor")
result=cursor.fetchall()
output=[]

output=[r[0] for r in result]
# print(output)
boolean = True


act_id=int(input("Enter actor id ")) 
first_name=input("Enter First name ") 
last_name=input("Enter Last name ")
gender=input("Enter Gender ")

if act_id in output:
    print("act_id already exists in database select different one")
else:
    print("Actor details inserted into the actor table successfully")
    boolean = False

if boolean==False:
    cursor.execute(f"Insert into actor(act_id, act_fname, act_lname, act_gender) values(%s,%s,%s,%s)",(str(act_id),first_name,last_name,gender))
    conn.commit()

cursor.execute("SELECT * from actor ")
result = cursor.fetchall()
# print(result)


conn.close()