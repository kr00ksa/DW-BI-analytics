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


/*https://learndb.ru/courses/task/33

Задача
	Для каждой должности rank получи информацию о других должностях этого же магазина. 
	Выведи:
		store_id - идентификатор магазина;
		rank_id - идентификатор должности;
		rank_id_other - идентификатор другой должности магазина.
		
	Отсортируй результат по store_id, rank_id, rank_id_other.*/
	
SELECT
    r1.store_id
  , r1.rank_id
  , r2.rank_id rank_id_other
FROM rank r1
  INNER JOIN rank r2
    ON r1.store_id = r2.store_id AND r1.rank_id != r2.rank_id
ORDER BY store_id, rank_id, rank_id_other