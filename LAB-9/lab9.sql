#4
drop view if exists countSportgroups;

create view countSportgroups
as select s.name, count(ss.sportGroup_id) as count
from students as s
join student_sport as ss on s.id = ss.student_id
group by s.id;

select * from countSportgroups;

#1 
drop table if exists salarypayments_log;
create table salarypayments_log(
id int auto_increment primary key,
operation ENUM('INSERT','UPDATE','DELETE') not null,
coach_id int,
month int,
year int,
salaryAmount decimal,
dateOfPayment datetime,
dateOfLog datetime
)Engine = Innodb;

drop trigger if exists deleteFromSP;
delimiter /
create trigger deleteFromSP 
before delete on salarypayments
for each row
begin
insert into salarypayments_log(operation, coach_id , month, year , salaryAmount, dateOfPayment,
dateOfLog )
values('DELETE', old.coach_id, old.month, old.year, old.salaryAmount, old.dateOfPayment, now());
end /
delimiter ;

delete from `salarypayments` WHERE `id`=1;
select * from salarypayments;


#2
#Изтрийте цялата информация от таблицата salarypayments и напишете 
#заявка, с която я възстановявате от таблицата salarypayments_log

drop trigger if exists delete_from_salaryp;
delimiter ?
create trigger  delete_from_salaryp before delete
on salarypayments FOR EACH ROW
begin
insert into salarypayments_log(operation, coach_id , month, year , salaryAmount, dateOfPayment,
dateOfLog )
values('DELETE', old.coach_id, old.month, old.year, old.salaryAmount, old.dateOfPayment, now());
end ?
delimiter ;

DELETE FROM salarypayments WHERE id > 0;
select * from salarypayments_log;

#3
#Съгласно въведено ограничение всеки ученик може да тренира в не 
drop trigger if exists check_count_sportgroups;
delimiter *
create trigger check_count_sportgroups
before insert on student_sport for each row
begin
declare group_count int ;
select count(sportGroup_id) from student_sport
where student_id = new.student_id;

if group_count >= 2 then
SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error.';
    END IF;
end *
delimiter ;

INSERT INTO student_sport (student_id, sportGroup_id)
VALUES (1, 2);


#5
drop procedure if exists sport_info;
delimiter !
create procedure sport_info(in sport_name varchar(100))
begin
select distinct c.name, sg.location, sg.dayOfWeek,sg.hourOfTraining
from sportgroups as sg
join coaches as c on c.id = sg.coach_id
join sports as s on s.id = sg.sport_id
where s.name = sport_name;
end !
delimiter ;

call sport_info('Football');
