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

/*https://learndb.ru/courses/task/48

Задача
	Для каждого товара получи минимальную и максимальную стоимость из таблицы product_price. Выведи столбцы:

	product_id - идентификатор товара;
	price_min - минимальная стоимость товара;
	price_max - максимальная стоимость товара.
	В результате оставь только те товары, для которых минимальная и максимальная стоимость отличается.

	Отсортируй результат по идентификатору товара.*/
	
SELECT
    product_id
  , MIN(price) price_min
  , MAX(price) price_max
FROM product_price
GROUP BY product_id
HAVING MIN(price) != MAX(price)
ORDER BY product_id