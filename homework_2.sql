/*
Практическое задание по теме “Управление БД”
Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
(по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword
  базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
*/

-- СУБД установил :)

Файл .my.conf расположенный "C:\Users\mikhail.merkulov":
[mysql]
user=root
password=1234

----------------
----------------
----------------

#create database homework2;
/*
create table t1 (
	col1 int primary key,
	col2 int 
);
*/

select * from t1;

create table users (
	uid int primary key,
	navi_user varchar(100)
);

-- сделали дамп из командной строки
C:\Program Files\MySQL\MySQL Server 8.0\bin>mysqldump --user=root -p --databases homework2 --result-file="C:\Program Files\MySQL\MySQL Server 8.0\bin\CustomDB\dump_homework2.sql"
Enter password: ****

C:\Program Files\MySQL\MySQL Server 8.0\bin>

-- сделали импорт дампа
-- 1. Создано новую БД => mysql -u root -p
create database new_homework2;
-- 2. Вызвал команду:
C:\Program Files\MySQL\MySQL Server 8.0\bin>mysql -u root -p -B new_homework2 < "C:\Program Files\MySQL\MySQL Server 8.0\bin\CustomDB\dump_homework2.sql"
-- Выполнилось успешно, но дамп не разлился
-- 3. перекинул Дамп в ./bin, зашёл в mysql, выполнил use new_homework2 и сделал:
source dump_homework2.sql
show tables;

-- результат появился

-- p.s. хз как данную домашку оформить....

