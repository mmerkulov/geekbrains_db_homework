/*
1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs
	помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей
*/


-- 1
drop table sys_logs;
create table sys_logs
(
	slog_id SERIAL,
	navi_date date,
	table_name varchar(100),
	slog_text varchar(3999)
) engine=archive;

select * from sys_logs;
select * from users;

drop trigger hm11_dz1_t_users;
create trigger hm11_dz1_t_users after insert on users
for each row
begin
	insert into sys_logs(navi_date, table_name, slog_text)
-- 	навернякак как-то можно достать имя таблицы.
	values(now(), 'shop.users', CONCAT('id=', new.id, '; name=',new.name));
--  аналогично создаются и другие триггеры на таблицу products, catalogs
end;

insert into users(name, birthday_at , created_at , updated_at )
values ('Юра', '1993-03-18', now(), now());

select * from sys_logs;

delete from users 
where users.name = 'Юра';


-- 2
select @@cte_max_recursion_depth;
set @@cte_max_recursion_depth = 1000000000;

drop table temp_users;
create table temp_users (id integer);

insert into temp_users (id)
WITH RECURSIVE temp AS
(
  SELECT 1 as n
  UNION ALL
  SELECT n + 1
  FROM temp WHERE n < 1000000
)
select temp.n from temp;
select count(*) from temp_users;

set @@cte_max_recursion_depth = 1000;
