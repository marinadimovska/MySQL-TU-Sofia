CREATE DATABASE movies1;
USE movies1;

CREATE TABLE producers (
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
bulstatt VARCHAR(9) NOT NULL UNIQUE,
address VARCHAR(50) NOT NULL,
name VARCHAR(20) NOT NULL);

INSERT INTO producers (bulstatt, address, name)
VALUES ('123456789', "Studentski grad, Sofia", "John Smith"),
('987654321', "First street, Veliko Tyrnovo", "Sam Donovan");

CREATE TABLE studios (
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
bulstatt VARCHAR(9) NOT NULL UNIQUE,
address VARCHAR(50) NOT NULL);

INSERT INTO studios (bulstatt, address)
VALUES ('425136789', "Plovdiv"),
('471528693', "Varna");

CREATE TABLE actors(
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
sex ENUM ('M', 'F', 'Other') NOT NULL,
address VARCHAR(50) NOT NULL,
name VARCHAR(20) NOT NULL,
birthday DATE NULL DEFAULT NULL);

INSERT INTO actors (sex, address, name, birthday)
VALUES ('M', "Sofia", "Stoyan Ivanov", '1969-04-01'),
('F', "Vratsa", "Militsa Dimitrova", '1994-08-15'),
('Other', "Burgas", "Nedelin Petrov", '1985-05-25');

CREATE TABLE movies (
id INT PRIMARY KEY AUTO_INCREMENT,
length TIME NOT NULL,
title VARCHAR (60) NOT NULL,
year YEAR NOT NULL,
budget DOUBLE NOT NULL,
studio_id INT NOT NULL,
producer_id INT NOT NULL,
FOREIGN KEY (studio_id) REFERENCES studios(id),
FOREIGN KEY (producer_id) REFERENCES producers(id));

INSERT INTO movies (length, title, year, budget, studio_id, producer_id)
VALUES ('02:15:10', "The day after tomorrow", '1995', 2.7, 1, 2),
('02:05:10', "The hunger games", '1999', 3.7, 2, 1),
('01:10:10', "Tryptich", '2022', 7.2, 1, 2);

INSERT INTO movies (length, title, year, budget, studio_id, producer_id)
VALUES ('02:05:10', "Titanic", '1992', 4.8, 2, 1),
('02:05:10', "Lover", '1993', 6.3, 2, 1);

CREATE TABLE actor_movie(
actor_id INT REFERENCES actors(id),
movie_id INT REFERENCES movies(id),
PRIMARY KEY(actor_id, movie_id));

INSERT INTO actor_movie(actor_id, movie_id)
VALUES (1, 1),
(3,2),
(1,3);

SELECT actors.name
FROM actors
where actors.sex = "M" or actors.address = "Sofia";

select movies.title, movies.budget
from movies
where movies.year BETWEEN 1990 and 2000
order by budget desc
limit 3;

select actors.name, movies.title
from movies
join actor_movie on movies.id = actor_movie.movie_id
join actors on actors.id = actor_movie.actor_id
join producers on producers.id = movies.producer_id
where producers.name ='John Smith';

select actors.name, avg(movies.length) as average_length
from actors join actor_movie
on actors.id = actor_movie.actor_id
join movies on movies.id = actor_movie.movie_id
where movies.length > (SELECT AVG(length) FROM movies WHERE year < 2000)
GROUP BY actors.name;




