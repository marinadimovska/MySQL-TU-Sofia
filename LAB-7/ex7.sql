use transaction_test;
drop procedure if exists ex6;

delimiter //
create procedure ex6(nameProvider varchar(100), nameRecipient varchar(100), in currencyType varchar(100),sumAmount double)
begin

select @check := amount from customer_accounts
join customers on customers.id = customer_accounts.customer_id
where customers.name = nameProvider;

update customer_accounts
set amount = case 
when amount - sumAmount >= 0 then amount - sumAmount
else amount
end
where customers.name = nameProvider and customer_accounts.currency = currencyType;

update customer_accounts
set amount = case 
when @check >= sumAmount then amount + sumAmount
else amount
end
where customers.name = nameRecipient;
select if(row_count() = 0, 'Some error occured. Possible not enough money.', 'Successsfull.') as Massage;

end //
delimiter ;

call ex6('Ivan Petrov Iordanov', 'Stoyan Pavlov Pavlov', 'BGN', 500);

select * from customers;
select * from customer_accounts;

