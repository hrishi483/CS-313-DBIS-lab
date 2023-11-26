-- --Q1
-- -- Start a new transaction
BEGIN;

-- --Q2
-- -- Insert a new actor into the "actor" table
INSERT INTO actor (act_id,act_fname, act_lname, act_gender) VALUES (125,'John', 'Doe', 'M');

-- --Q3
select * from actor;

-- --Q4
-- -- Commit the transaction to save the changes
COMMIT;

-- --Q5
-- -- In Terminal 2
SELECT * FROM actor;

-- --Q6
-- BEGIN;
-- -- Insert a new actor into the "actor" table
INSERT INTO actor (act_id,act_fname, act_lname, act_gender) VALUES (125,'John', 'Doe', 'M');
select * from actor;
-- -- ROLLBACK the transaction to save the changes
ROLLBACK;

-- -- In Terminal 2
SELECT * FROM actor;

--Q7 ERROR : Instead of act_gender written only gender
BEGIN;
INSERT INTO actor (act_id,act_fname,act_lname,act_gender) VALUES (126, 'John', 'Doe', 'M');
COMMIT;


--Section 2
--Q1 
ALTER TABLE movie_cast ADD PRIMARY KEY (mov_id,act_id);