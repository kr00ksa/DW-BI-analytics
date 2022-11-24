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
FROM hierarchy h
ORDER BY CONCAT(h.managers || '; ', h.first_name, ' ', h.last_name)


/*https://learndb.ru/courses/task/108

Задача
	Реши задачу из предыдущего задания, используя вместо таблицы employee подзапрос lv_employee:
		WITH lv_employee AS (
		  SELECT e.employee_id, 
				 e.first_name, 
				 e.last_name, 
				 e.manager_id
			FROM employee e
		   UNION ALL
		  SELECT e.employee_id * 1000, 
				 e.first_name, 
				 e.last_name, 
				 e.manager_id * 1000
			FROM employee e
		)
	Для каждого сотрудника выведи количество его руководителей и их список.

	В результате запроса выведи столбцы:
		employee_id - идентификатор сотрудника;
		first_name - имя;
		last_name - фамиля;
		count_managers - количество руководителей над сотрудником;
		managers - список руководителей (имя и фамилия, разделенные пробелом), разделенных через '; ' (точка с запятой + пробел). Если у сотрудника нет руководителей, выведи пустую строку. Руководители должны следовать в порядке их подчиненности: на персом месте - самый главный начальник, на последнем - непосредственный руководитель сотрудника. В начале и конце строки точки с запятой быть не должно.
		
	Отсортируй результат так, чтобы:
		подчиненные руководителя следовали сразу за строчкой с руководителем;
		подчиненные одного руководителя были отсортированы сначала по имени, затем по фамилии;
		сотрудники без руководителя отсортированы сначала по имени, затем по фамилии, затем по идентификатору сотрудника.*/
	
WITH RECURSIVE lve AS (
  SELECT e.employee_id, 
         e.first_name, 
         e.last_name, 
         e.manager_id
    FROM employee e
   UNION ALL
  SELECT e.employee_id * 1000, 
         e.first_name, 
         e.last_name, 
         e.manager_id * 1000
    FROM employee e
)
, hierarchy AS (
  SELECT
      employee_id
    , first_name
    , last_name
    , 0 AS count_managers
    , NULL AS managers
    , array[ROW_NUMBER() OVER (ORDER BY lve.first_name, lve.last_name, lve.employee_id)] AS path_sort
  FROM lve
  WHERE manager_id IS NULL
  
  UNION ALL
  
  SELECT
      lve.employee_id
    , lve.first_name
    , lve.last_name
    , h.count_managers + 1 AS count_managers
    , CONCAT(h.managers || '; ', h.first_name, ' ', h.last_name) AS managers
    , path_sort || ROW_NUMBER() OVER (PARTITION BY lve.manager_id ORDER BY lve.first_name, lve.last_name, lve.employee_id) AS path_sort
  FROM hierarchy h
    INNER JOIN lve
      ON lve.manager_id = h.employee_id
  )
SELECT
      employee_id
    , first_name
    , last_name
    , count_managers
    , COALESCE(managers, '') AS managers
FROM hierarchy h
ORDER BY path_sort
