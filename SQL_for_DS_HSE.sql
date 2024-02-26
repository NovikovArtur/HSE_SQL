-- Домашнее задание 5
-- В задании предлагается рассмотреть известную базу данных HR Oracle (ссылки на этой строке для общего развития, не обязательны): https://docs.oracle.com/en/database/oracle/oracle-database/12.2/comsc/HR-sample-schema-table-descriptions.html#GUID-506C25CE-FA5D-472A-9C4C-F9EF200823EE, https://github.com/oracle/db-sample-schemas/tree/main/human_resources

-- Скрипты для создания таблиц и заполнения их данными для разных СУБД: https://www.sqltutorial.org/sql-sample-database/

-- Необходимо написать 20 SQL-запросов (каждый по 0.5б), каждый из которых независимо будет решать описанную задачу.
-- В качестве решения необходимо сдать текстовый файл с расширением .sql, где останутся все условия, и после каждого условия будет написан решающий задачу код на SQL.

-- Укажите в конце этой строки СУБД, которую вы используете: MySQL

-- 1
-- Таблица Employees. Получить список всех сотрудников из 5го и из 8го отдела (department_id), которых наняли в 1998 году

SELECT *
FROM Employees WHERE (department_id = 5 OR department_id = 8) 
AND (YEAR(hire_date) = 1998);

-- 2
-- Таблица Employees. Получить список всех сотрудников, у которых в имени содержатся минимум 2 буквы 'n'

SELECT *
FROM Employees 
WHERE LENGTH(LOWER(first_name)) - LENGTH(REPLACE(LOWER(first_name), 'n', '')) >= 2;

-- 3
-- Таблица Employees. Получить список всех сотрудников, у которых зарплата находится в промежутке от 8000 до 9000 (включительно) и/или кратна 1000

SELECT *
FROM Employees
WHERE (salary >= 8000 AND salary <= 9000) OR (salary % 1000 = 0);

-- 4
-- Таблица Employees. Получить список всех сотрудников, у которых длина имени больше 10 букв и/или у которых в имени есть буква 'b' (без учета регистра)

SELECT *
FROM Employees
WHERE (LENGTH(first_name) > 10) OR (LENGTH(LOWER(first_name)) - LENGTH(REPLACE(LOWER(first_name), 'b', '')) >= 1);

-- 5
-- Таблица Employees. Получить первое трёхзначное число телефонного номера сотрудника, если его номер в формате ХХХ.ХХХ.ХХХХ

SELECT 
	first_name, 
    last_name, 
    LEFT(phone_number, 3) AS first_phone_number

from Employees;
-- 6
-- Таблица Departments. Получить первое слово из имени департамента для тех, у кого в названии больше одного слова

select 
	*, 
	LEFT(department_name, POSITION(' ' IN department_name)) as first_department_name
from Departments
where POSITION(' ' IN department_name) != 0;


-- 7
-- Таблица Employees. Получить список всех сотрудников, которые пришли на работу в первый день месяца (любого)

SELECT 
	first_name, 
	last_name, 
    hire_date
FROM Employees 
WHERE DAY(hire_date) = 1;

-- Посмотрите, как можно записать условия в SQL. Обратите внимание на конструкцию CASE-WHEN
-- 8
-- Таблица Countries. Для каждой страны показать регион в котором она находится: 1-Europe, 2-America, 3-Asia, 4-Africa (без Join)

SELECT *,
case
	when region_id = 1 then 'Europe'
    when region_id = 2 then 'America'
    when region_id = 3 then 'Asia'
    else 'Africa'
END AS region
FROM Countries;

-- 9
-- Таблица Employees. Получить уровень зарплаты каждого сотрудника: Меньше 5000 считается Low level, Больше или равно 5000 и меньше 10000 считается Normal level, Больше или равно 10000 считается High level

SELECT 
	first_name,
    last_name,
    salary,
case
	when salary < 5000 then 'Low level'
    when salary >= 10000 then 'High level'
    else 'Normal level'
END AS level_of_salary
FROM Employees;

-- 10
-- Таблица Employees. Получить отчёт по department_id с минимальной и максимальной зарплатой, с самой ранней и самой поздней датой прихода на работу и с количеством сотрудников. Сортировать по количеству сотрудников (по убыванию)

SELECT 
    department_id,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MIN(hire_date) AS min_hire_date,
    MAX(hire_date) AS max_hire_date,
    COUNT(*) AS employee_count
FROM Employees
GROUP BY department_id
ORDER BY employee_count DESC;

-- 11
-- Таблица Employees. Сколько сотрудников, которые работают в одном и тоже отделе и получают одинаковую зарплату?

SELECT 
    department_id,
    salary,
    COUNT(*) AS employee_count
FROM Employees
GROUP BY department_id, salary
HAVING COUNT(*) > 1;

-- 12
-- Таблица Employees. Сколько в таблице сотрудников, имена которых начинаются с одной и той же буквы? Сортировать по количеству. Показывать только те строки, где количество сотрудников больше 1

SELECT 
    LEFT(first_name, 1) AS first_letter,
    COUNT(*) AS employee_count
FROM Employees
GROUP BY first_letter
HAVING COUNT(*) > 1
ORDER BY employee_count DESC;

-- 13
-- Таблица Employees. Получить список department_id и округленную среднюю зарплату работников в каждом департаменте.

SELECT 
    department_id,
    ROUND(AVG(salary), 2) AS avg_salary
FROM Employees
GROUP BY department_id;

-- 14
-- Таблица Countries. Получить список region_id, сумма длин всех country_name в котором больше 60

SELECT 
    region_id,
    SUM(LENGTH(country_name)) AS total_length
FROM Countries
GROUP BY region_id
HAVING total_length > 60;

-- 15
-- Таблица Employees, Departments, Locations, Countries, Regions. Получить список регионов и количество сотрудников в каждом регионе

SELECT 
    r.region_name,
    COUNT(e.employee_id) AS employee_count
FROM Regions r
JOIN Countries c ON r.region_id = c.region_id
JOIN Locations l ON c.country_id = l.country_id
JOIN Departments d ON l.location_id = d.location_id
JOIN Employees e ON d.department_id = e.department_id
GROUP BY r.region_name;

-- 16
-- Таблица Employees. Показать всех менеджеров, которые имеют в подчинении больше шести сотрудников

SELECT manager.*
FROM employees manager
JOIN employees employee ON manager.employee_id = employee.manager_id
GROUP BY manager.employee_id
HAVING COUNT(employee.employee_id) > 6;

-- 17
-- Таблица Employees. Показать всех сотрудников, у которых нет никого в подчинении

SELECT *
FROM Employees e
WHERE e.employee_id NOT IN (SELECT manager_id FROM Employees WHERE manager_id IS NOT NULL);

-- 18
-- Таблица Employees, Departments. Показать все департаменты, в которых работают больше пяти сотрудников

SELECT 
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM Departments d
JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) > 5;

-- 19
-- Таблица Employees. Получить список сотрудников с зарплатой большей средней зарплаты всех сотрудников.

SELECT *
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 20
-- Таблица Employees, Departments. Показать сотрудников, которые работают в департаменте IT

SELECT *
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';