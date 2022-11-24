/*https://learndb.ru/courses/task/109

Задача
	Построй иерархию подчиненности сотрудников из таблицы employee.

	В результате запроса выведи столбцы:
		employee_id - идентификатор сотрудника;
		full_name - имя и фамилия сотрудника, разделенные пробелом. Слева добавь 8 пробелов на каждый уровень вложенности. Перед ФИО сотрудника, которым никто не руководит, пробелов быть не должно.
	
	Отсортируй результат так, чтобы:
		подчиненные руководителя следовали сразу за строчкой с руководителем;
		подчиненные одного руководителя были отсортированы сначала по имени, затем по фамилии;
		сотрудники без руководителя отсортированы сначала по имени, затем по фамилии, затем по идентификатору сотрудника.*/
	
WITH RECURSIVE hierarchy AS (
  SELECT
      employee_id
    , 1 AS count_managers
    , CONCAT(e.first_name, ' ', e.last_name) AS full_name
    , array[ROW_NUMBER() OVER (ORDER BY e.first_name, e.last_name, e.employee_id)] AS sort
  FROM employee e
  WHERE manager_id IS NULL
  
  UNION ALL
  
  SELECT
      e.employee_id
    , h.count_managers + 1 AS count_managers
    , CONCAT(LPAD('', count_managers * 8, ' '), CONCAT(e.first_name, ' ', e.last_name)) AS full_name
    , sort || ROW_NUMBER() OVER (PARTITION BY e.manager_id ORDER BY e.first_name, e.last_name, e.employee_id) AS sort
  FROM hierarchy h
    INNER JOIN employee e
      ON e.manager_id = h.employee_id
  )
SELECT
      employee_id
    , full_name
FROM hierarchy h
ORDER BY sort