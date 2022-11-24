/*https://learndb.ru/courses/task/104

Задача
	Построй три набора данных: c 101 до 110, с 201 до 215, с 301 до 320.
	В результате выведи один столбец - result_number.

	Отсортируй результат по result_number по возрастанию.*/
	
WITH RECURSIVE start_num AS (
SELECT 
    101 AS start_num1
  , 10 AS count_iterations
UNION ALL
SELECT
    201 AS start_num1
  , 15 AS count_iterations
UNION ALL
SELECT
    301 AS start_num1
  , 20 AS count_iterations  
)
, generation_num AS (
SELECT
    start_num1
  , count_iterations
  , 1 AS current_iteration
  , start_num1 AS result_number
FROM start_num
UNION ALL
SELECT
    start_num1
  , count_iterations
  , current_iteration + 1
  , result_number + 1
FROM generation_num
WHERE current_iteration < count_iterations
)
SELECT result_number
FROM generation_num
ORDER BY result_number


/*https://learndb.ru/courses/task/105

Задача
	Для каждого сотрудника выведи количество руководителей над ним.
	В результате запроса выведи столбцы:
	employee_id - идентификатор сотрудника;
	first_name - имя;
	last_name - фамилия;
	count_managers - количество руководителей над сотрудником. Если у сотрудника нет руководителя, то выведи 0.*/
	
WITH RECURSIVE hierarchy AS (
  SELECT
      employee_id
    , first_name
    , last_name
    , 0 AS count_managers
  FROM employee
  WHERE manager_id IS NULL
  
  UNION ALL
  
  SELECT
      e.employee_id
    , e.first_name
    , e.last_name
    , h.count_managers + 1 AS count_managers
  FROM hierarchy h
    INNER JOIN employee e
      ON e.manager_id = h.employee_id
)
SELECT
    employee_id
  , first_name
  , last_name
  , count_managers    
FROM hierarchy