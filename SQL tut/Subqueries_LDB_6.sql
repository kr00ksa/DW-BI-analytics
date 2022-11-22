/*https://learndb.ru/courses/task/101

Задача
	Найди сотрудников, которые продали меньше, чем среднестатистический сотрудник.

	Будем считать, что среднестатистический сотрудник продал на сумму, равную среднему значению от суммы продаж каждого сотрудника. Например, если в системе три сотрудника и они продали на суммы 100, 100 и 400 соответственно, то среднестатистический сотрудник продал на сумму (100 + 100 + 400) / 3 = 200.

	Сумма продаж сотрудника определяется как сумма произведения стоимости товара на количество по всем заказам, которые оформил сотрудник.
	Сотрудников, которые не сделали ни одной продажи, в расчет не берем.

	Выведи информацию по каждому сотруднику:
	employee_id - идентификатор сотрудника;
	last_name - фамилия сотрудника;
	first_name - имя сотрудника;
	sum_purchases - сумма продаж сотрудника.
	
	Отсортируй результат сначала по сумме продаж сотрудника, затем по идентификатору сотрудника.*/
	
WITH sum_emp_t AS
(
  SELECT
      p.employee_id
    , last_name
    , first_name   
    , SUM(price * count) sum_purchases
  FROM employee emp
    INNER JOIN purchase p
      ON emp.employee_id = p.employee_id
    INNER JOIN purchase_item pi
      ON pi.purchase_id = p.purchase_id
  GROUP BY p.employee_id, last_name, first_name 
  ORDER BY p.employee_id
)
, avg_emp AS
(
  SELECT AVG(sum_purchases) avg_sum
  FROM sum_emp_t
)
SELECT
    employee_id
  , last_name
  , first_name
  , sum_purchases
FROM  sum_emp_t, avg_emp
WHERE sum_purchases < avg_sum
ORDER BY sum_purchases, employee_id

