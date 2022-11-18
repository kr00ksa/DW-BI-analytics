/*https://learndb.ru/courses/task/78

Задача
	Сконкатенируй ФИО из таблицы сотрудников employee.
	Выведи один столбец full_name в формате 'Фамилия Имя Отчество;'
	Отсортируй результат по full_name.*/
	
SELECT
    CONCAT(last_name, ' ', first_name, ' ', middle_name, ';') full_name
FROM employee
ORDER BY full_name


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


/*https://learndb.ru/courses/task/82

Задача
	Собери для каждого сотрудника из таблицы employee строку в формате "Фамилия ПерваяБукваИмени****". Звездочками заменяются все буквы имени, кроме первой.
	Например, из 'Иванов Иван' должно получиться 'Иванов И***'.

	В результате выведи поле:
	mask - отформатированное ФИО сотрудника.
	
	Отсортируй результат по полю mask.*/
	
SELECT 
    CONCAT(last_name, ' ', RPAD(LEFT(first_name, 1), LENGTH(first_name), '*')) mask
FROM employee
ORDER BY mask


/*https://learndb.ru/courses/task/82

Задача
	Напиши запрос для получения из таблицы employee одного столбца:
	full_name - ФИО сотрудника. Фамилия, имя и отчество должны быть разделены пробелом.
	
	У некоторых сотрудников не заполнено отчество. В full_name не должно быть пробелов в начале и конце строки.

	Отсортируй результат по full_name.*/
	
SELECT RTRIM(CONCAT(last_name, ' ', first_name, ' ', middle_name)) full_name
FROM employee
ORDER BY full_name


/*https://learndb.ru/courses/task/84

Задача
	В поле address таблицы store_address замени сокращения типа улицы на полное название:
	ул. на улица;
	пр. на проспект.
	В результате запросы выведи один столбец:
	address_full - получившаяся строка адреса.
	
	Отсортируй результат по address_full.*/
	
SELECT 
    REPLACE(
		REPLACE(
			address, 'ул.', 'улица'
		), 'пр.', 'проспект'
	) address_full
FROM store_address
ORDER BY address_full