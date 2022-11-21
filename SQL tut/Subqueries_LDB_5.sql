/*https://learndb.ru/courses/task/100

Задача
	Сформируй статистику продаж по сотрудникам.

	Выведи столбцы:
	employee_id - идентификатор сотрудника (purchase.employee_id).
	last_name - фамилия сотрудника.
	first_name - имя сотрудника.
	purchase_id - идентификатор заказа.
	price_purchase - сумма заказа. Равна сумме price * count по всем товарам заказа.
	price_total_percent - процент суммы заказа от суммы всех заказов, оформленных сотрудником, округленный до целого (100 * price_purchase / price_total).
	price_total - сумма всех заказов, оформленных сотрудником.
	count_total - количество заказов, оформленных сотрудником.
	
	Отсортируй результат по:
	Количеству заказов, оформленных сотрудником, по убыванию;
	Идентификатору сотрудника;
	Сумме заказа по убыванию;
	Идентификатору заказа.
	
Решение через оконные функции:*/

SELECT
    p.employee_id 
  , last_name
  , first_name
  , p.purchase_id
  , SUM(SUM(price * count)) OVER (PARTITION BY p.purchase_id) AS price_purchase
  , ROUND(SUM(SUM(price * count)) OVER (PARTITION BY p.purchase_id) / SUM(SUM(price * count)) OVER w * 100) AS price_total_percent
  , SUM(SUM(price * count)) OVER w AS price_total
  , COUNT(COUNT(p.purchase_id)) OVER w AS count_total
FROM employee e
  INNER JOIN purchase p
    ON e.employee_id = p.employee_id
  INNER JOIN purchase_item pi
    ON p.purchase_id = pi.purchase_id
GROUP BY p.employee_id, last_name, first_name, p.purchase_id
  WINDOW w AS (PARTITION BY p.employee_id)
ORDER BY count_total DESC, employee_id, price_purchase DESC, purchase_id

--План этого запроса:
1	Sort  (cost=440.10..443.38 rows=1310 width=176)
2	  Sort Key: (count((count(p.purchase_id))) OVER (?)) DESC, p.employee_id, (sum((sum((pi.price * (pi.count)::numeric)))) OVER (?)) DESC, p.purchase_id
3	  ->  WindowAgg  (cost=339.53..372.28 rows=1310 width=176)
4	        ->  Sort  (cost=339.53..342.80 rows=1310 width=152)
5	              Sort Key: p.purchase_id
6	              ->  WindowAgg  (cost=245.50..271.70 rows=1310 width=152)
7	                    ->  Sort  (cost=245.50..248.77 rows=1310 width=112)
8	                          Sort Key: p.employee_id
9	                          ->  HashAggregate  (cost=151.47..177.67 rows=1310 width=112)
10	                                Group Key: e.last_name, e.first_name, p.purchase_id
11	                                ->  Hash Join  (cost=69.05..99.07 rows=1310 width=94)
12	                                      Hash Cond: (p.employee_id = e.employee_id)
13	                                      ->  Hash Join  (cost=48.25..74.80 rows=1310 width=30)
14	                                            Hash Cond: (pi.purchase_id = p.purchase_id)
15	                                            ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26)
16	                                            ->  Hash  (cost=27.00..27.00 rows=1700 width=8)
17	                                                  ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8)
18	                                      ->  Hash  (cost=14.80..14.80 rows=480 width=68)
19	                                            ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68)

--Решение, предложенное разработчиками курса:
SELECT e.employee_id,
       e.last_name,
       e.first_name,
       p.purchase_id,
       pp.price_purchase,
       round (100 * price_purchase / ep.price_total) AS price_total_percent,
       ep.price_total,
       ep.count_total
  FROM purchase p,
       (SELECT p.employee_id,
               sum (pi.price * pi.count) AS price_total,
               count (distinct p.purchase_id) AS count_total
          FROM purchase p,
               purchase_item pi
         WHERE pi.purchase_id = p.purchase_id
         GROUP BY p.employee_id
       ) ep,
       (SELECT p.purchase_id,
               sum (pi.price * pi.count) as price_purchase
          FROM purchase p,
               purchase_item pi
         WHERE pi.purchase_id = p.purchase_id
         GROUP BY p.purchase_id
       ) pp,
       employee e
 WHERE e.employee_id = p.employee_id
   AND ep.employee_id = p.employee_id
   AND pp.purchase_id = p.purchase_id
 ORDER BY ep.count_total DESC,
          e.employee_id,
          pp.price_purchase,
          p.purchase_id
		  
--План этого запроса:
1	Sort  (cost=439.90..443.17 rows=1310 width=176)
2	  Sort Key: ep.count_total DESC, e.employee_id, pp.price_purchase, p.purchase_id
3	  ->  Hash Join  (cost=323.83..372.07 rows=1310 width=176)
4	        Hash Cond: (e.employee_id = ep.employee_id)
5	        ->  Hash Join  (cost=154.55..189.50 rows=1310 width=108)
6	              Hash Cond: (p.employee_id = e.employee_id)
7	              ->  Hash Join  (cost=133.75..165.22 rows=1310 width=40)
8	                    Hash Cond: (p.purchase_id = pp.purchase_id)
9	                    ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8)
10	                    ->  Hash  (cost=117.37..117.37 rows=1310 width=36)
11	                          ->  Subquery Scan on pp  (cost=87.90..117.37 rows=1310 width=36)
12	                                ->  HashAggregate  (cost=87.90..104.27 rows=1310 width=36)
13	                                      Group Key: p_1.purchase_id
14	                                      ->  Hash Join  (cost=48.25..74.80 rows=1310 width=26)
15	                                            Hash Cond: (pi.purchase_id = p_1.purchase_id)
16	                                            ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26)
17	                                            ->  Hash  (cost=27.00..27.00 rows=1700 width=4)
18	                                                  ->  Seq Scan on purchase p_1  (cost=0.00..27.00 rows=1700 width=4)
19	              ->  Hash  (cost=14.80..14.80 rows=480 width=68)
20	                    ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68)
21	        ->  Hash  (cost=166.78..166.78 rows=200 width=44)
22	              ->  Subquery Scan on ep  (cost=142.63..166.78 rows=200 width=44)
23	                    ->  GroupAggregate  (cost=142.63..164.78 rows=200 width=44)
24	                          Group Key: p_2.employee_id
25	                          ->  Sort  (cost=142.63..145.90 rows=1310 width=30)
26	                                Sort Key: p_2.employee_id
27	                                ->  Hash Join  (cost=48.25..74.80 rows=1310 width=30)
28	                                      Hash Cond: (pi_1.purchase_id = p_2.purchase_id)
29	                                      ->  Seq Scan on purchase_item pi_1  (cost=0.00..23.10 rows=1310 width=26)
30	                                      ->  Hash  (cost=27.00..27.00 rows=1700 width=8)
31	                                            ->  Seq Scan on purchase p_2  (cost=0.00..27.00 rows=1700 width=8)