import psycopg2
conn = psycopg2.connect(database='moviedb',
                        user='postgres',
                        password='1234',
                        host='localhost')
cursor = conn.cursor()
conn.autocommit=False
act_id = int (input('Enter the id of actor: '))
cursor.execute("Select act_id from actor")
all_act_id = cursor.fetchall()
all_act_ids = [i[0] for i in all_act_id]
if act_id in all_act_ids:

    num_movies = int(input('Enter the number of movies: '))

    cursor.execute("SELECT mov_id FROM movie")
    movie_list = [i[0] for i in cursor.fetchall()]
    # print(movie_list)

    boolean = True
    movie_index=[]
    select_query="Select * from movie_cast where act_id= %s"
    insert_query = "Insert into movie_cast(act_id, mov_id, role) Values(%s, %s, %s) " 

    cursor.execute(select_query,(act_id,)) #psycopg2 expects parameters to be passed as a tuple or a list.
    result = cursor.fetchone()
    # print("Before Insertion ",result)

    noerrors=False
    for i in range(num_movies):
        movie_id = int(input(f"\nEnter movie id of movie number {i+1} : "))
        movie_role = input(f"\nEnter role of the actor in movie number {i+1}: ")
        if movie_id in movie_list:
            #Check for duplicates
            cursor.execute("Select act_id,mov_id from movie_cast where act_id=%s and mov_id=%s",(act_id,movie_id))
            duplicates=cursor.fetchall()
            # print(duplicates)
            if (act_id,movie_id) not in duplicates:
                cursor.execute(insert_query,(act_id, movie_id, movie_role))
            else:
                print("Entry already exists in DataBase")
                noerrors=True
                break
        else:
            movie_index.append(i+1)
            boolean=False
        # print(f"Actor  acts in {movie_id} as {movie_role} ",end='\n')

    if boolean==True:
        # conn.commit()
        pass
    else:
        print("Movie number ",movie_index," is not present in the database. Database is not updated")
        conn.rollback()

    if noerrors==False:
        conn.commit()
        select_query="Select * from movie_cast where act_id= %s"
        cursor.execute(select_query,(act_id,))
        # result = cursor.fetchone()
        # print("After Insertion ",result)
else:
    
    print("Invalid actor id inserted: ",act_id,"not in actor table")
