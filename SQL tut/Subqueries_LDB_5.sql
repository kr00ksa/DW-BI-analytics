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

--План этого запроса после его выполнения:
1	Sort  (cost=440.10..443.38 rows=1310 width=176) (actual time=0.164..0.165 rows=9 loops=1)
2	  Sort Key: (count((count(p.purchase_id))) OVER (?)) DESC, p.employee_id, (sum((sum((pi.price * (pi.count)::numeric)))) OVER (?)) DESC, p.purchase_id
3	  Sort Method: quicksort  Memory: 26kB
4	  ->  WindowAgg  (cost=339.53..372.28 rows=1310 width=176) (actual time=0.139..0.149 rows=9 loops=1)
5	        ->  Sort  (cost=339.53..342.80 rows=1310 width=152) (actual time=0.130..0.131 rows=9 loops=1)
6	              Sort Key: p.purchase_id
7	              Sort Method: quicksort  Memory: 26kB
8	              ->  WindowAgg  (cost=245.50..271.70 rows=1310 width=152) (actual time=0.113..0.122 rows=9 loops=1)
9	                    ->  Sort  (cost=245.50..248.77 rows=1310 width=112) (actual time=0.101..0.102 rows=9 loops=1)
10	                          Sort Key: p.employee_id
11	                          Sort Method: quicksort  Memory: 26kB
12	                          ->  HashAggregate  (cost=151.47..177.67 rows=1310 width=112) (actual time=0.085..0.091 rows=9 loops=1)
13	                                Group Key: e.last_name, e.first_name, p.purchase_id
14	                                ->  Hash Join  (cost=69.05..99.07 rows=1310 width=94) (actual time=0.057..0.065 rows=15 loops=1)
15	                                      Hash Cond: (p.employee_id = e.employee_id)
16	                                      ->  Hash Join  (cost=48.25..74.80 rows=1310 width=30) (actual time=0.023..0.028 rows=18 loops=1)
17	                                            Hash Cond: (pi.purchase_id = p.purchase_id)
18	                                            ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.002..0.003 rows=18 loops=1)
19	                                            ->  Hash  (cost=27.00..27.00 rows=1700 width=8) (actual time=0.007..0.007 rows=11 loops=1)
20	                                                  Buckets: 2048  Batches: 1  Memory Usage: 17kB
21	                                                  ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.002..0.003 rows=11 loops=1)
22	                                      ->  Hash  (cost=14.80..14.80 rows=480 width=68) (actual time=0.023..0.023 rows=46 loops=1)
23	                                            Buckets: 1024  Batches: 1  Memory Usage: 11kB
24	                                            ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68) (actual time=0.005..0.010 rows=46 loops=1)
25	Planning time: 0.252 ms
26	Execution time: 0.298 ms

--Решение через CTE:
WITH pi1 AS
(
  SELECT
      purchase_id
    , SUM(price * count) price_purchase
  FROM purchase_item
  GROUP BY purchase_id
)
, emp AS
(
  SELECT
      p.employee_id 
    , last_name
    , first_name
    , SUM(price * count) price_total
    , COUNT(DISTINCT p.purchase_id) count_total    
  FROM employee e
    INNER JOIN purchase p
      ON e.employee_id = p.employee_id
    INNER JOIN purchase_item pi
      ON p.purchase_id = pi.purchase_id
  GROUP BY p.employee_id, last_name, first_name
)
SELECT
    p.employee_id
  , last_name
  , first_name  
  , p.purchase_id
  , price_purchase
  , ROUND(100 * price_purchase / price_total) price_total_percent
  , price_total
  , count_total
FROM emp
  INNER JOIN purchase p
    ON emp.employee_id = p.employee_id
  INNER JOIN pi1
    ON pi1.purchase_id = p.purchase_id 
ORDER BY count_total DESC
      , p.employee_id
      , price_purchase DESC
      , purchase_id
	  
--План этого запроса после его выполнения:
1	Sort  (cost=456.43..459.70 rows=1310 width=176) (actual time=0.323..0.324 rows=9 loops=1)
2	  Sort Key: emp.count_total DESC, p.employee_id, pi1.price_purchase DESC, p.purchase_id
3	  Sort Method: quicksort  Memory: 26kB
4	  CTE pi1
5	    ->  HashAggregate  (cost=36.20..38.70 rows=200 width=36) (actual time=0.025..0.029 rows=11 loops=1)
6	          Group Key: purchase_item.purchase_id
7	          ->  Seq Scan on purchase_item  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.001..0.003 rows=18 loops=1)
8	  CTE emp
9	    ->  GroupAggregate  (cost=166.90..209.47 rows=1310 width=108) (actual time=0.176..0.207 rows=8 loops=1)
10	          Group Key: p_1.employee_id, e.last_name, e.first_name
11	          ->  Sort  (cost=166.90..170.17 rows=1310 width=94) (actual time=0.150..0.151 rows=15 loops=1)
12	                Sort Key: p_1.employee_id, e.last_name, e.first_name
13	                Sort Method: quicksort  Memory: 26kB
14	                ->  Hash Join  (cost=69.05..99.07 rows=1310 width=94) (actual time=0.086..0.095 rows=15 loops=1)
15	                      Hash Cond: (p_1.employee_id = e.employee_id)
16	                      ->  Hash Join  (cost=48.25..74.80 rows=1310 width=30) (actual time=0.034..0.040 rows=18 loops=1)
17	                            Hash Cond: (pi.purchase_id = p_1.purchase_id)
18	                            ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.003..0.005 rows=18 loops=1)
19	                            ->  Hash  (cost=27.00..27.00 rows=1700 width=8) (actual time=0.013..0.013 rows=11 loops=1)
20	                                  Buckets: 2048  Batches: 1  Memory Usage: 17kB
21	                                  ->  Seq Scan on purchase p_1  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.004..0.005 rows=11 loops=1)
22	                      ->  Hash  (cost=14.80..14.80 rows=480 width=68) (actual time=0.037..0.037 rows=46 loops=1)
23	                            Buckets: 1024  Batches: 1  Memory Usage: 11kB
24	                            ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68) (actual time=0.012..0.017 rows=46 loops=1)
25	  ->  Hash Join  (cost=55.27..140.42 rows=1310 width=176) (actual time=0.264..0.304 rows=9 loops=1)
26	        Hash Cond: (emp.employee_id = p.employee_id)
27	        ->  CTE Scan on emp  (cost=0.00..26.20 rows=1310 width=108) (actual time=0.178..0.212 rows=8 loops=1)
28	        ->  Hash  (cost=52.77..52.77 rows=200 width=40) (actual time=0.069..0.069 rows=9 loops=1)
29	              Buckets: 1024  Batches: 1  Memory Usage: 9kB
30	              ->  Hash Join  (cost=48.25..52.77 rows=200 width=40) (actual time=0.051..0.064 rows=11 loops=1)
31	                    Hash Cond: (pi1.purchase_id = p.purchase_id)
32	                    ->  CTE Scan on pi1  (cost=0.00..4.00 rows=200 width=36) (actual time=0.026..0.036 rows=11 loops=1)
33	                    ->  Hash  (cost=27.00..27.00 rows=1700 width=8) (actual time=0.007..0.007 rows=11 loops=1)
34	                          Buckets: 2048  Batches: 1  Memory Usage: 17kB
35	                          ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.001..0.002 rows=11 loops=1)
36	Planning time: 0.687 ms
37	Execution time: 0.523 ms

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
		  
--План этого запроса после его выполнения:
1	Sort  (cost=439.90..443.17 rows=1310 width=176) (actual time=0.236..0.237 rows=9 loops=1)
2	  Sort Key: ep.count_total DESC, e.employee_id, pp.price_purchase, p.purchase_id
3	  Sort Method: quicksort  Memory: 26kB
4	  ->  Hash Join  (cost=323.83..372.07 rows=1310 width=176) (actual time=0.210..0.222 rows=9 loops=1)
5	        Hash Cond: (e.employee_id = ep.employee_id)
6	        ->  Hash Join  (cost=154.55..189.50 rows=1310 width=108) (actual time=0.105..0.111 rows=9 loops=1)
7	              Hash Cond: (p.employee_id = e.employee_id)
8	              ->  Hash Join  (cost=133.75..165.22 rows=1310 width=40) (actual time=0.070..0.074 rows=11 loops=1)
9	                    Hash Cond: (p.purchase_id = pp.purchase_id)
10	                    ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.002..0.003 rows=11 loops=1)
11	                    ->  Hash  (cost=117.37..117.37 rows=1310 width=36) (actual time=0.057..0.057 rows=11 loops=1)
12	                          Buckets: 2048  Batches: 1  Memory Usage: 17kB
13	                          ->  Subquery Scan on pp  (cost=87.90..117.37 rows=1310 width=36) (actual time=0.045..0.054 rows=11 loops=1)
14	                                ->  HashAggregate  (cost=87.90..104.27 rows=1310 width=36) (actual time=0.045..0.052 rows=11 loops=1)
15	                                      Group Key: p_1.purchase_id
16	                                      ->  Hash Join  (cost=48.25..74.80 rows=1310 width=26) (actual time=0.021..0.026 rows=18 loops=1)
17	                                            Hash Cond: (pi.purchase_id = p_1.purchase_id)
18	                                            ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.002..0.003 rows=18 loops=1)
19	                                            ->  Hash  (cost=27.00..27.00 rows=1700 width=4) (actual time=0.006..0.006 rows=11 loops=1)
20	                                                  Buckets: 2048  Batches: 1  Memory Usage: 17kB
21	                                                  ->  Seq Scan on purchase p_1  (cost=0.00..27.00 rows=1700 width=4) (actual time=0.001..0.002 rows=11 loops=1)
22	              ->  Hash  (cost=14.80..14.80 rows=480 width=68) (actual time=0.026..0.026 rows=46 loops=1)
23	                    Buckets: 1024  Batches: 1  Memory Usage: 11kB
24	                    ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68) (actual time=0.006..0.012 rows=46 loops=1)
25	        ->  Hash  (cost=166.78..166.78 rows=200 width=44) (actual time=0.094..0.094 rows=8 loops=1)
26	              Buckets: 1024  Batches: 1  Memory Usage: 9kB
27	              ->  Subquery Scan on ep  (cost=142.63..166.78 rows=200 width=44) (actual time=0.063..0.087 rows=9 loops=1)
28	                    ->  GroupAggregate  (cost=142.63..164.78 rows=200 width=44) (actual time=0.063..0.085 rows=9 loops=1)
29	                          Group Key: p_2.employee_id
30	                          ->  Sort  (cost=142.63..145.90 rows=1310 width=30) (actual time=0.044..0.045 rows=18 loops=1)
31	                                Sort Key: p_2.employee_id
32	                                Sort Method: quicksort  Memory: 26kB
33	                                ->  Hash Join  (cost=48.25..74.80 rows=1310 width=30) (actual time=0.027..0.032 rows=18 loops=1)
34	                                      Hash Cond: (pi_1.purchase_id = p_2.purchase_id)
35	                                      ->  Seq Scan on purchase_item pi_1  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.004..0.005 rows=18 loops=1)
36	                                      ->  Hash  (cost=27.00..27.00 rows=1700 width=8) (actual time=0.007..0.008 rows=11 loops=1)
37	                                            Buckets: 2048  Batches: 1  Memory Usage: 17kB
38	                                            ->  Seq Scan on purchase p_2  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.001..0.003 rows=11 loops=1)
39	Planning time: 0.400 ms
40	Execution time: 0.377 ms