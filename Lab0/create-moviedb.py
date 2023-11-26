import psycopg2

conn = psycopg2.connect(
                        host="localhost",
                        user="postgres",
                        password="1234",
                        port=5432) 

# preparing a cursor object
cursor = conn.cursor()


# creating database
#cursor.execute("CREATE DATABASE IF NOT EXISTS movieDB")

cursor.execute("SELECT 'CREATE DATABASE moviedb' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'moviedb')")

print(cursor.fetchall())

