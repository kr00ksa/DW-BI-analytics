/*https://learndb.ru/courses/task/78

Задача
	Сконкатенируй ФИО из таблицы сотрудников employee.
	Выведи один столбец full_name в формате 'Фамилия Имя Отчество;'
	Отсортируй результат по full_name.*/
	
SELECT
    CONCAT(last_name, ' ', first_name, ' ', middle_name, ';') full_name
FROM employee
ORDER BY full_name

/*https://learndb.ru/courses/task/79

Задача
	Объедини фамилию и имя через пробел из таблицы сотрудников employee. Выведи результат конкатенации в трех столбцах:
	lower - строка, преобразованная в нижний регистр;
	upper - строка, преобразованная в верхний регистр;
	initcap - строка после применения функции initcap.
	
	Отсортируй результат сначала по фамилии, затем по имени.*/
	
SELECT
    LOWER(CONCAT(last_name, ' ', first_name)) lower
  , UPPER(CONCAT(last_name, ' ', first_name)) upper
  , INITCAP(CONCAT(last_name, ' ', first_name)) initcap  
FROM employee
ORDER BY last_name, first_name

/*https://learndb.ru/courses/task/86

Задача
	Получи строку с фамилией и первой буквой имени сотрудника в формате 'Фамилия И.'. Например, Иванов В. для Иванова Владимира. 
	Выведи два столбца:
	employee_id - идентификатор сотрудника;
	full_name - фамилия с первой буквой имени.
	
	Отсортируй результат сначала по фамилии сотрудника, затем по имени.*/
	
SELECT
    employee_id
  , CONCAT(last_name, ' ', LEFT(first_name, 1), '.') full_name
FROM employee
ORDER BY last_name, first_name


