import psycopg2
conn = psycopg2.connect(dbname="moviedb", user="postgres", password="1234",host="localhost")
cursor=conn.cursor()
cursor.execute("SELECT * FROM actor")
result = cursor.fetchall()
# print(result)
try:
    cursor.execute("ALTER TABLE movie_cast ADD PRIMARY KEY (mov_id,act_id)");
    result = cursor.fetchall()
    conn.commit()
except:
    print("Alter Table Failed")
conn.close()