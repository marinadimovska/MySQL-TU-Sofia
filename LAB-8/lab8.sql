#1
drop view if exists coachInfo; 

create view coachInfo as select distinct 
c.name, sg.location, s.name as sport_name, 
year(cw.date), month(cw.date), c.month_salary from coaches as c

join sportgroups as sg on sg.coach_id = c.id
join sports as s on s.id = sg.sport_id
join coach_work as cw on cw.coach_id = c.id;

select * from coachInfo;

#2 
DROP PROCEDURE IF EXISTS studentWhoTrain;

DELIMITER //
CREATE PROCEDURE studentWhoTrain()
BEGIN 
    DECLARE finished INT;
    DECLARE studName VARCHAR(100);

    DECLARE studCur CURSOR FOR
    SELECT s.name 
    FROM students AS s 
    JOIN student_sport AS ss ON ss.student_id = s.id
    JOIN sports AS sp ON sp.id = ss.sportGroup_id
    GROUP BY s.id
    HAVING COUNT(DISTINCT ss.sportGroup_id) > 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET finished = 1;

    SET finished = 0;

    OPEN studCur;

    stud_loop: WHILE(finished = 0) DO
        FETCH studCur INTO studName;
        IF(finished = 1) THEN 
            LEAVE stud_loop;
        END IF;
        SELECT studName;
    END WHILE;
    CLOSE studCur;
    SET finished = 0;
    SELECT 'finished';
END //
DELIMITER ;

call studentWhoTrain();

#3  
#Напишете процедура, която извежда имената на всички треньори, които не тренират 
#групи.
drop procedure if exists coachesNames;
delimiter #
create procedure coachesNames()
begin
declare finished int;
declare coachName varchar(100);

declare coachCur cursor for
select c.name from coaches as c
join coach_work as cw on cw.coach_id = c.id
group by c.id
having count(cw.group_id) < 1;

declare continue handler for not found
set finished = 1;

set finished = 0;

open coachCur;

coach_loop : while(finished = 0)
do
fetch coachCur into coachName;
if(finished = 1) then
leave coach_loop;
end if;
select coachName;
end while;

close coachCur;
select('finished');
end #
delimiter ;

call coachesNames();

#4
DROP PROCEDURE IF EXISTS transfer_money;
DELIMITER #
CREATE PROCEDURE transfer_money(
  IN sum DECIMAL(10,2),
  IN fromId INT,
  IN cunv_from VARCHAR(4),
  IN cunv_to VARCHAR(4),
  IN toId INT
)
BEGIN
  IF(cunv_from = 'BGN') THEN
    UPDATE customer_accounts AS ca
    SET amount = amount - sum
    WHERE customer_id = fromId AND ca.currency = cunv_from;
  ELSE
    UPDATE customer_accounts AS ca
    SET amount = amount - sum / 1.95583
    WHERE customer_id = fromId AND ca.currency = cunv_from;
  END IF;

  IF(cunv_to = 'BGN') THEN
    UPDATE customer_accounts AS ca
    SET amount = amount + sum
    WHERE customer_id = toId AND ca.currency = cunv_to;
  ELSE
    UPDATE customer_accounts AS ca
    SET amount = amount + sum * 1.95583
    WHERE customer_id = toId AND ca.currency = cunv_to;
  END IF;
END #
DELIMITER ;

call transfer_money(10, 1, 'BGN','EUR', 2);
select * from customer_accounts;

#5
drop procedure if exists opt_transfer_money;
delimiter ?
create procedure opt_transfer_money(in fromId int, in toId int, in sum decimal(10,2))
begin
DECLARE from_currency VARCHAR(4);
DECLARE to_currency VARCHAR(4);

SELECT currency INTO from_currency FROM customer_accounts;
SELECT currency INTO to_currency FROM customer_accounts ;

IF from_currency = to_currency THEN
    CALL transfer_money(amount, from_account_id, from_currency, to_currency, to_account_id);
  ELSEIF (from_currency = 'BGN' AND to_currency = 'EUR') OR (from_currency = 'EUR' AND to_currency = 'BGN') THEN
    CALL transfer_money(amount, from_account_id, from_currency, to_currency, to_account_id);
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid currency conversion';
  END IF;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed: Insufficient funds or invalid account id';
  END IF;

end ?
delimiter ;

call opt_transfer_money(1, 2, 10);
select * from customer_accounts;






