/*https://learndb.ru/courses/task/70

Задача
	Получи список категорий товаров, в которых нет ни одного товара. Выведи поля

	category_id - идентификатор категории;
	name - название категории.
	Отсортируй результат по названию категории.*/
	
--Решение 1:
SELECT 
    tc.category_id
  , tc.name
FROM category tc
  LEFT JOIN product p
    ON tc.category_id = p.category_id
WHERE p.product_id IS NULL
ORDER BY tc.name

--Решение 2:
SELECT
    category_id
  , name
FROM category c
WHERE category_id IN (SELECT tc.category_id
                       FROM category tc
                         LEFT JOIN product p
                           ON tc.category_id = p.category_id
                       WHERE p.product_id IS NULL)
ORDER BY name   

--Решение 3:
SELECT
    category_id
  , name
FROM category c
WHERE (SELECT 1
       FROM product p
       WHERE c.category_id = p.category_id
       LIMIT 1) IS NULL
ORDER BY name   

