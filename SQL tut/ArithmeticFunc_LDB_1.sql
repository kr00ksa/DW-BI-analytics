/*https://learndb.ru/courses/task/88

Задача
В некоторых магазинах существует "гарантия лучшей цены". Если вы находите такой же товар дешевле в другом магазине, то вам предоставляют скидку в размере определенного процента от разницы цен.

В этом задании будем предоставлять скидку в размере 50% от разницы цен. Например, если товар в текущем магазине стоит 2000, а в другом 1800, то скидка составит (2000 - 1800) * 0.5 = 100.

Определи размер скидки на товар из product_price от минимальной цены на этот товар по всем магазинам.
product_id - идентификатор товара;
store_id - идентификатор магазина;
price - цена на товар в магазине;
discount - размер 50% скидки от минимальной стоимости на товар в других магазинах.

Отсортируй результат сначала по идентификатору товара, затем по цене на товар в магазине.*/

--C CTE:

WITH t1 AS
(
  SELECT 
      product_id
    , MIN(price) min_price
  FROM product_price
  GROUP BY product_id
)
SELECT
    pp.product_id
  , store_id
  , price
  , (price - min_price) * 0.5 discount
FROM product_price pp
  INNER JOIN t1
    ON pp.product_id = t1.product_id
ORDER BY product_id, price, store_id

--Или короче, с оконной функцией:

SELECT
    product_id
  , store_id
  , price
  , (price - MIN(price) OVER (PARTITION BY product_id)) * 0.5 discount
FROM product_price pp
ORDER BY product_id, price


/*https://learndb.ru/courses/task/91

Задача
	Получи идентификатор временной зоны со сдвигом относительно UTC в 4 часа.

	Выведи один столбец:
	timezone_id - идентификатор временной зоны.*/

SELECT timezone_id
FROM timezone
WHERE RIGHT(time_offset, -4)::integer = 4


/*https://learndb.ru/courses/task/93

Задача
	Из таблицы product_price получи среднюю стоимость товара в магазине.

	Выведи столбцы:
	store_id - идентификатор магазина;
	average_price - средняя стоимость товара в магазине;
	average_price_round - средняя стоимость товара в магазине, округленная до копеек (2 знака после запятой)
	average_price_trunc - средняя стоимость товара в магазине, усеченная до копеек (2 знака после запятой).
	
	Отсортируй результат по average_price по возрастанию.*/

SELECT
    store_id
  , AVG(price) average_price
  , ROUND(AVG(price), 2) average_price_round
  , TRUNC(AVG(price), 2) average_price_trunc
FROM product_price
GROUP BY store_id
ORDER BY average_price