/*https://learndb.ru/courses/task/71

Задача
	Для каждой категории товаров получи пример товара.

	Выведи поля:
	name - название категории;
	product_example - название примера продукта в категории. Возьми первый по алфавиту товар в категории.
	Отсортируй результат по названию категории.*/
	
SELECT
    c.name AS name 
  , (SELECT p.name
     FROM product p
     WHERE c.category_id = p.category_id
     ORDER BY p.name
     LIMIT 1) product_example
FROM category c 
ORDER BY name

-- Также задачу можно решить с помощью оконной функции 

WITH t1 AS 
(
  SELECT
      c.name AS name 
    , p.name product_example
    , RANK() OVER (PARTITION BY p.category_id ORDER BY p.name) rnk
  FROM category c
    LEFT JOIN product p
      ON c.category_id = p.category_id
)
SELECT
    name
  , product_example
FROM t1
WHERE rnk = 1
ORDER BY name