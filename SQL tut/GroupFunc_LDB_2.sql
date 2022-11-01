/*https://learndb.ru/courses/task/123

Задача
	Найди товар, который чаще всего встречается в заказах (purchase_item). Выведи информацию о нем:

	product_id - идентификатор товара;
	name - название;
	description - описание.*/

WITH t1 AS
(
  SELECT 
      MODE() WITHIN GROUP (ORDER BY product_id) mp
  FROM purchase_item
)
SELECT
    product_id
  , name
  , description
FROM product, t1
WHERE product_id = mp