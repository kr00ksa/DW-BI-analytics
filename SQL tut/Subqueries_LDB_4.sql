/*https://learndb.ru/courses/task/72

Задача
	Получи информацию о сотрудниках, которые кем-либо руководят (идентификатор сотрудника присутствует в столбце employee.manager_id). 
	
	Выведи следующие столбцы:
	employee_id - идентификатор сотрудника;
	last_name - фамилия;
	first_name - имя;
	rank_id - идентификатор должности.
	
	Отсортируй результат сначала по фамилии, затем по идентификатору сотрудника.*/
	
--Решение 1:
SELECT
    DISTINCT e.employee_id
  , e.last_name
  , e.first_name
  , e.rank_id
FROM employee e
  INNER JOIN employee mngr
    ON e.employee_id = mngr.manager_id
ORDER BY e.last_name, e.employee_id

--Решение 2:
SELECT
    employee_id
  , last_name
  , first_name
  , rank_id
FROM employee
WHERE employee_id IN
(
  SELECT manager_id
  FROM employee
)
ORDER BY last_name, employee_id