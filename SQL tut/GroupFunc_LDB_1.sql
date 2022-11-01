/*https://learndb.ru/courses/task/122

Задача
	Выведи список сотрудников магазина единой строкой для каждого магазина.

	В результате отобрази поля

	store_id - идентификатор магазина.
	list_employees - список из сотрудников, разделенных точкой с запятой и пробелом '; '. По каждому сотруднику выведи фамилию и имя, разделив их пробелом. Сотрудников отсортируй сначала по фамилии, затем по имени.
	Отсортируй результат по идентификатору магазина.*/

SELECT store_id,
       STRING_AGG(CONCAT(last_name, ' ', first_name), '; ' ORDER BY last_name, first_name) list_employees
FROM employee
GROUP BY store_id
ORDER BY store_id