/*https://learndb.ru/courses/task/101

Задача
	Найди сотрудников, которые продали меньше, чем среднестатистический сотрудник.

	Будем считать, что среднестатистический сотрудник продал на сумму, равную среднему значению от суммы продаж каждого сотрудника. Например, если в системе три сотрудника и они продали на суммы 100, 100 и 400 соответственно, то среднестатистический сотрудник продал на сумму (100 + 100 + 400) / 3 = 200.

	Сумма продаж сотрудника определяется как сумма произведения стоимости товара на количество по всем заказам, которые оформил сотрудник.
	Сотрудников, которые не сделали ни одной продажи, в расчет не берем.

	Выведи информацию по каждому сотруднику:
	employee_id - идентификатор сотрудника;
	last_name - фамилия сотрудника;
	first_name - имя сотрудника;
	sum_purchases - сумма продаж сотрудника.
	
	Отсортируй результат сначала по сумме продаж сотрудника, затем по идентификатору сотрудника.*/
	
WITH sum_emp_t AS
(
  SELECT
      p.employee_id
    , last_name
    , first_name   
    , SUM(price * count) sum_purchases
  FROM employee emp
    INNER JOIN purchase p
      ON emp.employee_id = p.employee_id
    INNER JOIN purchase_item pi
      ON pi.purchase_id = p.purchase_id
  GROUP BY p.employee_id, last_name, first_name 
  ORDER BY p.employee_id
)
, avg_emp AS
(
  SELECT AVG(sum_purchases) avg_sum
  FROM sum_emp_t
)
SELECT
    employee_id
  , last_name
  , first_name
  , sum_purchases
FROM  sum_emp_t, avg_emp
WHERE sum_purchases < avg_sum
ORDER BY sum_purchases, employee_id


/*https://learndb.ru/courses/task/102

Задача
	Проанализируй суммы продаж сотрудников.
	Определи двух человек с самой низкой суммой продаж и двух человек с самой высокой суммой продаж.

	Сумма продаж сотрудника определяется как сумма произведения стоимости товара на количество по всем заказам, которые оформил сотрудник.

	По этим сотрудникам выведи информацию:
	employee_id - идентификатор сотрудника;
	last_name - фамилия сотрудника;
	first_name - имя сотрудника;
	sum_purchases - сумма продаж сотрудника;
	action - строка, принимающая одно из двух значений: 'Уволить' или 'Повысить'. Для двух сотрудников с худшими показателями отображается 'Уволить'. Для сотрудников с лучшими показателями - 'Повысить'.
	
	Отсортируй результат сначала по сумме продаж, затем по идентификатору сотрудника.*/
	
--Решение через CTE и оконные функции:
WITH sum_emp_t AS
(
  SELECT
      p.employee_id
    , last_name
    , first_name
    , SUM(price * count) sum_purchases
  FROM employee e
    INNER JOIN purchase p
        ON e.employee_id = p.employee_id
    INNER JOIN purchase_item pi
        ON pi.purchase_id = p.purchase_id
  GROUP BY p.employee_id, last_name, first_name
)
, min_max_t AS
(
  SELECT
      employee_id
    , ROW_NUMBER() OVER(ORDER BY sum_purchases) min
    , ROW_NUMBER() OVER(ORDER BY sum_purchases DESC) max
  FROM sum_emp_t
)
SELECT
    sum_emp_t.employee_id
  , last_name
  , first_name
  , sum_purchases
  , CASE
    WHEN min IN (1, 2) THEN 'Уволить'
    WHEN max IN (1, 2) THEN 'Повысить'
    END AS action
FROM sum_emp_t
  INNER JOIN min_max_t
    ON sum_emp_t.employee_id = min_max_t.employee_id
WHERE min IN (1, 2) OR max IN (1, 2)
ORDER BY sum_purchases, sum_emp_t.employee_id

--План этого запроса после его выполнения:
QUERY PLAN
1	Sort  (cost=419.11..419.54 rows=170 width=132) (actual time=0.247..0.247 rows=4 loops=1)
2	  Sort Key: sum_emp_t.sum_purchases, sum_emp_t.employee_id
3	  Sort Method: quicksort  Memory: 25kB
4	  CTE sum_emp_t
5	    ->  HashAggregate  (cost=118.72..135.10 rows=1310 width=100) (actual time=0.155..0.162 rows=8 loops=1)
6	          Group Key: p.employee_id, e.last_name, e.first_name
7	          ->  Hash Join  (cost=69.05..99.07 rows=1310 width=90) (actual time=0.123..0.132 rows=15 loops=1)
8	                Hash Cond: (p.employee_id = e.employee_id)
9	                ->  Hash Join  (cost=48.25..74.80 rows=1310 width=26) (actual time=0.031..0.037 rows=18 loops=1)
10	                      Hash Cond: (pi.purchase_id = p.purchase_id)
11	                      ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.002..0.003 rows=18 loops=1)
12	                      ->  Hash  (cost=27.00..27.00 rows=1700 width=8) (actual time=0.013..0.013 rows=11 loops=1)
13	                            Buckets: 2048  Batches: 1  Memory Usage: 17kB
14	                            ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.005..0.006 rows=11 loops=1)
15	                ->  Hash  (cost=14.80..14.80 rows=480 width=68) (actual time=0.024..0.024 rows=46 loops=1)
16	                      Buckets: 1024  Batches: 1  Memory Usage: 11kB
17	                      ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68) (actual time=0.006..0.012 rows=46 loops=1)
18	  CTE min_max_t
19	    ->  WindowAgg  (cost=184.78..207.71 rows=1310 width=52) (actual time=0.046..0.052 rows=8 loops=1)
20	          ->  Sort  (cost=184.78..188.06 rows=1310 width=44) (actual time=0.044..0.044 rows=8 loops=1)
21	                Sort Key: sum_emp_t_1.sum_purchases DESC
22	                Sort Method: quicksort  Memory: 25kB
23	                ->  WindowAgg  (cost=94.03..116.95 rows=1310 width=44) (actual time=0.029..0.032 rows=8 loops=1)
24	                      ->  Sort  (cost=94.03..97.30 rows=1310 width=36) (actual time=0.024..0.024 rows=8 loops=1)
25	                            Sort Key: sum_emp_t_1.sum_purchases
26	                            Sort Method: quicksort  Memory: 25kB
27	                            ->  CTE Scan on sum_emp_t sum_emp_t_1  (cost=0.00..26.20 rows=1310 width=36) (actual time=0.000..0.011 rows=8 loops=1)
28	  ->  Hash Join  (cost=33.08..70.01 rows=170 width=132) (actual time=0.231..0.234 rows=4 loops=1)
29	        Hash Cond: (sum_emp_t.employee_id = min_max_t.employee_id)
30	        ->  CTE Scan on sum_emp_t  (cost=0.00..26.20 rows=1310 width=100) (actual time=0.156..0.157 rows=8 loops=1)
31	        ->  Hash  (cost=32.75..32.75 rows=26 width=20) (actual time=0.061..0.061 rows=4 loops=1)
32	              Buckets: 1024  Batches: 1  Memory Usage: 9kB
33	              ->  CTE Scan on min_max_t  (cost=0.00..32.75 rows=26 width=20) (actual time=0.048..0.057 rows=4 loops=1)
34	                    Filter: ((min = ANY ('{1,2}'::bigint[])) OR (max = ANY ('{1,2}'::bigint[])))
35	                    Rows Removed by Filter: 4
36	Planning time: 0.347 ms
37	Execution time: 0.410 ms


--Решение через CTE и UNION ALL
WITH sum_emp_t AS
(
  SELECT
      p.employee_id
    , last_name
    , first_name
    , SUM(price * count) sum_purchases
  FROM employee e
    INNER JOIN purchase p
        ON e.employee_id = p.employee_id
    INNER JOIN purchase_item pi
        ON pi.purchase_id = p.purchase_id
  GROUP BY p.employee_id, last_name, first_name
)
, min_t AS
(
  SELECT       
      employee_id
    , last_name
    , first_name
    , sum_purchases
    , 'Уволить' AS action
  FROM sum_emp_t
  ORDER BY sum_purchases
  LIMIT 2
)
, max_t AS
(
  SELECT       
      employee_id
    , last_name
    , first_name
    , sum_purchases
    , 'Повысить' AS action
  FROM sum_emp_t
  ORDER BY sum_purchases DESC
  LIMIT 2
)
SELECT *
FROM min_t

UNION ALL

SELECT *
FROM max_t

ORDER BY sum_purchases, employee_id

--План этого запроса после его выполнения:
QUERY PLAN
1	Sort  (cost=213.83..213.84 rows=4 width=132) (actual time=0.132..0.132 rows=4 loops=1)
2	  Sort Key: min_t.sum_purchases, min_t.employee_id
3	  Sort Method: quicksort  Memory: 25kB
4	  CTE sum_emp_t
5	    ->  HashAggregate  (cost=118.72..135.10 rows=1310 width=100) (actual time=0.085..0.091 rows=8 loops=1)
6	          Group Key: p.employee_id, e.last_name, e.first_name
7	          ->  Hash Join  (cost=69.05..99.07 rows=1310 width=90) (actual time=0.060..0.068 rows=15 loops=1)
8	                Hash Cond: (p.employee_id = e.employee_id)
9	                ->  Hash Join  (cost=48.25..74.80 rows=1310 width=26) (actual time=0.029..0.034 rows=18 loops=1)
10	                      Hash Cond: (pi.purchase_id = p.purchase_id)
11	                      ->  Seq Scan on purchase_item pi  (cost=0.00..23.10 rows=1310 width=26) (actual time=0.001..0.003 rows=18 loops=1)
12	                      ->  Hash  (cost=27.00..27.00 rows=1700 width=8) (actual time=0.009..0.009 rows=11 loops=1)
13	                            Buckets: 2048  Batches: 1  Memory Usage: 17kB
14	                            ->  Seq Scan on purchase p  (cost=0.00..27.00 rows=1700 width=8) (actual time=0.002..0.003 rows=11 loops=1)
15	                ->  Hash  (cost=14.80..14.80 rows=480 width=68) (actual time=0.021..0.021 rows=46 loops=1)
16	                      Buckets: 1024  Batches: 1  Memory Usage: 11kB
17	                      ->  Seq Scan on employee e  (cost=0.00..14.80 rows=480 width=68) (actual time=0.004..0.009 rows=46 loops=1)
18	  CTE min_t
19	    ->  Limit  (cost=39.30..39.31 rows=2 width=132) (actual time=0.106..0.106 rows=2 loops=1)
20	          ->  Sort  (cost=39.30..42.58 rows=1310 width=132) (actual time=0.105..0.105 rows=2 loops=1)
21	                Sort Key: sum_emp_t.sum_purchases
22	                Sort Method: top-N heapsort  Memory: 25kB
23	                ->  CTE Scan on sum_emp_t  (cost=0.00..26.20 rows=1310 width=132) (actual time=0.086..0.095 rows=8 loops=1)
24	  CTE max_t
25	    ->  Limit  (cost=39.30..39.31 rows=2 width=132) (actual time=0.012..0.013 rows=2 loops=1)
26	          ->  Sort  (cost=39.30..42.58 rows=1310 width=132) (actual time=0.012..0.012 rows=2 loops=1)
27	                Sort Key: sum_emp_t_1.sum_purchases DESC
28	                Sort Method: top-N heapsort  Memory: 25kB
29	                ->  CTE Scan on sum_emp_t sum_emp_t_1  (cost=0.00..26.20 rows=1310 width=132) (actual time=0.000..0.001 rows=8 loops=1)
30	  ->  Append  (cost=0.00..0.08 rows=4 width=132) (actual time=0.106..0.121 rows=4 loops=1)
31	        ->  CTE Scan on min_t  (cost=0.00..0.04 rows=2 width=132) (actual time=0.106..0.107 rows=2 loops=1)
32	        ->  CTE Scan on max_t  (cost=0.00..0.04 rows=2 width=132) (actual time=0.013..0.013 rows=2 loops=1)
33	Planning time: 0.256 ms
34	Execution time: 0.243 ms