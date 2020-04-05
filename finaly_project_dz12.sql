-- ars = Auto repair shop = Автомастерская
-- create database ars;

/*
База данных автомастерская, в которой сотрудники автосервиса регистрируют клиентов и их автомобили. Имеется история проведённых работ,
по которой можно анализировать состояние автомобиля, предлагать дополнительный сервис, а так же на "опережение" предлагать услуги. 
 
Список таблиц
 1. автомобили
 2. автовладелец
 3. персонал
 4. история персонала
 5. статус персонала
 6. клиент
 7. история клиента
 8. статус клиента
 9. юридический тип -> относится к клиенту
 10. Тип работ
 11. Работа
 12. Запчасти
 13. Услуги
 14. Заказ
 */


drop table if exists client_status;

create table client_status(
	clst_id SERIAL primary key,
	name varchar(200)
);

insert into client_status (name)
value	('Действующий'),
		('Времено закрыт'),
		('Закрытый');

select * from client_status ;

drop table if exists jur_types;

create table jur_types(
	jrtp_id SERIAL primary key,
	name varchar(100)
);

insert into jur_types(name)
values	('ФЛ'),
		('ЮЛ'),
		('ИП');

drop table if exists client;

create table client(
	clnt_id serial primary key,
	clst_clst_id BIGINT UNSIGNED NOT null,
	jrtp_jrtp_id BIGINT UNSIGNED NOT null,
	navi_user varchar(200),
	navi_date datetime default now(),
	
	FOREIGN KEY (clst_clst_id) REFERENCES client_status(clst_id),
	FOREIGN KEY (jrtp_jrtp_id) REFERENCES jur_types(jrtp_id)
);

insert into client(clst_clst_id, jrtp_jrtp_id, navi_user)
value	(1, 1, 'ARS_SYSTEM'),	-- 1
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),	-- 5
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),
		(1, 1, 'ARS_SYSTEM'),	-- 10
		(2, 1, 'ARS_SYSTEM'),
		(3, 1, 'ARS_SYSTEM'),	-- 12
		(2, 2, 'ARS_SYSTEM'),
		(3, 2, 'ARS_SYSTEM'),
		(1, 2, 'ARS_SYSTEM'),	-- 15
		(1, 2, 'ARS_SYSTEM'),
		(1, 3, 'ARS_SYSTEM'),	-- 17
		(1, 3, 'ARS_SYSTEM'),
		(1, 2, 'ARS_SYSTEM'),
		(1, 2, 'ARS_SYSTEM')
;

select * from client;

drop table if exists client_history;

create table client_history(
	clnt_clnt_id BIGINT UNSIGNED NOT null,
	number_history int not null, -- Нужен будет триггер +1 при вставке для каждого клиент
	clst_clst_id BIGINT UNSIGNED NOT null,
	jrtp_jrtp_id BIGINT UNSIGNED NOT null,
	account varchar(300),	-- ЛС
	name varchar(300),		-- ФИО
	birth_day date, 			-- ДР
	comment varchar(1000),	-- 
	start_date datetime,	-- начало действия записи
	end_date datetime,		-- окончание действия записи 31.12.2999
	navi_user varchar(100),	-- юзер вставивший запись
	navi_date datetime default now(), -- дата вставки записи в таблицу
	
	primary key (clnt_clnt_id, number_history),
	FOREIGN KEY (clnt_clnt_id) REFERENCES client(clnt_id),
	FOREIGN KEY (clst_clst_id) REFERENCES client_status(clst_id),
	FOREIGN KEY (jrtp_jrtp_id) REFERENCES jur_types(jrtp_id)
);
   
insert into client_history (clnt_clnt_id, number_history, clst_clst_id, jrtp_jrtp_id, account, name, birth_day, comment, start_date, end_date, navi_user)
values	(1, 1, 1, 1, '100', 'Петров Игорь Михайлович', '1970-02-03', '', '2019-01-01', '2019-06-25', 'ARS_SYSTEM'),
		(1, 2, 1, 1, '100', 'Петров Игорь Михайлович', '1970-02-03', 'Не звонить', '2019-01-01', '2999-12-31', 'ARS_SYSTEM'),
		(2, 1, 1, 1, '200', 'Смирнов Андрей Игорьевич', '1976-03-03', '', '2019-11-03', '2999-12-31', 'ARS_SYSTEM'),
		(3, 1, 1, 1, '300', 'Кукушкин Антон Петрович', '1984-10-22', '', '2019-05-21', '2999-12-31', 'ARS_SYSTEM'),
		(4, 1, 1, 1, '400', 'Мухина Ирина Александровна', '1980-07-17', '', '2018-04-21', '2999-12-31', 'ARS_SYSTEM'),
		(5, 1, 1, 1, '500', 'Жуков Артур Антонович', '1977-08-03', '', '2019-05-01', '2999-12-31', 'ARS_SYSTEM'),
		(11, 1, 1, 2, '1100', 'ООО Рога и Копыта', '1990-03-02', '', '2017-03-02', '2999-12-31', 'ARS_SYSTEM'),
		(12, 1, 1, 3, '1200', 'ООО Ганза', '1985-09-09', '', '2015-09-09', '2999-12-31', 'ARS_SYSTEM'),
		(15, 1, 1, 2, '1500', 'ПАО Альфа', '1990-06-13', '', '2019-06-13', '2019-10-20', 'ARS_SYSTEM'),
		(15, 2, 1, 2, '1500', 'ПАО Альфа', '1990-06-13', '', '2019-10-20', '2999-12-31', 'ARS_SYSTEM'),
		(6, 1, 1, 1, '600', 'Синченко Анна Михайловна', '1969-05-02', '', '01.12.2019', '2999-12-31', 'ARS_SYSTEM')
;


drop table if exists job_type;

create table job_type(
	jbtp_id serial primary key,
	name varchar(1000)
);

insert into job_type (name)
value	('Диагностика'),
		('Замена масла'),
		('Ремонт кузова'),
		('Шиномантаж'),
		('Работа с ходовой'),
		('Диагностика двигателя'),
		('Работа с двигателем')
;

drop table if exists job;
create table job(
	job_id serial primary key,
	job_name varchar(1000),
	jbtp_jbtp_id bigint UNSIGNED NOT null,
	price decimal(18,2),
	start_date datetime,
	end_date datetime,
	navi_date datetime default now(),
	navi_user varchar(100),
	FOREIGN KEY (jbtp_jbtp_id) REFERENCES job_type(jbtp_id)
);

insert into job(job_name, jbtp_jbtp_id, price, start_date, end_Date, navi_user)
values	('Диагностика', 1, '700', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена масла в двигателе', 2, '800', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена масла в АКПП', 2, '3000', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Ремонт переднего бампера', 3, '5000', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Ремонт заднего бампера', 3, '5000', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена сальников 4 шт', 4, '2000', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена сальников 3 шт', 4, '1500', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена сальников 2 шт', 4, '1000', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена сальника 1 шт', 4, '500', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Диагностика двигателя', 5, '1300', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Устранение течи масла', 6, '1000', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена свечей 4 шт', 6, '2400', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена свечей 3 шт', 6, '1800', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена свечей 2 шт', 6, '1200', now(), '2999-12-31', 'ARS_SYSTEM'),
		('Замена свечи 1 шт', 6, '600', now(), '2999-12-31', 'ARS_SYSTEM')
		

drop table if exists spares;
create table spares(
	spares_id serial primary key,
	name varchar(500),
	amount int,
	price decimal(18,2)
);

insert into spares(name, amount, price)
values ('Резина Contenintal SportEdition 17R', 20, '7800'),
		('Моторное мало MOTUL RX', 350, '3000'),
		('Подшипник', 6000, '50'),
		('Рычаг на NISSAN TEANA J32 ЛЕВЫЙ ПЕРЕД', 6, '10100'),
		('Резина TOYO GSI-5', 99, '7100'),
		('Дворник LYNX 25см', 55, '510'),
		('Сальник NISSAN TEANA J32', 13, '250'),
		('Сальник TOYOTA RAV4 2005', 13, '150'),
		('Сальник TOYOTA RAV4 2010', 25, '350'),
		('Диагностика ходовой', 1, 800),
		('Диагностика двигателя', 1, 1500)
;

select * from spares;

drop table service;
create table service(
	service_id serial primary key,
	job_job_id bigint UNSIGNED NOT null,
	sprs_sprs_id bigint UNSIGNED NOT null,
	navi_date datetime default now(),
	navi_user varchar(100),
	
	FOREIGN KEY (job_job_id) REFERENCES job(job_id),
	FOREIGN KEY (sprs_sprs_id) references spares(spares_id)
);

insert into service(job_job_id, sprs_sprs_id, navi_user)
values	(1, 10, 'ARS_SYSTEM'),
		(2, 1, 'ARS_SYSTEM'),
		(3, 2, 'ARS_SYSTEM'),
		(4, 3, 'ARS_SYSTEM'),
		(5, 4, 'ARS_SYSTEM'),
		(6, 5, 'ARS_SYSTEM'),
		(7, 6, 'ARS_SYSTEM'),
		(8, 8, 'ARS_SYSTEM'),
		(9, 9, 'ARS_SYSTEM'),
		(10, 11, 'ARS_SYSTEM');

drop table if exists staff_status;
create table staff_status(
	sfst_id serial primary key,
	name varchar(100)
);

insert into staff_status(name)
values ('Действующий'),
		('Уволен');
	
select * from staff_status ;

drop table if exists staff;
create table staff(
	staff_id serial primary key,
	sfst_sfst_id bigint,
	navi_date datetime default now(),
	navi_user varchar(100)
);

insert into staff(sfst_sfst_id, navi_user)
values (1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM'),
		(1, 'ARS_SYSTEM');

select * from staff ;

drop table if exists staff_position;
create table staff_position(
	stpt_id serial primary key,
	name varchar(100),
	navi_user varchar(100),
	navi_date datetime default now()
);

insert into staff_position (name, navI_user)
values ('Директор', 'ARS_SYSTEM'),	-- 1
		('Специалист', 'ARS_SYSTEM'),
		('Менеджер', 'ARS_SYSTEM'), 		-- 3
		('Автометахник', 'ARS_SYSTEM'),
		('Автоэлектрик', 'ARS_SYSTEM'),	-- 5
		('Грузчик', 'ARS_SYSTEM'),
		('Дальнобойщик', 'ARS_SYSTEM')	-- 7
	;

drop table if exists staff_history;
create table staff_history(
	staff_staff_id bigint UNSIGNED NOT null,
	number_history bigint,
	name varchar(100),
	birth_day date,
	stpt_stpt_id bigint UNSIGNED NOT null,
	salary decimal(18,2),
	sfst_sfst_id bigint UNSIGNED NOT null,
	is_own_car bit default 0,		-- собственный автомобиль
	start_date datetime, 
	end_date datetime,
	comment varchar(1000) default null,
	navi_user varchar(100),
	navi_date datetime default now(),
	
	primary key (staff_staff_id, number_history),
	FOREIGN KEY (staff_staff_id) REFERENCES staff(staff_id),
	FOREIGN KEY (stpt_stpt_id) REFERENCES staff_position(stpt_id),
	FOREIGN KEY (sfst_sfst_id) REFERENCES staff_status(sfst_id)
);

insert into staff_history(staff_staff_id, number_history, name, birth_day, stpt_stpt_id, salary, sfst_sfst_id, start_date, end_Date, navi_user)
values	(1, 1, 'Гусев Артём Игорьевич', '1980-03-05', 1, '290000', 1, date_add(now(), interval -100 day), date_add(now(), interval -10 day), 'ARS_SYSTEM'),
		(1, 2, 'Гусев Артём Игорьевич', '1980-03-05', 1, '310000', 1, date_add(now(), interval -10 day), '2999-12-31', 'ARS_SYSTEM'),
		(2, 1, 'Петро Александр Васильеви', '1969-12-31', 4, '69000', 1, date_add(now(), interval -100 day), date_add(now(), interval -39 day), 'ARS_SYSTEM'),
		(2, 2, 'Петро Александр Васильеви', '1969-12-31', 4, '89000', 1, date_add(now(), interval -39 day), '2999-12-31', 'ARS_SYSTEM'),
		(3, 1, 'Калядин Максим Александрович', '1990-09-07', 5, '102000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(4, 1, 'Будрин Егор Михайлович', '1981-06-26', 3, '88000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(5, 1, 'Сидоров Иван Дмитриевич', '1985-02-12', 3, '58000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(6, 1, 'Бубнов Пётр Кирилович', '1977-07-10', 6, '120000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(7, 1, 'Сидков Григорий Владимирович', '1979-01-18', 4, '55000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(8, 1, 'Рыбков Максим Владимирович', '1971-10-10', 5, '85000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(9, 1, 'Борисов Борис Борисович', '1985-10-30', 4, '49000', 1, date_add(now(), interval -100 day), '2999-12-31', 'ARS_SYSTEM'),
		(10, 1, 'Бурундуков Артём Дмитриевич', '1985-10-30', 4, '49000', 1, date_add(now(), interval -100 day), date_add(now(), interval -50 day), 'ARS_SYSTEM'),
		(10, 2, 'Бурундуков Артём Дмитриевич', '1985-10-30', 4, '49000', 2, date_add(now(), interval -50 day), '2999-12-31', 'ARS_SYSTEM')
;

drop table if exists car;
create table car(
	car_id serial primary key,
	mark varchar(200),
	name varchar(200),
	year_car date
);

insert into car(mark, name, year_car)
values	('TOYOTA', 'RAV4', '2005-01-01'),
		('TOYOTA', 'RAV4', '2015-01-01'),
		('TOYOTA', 'Corolla', '2005-01-01'),
		('NISSAN', 'TEANA', '2005-01-01'),
		('NISSAN', 'TEANA', '2011-01-01'),
		('NISSAN', 'TEANA', '2014-01-01'),
		('NISSAN', 'JUKE', '2017-01-01'),
		('NISSAN', 'JUKE', '2018-01-01'),
		('BMN', 'X3', '2005-01-01'),
		('BMN', 'X3', '2010-01-01'),
		('BMN', 'X3', '2011-01-01'),
		('BMN', 'X3', '2015-01-01'),
		('BMN', 'X3', '2019-01-01');
		
drop table if exists car_owner;
create table car_owner(
	carown_id serial primary key,
	clnt_clnt_id bigint UNSIGNED NOT null,
	car_car_id bigint UNSIGNED NOT null,
	plate_number varchar(11),
	is_owner bit default 1,
	car_mileage bigint default 0,
	navi_date datetime default now(),
	navi_user varchar(100),
	
	foreign key (clnt_clnt_id) REFERENCES client(clnt_id),
	foreign key (car_car_id) REFERENCES car(car_id)
);

insert into car_owner(clnt_clnt_id, car_car_id, plate_number, car_mileage, navi_user)
values	(1, 1, 'А123РС154', 120000, 'ARS_SYSTEM'),
		(1, 2, 'Н396ВМ54', 53525, 'ARS_SYSTEM'),
		(2, 1, 'С771РО154', 220000, 'ARS_SYSTEM'),
		(3, 1, 'Х519УТ54', 42400, 'ARS_SYSTEM'),
		(4, 4, 'М456ВС54', 76250, 'ARS_SYSTEM'),
		(5, 1, 'О883ЕК54', 65232, 'ARS_SYSTEM'),
		(6, 1, 'Х735ВУ154', 532566, 'ARS_SYSTEM'),
		(10, 1, 'Т333АК54', 9900, 'ARS_SYSTEM'),
		(19, 12, 'В008УВ54', 15000, 'ARS_SYSTEM'),
		(20, 13, 'С009РС54', 15000, 'ARS_SYSTEM'),
		(20, 13, 'А007ЕН54', 15000, 'ARS_SYSTEM');

drop table if exists order_status;
create table order_status(
	orst_id serial primary key,
	name varchar(100),
	navi_user varchar(100),
	navi_date datetime default now()
);

insert into order_status (name, navi_user)
values	('Создан', 'ARS_USER'),
		('В работе', 'ARS_USER'),
		('Приостановлен', 'ARS_USER'),
		('Откланён клиентом', 'ARS_USER'),
		('Ожидание оплаты', 'ARS_USER'),
		('Оплачен', 'ARS_USER'),
		('Ожидает проведения работ', 'ARS_USER'),
		('Ожидает подтверждения выполнения', 'ARS_USER'),
		('Закрыт', 'ARS_USER');
	
select * from order_status ;
	
drop table if exists orders;
create table orders(
	order_id serial primary key,
	carowner_carowner_id bigint UNSIGNED NOT null,
	staff_staff_id bigint UNSIGNED NOT null,
	service_service_id bigint UNSIGNED NOT null,
	total_price decimal(18,2),
	orst_orst_id bigint UNSIGNED NOT null,
	navi_date datetime default now(),
	navi_user varchar(100),
	
	foreign key (carowner_carowner_id) references car_owner(carown_id),
	foreign key (staff_staff_id) references staff(staff_id),
	foreign key (service_service_id) references service(service_id),
	foreign key (orst_orst_id) references order_status(orst_id),
	
	INDEX carowner_carowner_idx (carowner_carowner_id)
);

insert into orders(carowner_carowner_id, staff_staff_id, service_service_id, total_price, orst_orst_id, navi_date, navi_user)
values	(1, 2, 1, 1500, 9, '2018-10-4', 'ARS_SYSTEM'),
		(2, 2, 1, 6300, 9, '2018-12-24', 'ARS_SYSTEM'),
		(3, 7, 5, 66300, 9, '2017-06-22', 'ARS_SYSTEM')

insert into orders(carowner_carowner_id, staff_staff_id, service_service_id, total_price, orst_orst_id, navi_user)
values	(1, 2, 1, 1100, 1, 'ARS_SYSTEM'),
		(1, 2, 2, 4100, 2, 'ARS_SYSTEM'),
		(2, 2, 3, 1100, 2, 'ARS_SYSTEM'),
		(3, 7, 2, 5200, 2, 'ARS_SYSTEM'),
		(3, 9, 3, 9000, 3, 'ARS_SYSTEM'),
		(4, 2, 4, 3200, 9, 'ARS_SYSTEM'),
		(4, 7, 5, 11600, 5, 'ARS_SYSTEM'),
		(4, 9, 6, 6630, 7,'ARS_SYSTEM'),
		(5, 9, 8, 9020, 4, 'ARS_SYSTEM')
;

-- представления
-- №1 Список актуальных сотрудников
create view actual_staff
as
select sh.name as FIO, sh.birth_day as BIRTH_DAY, sp.name as POSITION, salary
from staff s
	inner join staff_history sh on s.staff_id = sh.staff_staff_id and sh.end_Date > now()
	inner join staff_position sp on sh.stpt_stpt_id = sp.stpt_id
where s.sfst_sfst_id = 1;

-- № Средний, минимальный и максимальный заказ с разбивкой по годам
create view avg_min_max_order_price_by_year
as
select year(o.navi_date), round(avg(o.total_price), 2), min(o.total_price), max(o.total_price)
from orders o
	inner join car_owner co on co.carown_id = o.carowner_carowner_id
	inner join staff s on s.staff_id = o.staff_staff_id
	inner join service sv on o.service_service_id = sv.service_id
	inner join order_status os on o.orst_orst_id = os.orst_id
group by year(o.navi_date);
