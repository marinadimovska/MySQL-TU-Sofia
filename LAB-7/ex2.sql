#1
delimiter //
drop procedure if exists coach_training;
create procedure coach_training(IN coachname varchar(100))
begin
select sports.name, sportgroups.location, sportgroups.dayOfWeek, sportgroups.houroftraining, students.name, students.phone
from sports
join sportgroups on sportgroups.sport_id = sports.id
join student_sport on sportgroups.sport_id = student_sport.sportgroup_id
join students on students.id = student_sport.student_id;
join coaches on coaches.id = sportgroups.coach_id
where coaches.name = coachname ;
end //
delimiter ;
