/*https://learndb.ru/courses/task/39

Задача
	Получи следующую информацию по таблице цен на товары product_price:

	price_min - минимальная цена товара;
	price_avg - средняя цена товара;
	price_max - максимальная цена товара.*/
	
SELECT
    MIN(price) price_min
  , AVG(price) price_avg
  , MAX(price) price_max
FROM product_price