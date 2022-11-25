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


/*https://learndb.ru/courses/task/110

Задача
	Доработай запрос из теории, нумерующий каталоги товаров. Добавь к каталогам товары этих каталогов и выведи два столбца:
		full_name - полное название, состоящее из четырех точек на каждый уровень вложенности + полный номер в списке + название товара или категории, добавленное через пробел.
		type - тип объекта: 'категория' для категорий, 'товар' для товаров.
		
	Строки должны быть отсортированы по названию с учетом вложенности.

	В результате должна получиться таблица:

	#	full_name	type
	1	1. Товары для дома	категория
	2	....1.1. Бытовая техника	категория
	3	........1.1.1. Пылесос S6	товар
	4	........1.1.2. Холодильник A2	товар
	5	2. Цифровая техника	категория
	...	...	...*/

WITH RECURSIVE hierarchy AS (
SELECT
    category_id
  , parent_category_id
  , name
  , 1 AS level
  , ARRAY[ROW_NUMBER() OVER (ORDER BY name)] AS path_sort
FROM category c
WHERE parent_category_id IS NULL

UNION ALL

SELECT
    c.category_id
  , c.parent_category_id
  , c.name
  , h.level + 1 AS level
  , h.path_sort || ROW_NUMBER() OVER (PARTITION BY c.parent_category_id ORDER BY c.name) AS path_sort
FROM hierarchy h
  INNER JOIN category c
    ON c.parent_category_id = h.category_id
)
, t1 AS
(
SELECT
    category_id
  , name
  , level
  , path_sort
  , 'категория' AS type
FROM hierarchy h

UNION ALL

SELECT
    p.category_id
  , p.name
  , h.level + 1 AS level
  , h.path_sort || ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.name) AS path_sort
  , 'товар' AS type
FROM hierarchy h
  INNER JOIN product p
    ON h.category_id = p.category_id
)
SELECT
    CONCAT(LPAD('', (level - 1) * 4, '.'), ARRAY_TO_STRING(path_sort, '.'), '. ', name) AS full_name
  , type
FROM t1
ORDER BY path_sort