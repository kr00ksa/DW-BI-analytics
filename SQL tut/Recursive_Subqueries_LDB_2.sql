/*https://learndb.ru/courses/task/106

Задача
	Для каждого сотрудника выведи количество его руководителей и их список.
	
	В результате запроса выведи столбцы:
		employee_id - идентификатор сотрудника;
		first_name - имя;
		last_name - фамиля;
		count_managers - количество руководителей над сотрудником;
		managers - список руководителей (имя и фамилия, разделенные пробелом), разделенных через '; ' (точка с запятой + пробел). Если у сотрудника нет руководителей, выведи пустую строку. Руководители должны следовать в порядке их подчиненности: на первом месте - самый главный начальник, на последнем - непосредственный руководитель сотрудника. В начале и конце строки точки с запятой быть не должно.*/
	
WITH RECURSIVE hierarchy AS (
  SELECT
      employee_id 
    , first_name
    , last_name
    , 0 AS count_managers 
    , null AS managers
  FROM employee
  WHERE manager_id IS NULL
  
  UNION ALL
  
  SELECT
      e.employee_id
    , e.first_name
    , e.last_name
    , h.count_managers + 1 AS count_managers
    , CONCAT(h.managers || '; ', h.first_name, ' ', h.last_name) AS managers
  FROM hierarchy h
    INNER JOIN employee e
      ON e.manager_id = h.employee_id
)
SELECT
    employee_id
  , first_name
  , last_name
  , count_managers
  , COALESCE(managers, '') AS managers
  FROM hierarchy
  
 
/*https://learndb.ru/courses/task/107

Задача
	Для каждого сотрудника выведи количество его руководителей и их список.

	В результате запроса выведи столбцы:
		employee_id - идентификатор сотрудника;
		first_name - имя;
		last_name - фамилия;
		count_managers - количество руководителей над сотрудником;
		managers - список руководителей (имя и фамилия, разделенные пробелом), разделенных через '; ' (точка с запятой + пробел). Если у сотрудника нет руководителей, выведи пустую строку. Руководители должны следовать в порядке их подчиненности: на первом месте - самый главный начальник, на последнем - непосредственный руководитель сотрудника. В начале и конце строки точки с запятой быть не должно.
		
	Отсортируй результат так, чтобы:
		подчиненные руководителя следовали сразу за строчкой с руководителем;
		подчиненные одного руководителя были отсортированы сначала по имени, затем по фамилии;
		сотрудники без руководителя отсортированы сначала по имени, затем по фамилии.
		
		В результате строки должны быть отсортированы так:
		Анна Никитина
		Иван Иванов
			Алексей Петров
			Вячеслав Сидоров
				Сергей Сергеев
			Борис Ивлев
			Федор Достоевский
				Александр Пушкин
		Михаил Аверин*/
	
WITH RECURSIVE hierarchy AS (
  SELECT
      employee_id
    , first_name
    , last_name
    , 0 AS count_managers
    , NULL AS managers
    , CONCAT(first_name, ' ', last_name) AS managers_name
  FROM employee
  WHERE manager_id IS NULL
  
  UNION ALL
  
  SELECT
      e.employee_id
    , e.first_name
    , e.last_name
    , h.count_managers + 1 AS count_managers
    , CONCAT(h.managers || '; ', h.first_name, ' ', h.last_name) AS managers
    , CONCAT(managers_name, '; ', e.first_name, ' ', e.last_name) AS managers_name
  FROM hierarchy h
    INNER JOIN employee e
      ON e.manager_id = h.employee_id
  )
SELECT
      employee_id
    , first_name
    , last_name
    , count_managers
    , COALESCE(managers, '') AS managers
FROM hierarchy
ORDER BY managers_name