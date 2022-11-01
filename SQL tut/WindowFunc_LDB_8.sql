/*
https://learndb.ru/courses/task/119

Задача
	Выведи информацию по заказам со статистикой по сотрудникам магазинов, оформивших заказ:

	purchase_id - идентификатор заказа.
	employee - фамилия и имя сотрудника, оформившего заказ, разделенные через пробел.
	price_purchase - полная стоимость заказа (сумма по всем позициям стоимости товара * количество товара).
	total_by_employee - полная стоимость всех заказов, оформленных сотрудником. Стоимость заказов, оформленных без сотрудника, посчитай единой суммой.
	Отсортируй результат сначала по фамилии и имени сотрудника (заказы, оформленные без сотрудника, размести в конце), затем по идентификатору заказа.*/
	
-- на портале в качестве правильного предлагалось решение:

SELECT p.purchase_id,
       e.last_name || ' ' || e.first_name AS employee,
       p.price_purchase,
       sum(p.price_purchase) over (PARTITION BY p.employee_id) AS total_by_employee
  FROM (SELECT p.purchase_id,
               p.employee_id,
               sum (pi.count * pi.price) AS price_purchase
          FROM purchase p,
               purchase_item pi
         WHERE pi.purchase_id = p.purchase_id
         GROUP BY p.purchase_id,
                  p.employee_id
       ) p
  LEFT JOIN
       employee e
    ON e.employee_id = p.employee_id
 ORDER BY employee NULLS LAST,
          p.purchase_id
		  
		  
		  
-- Мой вариант без использования вложенных запросов

SELECT
    p.purchase_id
  , CASE WHEN last_name IS NOT NULL
      THEN TRIM(CONCAT(last_name, ' ', first_name))
      ELSE NULL
      END employee
  , SUM(price*count) price_purchase
  , SUM(SUM(price*count)) OVER (PARTITION BY p.employee_id) total_by_employee
FROM purchase p 
  LEFT JOIN employee e
    ON e.employee_id = p.employee_id
  INNER JOIN purchase_item pi
    ON p.purchase_id = pi.purchase_id
GROUP BY p.purchase_id, last_name, first_name
ORDER BY employee NULLS LAST, purchase_id;