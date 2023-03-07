CREATE DATABASE school_sport_clubs;
USE school_sport_clubs;

CREATE TABLE students(
name VARCHAR(10) NOT NULL,
egn VARCHAR(10) NOT NULL UNIQUE,
id INT PRIMARY KEY AUTO_INCREMENT,
class VARCHAR(10) NULL DEFAULT NULL,
phone VARCHAR(10) NULL DEFAULT NULL,
adress VARCHAR(10) NOT NULL
);

CREATE TABLE sportsGroup(
id INT PRIMARY KEY AUTO_INCREMENT,
location VARCHAR(10) NOT NULL,
dayOfTheWeek ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'),
hourOfTraining TIME NOT NULL,
UNIQUE KEY(location,dayOfTheWeek,hourOfTraining)
);

CREATE TABLE studentSport(
student_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (student_id) REFERENCES students(id),
sportsGroup_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (sportsGroup_id) REFERENCES sportsGroups(id),
PRIMARY KEY(student_id,sportsGroup_id)
);

CREATE TABLE sports(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(10) NOT NULL
);

ALTER table sportsGroup
ADD CONSTRAINT FOREIGN KEY(sport_id) REFERENCES sports(id);

CREATE TABLE coaches(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(10) NOT NULL,
egn VARCHAR(10) NOT NULL UNIQUE
);

ALTER TABLE sportsGroup
ADD coach_id INT,
ADD CONSTRAINT FOREIGN KEY (coach_id) REFERENCES coaches(id);
