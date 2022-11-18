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


/*https://learndb.ru/courses/task/81

Задача
	Из фамилии сотрудника получи подстроку с начала и до первой буквы 'а' включительно. Буква 'а' может быть как заглавной, так и строчной.

	Выведи столбцы:
	last_name - фамилия сотрудника;
	substring - часть фамилии до буквы 'а'.
	
	Отсортируй результат по фамилии.*/
	
SELECT
    last_name
  , SUBSTR(last_name, 1, POSITION('а' in LOWER(last_name))) AS substring1
  , LEFT(e.last_name, position('а' in LOWER(e.last_name))) AS substring2
FROM employee
ORDER BY last_name
