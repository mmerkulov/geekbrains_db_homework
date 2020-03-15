/*
 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
 	Поля from, to и label содержат английские названия городов, поле name — русское.
 	Выведите список рейсов flights с русскими названиями городов.
 */

-- 1
insert into orders (user_id , created_at , updated_at )
values (1, now()-3, now()-3),
		(2, now(), now()),
		(2, now()-2, now()-2),
		(3, now()-1, now()-1),
		(3, now()-1, now()-1),
		(3, now()-1, now()-1),
		(4, now()-4, now()-4),
		(5, now()-1, now()-1);

select distinct u.name from orders o
	join users u on o.user_id = u.id;

-- 2
select
	p.name,
	c.name 
from products p
	inner join catalogs c
;

-- 3
select
	f.*,
	c1.name,
	c2.name
from flights f
	inner join cities c1 on f.from_ = c1.label
 	inner join cities c2 on f.to_ = c2.label;
 	
 	
create table flights (id int, from_ varchar(100), to_ varchar(100));
create table cities (label varchar(100), name varchar(100));

insert into cities (label, name)
values ('NSK', 'Новосибирск'),
		('UFA', 'Уфа'),
		('MSK', 'Москва'),
		('SPB', 'Сп-Б'),
		('KZN', 'Казань');
		
insert into flights (id, from_, to_)
values (1, 'NSK', 'MSK'),
		(2, 'NSK', 'SPB'),
		(3, 'KZN', 'MSK'),
		(4, 'KZN', 'UFA'),
		(5, 'NSK', 'UFA'),
		(6, 'MSK', 'NSK'),
		(7, 'MSK', 'UFA'),
		(8, 'KZN', 'SPB'),
		(9, 'SPB', 'UFA'),
		(10, 'UFA', 'SPB');
