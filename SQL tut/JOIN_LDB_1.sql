/*https://learndb.ru/courses/task/32

Задача
	Помоги сотрудникам найти повышение в должности, либо перейти на ту же должность, но в другой магазин.
	Для каждого сотрудника получи информацию о должностях либо магазина, в котором работает сотрудник, либо должностях с таким же индентификатором должности в другом магазине. 
	
	Выведи следующие столбцы:
		last_name - фамилия сотрудника;
		first_name - имя сотрудника;
		store_id_employee - идентификатор магазина сотрудника;
		store_id_rank - идентификатор магазина должности;
		rank_id - идентификатор должности в магазине;
		rank_name - название должности.
		
	Отсортируй результат по
		фамилии;
		имени;
		идентификатору магазина должности;
		идентификатору должности.*/
	
SELECT
    e.last_name
  , e.first_name
  , e.store_id store_id_employee
  , r.store_id store_id_rank
  , r.rank_id
  , r.name rank_name
FROM employee e
  INNER JOIN rank r
  ON e.rank_id = r.rank_id OR e.store_id = r.store_id
ORDER BY last_name, first_name, store_id_rank, rank_id