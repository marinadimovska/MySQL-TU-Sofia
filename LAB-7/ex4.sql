#3
delimiter //
drop procedure if exists avg_taxes;
create procedure avg_taxes(in student_name varchar(100), in year_tp int, out avg_payment decimal(10,2))
begin
select avg(tp.paymentAmount) into avg_payment, students.name
from taxespayments as tp
join students as s on tp.students_id = students.id
where students.name = student_name and tp.year = year_tp;
end //
delimiter ;

call avg_taxes('Iliyan Ivanov', 2022);
