/*https://learndb.ru/courses/task/121

Задача
	Выведи доходы от покупок нарастающим итогом в порядке оформления заказов по каждому магазину в отдельности.

	Выведи поля:

	store_id - идентификатор магазина;
	purchase_date - дата заказа;
	price_purchase - полная стоимость заказа (сумма по всем позициям стоимости товара * количество товара);
	price_total - полная стоимость всех заказов, оформленных с самого начала и до оформления текущего заказа (включительно) в рамках магазина.
	Отсортируй результат сначала по идентификатору магазина, затем по дате заказа.*/
	
	
-- на портале в качестве правильного предлагалось решение:

SELECT p.store_id,
       p.purchase_date,
       p.price_purchase,
       sum (p.price_purchase) over (PARTITION BY p.store_id ORDER BY p.purchase_date) AS price_total
  FROM (SELECT p.store_id,
               p.purchase_date,
               sum (pi.count * pi.price) AS price_purchase
          FROM purchase p,
               purchase_item pi
         WHERE pi.purchase_id = p.purchase_id
         GROUP BY p.store_id,
                  p.purchase_id,
                  p.purchase_date
       ) p
 ORDER BY p.store_id, 
          p.purchase_date
 
 
-- Мой вариант без использования вложенных запросов

SELECT
    store_id
  , purchase_date
  , SUM(price*count) price_purchase
  , SUM(SUM(price*count)) OVER (PARTITION BY store_id ORDER BY purchase_date) price_total
FROM purchase p
  LEFT JOIN purchase_item pi
    ON p.purchase_id = pi.purchase_id
GROUP BY store_id, purchase_date
ORDER BY store_id, purchase_date