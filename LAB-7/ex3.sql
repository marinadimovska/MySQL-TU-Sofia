#2
drop procedure if exists sportsId;
delimiter //
create procedure sportsId(in sport_id int)
begin
select distinct sports.id, students.name, coaches.name
from sports
join sportgroups on sportgroups.sport_id = sports.id
join student_sport on sportgroups.sport_id = student_sport.sportgroup_id
join students on students.id = student_sport.student_id
join coaches on coaches.id = sportgroups.coach_id
where sports.id = sport_Id ;
end //
delimiter ;

call sportsId(1);
