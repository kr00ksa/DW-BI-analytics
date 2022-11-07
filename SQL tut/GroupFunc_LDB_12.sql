/*https://learndb.ru/courses/task/56

Задача
	Получи информацию о количестве сотрудников из таблицы employee:
	в каждом магазине на каждой должности;
	общее количество сотрудников в магазине;
	общее количество сотрудников во всех магазинах.
	
	В результате выведи столбцы:
	store_id - идентификатор магазина;
	rank_id - идентификатор должности;
	count_employees - количество сотрудников.
	
	Отсортируй результат сначала по идентификатору магазина, затем по идентификатору должности. Для обоих полей NULL значения размести в конце.*/
	
SELECT 
    store_id
  , rank_id
  , COUNT(employee_id) count_employees
FROM employee
GROUP BY ROLLUP (store_id, rank_id)
ORDER BY store_id NULLS LAST, rank_id NULLS LAST


/*https://learndb.ru/courses/task/57

Задача
	Получи информацию о количестве сотрудников из таблицы employee:
	в каждом магазине на каждой должности;
	общее количество сотрудников в магазине;
	общее количество сотрудников, занимающих определенную должность;
	общее количество сотрудников во всех магазинах.
	
	В результате выведи столбцы:
	store_id - идентификатор магазина;
	rank_id - идентификатор должности;
	count_employees - количество сотрудников.
	
	Отсортируй результат сначала по идентификатору магазина, затем по идентификатору должности. Для обоих полей NULL значения размести в конце.*/
	
SELECT 
    store_id
  , rank_id
  , COUNT(employee_id) count_employees
FROM employee
GROUP BY ROLLUP (store_id, rank_id)
ORDER BY store_id NULLS LAST, rank_id NULLS LAST


/*https://learndb.ru/courses/task/58

Задача
	Получи информацию о количестве сотрудников из таблицы employee:
	в каждом магазине на каждой должности;
	общее количество сотрудников во всех магазинах.
	
	В результате выведи столбцы:
	store_id - идентификатор магазина;
	rank_id - идентификатор должности;
	count_employees - количество сотрудников.
	
	Отсортируй результат сначала по идентификатору магазина, затем по идентификатору должности. Для обоих полей NULL значения размести в конце.*/
	
SELECT 
    store_id
  , rank_id
  , COUNT(employee_id) count_employees
FROM employee
GROUP BY GROUPING SETS ((store_id, rank_id), ())
ORDER BY store_id NULLS LAST, rank_id NULLS LAST