/*https://learndb.ru/courses/task/41

Задача
	Из таблицы заказов получи информацию:

	count_total - общее количество заказов;
	count_employee - количество заказов, которые оформили сотрудники магазина;
	count_distinct_employee - количество сотрудников магазинов, когда-либо оформивших заказ.*/

SELECT
    COUNT(*) count_total
  , COUNT(employee_id) count_employee
  , COUNT(DISTINCT employee_id) count_distinct_employee
FROM purchase  