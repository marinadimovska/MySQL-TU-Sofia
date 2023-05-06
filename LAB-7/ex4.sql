#3
delimiter //
drop procedure if exists avg_taxes;
create procedure avg_taxes(in student_name varchar(100), in year_tp int)
begin
select avg(tp.paymentAmount), s.name
from taxespayments as tp
join students as s on tp.student_id = s.id
where s.name = student_name and tp.year = year_tp
group by s.name;
end //
delimiter ;

call avg_taxes("Iliyan Ivanov", 2022);
