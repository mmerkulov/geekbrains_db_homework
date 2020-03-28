/*
1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
	Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

2. Создайте представление, которое выводит название name товарной позиции из таблицы products и
	соответствующее название каталога name из таблицы catalogs.
	
3. (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи
	за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос,
	который выводит полный список дат за август, выставляя в соседнем поле значение 1,
	если дата присутствует в исходном таблице и 0, если она отсутствует.
	
4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет
	устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
*/

-- 1, не хочу лезть в иные бд и вазиться с транзакциями в MySQL.
set autocommit=0;
start transaction;

drop table if exists hm9_dz1;
-- create table hm9_dz1 as
-- select * from shop.users where id = 1;
 
create table hm9_dz1 (id number);


insert into hm9_dz1 (id)
select id from shop.users u where u.id = 1;

commit;

drop table hm9_dz1;
set autocommit=1;

-- 2
create view prod_catalog as
select p.name as product, c.name as catalog 
from products p
	inner join catalogs c on p.catalog_id = c.id 
	
select * from prod_catalog;

-- 3
drop table if exists hm9_dz3;
create table hm9_dz3 (create_at date);

insert into hm9_dz3 (create_at) values  ('2018-08-01'), 
										('2016-08-04'),
										('2018-08-16'),
										('2018-08-17');
select * from hm9_dz3;
									
WITH RECURSIVE full_autumn (n) AS
(
  SELECT '2018-08-01'
  UNION ALL
  SELECT date_add(n, interval 1 day)
  FROM full_autumn WHERE n < '2018-08-31'
)
select *, case when q.col1 is not null and q.col2 is not null then 1 else 0 end
from (
		SELECT fa.n as col1, d.create_at as col2
		FROM full_autumn fa
			left join hm9_dz3 d on fa.n = d.create_at
		union all
		SELECT *
		FROM full_autumn fa
			right join hm9_dz3 d on fa.n = d.create_at
) Q
	;
drop table hm9_dz3;

-- 4

drop table if exists hm9_dz4;
create table hm9_dz4 (create_at date);
insert into hm9_dz4 (create_at) values ('2018-01-01'),
										('2018-01-02'),
										('2018-01-31'),
										('2018-01-21'),
										('2018-01-05'),
										('2018-01-09'),
										('2018-01-06'),
										('2018-01-11')

select * from hm9_dz4 tl;
order by t.create_at desc
limit 5 offset 0
;
delete from hm9_dz4 t
where t.create_at not in (select x.col1 from (select q.create_at as col1 from hm9_dz4 q
							order by q.create_at desc
							limit 5) x )
;

-- ПРОДОЛЖЕНИЕ ДОМАШКИ
/*
1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие
обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
При попытке присвоить полям NULL-значение необходимо отменить операцию.

3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
Вызов функции FIBONACCI(10) должен возвращать число 55.
*/

-- 1
create procedure hello()
BEGIN
	IF date_format(now(), '%H:%i:%s') between '06:00:00' and '11:59:59' then
		select 'Good morning';
 	elseif date_format(now(), '%H:%i:%s') between '12:00:00' and '17:59:59' then
 		select 'Good day';
 	elseif date_format(now(), '%H:%i:%s') between '18:00:00' and '17:59:59' then
 		select 'Good evenig';
	ELSE
		SELECT 'Good night';
	end if;
END
;
call hello();
drop procedure hello;

-- 2
create trigger hm9_part2_dz2 before insert on products
for each row
begin 
	if new.name is null and new.descriptions is null then 
		signal sqlstate = '45000'
		set message_text = 'Оба значения для ИМЕНИ и ОПИСАНИЯ пустые. Запрещено вставлять.'
	end if;
end;

-- 3
CREATE FUNCTION my_func(num INTEGER)
RETURNS INTEGER DETERMINISTIC
BEGIN
 	
	if num <= 0 then
 		return 0;
 	elseif num = 1 or num = 2 then
 		return 1;
 	else
		return my_func(num - 1) + my_func(num - 2);
	end if;
END
;

-- 4
CREATE FUNCTION my_func2(num INTEGER)
RETURNS INTEGER DETERMINISTIC
BEGIN
	declare q double;
	set q = sqrt(5);
	
	return (POW((1 + q)/2, num) - POW((1 - q)/2, num))/q;
END
;
drop function my_func2;
select my_func2(8);

