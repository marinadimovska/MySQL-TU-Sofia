DROP DATABASE IF EXISTS health_treatments;
CREATE DATABASE health_treatments;
USE health_treatments;

CREATE TABLE patient(
  egn VARCHAR(10) PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO patient(egn, name)
VALUES ('2215185463', "Dimitur Todorov"),
('4578962545', "Ivana Miladinova"),
('9807152537', "Doroteya Stpyanova");

CREATE TABLE treatment(
  id INT PRIMARY KEY AUTO_INCREMENT,
  price DECIMAL(6,2) NOT NULL
);

INSERT INTO treatment (price)
VALUES (3.7),
(14.2),
(52.6),
(70.2);

CREATE TABLE doctor(
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL
);

INSERT INTO doctor(name)
VALUES ("Ivan Ivanov"),
("Cvetelin Petrakiev"),
("David Georgiev");

CREATE TABLE procedures(
  room_no INT NOT NULL,
  time DATETIME NOT NULL,
  patient_egn VARCHAR(10) NOT NULL,
  FOREIGN KEY(patient_egn) REFERENCES patient(egn),
  treatment_id INT NOT NULL,
  FOREIGN KEY(treatment_id) REFERENCES treatment(id),
  doctor_id INT NOT NULL,
  FOREIGN KEY(doctor_id) REFERENCES doctor(id)
);

INSERT INTO procedures (room_no, time, patient_egn, treatment_id, doctor_id)
VALUES (5, '2022-05-17', '2215185463', 3, 2),
(4, '2023-03-01', '9807152537', 2, 1),
(3, '2023-01-30', '4578962545', 1, 1),
(3, '2023-02-24', '2215185463', 3, 1);

SELECT patient.name, doctor.id, procedures.room_no, procedures.time
FROM procedures join patient 
on procedures.patient_egn = patient.egn
join doctor 
on procedures.doctor_id = doctor.id
where procedures.treatment_id = 1 and doctor.name="Ivan Ivanov";

SELECT patient.name, SUM(treatment.price)
FROM procedures
JOIN patient ON patient.egn = procedures.patient_egn
JOIN treatment ON treatment.id = procedures.treatment_id
WHERE procedures.doctor_id = 1 AND procedures.room_no = 3
GROUP BY patient.egn;


