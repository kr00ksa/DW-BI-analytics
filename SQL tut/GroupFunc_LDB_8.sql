/*https://learndb.ru/courses/task/44

Задача
	Для каждого товара получи минимальную и максимальную стоимость из таблицы product_price. Выведи столбцы:

	name - название товара;
	price_min - минимальная стоимость товара;
	price_max - максимальная стоимость товара.
	Отсортируй результат по названию товара.*/

SELECT
    name
  , MIN(price) price_min
  , MAX(price) price_max
FROM product_price pp
  INNER JOIN product p
    ON p.product_id = pp.product_id
GROUP BY p.product_id, name
ORDER BY  name