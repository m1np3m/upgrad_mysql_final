USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows from INFORMATION_SCHEMA.tables
WHERE TABLE_SCHEMA = 'imdb';








-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count, 
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count, 
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
		SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages,
		SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count

FROM movie;







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
--fist part
SELECT
		YEAR(date_published) as Year,
	count(*) as number_of_movies
FROM
	movie
group by
	date_published;

-- second part
SELECT
		MONTH(date_published) as month_num,
	count(*) as number_of_movies
FROM
	movie
group by
	date_published;









/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT
		count(*) number_of_films
FROM
	movie
WHERE 
	country IN ('USA', 'India') AND 
	YEAR(date_published) = 2019









/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select
	count(DISTINCT genre)
from
	genre g ;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select
	genre
from
	genre g
group by
	genre
order by
	COUNT(movie_id) DESC
limit 1;









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with movies_1_genre as (
select
	count(DISTINCT movie_id)
from
	genre g
group by
	movie_id
having
	count(genre) = 1)
select
	count(*)
from
	movies_1_genre










/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	g.genre as genre,
	AVG(m.duration) as avg_duration
from
	genre g
join movie m on
	g.movie_id = m.id
GROUP by
	g.genre;









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_rankings AS(
SELECT
	genre,
	count(movie_id) AS movie_count,
	RANK() OVER(
ORDER BY
	count(movie_id) DESC) AS genre_rank
FROM
	genre
GROUP BY
	genre)
SELECT
	*
FROM
	genre_rankings
WHERE
	genre = 'Thriller'









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select MIN(avg_rating) as min_avg_rating, 
		MAX(avg_rating) as max_avg_rating, 
		MIN(total_votes) as min_total_votes,
		MAX(total_votes) as max_total_votes,
		MIN(median_rating) as min_median_rating,
		MAX(median_rating) as max_median_rating 
from ratings r 





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
with top_10_movies as (
SELECT
	m.title as title,
	AVG(r.avg_rating) as avg_rating
FROM
	ratings r
join movie m on
	r.movie_id = m.id
group by
	r.movie_id
order by
	r.avg_rating desc
limit 10)
select
	title,
	avg_rating,
	RANK() OVER(
	ORDER by avg_rating) as 'movie_rank'
from
	top_10_movies







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select
	median_rating,
	count(movie_id) as movie_count
FROM
	ratings r
group by
	median_rating
ORDER by count(movie_id) desc









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
with production_companies_having_most_hit as (
SELECT
	DISTINCT m.production_company as production_companies
from
	movie m
join ratings r on
	m.id = r.movie_id
where
	r.avg_rating > 8
GROUP by
	m.production_company),
movies_count_by_most_hit_companies as (
select
		m.production_company as production_company,
		count(m.id) as movie_count
from
		movie m
where
		m.production_company in (
	SELECT
			production_companies
	from
			production_companies_having_most_hit)
group by
		m.production_company )
select
	production_company,
	movie_count ,
	rank() over(
order by
	movie_count) as 'prod_company_rank'
from
	movies_count_by_most_hit_companies









-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, count(m.id) as movie_count
from movie m join ratings r on m.id = r.movie_id  join genre g on g.movie_id = m.id 
where 
 MONTH(m.date_published) = 3 AND 
 YEAR(m.date_published) = 2017 AND 
 m.country = 'USA' AND 
 r.total_votes > 1000
group by g.genre 







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select m.title ,r.avg_rating, g.genre
from movie m join ratings r on m.id = r.movie_id  join genre g on g.movie_id = m.id 
where 
 m.title like 'The%' AND 
 r.avg_rating > 8
order by r.avg_rating desc









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	count(movie_id) AS movies
FROM movie AS mo
	INNER JOIN ratings as ra ON mo.id = ra.movie_id
WHERE  ra.median_rating = 8
AND mo.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY ra.median_rating;






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
	country, 
	sum(total_votes) as total_votes
FROM movie AS mo
	INNER JOIN ratings as ra ON mo.id = ra.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
	SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top3_genre AS
(
	SELECT 
		ge.genre, 
		COUNT(ge.movie_id) AS movie_count
	FROM genre AS ge
		INNER JOIN ratings AS ra ON ge.movie_id = ra.movie_id
	WHERE ra.avg_rating > 8
    GROUP BY ge.genre
    ORDER BY movie_count
    LIMIT 3
),

top_director AS
(
SELECT 
	na.name AS director_name,
	COUNT(ge.movie_id) AS movie_count,
    ROW_NUMBER() OVER(ORDER BY COUNT(ge.movie_id) DESC) AS director_row_rank
FROM names AS na
	INNER JOIN director_mapping AS dm ON na.id = dm.name_id 
	INNER JOIN genre AS ge ON dm.movie_id = ge.movie_id 
	INNER JOIN ratings AS ra ON ra.movie_id = ge.movie_id,
WHERE ge.genre in (top3_genre.genre) AND avg_rating>8
GROUP BY director_name
ORDER BY movie_count DESC
)

SELECT *
FROM top_director
WHERE director_row_rank <= 3
LIMIT 3;








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT DISTINCT name AS actor_name, COUNT(ra.movie_id) AS movie_count
FROM ratings AS ra INNER JOIN role_mapping AS rm ON rm.movie_id = ra.movie_id
INNER JOIN names AS na ON rm.name_id = na.id
WHERE median_rating >= 8 AND category = 'actor'
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
	production_company, 
	SUM(ra.total_votes) AS vote_count,
	DENSE_RANK() OVER(ORDER BY sum(ra.total_votes)DESC) AS prod_comp_rank
FROM movie AS mo
INNER JOIN ratings AS ra ON mo.id= ra.movie_id
GROUP BY production_company
LIMIT 3;






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	name AS actor_name, total_votes,
    COUNT(mo.id) as movie_count,
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
    RANK() OVER(ORDER BY avg_rating DESC) AS actor_rank
FROM movie AS mo
	INNER JOIN ratings AS ra ON mo.id = ra.movie_id 
	INNER JOIN role_mapping AS rm ON mo.id=rm.movie_id 
	INNER JOIN names AS na ON rm.name_id=na.id
WHERE category='actor' AND country= 'india'
GROUP BY name
HAVING COUNT(mo.id)>=5
LIMIT 3;


 



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	name AS actress_name, ra.total_votes,
    COUNT(mo.id) AS movie_count,
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
    RANK() OVER(ORDER BY  ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank		
FROM movie AS mo
	INNER JOIN ratings AS ra ON mo.id = ra.movie_id 
	INNER JOIN role_mapping AS rm ON mo.id=rm.movie_id 
	INNER JOIN names AS na ON rm.name_id=na.id
WHERE rm.category='actress' AND mo.country LIKE '%India%' AND mo.languages LIKE '%Hindi%'
GROUP BY name
HAVING COUNT(mo.country='India')>=3
LIMIT 5;





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:



SELECT title,
		CASE WHEN avg_rating > 8 THEN 'Superhit movies'
			 WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
             WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
			 WHEN avg_rating < 5 THEN 'Flop movies'
		END AS avg_rating_category
FROM movie AS mo
	INNER JOIN genre AS ge ON mo.id=ge.movie_id
	INNER JOIN ratings as ra ON mo.id=ra.movie_id
WHERE genre='thriller';





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
	ROUND(AVG(duration),2) AS avg_duration,
    SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS mo
	INNER JOIN genre AS ge ON mo.id= ge.movie_id
GROUP BY genre
ORDER BY genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top3_genre AS
( 	
	SELECT 
		genre, 
		COUNT(movie_id) AS number_of_movies
    FROM movie AS mo
		INNER JOIN genre AS ge ON mo.id= ge.movie_id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top5 AS
(
	SELECT 
		genre,
		year,
		title AS movie_name,
		worlwide_gross_income,
		DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank        
	FROM movie AS mo
		INNER JOIN genre AS ge ON mo.id= ge.movie_id
	WHERE genre IN (SELECT genre FROM top3_genre)
)

SELECT *
FROM top5
WHERE movie_rank<=5;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
		COUNT(mo.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS mo
	INNER JOIN ratings AS ra ON mo.id=ra.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	name, 
	SUM(total_votes) AS total_votes,
	COUNT(rm.movie_id) AS movie_count,
	avg_rating,
	DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS actress_rank
FROM names AS na
	INNER JOIN role_mapping AS rm ON na.id = rm.name_id
	INNER JOIN ratings AS ra ON ra.movie_id = rm.movie_id
	INNER JOIN genre AS ge ON ra.movie_id = ge.movie_id
WHERE category = 'actress' AND avg_rating > 8 AND genre = 'drama'
GROUP BY name
LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH date_movie_info AS
(
SELECT 
		dm.name_id, 
		name, 
		dm.movie_id,
		mo.date_published, 
		LEAD(date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY date_published, dm.movie_id) AS next_movie_date
FROM director_mapping AS dm
	JOIN names AS na ON dm.name_id=na.id 
	JOIN movie AS mo ON dm.movie_id=mo.id
),

date_diff AS
(
	SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	FROM date_movie_info
 ),
SELECT 
	dm.name_id AS director_id,
	name AS director_name,
	COUNT(dm.movie_id) AS number_of_movies,
	Round(Avg(diff),2) AS avg_inter_movie_days,
	ROUND(AVG(avg_rating),2) AS avg_rating,
	SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
	MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration,
	ROW_NUMBER() OVER(ORDER BY COUNT(dm.movie_id) DESC) AS director_rank
FROM
	names AS na
    JOIN director_mapping AS dm ON na.id=dm.name_id
	JOIN ratings AS raON dm.movie_id=ra.movie_id
	JOIN movie AS mo ON mo.id=ra.movie_id
	JOIN date_diff AS dd ON dd.name_id=dm.name_id
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
 




