/*https://learndb.ru/courses/task/40

Задача
	Из таблицы заказов получи строки с информацией:

	count_total - общее количество заказов;
	count_employee - количество заказов, которые оформили сотрудники магазина.*/

SELECT
    COUNT(*) count_total
  , COUNT(employee_id) count_employee
FROM purchase  