/*https://learndb.ru/courses/task/43

Задача
	Для каждого товара получи минимальную и максимальную стоимость из таблицы product_price. Выведи столбцы:

	product_id - идентификатор товара;
	price_min - минимальная стоимость товара;
	price_max - максимальная стоимость товара.
	Отсортируй результат по идентификатору товара.*/

SELECT
    product_id
  , MIN(price) price_min
  , MAX(price) price_max
FROM product_price
GROUP BY product_id
ORDER BY product_id