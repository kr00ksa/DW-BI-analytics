/*https://learndb.ru/courses/task/120

Задача
	Выведи доходы от покупок по всем магазинам нарастающим итогом в порядке оформления заказов.

	Выведи поля
	purchase_id - идентификатор заказа;
	purchase_date - дата заказа;
	price_purchase - полная стоимость заказа (сумма по всем позициям стоимости товара * количество товара);
	price_total - полная стоимость всех заказов, оформленных с самого начала и до оформления текущего заказа (включительно).
	Отсортируй результат по дате заказа.*/
	
-- предлагалось решение

SELECT p.purchase_id,
       p.purchase_date,
       p.price_purchase,
       sum (p.price_purchase) over (ORDER BY p.purchase_date) AS price_total
  FROM (SELECT p.purchase_id,
               p.purchase_date,
               sum (pi.count * pi.price) AS price_purchase
          FROM purchase p,
               purchase_item pi
         WHERE pi.purchase_id = p.purchase_id
         GROUP BY p.purchase_id,
                  p.purchase_date
       ) p
 ORDER BY p.purchase_date
 
 
 
-- Мой вариант без использования вложенных запросов

SELECT
      p.purchase_id
    , p.purchase_date
    , SUM(pi.price*pi.count) price_purchase
    , SUM(SUM(pi.price*pi.count)) OVER (ORDER BY purchase_date) price_total
FROM purchase p
  INNER JOIN purchase_item pi
    ON p.purchase_id = pi.purchase_id
GROUP BY p.purchase_date, p.purchase_id
ORDER BY purchase_date