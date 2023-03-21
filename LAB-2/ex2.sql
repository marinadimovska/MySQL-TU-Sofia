DROP DATABASE IF EXISTS lab2;
CREATE DATABASE lab2;
use lab2;

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
hire_date DATE NOT NULL,
employee_type VARCHAR(10),
salary DOUBLE
);

CREATE TABLE departments(
id INT PRIMARY KEY AUTO_INCREMENT,
department_name VARCHAR(10) NOT NULL,
manager_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (manager_id) REFERENCES employees(id)
);

CREATE TABLE projects(
id INT PRIMARY KEY AUTO_INCREMENT,
budget double,
department_id INT NOT NULL,
coordinator_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (department_id) REFERENCES departments(id),
CONSTRAINT FOREIGN KEY (coordinator_id) REFERENCES employees(id)
);

CREATE TABLE project_employees(
id INT PRIMARY KEY AUTO_INCREMENT,
project_id INT,
CONSTRAINT FOREIGN KEY (project_id) REFERENCES projects(id),
employee_id INT,
CONSTRAINT FOREIGN KEY (employee_id) REFERENCES employees(id),
hours_worked INT,
start_date DATE,
end_date date,
status VARCHAR(50)
);

INSERT INTO employees
VALUES 
('1', 'John', 'Smith', '2015-01-01', 'appointed', '5000'),
('2', 'Jane', 'Doe', '2016-05-15', 'appointed', '6000'),
('3', 'Bob', 'Johnson', '2018-02-28', 'executive', '4500'),
('4', 'Jack', 'Brown', '2014-12-15', 'appointed', '4800'),
('5', 'Sarah', 'Davis', '2019-07-01', 'executive', '4200');

INSERT INTO departments
VALUES
('1', 'Sales', '4'),
('2', 'Marketing', '3'),
('3', 'HR','2'),
('4', 'IT', '5'),
('5', 'Accounting', '1');

ALTER TABLE projects
ADD project_name VARCHAR(50);

INSERT INTO projects
VALUES 
('1', '750000', '4', '1', 'Website redesign'),
('2', '1200000', '1', '4', 'New product launch'),
('3', '500000', '3', '2', 'Employee engagement program'),
('4', '1000000', '4', '1', 'Cloud migration'),
('5', '300000', '5', '5', 'Financial audit');

SELECT *
FROM employees
ORDER BY hire_date
LIMIT 1;

SELECT *
FROM projects
WHERE budget >= 1000000;

SELECT DISTINCT department_id
FROM projects;

SELECT * FROM departments WHERE department_name LIKE 'A%';


SELECT  first_name, last_name, salary 
FROM employees  
ORDER BY salary DESC;

SELECT * FROM employees ORDER BY last_name, first_name ;





