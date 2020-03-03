/* Практическое задание 3
Практическое задание по теме “Введение в проектирование БД”
Написать скрипт, добавляющий в БД vk, которую создали на занятии,
	3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
*/

/*
 *
DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
*/
USE vk;

-- создание таблиц

-- наполнение нужными данными

-- скрипт самого задания
-- let's start

DROP TABLE IF EXISTS profile_history;
DROP TABLE IF EXISTS profile_status;
DROP TABLE IF EXISTS user_wallet_vk;
DROP TABLE IF EXISTS wallet_vk;
DROP TABLE IF EXISTS wallet_status;

-- table #1 статус профиля в VK
CREATE TABLE profile_status(
	profsts_id SERIAL PRIMARY KEY,
	status_name varchar(250)
);

-- table #2 история изменения профиля
CREATE TABLE profile_history(
	profh_id SERIAL PRIMARY KEY,
	start_date DATETIME DEFAULT now(),    -- дата начал действия записи
	end_date DATETIME,    -- дата окончания действия записи
	profsts_profsts_id BIGINT UNSIGNED NOT NULL,    -- фк на статус профиля
	
	-- создать fk + idx
	INDEX profile_history_profsts_idx (profsts_profsts_id),    -- индекс статус профиля
    FOREIGN KEY (profsts_profsts_id) REFERENCES profile_status(profsts_id)    -- фк на статус профиля
);

-- table #3 статус кошелька
CREATE TABLE wallet_status(
	walsts_id SERIAL PRIMARY KEY,
	status_name varchar(200)
);

-- table #4 кошелёк
CREATE TABLE wallet_vk(
	wallet_id SERIAL PRIMARY KEY,
	created_at DATETIME DEFAULT NOW()
);

-- table #5 кошелёк пользователя vk
CREATE TABLE user_wallet_vk(
	user_wallet_id SERIAL PRIMARY KEY,
	user_user_id bigint,
	wallet_wallet_id BIGINT UNSIGNED, 
	walsts_walsts_id BIGINT UNSIGNED,
	
	INDEX user_wallet_wallet_id_idx (wallet_wallet_id),    -- индек по ключу
	INDEX user_wallet_walsts_idx (walsts_walsts_id),    -- индекс по статусу кошелька
	FOREIGN KEY (wallet_wallet_id) REFERENCES wallet_vk(wallet_id),    -- фк на кошелёк
	FOREIGN KEY (walsts_walsts_id) REFERENCES wallet_status(walsts_id)    -- фк на статус кошелька
);
