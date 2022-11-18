/*https://learndb.ru/courses/task/78

Задача
	Сконкатенируй ФИО из таблицы сотрудников employee.
	Выведи один столбец full_name в формате 'Фамилия Имя Отчество;'
	Отсортируй результат по full_name.*/
	
SELECT
    CONCAT(last_name, ' ', first_name, ' ', middle_name, ';') full_name
FROM employee
ORDER BY full_name

