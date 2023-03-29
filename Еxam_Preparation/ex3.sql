drop database if exists expedition;
create DATABASE expedition;
use expedition;

create table alpinist(
id int primary key AUTO_INCREMENT,
first_name varchar(50) not null,
last_name varchar(50) not null,
speciality varchar(50) not null
);

insert into alpinist(first_name, last_name, speciality)
VALUES("Marina", "Dimovska", "Geology"),
("Boyan", "Petrova", "Climber"),
("Hristo", "Kazakov", "Geology"),
("Mihaela", "Petrova", "Climber");

create table country(
code int primary key UNIQUE,
name varchar(50) not null,
population BIGINT not null,
countinent ENUM('Asia',' Africa', 'North America', 'South America', 'Antarctica', 'Europe', 'Australia'),
surface_area int not null
);

insert into country(code, name, population,countinent, surface_area)
VALUES(1250,'Nepal',1454472 ,'Asia', 960000),
(1860,'Bulgaria',65667239 ,'Europe', 111000),
(1260,'Greece',65667239 ,'Europe', 11000),
(1870,'France',65667239 ,'Europe', 11800)
;

create table mountain(
id int primary key AUTO_INCREMENT,
name varchar(50) not null
);

insert into mountain(name)
VALUES('Himalay'),
('Rila'),
('Smolika'),
('MonBlan');

CREATE TABLE located(
		country_id INT NOT NULL,
        mountain_id INT NOT NULL,
		FOREIGN KEY (country_id ) REFERENCES country(code),
        FOREIGN KEY (mountain_id) REFERENCES mountain(id),
        PRIMARY KEY (country_id,mountain_id)
        );

insert into located(country_id ,mountain_id)
VALUES(1250,1),
(1860,2),
(1260,3),
(1870,4);

create table peak(
id int AUTO_INCREMENT PRIMARY key,
name VARCHAR(50) not null,
elevation int not null,
mountain_id int not null,
FOREIGN KEY(mountain_id) REFERENCES mountain(id)
);

INSERT INTO peak(name,elevation,mountain_id)
VALUES('Everest',8849,1),
('Musala',2925,2),
('Ilias',2300,3),
('MonBlan',3000,4)
;

CREATE TABLE expedition(
		id INT AUTO_INCREMENT PRIMARY KEY,
        organizer VARCHAR(100) NOT NULL,
        begin_date DATE NOT NULL,
        end_date DATE NOT NULL,
        route VARCHAR(255),
        peak_id INT NOT NULL,
        FOREIGN KEY (peak_id) REFERENCES peak(id)
		);
INSERT INTO expedition(organizer,begin_date,end_date ,route ,peak_id)
	VALUES('Mon Blan','2012-04-12','2012-03-16','Mon Blan',4),
          ('Himalayas','2012-03-12','2012-03-16','Himalayas',1),
		('Bulgaria','2012-02-12','2012-02-16','Bulgaria',2),
        ('Greece','2012-05-12','2012-05-16','Greece',3);

create TABLE Participate(
		Leader_of_Expedition INT NOT NULL,
        expedition_id INT NOT NULL,
        FOREIGN KEY (Leader_of_Expedition) REFERENCES alpinist(id),
        FOREIGN KEY (expedition_id) REFERENCES expedition(id),
        PRIMARY KEY(Leader_of_Expedition,expedition_id)
        );
INSERT INTO Participate(Leader_of_Expedition,expedition_id)
VALUES(2,1),(3,2),(1,2),(4,2);
#1
select alpinist.first_name, alpinist.last_name, alpinist.speciality, mountain.name as mountain_name
from alpinist
join participate on participate.Leader_of_Expedition = alpinist.id
join expedition on expedition.id = participate.expedition_id
join peak on expedition.peak_id = peak.id
join mountain on mountain.id = peak.mountain_id
where alpinist.speciality = 'Geology' and mountain.name = 'Himalay';
#2
select alpinist.last_name, expedition.route
from alpinist
join participate on participate.Leader_of_Expedition = alpinist.id
join expedition on expedition.id = participate.expedition_id
where alpinist.last_name = 'Kazakov' and expedition.route = 'Himalayas';
