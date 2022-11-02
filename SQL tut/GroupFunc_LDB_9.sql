/*https://learndb.ru/courses/task/45

Задача
	Для товаров категории товаров с идентификаторами 6 и 7 получи минимальную и максимальную стоимость из таблицы product_price. Выведи столбцы:

	category_id - идентификатор категории товара;
	name - название товара;
	price_min - минимальная стоимость товара;
	price_max - максимальная стоимость товара.
	Отсортируй результат сначала по category_id, затем по названию товара.*/

SELECT
    category_id
  , name
  , MIN(price) price_min
  , MAX(price) price_max
FROM product_price pp
  INNER JOIN product p
    ON p.product_id = pp.product_id
WHERE category_id IN (6, 7)
GROUP BY p.product_id, category_id, name
ORDER BY category_id, name