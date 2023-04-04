create database if not exists transaction_test;
use transaction_test;

drop table if exists customer_accounts;

drop table if exists customers;
create table customers(
id int auto_increment primary key,
name varchar(255) not null,
address varchar(255)
);



create table if not exists customer_accounts(
id int  auto_increment primary key,
amount double not null,
currency varchar(10),
customer_id int not null,
constraint foreign key  (customer_id) references customers(id) on delete restrict on update cascade
);

INSERT INTO `transaction_test`.`customers` (`name`, `address`) VALUES ('Ivan Petrov Iordanov', 'Sofia, Krasno selo 1000');
INSERT INTO `transaction_test`.`customers` (`name`, `address`) VALUES ('Stoyan Pavlov Pavlov', 'Sofia, Liuylin 7, bl. 34');
INSERT INTO `transaction_test`.`customers` (`name`, `address`) VALUES ('Iliya Mladenov Mladenov', 'Sofia, Nadezhda 2, bl 33');

INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('5000', 'BGN', '1');
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('10850', 'EUR', '1');
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('1450000', 'BGN', '2');
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('17850', 'EUR', '2');

begin;
use transaction_test;
UPDATE customer_accounts 
SET amount = amount - 50 WHERE id = 1;

UPDATE customer_accounts
SET amount = amount + 50 
WHERE id = 2;
commit;
