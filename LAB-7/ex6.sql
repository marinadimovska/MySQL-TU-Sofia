#5
use transaction_test;
drop procedure if exists ex5;

delimiter //
create procedure ex5(idProvider int, idRecipient int, sumAmount double)
begin

select @check := amount from customer_accounts
where id = idProvider;

update customer_accounts
set amount = case 
when amount - sumAmount >= 0 then amount - sumAmount
else amount
end
where id = idProvider;

update customer_accounts
set amount = case 
when @check >= sumAmount then amount + sumAmount
else amount
end
where id = idRecipient;
select if(row_count() = 0, 'Some error occured. Possible not enough money.', 'Successsfull.') as Massage;

end //
delimiter ;

call ex5(1, 3, 500);

select * from customers;
select * from customer_accounts;
