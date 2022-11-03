/*https://learndb.ru/courses/task/47#employee

Задача
	Посчитай статистику по руководителям (employee.manager_id) в магазинах. Выведи следующие данные:

	store_name - название магазина;
	manager_full_name - имя и фамилия руководителя, разделенные пробелом;
	amount_employees - количество человек в подчинении.
	Если в магазине есть сотрудники, у которых нет руководителя (manager_id is null), в результате должна быть строка, в которой manager_full_name принимает значение NULL, а amount_employees равно количеству сотрудников без руководителя в магазине.

	Отсортируй результат по названию магазина, затем по manager_full_name.*/
	
SELECT
    name store_name
  , mngr.first_name || ' ' || mngr.last_name manager_full_name
  , COUNT(*) amount_employees
FROM employee emp
  LEFT JOIN employee mngr
    ON mngr.employee_id = emp.manager_id
  LEFT JOIN store s
    ON s.store_id = emp.store_id
GROUP BY mngr.manager_id, name, store_id, mngr.last_name, mngr.first_name
ORDER BY store_name, manager_full_name