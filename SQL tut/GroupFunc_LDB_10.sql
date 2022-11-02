/*https://learndb.ru/courses/task/46

Задача
	Получи информацию о минимальной и максимальной стоимости товаров в каждой категории товаров в магазине из таблицы product_price. Выведи столбцы:

	store_id - идентификатор магазина;
	category_id - идентификатор категории товара;
	price_min - минимальная стоимость товара;
	price_max - максимальная стоимость товара.
	Отсортируй результат сначала по идентификатору магазина, затем по идентификатору категории товара.*/

SELECT
    store_id
  , category_id
  , MIN(price) price_min
  , MAX(price) price_max
FROM product_price pp
  INNER JOIN product p
    ON p.product_id = pp.product_id
GROUP BY store_id, category_id
ORDER BY store_id, category_id