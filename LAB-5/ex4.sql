CREATE DATABASE usersystem;
USE usersystem;

CREATE TABLE users(
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO users(name)
VALUES ("Petar"), ("Ivan"), ("Maria"), ("Philip");

CREATE TABLE articles(
  id INT AUTO_INCREMENT  PRIMARY KEY,
  title VARCHAR(160) NOT NULL,
  contents TEXT NOT NULL,
  author_id INT NOT NULL,
  published_on DATE NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id),
  moderator_id INT NULL DEFAULT NULL,
  FOREIGN KEY (moderator_id) REFERENCES users(id)
);

INSERT INTO articles(title, contents, published_on, author_id, moderator_id)
VALUES ("Article 1", "Content of article 1...", "2012-03-12", 2, NULL),
       ("Article 2", "Content of article 2...", "2012-03-28", 3, NULL),
       ("Article 3", "Content of article 3...", "2012-04-04", 3, NULL),
       ("Article 4", "Content of article 4...", "2012-02-27", 2, NULL),
       ("Article 5", "Content of article 5...", "2012-03-28", 3, 1),
       ("Article 6", "Content of article 6...", "2012-04-04", 3, 2),
       ("Article 7", "Content of article 7...", "2012-02-27", 2, 1),
       ("Article 8", "Content of article 8...", "2012-02-27", 1, 2),
       ("Article 9", "Content of article 9...", "2012-02-27", 1, NULL);

SELECT title, contents, published_on
FROM articles
WHERE moderator_id IS NULL
      AND author_id = ( SELECT id
                        FROM users
                        WHERE name = "Ivan"
                      );

SELECT users.id as user_id, users.name as user_name,
count(articles.id) AS moderatedcount
from users join articles
on users.id = articles.author_id
WHERE articles.moderator_id IS NOT NULL
GROUP BY users.id;

SELECT users.id AS user_id, users.name as user_name,
COUNT(articles.id) AS unmoderatedcount
FROM users JOIN articles ON users.id = articles.author_id
WHERE articles.moderator_id IS NULL
GROUP BY users.id;

