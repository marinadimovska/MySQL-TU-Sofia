DROP DATABASE IF EXISTS household_shopping;
CREATE DATABASE household_shopping;

USE household_shopping;
#1
CREATE TABLE households (
    household_id INT PRIMARY KEY AUTO_INCREMENT,
    household_name VARCHAR(50) NOT NULL,
    household_address VARCHAR(255),
	household_city VARCHAR(255),
    household_country VARCHAR(255)
);
INSERT INTO households (household_name, household_address, household_city, household_country)
VALUES 
('Smith Household', '123 Main St', 'Anytown', 'USA'),
('Johnson Household', '456 Oak Ave', 'Smallville', 'USA'),
('Garcia Household', '789 Elm St', 'Big City', 'USA');
#2
CREATE TABLE family_members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    age INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    household_id INT NOT NULL,
    FOREIGN KEY (household_id) REFERENCES households(household_id)
);
INSERT INTO family_members (member_name,gender,age,status,household_id)
VALUES 
('John Smith', 'Male', 35, 'Software Engineer', 1),
('Jane Smith', 'Female', 30, 'Marketing Specialist', 1),
('Tom Johnson', 'Male', 40, 'Teacher', 2),
('Lisa Garcia', 'Female', 45, 'Doctor', 3);
#3
CREATE TABLE units (
    unit_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_name VARCHAR(50) NOT NULL
);
INSERT INTO units (unit_name)
VALUES 
('Each'),
('Pound'),
('Ounce'),
('Liter'),
('Gallon'),
('Package'),
('Box');
#4
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_name VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_id INT NOT NULL,
    family_member VARCHAR(50) NOT NULL,
    status ENUM('purchased', 'not purchased') NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);
INSERT INTO purchases (purchase_name,date,quantity,unit_id,family_member,status,unit_price,total_price)
VALUES 
  ('Milk', '2023-05-02', 1, 4, 'John Smith' , 'purchased', 1.20, 1.20),
  ('Bread', '2023-05-02', 2, 1,  'John Smith' , 'not purchased', 0.80, 1.60),
  ('Eggs', '2023-05-02', 12, 1,  'Jane Smith', 'purchased', 0.15, 1.80),
  ('Chicken', '2023-05-03', 1.5, 2,  'Tom Johnson', 'not purchased', 7.50, 11.25),
  ('Tomatoes', '2023-05-03', 0.5, 2,  'Lisa Garcia', 'not purchased', 2.00, 1.00),
  ('Cheese', '2023-05-04', 0.3, 2,  'John Smith', 'not purchased', 4.50, 1.35),
  ('Juice', '2023-05-02', 1, 4, 'Lisa Garcia' , 'purchased', 1.20, 1.20),
  ('Chocolate', '2023-05-02', 2, 1,'Tom Johnson' , 'not purchased', 0.80, 1.60);
#5
CREATE TABLE households_purchases (
    id INT PRIMARY KEY AUTO_INCREMENT,
    household_id INT NOT NULL,
    purchase_id INT NOT NULL,
    FOREIGN KEY (household_id) REFERENCES households(household_id),
    FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id)
);
INSERT INTO households_purchases ( household_id, purchase_id)
VALUES 
(1, 1),
(1, 2),
(1,3),
(2, 4),
(3, 5), 
(1, 6), 
(3, 7), 
(2, 8);
#6
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);
INSERT INTO categories (category_name)
VALUES 
('Groceries'),
('Household Items'),
('Clothing');
#7
CREATE TABLE items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    unit_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);
INSERT INTO items (item_name,category_id,unit_id,price)
VALUES 
  ('Milk', 1, 4,  1.20),
  ('Bread', 1, 1, 0.80),
  ('Eggs', 1, 1, 0.15),
  ('Chicken', 1, 2,7.50),
  ('Tomatoes', 1, 2, 2.00),
  ('Cheese', 1, 2, 4.50),
  ('Juice', 1, 4,  1.20),
  ('Chocolate',1, 1, 0.80),
  ('Microwave', 2, 1, 20),
  ('Coffee machine', 2, 1,  50),
  ('Sport Outfit',3, 1, 30);

#8
CREATE TABLE purchase_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_id INT NOT NULL,
    item_id INT NOT NULL,
    FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);
INSERT INTO purchase_items ( purchase_id, item_id)
VALUES 
(1, 1),
(2, 2),
(3,3),
(4, 4),
(5, 5), 
(6, 6), 
(7, 7), 
(8, 8);

#2т. Напишете заявка, в която демонстрирате SELECT с ограничаващо условие по избор.
SELECT * FROM purchases
WHERE status = 'not purchased';

#3т. Напишете заявка, в която използвате агрегатна функция и GROUP BY по ваш избор.
SELECT family_member, ROUND(SUM(unit_price * quantity), 2) AS total_spent
FROM purchases
GROUP BY family_member 
ORDER BY total_spent;

#4т. Напишете заявка, в която демонстрирате INNER JOIN по ваш избор.
SELECT fm.member_name, SUM(p.total_price)
FROM family_members fm
INNER JOIN households h ON fm.household_id = h.household_id
INNER JOIN households_purchases hp on hp.household_id = h.household_id
INNER JOIN purchases p ON p.purchase_id = hp.purchase_id
WHERE fm.age > 18
GROUP BY fm.member_name;

#5т. Напишете заявка, в която демонстрирате OUTER JOIN по ваш избор.
SELECT h.household_name, SUM(p.total_price) AS total_spending
FROM households h
LEFT OUTER JOIN households_purchases hp ON h.household_id = hp.household_id
LEFT OUTER JOIN purchases p ON p.purchase_id = hp.purchase_id
GROUP BY h.household_id;

#6т. Напишете заявка, в която демонстрирате вложен SELECT по ваш избор.
SELECT *
FROM family_members
WHERE household_id IN (
  SELECT household_id
  FROM households
  WHERE household_address = '123 Main St'
);

#7т. Напишете заявка, в която демонстрирате едновременно JOIN и агрегатна функция.
SELECT h.household_name, COUNT(fm.member_id) as num_members
FROM households h
INNER JOIN family_members fm ON h.household_id = fm.household_id
GROUP BY h.household_id;

#8т. Създайте тригер по ваш избор.
ALTER TABLE purchases ADD created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

DELIMITER #
drop trigger if exists `orders_created_at_trigger`;
CREATE TRIGGER `orders_created_at_trigger` BEFORE INSERT ON purchases FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END;
# DELIMITER ;

INSERT INTO purchases (purchase_name,date,quantity,unit_id,family_member,status,unit_price,total_price)
 VALUES ('Test product', '2023-05-02', 1, 1, 'Test person', 'not purchased', 10.99, 10.99);

SELECT * FROM purchases WHERE purchase_name = 'Test product';

#8.1
SET @OLD_SQL_MODE=@@SQL_MODE;
SET SQL_MODE='ALLOW_INVALID_DATES';
delimiter \\
drop trigger if exists before_insert_purchase;
create trigger before_insert_purchase
before insert
on purchases for each row
begin
	set @error_mess = "Product's expiration date has passed!";
	if new.date < current_timestamp() 
    then signal sqlstate '45000' set message_text = @error_mess;
    end if;
end \\
delimiter ;
SET SQL_MODE=@OLD_SQL_MODE;

INSERT INTO purchases (purchase_name,date,quantity,unit_id,family_member,status,unit_price,total_price) 
VALUES('Product B', '2019-07-08', 1, 4, 'John Smith' , 'purchased', 1.20, 1.20);

SELECT * FROM purchases;

#8.2
CREATE TABLE purchases_log (
  id INT NOT NULL AUTO_INCREMENT,
  purchase_name VARCHAR(100) NOT NULL,
  date DATE NOT NULL,
  quantity INT NOT NULL,
  unit_id INT NOT NULL,
  family_member VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  action VARCHAR(10) NOT NULL,
  PRIMARY KEY (id)
);

DELIMITER $$
CREATE TRIGGER purchases_log_trigger
AFTER INSERT ON purchases
FOR EACH ROW
BEGIN
  INSERT INTO purchases_log
  SET 
    purchase_name = NEW.purchase_name,
    date = NEW.date,
    quantity = NEW.quantity,
    unit_id = NEW.unit_id,
    family_member = NEW.family_member,
    status = NEW.status,
    unit_price = NEW.unit_price,
    total_price = NEW.total_price,
    action = 'INSERT';
END$$
DELIMITER ;

INSERT INTO purchases (purchase_name, date, quantity, unit_id, family_member, status, unit_price, total_price)
VALUES ('Product C', '2023-05-03', 2, 2, 'Anna Smith', 'purchased', 1.50, 3.00);

SELECT * FROM purchases;
SELECT * FROM purchases_log;

#9 - Създайте процедура, в която демонстрирате използване на курсор.
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

DROP PROCEDURE IF EXISTS list_of_names;

DELIMITER //

CREATE PROCEDURE list_of_names(INOUT list_names VARCHAR(4000))
BEGIN
    DECLARE finish INT DEFAULT 0;
    DECLARE name VARCHAR(50);

    DECLARE currName CURSOR FOR SELECT member_name FROM family_members;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finish = 1;

    OPEN currName;

    getName: LOOP
        FETCH currName INTO name;
        IF finish = 1 THEN
            LEAVE getName;
        END IF;
        SET list_names = CONCAT(name, ';', list_names);
    END LOOP getName;

    CLOSE currName;
END //

DELIMITER ;

SET @list_n = '';
CALL list_of_names(@list_n);
SELECT @list_n;

SET SQL_MODE=@OLD_SQL_MODE;


