/*https://learndb.ru/courses/task/69

Задача
	Для каждой категории товаров получи пример товара.

	Выведи поля:
	name - название категории;
	product_example - название примера продукта в категории. Возьми первый по алфавиту товар в категории.*/
	
SELECT
    c.name AS name 
  , (SELECT p.name
     FROM product p
     WHERE c.category_id = p.category_id
     ORDER BY p.name
     LIMIT 1) product_example
FROM category c 
ORDER BY name