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


/*https://learndb.ru/courses/task/96

Задача
	В договорах часто используют следующие конструкции: "Размер платежа составляет 5% от стоимости, но не менее 1000 рублей".
	Давай посчитаем предоплату за товары из таблицы product_price по этим правилам (5%, но не менее 1000 рублей).

	Выведи поля:
	product_id - идентификатор товара ;
	store_id - идентификатор магазина;
	price - стоимость;
	prepayment - величина предоплаты, округленная до рублей.
	
	Отсортируй результат по цене, идентификатору товара, идентификатору магазина.*/

SELECT
    product_id
  , store_id
  , price
  , ROUND(GREATEST(0.05 * price, 1000)) prepayment
FROM product_price
ORDER BY price, product_id, store_id