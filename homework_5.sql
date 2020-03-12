/*
 * Домашнее задание по видеоуроку №5.
 * 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
 * 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое
 * 	время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME,
 * 	сохранив введеные ранее значения.
 * 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 * 	0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
 * 	чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
 * 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
 * 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
 * 
 */

-- 1
/*
update users u
set u.created_at = now(),
	u.updated_at = now()
--commit;
*/

-- 2
select
	STR_TO_DATE(date_format(u.created_at, '%d.%m.%Y %H:%i:%s'), '%d-%m-%Y %H:%i:%s'),
	cast(date_format(u.updated_at, '%d.%m.%Y %H:%i:%s') as DATETIME),
	date_format(u.created_at, '%d.%m.%Y %H:%i:%s'),
	date_format(u.updated_at, '%d.%m.%Y %H:%i:%s'),
	u.created_at, u.updated_at
from users u ;

-- 3
select * from storehouses_products; -- Таблица пустая

-- сделал свою
drop table if exists temp1
create table temp1 (value int);
insert into temp1 values(0),(2500), (0), (30), (50), (1)

select q.value from
(
select t.value, 1 as i from temp1 t
where t.value != 0
union all
select t.value, 0 from temp1 t
where t.value = 0
) Q
order by Q.i desc, Q.value
;

-- New solution
SELECT * FROM temp1 ORDER BY IF (value > 0, 0, 1), value;
drop table if exists temp1;

-- 4
select
	u.*	
from users u
where case
		when month(u.birthday_at) = 1 then 'January'
		when month(u.birthday_at) = 2 then 'February'
		when month(u.birthday_at) = 3 then 'March'
		when month(u.birthday_at) = 4 then 'April'
		when month(u.birthday_at) = 5 then 'May'
		when month(u.birthday_at) = 6 then 'June'
		when month(u.birthday_at) = 7 then 'July'
		when month(u.birthday_at) = 8 then 'August'
		when month(u.birthday_at) = 9 then 'September'
		when month(u.birthday_at) = 10 then 'October'
		when month(u.birthday_at) = 11 then 'November'
		else 'December' end in ('May', 'August');

-- 5
select * from catalogs c
where c.id in (5,1,2)
order by case
			when c.id = 5 then 1
			when c.id = 1 then 2
			when c.id = 2 then 3
			else 0
		end;
		
/*
 * 1. Подсчитайте средний возраст пользователей в таблице users
 * 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 * 		Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 * 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы
 */
	
-- 1
select AVG(year(now()) - year(u.birthday_at)) from users u;

-- 2
insert into users(name, birthday_at) values('Михаил', '1992-05-17');
select count(*) from users u
group by week(u.birthday_at) 
;

-- 3, нагуглил
drop table if exists temp2
create table temp2 (value int)
insert into temp2 values(1), (2), (3), (4), (5)

select exp(SUM(log(value))) from temp2;
