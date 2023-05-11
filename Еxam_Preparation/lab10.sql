#4
drop view if exists info;
create view info
as
select concat(customers.firstName, ' ', customers.middleName, ' ', customers.lastName) as full_name,
payments.dateOfPayment,plans.name as plan_name, plans.monthly_fee
from customers 
join payments on customers.customerID = payments.customer_id
join plans on plans.planID = payments.plan_id;

select * from info;

#7
#Създайте процедура, която при подадени имена на клиент извежда всички 
#данни за клиента, както и извършените плащания

drop procedure if exists customer_informaton;
delimiter /
create procedure customer_informaton(in client_name varchar(100))
begin
declare name_c varchar(100);
declare email varchar(100);
declare phone varchar(100);
declare address varchar(100);
declare sum_amount double;
declare month int;
declare year int;
declare planId int;
declare finished int default 0;

declare cur cursor for select
concat(c.firstName, ' ', c.middleName, ' ', c.lastName) as full_name,
c.email, c.phone, c.address, p.paymentAmount, p.month , p.year, p.plan_id
from customers as c join payments as p on
c.customerID = p.customer_id
where concat(c.firstName, ' ', c.middleName, ' ', c.lastName) = client_name ;

declare continue handler for not found set finished = 1;
set finished = 0;

open cur;

read_loop: while(finished = 0)
do 
fetch cur into name_c,email,phone, address,sum_amount, month,year,planId;
if(finished = 1) then
	   LEAVE read_loop;
       END IF;	
select name_c,email,phone, address,sum_amount, month,year,planId;
end while;
close cur;
SET finished = 0;
SELECT 'Finished!';
end /
delimiter ;

call customer_informaton('John Doe Smith');

#5
drop trigger if exists insert_to_plan;
delimiter /
create trigger insert_to_plan before insert on plans 
for each row
begin 
if  new.monthly_fee <= 10 then
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'The price for each plan must be over 10 lv';
else
update plans
set monthly_fee = new.monthly_fee;
end if;
end /
delimiter ;

insert into plans(name, monthly_fee)
values ('Insert1', 9),
('Insert2', 12);

#1
drop procedure if exists transfer_money;
delimiter /
create procedure transfer_money(in customerID INT, in sum double, out result bit)
begin
declare curAmount double;
start transaction;
select amount into curAmount from accounts
where customer_id = customerID;

if curAmount<sum then
set result = 0;
rollback;
else
update accounts
set amount = amount - sum
where customer_id = customerId;
            set result = 1;
			end if;
commit;
end /
delimiter ;

call transfer_money(1, 100, @res);
select @res;

select * from customers;
select * from accounts;

#2
/*Създайте процедура, която извършва плащания в системата за потребителите, 
депозирали суми. Ако някое плащане е неуспешно, трябва да се направи запис 
в таблица длъжници. Използвайте трансакция и курсор.*/

drop procedure if exists ex2;
delimiter ?
create procedure ex2(in customerID int, in plan_id int)
begin
declare fee double;
declare isThere bool default false;
declare curCustomer, curPlan int;
declare finished int;

declare cur cursor for select
customer_id, plan_id from debtors;

declare continue handler for not found set finished =1 ;
set finished = 0;

start transaction;
select monthly_fee into fee from plans where planId = plan_id;
if(select amount from accounts where customer_id = customerId)>= fee then
update accounts
set amount = amount - fee
where customer_id = customerId;
else
open cur;
get_info: loop
fetch cur into curCustomer, curPlan;
if(finished = 1) then leave get_info;
end if;
if curCustomer = customer_id and curPlan = plan_id then 
update debtors
set isThere = true;
                    update debtors
                    set debt_amount = debt_amount + fee
                    where currCus = customer_id and currPlan = plan_id;

end if;
                end loop get_info;
if isThere = false then 
                insert into debtors(customer_id, plan_id, debt_amount)
                values(customerId, plan_id, fee);
                end if;
			end if;
		commit;
end ?
delimiter ;

call ex2(1, 2);
call ex2(2, 1);
select * from customers;
select * from accounts;
select * from plans;
select * from debtors;

#3
SET GLOBAL event_scheduler = ON;

delimiter //
CREATE EVENT monthly_tax
ON SCHEDULE EVERY 1 MONTH
STARTS '2023-05-28 12:00:00'
DO
BEGIN
	CALL ex2(1,1);
END;
//
delimiter ;

#6
/*Създайте тригер, който при добавяне на сума в клиентска сметка проверява 
дали сумата, която трябва да бъде добавена не е по-малка от дължимата сума.
Ако е по-малка, то добавянето се прекратява, ако не, то се осъществява.
*/
drop trigger if exists ex6;
delimiter *
create trigger ex6 before insert on accounts
for each row
begin
declare debtAmount double;
select debt_amount into debtAmount from debtors
where customer_id = new.customer_id; #присвояваме

if(new.amount< debtAmount) then
signal sqlstate '45000' set message_text = 'The amount must be at least equal to the amount owed.';
end if;
end *
delimiter ;

insert into accounts (amount, customer_id)
values(10.50,1);




