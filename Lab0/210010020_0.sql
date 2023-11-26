--P1
SELECT act_fname as first_name,act_lname as l_name
from actor,movie,movie_cast
WHERE movie.mov_id=movie_cast.mov_id and movie_cast.mov_id=actor.act_id
UNION 
SELECT dir_fname as first_name,dir_lname as l_name
from movie_direction,movie,director
WHERE movie.mov_id=movie_direction.mov_id and director.dir_id=movie_direction.dir_id;


--P2
SELECT reviewer.rev_name,movie.mov_title,rating.rev_stars
FROM reviewer,movie,rating
where (rating.rev_stars>=7) and (reviewer.rev_id=rating.rev_id) and (movie.mov_id=rating.mov_id);

--P3
SELECT DISTINCT mov_title from movie,rating where movie.mov_id NOT IN (Select rating.mov_id from rating);

--P4
SELECT mov_title,mov_year,mov_duration,mov_rel_date,mov_rel_country from movie where mov_rel_country != 'USA';

--P5
SELECT DISTINCT rev_name from reviewer,rating where reviewer.rev_id <> rating.rev_id;

--P6
SELECT mov_title,rev_name,rev_stars from movie,rating,reviewer 
where rating.mov_id=movie.mov_id and reviewer.rev_id=rating.rev_id and rating.rev_stars is NOT NULL and rev_name is NOT NULL ;

--P7
SELECT rev_name from reviewer where rev_id in (SELECT rating.rev_id from reviewer,rating,movie
WHERE rating.mov_id=movie.mov_id and rating.rev_id=reviewer.rev_id
GROUP BY rating.rev_id
HAVING COUNT(movie.mov_id)>1);

-- --P8
-- SELECT movie.mov_title,rating.num_o_rating FROM movie,rating where (movie.mov_id=rating.mov_id) and (num_o_rating IS NULL);
-- SELECT reviewer.rev_name FROM reviewer,rating WHERE (reviewer.rev_id=rating.rev_id) and (rating.rev_stars IS NULL);

--P8
(select mov_title
from movie 
natural join rating
natural join reviewer)
except
( 
select mov_title
from movie 
natural join rating
natural join reviewer
where rev_name='Paul Monks');

-- P9
SELECT DISTINCT movie.mov_title FROM movie,reviewer,rating where movie.mov_id=rating.mov_id and 
reviewer.rev_id = rating.rev_id and rating.rev_stars = (select MIN(rev_stars) from rating);

--P10
SELECT movie.mov_title FROM movie,director,movie_direction WHERE director.dir_id=movie_direction.dir_id and movie_direction.mov_id=movie.mov_id and dir_fname='James'and dir_lname='Cameron';

--P11
SELECT distinct rev_name from reviewer,rating WHERE rating.rev_id=reviewer.rev_id and rating.rev_stars IS NULL  ;

--P12
SELECT actor.act_fname,actor.act_lname FROM movie_cast,movie,actor WHERE movie.mov_year NOT BETWEEN 1990 and 2000 and movie.mov_id=movie_cast.mov_id and actor.act_id=movie_cast.act_id;

--P 13
SELECT dir_fname,dir_lname,gen_title,COUNT(m.mov_id)
FROM director as d,movie_direction as md,movie as m,
genres as g,movie_genres as mg
WHERE d.dir_id=md.dir_id and md.mov_id=m.mov_id and m.mov_id=mg.mov_id
and mg.gen_id=g.gen_id
GROUP BY g.gen_title,dir_fname,dir_lname
ORDER BY d.dir_fname,d.dir_lname;

--P14
SELECT movie.mov_title,movie.mov_year,genres.gen_title,dir_fname,dir_lname
FROM movie,genres,movie_genres,movie_direction,director
WHERE movie.mov_id=movie_genres.mov_id and movie_genres.gen_id=genres.gen_id and 
movie_direction.mov_id=movie.mov_id and director.dir_id=movie_direction.dir_id;

--P15
SELECT g.gen_title,COUNT(m.mov_id), AVG(mov_duration)
FROM movie as m,movie_genres as mg, genres as g
WHERE m.mov_id=mg.mov_id and mg.gen_id=g.gen_id
GROUP BY g.gen_title;

--P16
SELECT m.mov_title,m.mov_year,d.dir_fname,d.dir_lname,a.act_fname,a.act_lname,mc.role 
FROM movie as m,movie_cast as mc,actor as a,movie_direction as md,director as d
WHERE m.mov_id=mc.mov_id and mc.act_id=a.act_id and m.mov_id=md.mov_id
and md.dir_id=d.dir_id and m.mov_duration = (SELECT MIN(mov_duration) FROM movie);

--P17
SELECT rev_name,mov_title,rev_stars
FROM movie,rating,reviewer
WHERE movie.mov_id=rating.mov_id and rating.rev_id=reviewer.rev_id
ORDER BY rev_stars;

--P18 --doubt do we need to check for num_o_rating isNULL
SELECT mov_title,dir_fname,dir_lname,rev_stars
FROM movie as m,director as d, movie_direction as md,rating as ra,reviewer as re
WHERE m.mov_id=md.mov_id and md.dir_id=d.dir_id and m.mov_id=ra.mov_id
and ra.rev_id=re.rev_id and ra.rev_stars IS NOT NULL;

--P19
SELECT dir_fname,dir_lname,mov_title,mc.role
FROM movie AS m,movie_cast as mc,director as d,movie_direction as md,actor as a
WHERE m.mov_id=md.mov_id and md.dir_id=d.dir_id and m.mov_id=mc.mov_id
and mc.act_id=a.act_id and a.act_fname=d.dir_fname and a.act_lname=d.dir_lname;

--P20
SELECT act_fname,act_lname,act_gender,role
FROM movie as m,movie_cast as mc,actor as a
WHERE m.mov_id=mc.mov_id and mc.act_id=a.act_id and mov_title='Chinatown';

--P21
SELECT mov_title
FROM movie as m,movie_cast as mc,actor as a
WHERE m.mov_id=mc.mov_id and mc.act_id=a.act_id and 
a.act_fname='Harrison' and a.act_lname='Ford';

--P22
SELECT mov_title,mov_year,MAX(rev_stars)
FROM movie as m, rating as r, genres as g, movie_genres as mg
where m.mov_id=r.mov_id and m.mov_id=mg.mov_id and mg.gen_id=g.gen_id
GROUP BY m.mov_id,gen_title
HAVING gen_title='Mystery';

--P23
SELECT mov_title,act_fname,act_lname,act_gender,mov_year,role,gen_title,dir_fname,dir_lname,
mov_rel_date,rev_stars
FROM movie as m,movie_cast as mc,movie_direction as md,director as d,actor as a,movie_genres as mg,
genres as g,rating as r
WHERE m.mov_id=mc.mov_id and mc.act_id=a.act_id and m.mov_id=md.mov_id and md.dir_id=d.dir_id and m.mov_id=r.mov_id
and m.mov_id=mg.mov_id and mg.gen_id=g.gen_id and act_gender='F';

--P24
SELECT act_fname,act_lname,mov_year,mov_title
FROM actor as a,movie_cast as mc,movie as m
Where m.mov_id = mc.mov_id and mc.act_id=a.act_id and
mov_year IN (select mov_year FROM director as d,movie_direction as md,movie as m
WHERE m.mov_id = md.mov_id and md.dir_id=d.dir_id and d.dir_fname='Stanley' and d.dir_lname='Kubrick');
