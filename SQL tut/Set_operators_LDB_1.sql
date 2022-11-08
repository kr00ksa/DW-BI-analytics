/*https://learndb.ru/courses/task/66

Задача
	Найди все товары и категории товаров, в названии которых встречается подстрока 'но' без учета регистра. В результате выведи два столбца:

	name - название товара или категории товаров;
	type - тип объекта: 'Категория' для категорий товаров, 'Товар' для товаров.*/
	
SELECT
    name
  , 'Товар' AS type
FROM product
WHERE name ilike '%но%'

UNION

SELECT
    name
  , 'Категория' AS type
FROM category
WHERE name ilike '%но%'


/*https://learndb.ru/courses/task/61

Задача
	Выведи товары заказа (таблицы purchase_item и purchase), которые проданы по цене из каталога (таблица product_price).

	Выведи столбцы:
	product_id - идентификатор товара;
	store_id - идентификатор магазина;
	price - цена.*/
	
SELECT
    product_id
  , store_id
  , price  
FROM purchase_item pi
  INNER JOIN purchase p
    ON pi.purchase_id = p.purchase_id
    
INTERSECT

SELECT
    product_id
  , store_id
  , price  
FROM product_price


/*https://learndb.ru/courses/task/62

Задача
	Выведи товары заказа (таблицы purchase_item и purchase), которых больше нет в каталоге в магазине заказа по цене заказа (таблица product_price).

	Выведи столбцы:
	product_id - идентификатор товара;
	store_id - идентификатор магазина;
	price - цена.*/
	
SELECT
    product_id
  , store_id
  , price  
FROM purchase_item pi
  INNER JOIN purchase p
    ON pi.purchase_id = p.purchase_id
    
EXCEPT

SELECT
    product_id
  , store_id
  , price  
FROM product_price


/*https://learndb.ru/courses/task/67

Задача
	Выведи идентификаторы товаров, которые есть в таблице product_price, но нет в таблице purchase_item, либо есть в таблице purchase_item, но нет в product_price.

	Отсортируй результат по идентификатору товара product_id.*/
	
(
  SELECT
      product_id
  FROM product_price
  
  EXCEPT
  
  SELECT
      product_id
  FROM purchase_item
)
UNION ALL
(
  SELECT
      product_id
  FROM purchase_item
  
  EXCEPT
  
  SELECT
      product_id
  FROM product_price
)
ORDER BY product_id