/*
1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека,
	который больше всех общался с нашим пользователем.
2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/

-- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека,
-- 		который больше всех общался с нашим пользователем.
select max(q.amount)
from (
	select
		case
			when m2.from_user_id = 1 then m2.to_user_id 
			when m2.to_user_id = 1 then m2.from_user_id 
			else -1
		end as 'friends',
	 	count(*) as 'amount'	-- считаем количество перписок с друзьями
	from messages m2
	where m2.from_user_id = 1 or m2.to_user_id =  1	-- указываем какой у нас будет пользователь
		and exists (select 1 from friend_requests fr
					where fr.status = 'approved'	-- условие, что у нас есть в сообщения именно ДРУГ, который принял нас в друзья
							and (fr.initiator_user_id in (m2.to_user_id, m2.from_user_id) -- ищем друзьей по выбранном user_id
									or fr.target_user_id in (m2.to_user_id, m2.from_user_id))) -- т.е. у в friend_requests отбираем только те записи, где фигурирует наш пользователь
	group by friends
) q
;
-- имхо, можно сделать красивее :)

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
select count(*)
from likes l
	join profiles p on p.user_id = l.user_id and year(now()) - year(p.birthday) < 10
												 -- DATEDIFF(now(), p.birthday) < 3640
;

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
select MAX(q.amount) from (
	select
		count(*) as 'amount', p.gender
	from likes l
		inner join profiles p on p.user_id = l.user_id
	where p.gender is not null
		group by p.gender
) q
;


--
--  Поыптка написать цикл, который обновит таблицу gender
--
/
begin
	DECLARE i INT DEFAULT 0;
	declare q VARCHAR(10) default '';
	declare u int; -- переменная, которая будет принимать значение из курсора
	
	declare currentRow int; -- переменная для выхода из цикла
	declare maxRows = (select count(user_id) from profiles); -- переменная для выхода из цикла
	declare curs1 cursor for select user_id from profiles order by user_id; -- курсор, по таблице, смотрим в каждую строку и обрабатываем

	set currentRow = 0;

	open curs1;

	myLoop: loop
		fetch curs1 into u; -- берём курсор и вытаскиываем значение
	
		if currentRow = maxRows then leave myLoop end if; -- проверили, если текущая строка "дошла" до максимально возможной, то выходим из цикла
	
		set i = truncate((rand()*2), 0); -- просто определяем будем М или Ж
		if i = 1 then
			set q = 'male';
		else 
			set q = 'female';
		end if;
		
		update profiles t
		set t.gender = q
		where t.gender is null and t.id = u; -- проверяем, что обновляем запись только у нужной строчки
	
		commit;
		
		set currentRow = currentRow + 1;
	end LOOP;

	close curs1;
end;
/



