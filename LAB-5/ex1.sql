DROP DATABASE IF EXISTS cinema;
CREATE database cinema;
use cinema;

CREATE TABLE cinemas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE halls (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cinema_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  status ENUM('VIP', 'Deluxe', 'Standard') NOT NULL,
  FOREIGN KEY (cinema_id) REFERENCES cinemas(id)
);

CREATE TABLE films (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  year INT NOT NULL,
  country VARCHAR(50) NOT NULL
);

CREATE TABLE projections (
  id INT PRIMARY KEY AUTO_INCREMENT,
  hall_id INT NOT NULL,
  film_id INT NOT NULL,
  time DATETIME NOT NULL,
  audience INT NOT NULL,
  FOREIGN KEY (hall_id) REFERENCES halls(id),
  FOREIGN KEY (film_id) REFERENCES films(id)
);


INSERT INTO cinemas (name)
VALUES ('Arena Mladost'), ('Cinema City Sofia'), ('CineGrand Sofia');

INSERT INTO halls (cinema_id, name, status)
VALUES
  (1, 'VIP Hall 1', 'VIP'),
  (1, 'Standard Hall 2', 'Standard'),
  (2, 'VIP Hall', 'VIP'),
  (2, 'Deluxe Hall 1', 'Deluxe'),
  (2, 'Standard Hall', 'Standard'),
  (3, 'VIP Hall', 'VIP'),
  (3, 'Deluxe Hall', 'Deluxe'),
  (3, 'Standard Hall 1', 'Standard'),
  (3, 'Standard Hall 2', 'Standard');

INSERT INTO films (name, year, country)
VALUES
  ('Final Destination 7', 2022, 'USA'),
  ('Spider-Man: No Way Home', 2021, 'USA'),
  ('Dune', 2021, 'USA');

INSERT INTO projections (hall_id, film_id, time, audience)
VALUES
  (1, 1, '2023-03-23 19:00:00', 50),
  (1, 2, '2023-03-23 21:30:00', 70),
  (2, 1, '2023-03-23 20:00:00', 60),
  (2, 2, '2023-03-23 22:30:00', 80),
  (3, 1, '2023-03-23 19:30:00', 100),
  (3, 2, '2023-03-23 22:00:00', 120);



#1. 
SELECT c.name AS cinema_name, h.name AS hall_name, p.time
FROM cinemas c
INNER JOIN halls h ON h.cinema_id = c.id
INNER JOIN projections p ON p.hall_id = h.id
INNER JOIN films f ON f.id = p.film_id
WHERE f.name = 'Final Destination 7' AND h.status IN ('VIP', 'Deluxe')
ORDER BY c.name, h.name;


#2.
SELECT SUM(p.audience) AS total_audience
FROM cinemas c
INNER JOIN halls h ON h.cinema_id = c.id
INNER JOIN projections p ON p.hall_id = h.id
INNER JOIN films f ON f.id = p.film_id
WHERE c.name = 'Arena Mladost' AND h.status = 'VIP' AND f.name = 'Final Destination 7';
