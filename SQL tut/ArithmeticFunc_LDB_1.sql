/*https://learndb.ru/courses/task/87

Задача
Определи общую стоимость по каждому товару из таблицы purchase_item.

Выведи столбцы:
purchase_id - идентификатор заказа;
product_id - идентификатор товара;
price - цена за единицу товара;
count - количество единиц товара;
total_price - общая стоимость за весь товар.

Отсортируй результат сначала по идентификатору заказа, затем по идентификатору товара.*/
	
SELECT 
    purchase_id
  , product_id
  , price
  , count
  , price * count total_price 
FROM purchase_item
ORDER BY purchase_id, product_id