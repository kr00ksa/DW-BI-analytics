/*https://learndb.ru/courses/task/42

Задача
	Получи информацию об отрицательных ценах на товары (таких нет, но давай попробуем :) )

	min_price - минимальная цена;
	max_price - максимальная цена;
	count_rows - количество строк.
	И не забудь добавить в запрос WHERE price < 0.*/

SELECT
    MIN(price) min_price
  , MAX(price) max_price
  , COUNT(*) count_rows
FROM product_price
WHERE price < 0