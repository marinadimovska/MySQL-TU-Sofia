#4
drop procedure if exists isNotNull;
delimiter //
create procedure isNotNull(in coach_name varchar(100))
begin
declare group_count int default 0;

select count(sportgroups.id) into group_count 
from sportgroups
join coaches on coaches.id = sportgroups.coach_id
where coaches.name = coach_name;

if group_count != 0
then select group_count ;
ELSE
select ('0');
end if;
end //
delimiter ;

call isNotNull('Ivan Todorov Petkov');
