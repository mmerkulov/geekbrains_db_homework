/* Практическое задание 4
Практическое задание по теме “CRUD – операции”:
i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false).
	Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
v. Написать название темы курсового проекта (в комментарии)
*/

/*
DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
*/
USE vk;

-- Задание 1
-- Отдельный файл для заполнения filling_tables_dz4.sql

-- Задание №2
select u.firstname from vk.users u order by u.firstname;

-- Задание №3
begin
	if not exists ( SELECT 1
	            	FROM INFORMATION_SCHEMA.COLUMNS
	           		WHERE LOWER(table_name) = 'profiles'
	             		AND LOWER(table_schema) = 'vk'
	             		AND LOWER(column_name) = 'is_active') then 
		alter table vk.profiles add column is_active bit default 1 not null;
	end if;

	select * from profiles p where p.is_active = false;
end;

-- Задание №4
delete from vk.messages q
where q.created_at > now();

-- Удаляем все сообщения, которые имеют дату "написания" раньше, чем дата создания пользователя.
delete from messages m
where exists (select * from profiles p2 where p2.user_id = m.from_user_id and p2.created_at < m.created_at);

-- Задание №5
-- Что за тема курсовой? Оо
-- Пусть будет интернет провайдер, получается биллинговая система :) 
