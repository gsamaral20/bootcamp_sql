-- RANK() DENSE_RANK() E ROW_NUMBER()

-- Classificação dos produtos mais vendidos
SELECT p.product_id,
	p.product_name,
	SUM(o.unit_price * o.quantity) AS total_vendas
	
FROM order_details o
JOIN products p ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY SUM(o.unit_price * o.quantity) DESC

SELECT p.product_id,
	p.product_name,
	(o.unit_price * o.quantity) AS total_vendas,
	ROW_NUMBER() OVER(ORDER BY(o.unit_price * o.quantity) DESC) AS order_rn,
	RANK () OVER(ORDER BY(o.unit_price * o.quantity) DESC ) AS order_rank,
	DENSE_RANK() OVER(ORDER BY(o.unit_price * o.quantity) DESC) AS order_dense
FROM order_details o
JOIN products p ON p.product_id = o.product_id

-- PERCENT_RANK() E CUME_DIST()

SELECT  
  order_id, 
  unit_price * quantity AS total_sale,
  ROUND(CAST(PERCENT_RANK() OVER (PARTITION BY order_id 
    ORDER BY (unit_price * quantity) DESC) AS numeric), 2) AS order_percent_rank,
  ROUND(CAST(CUME_DIST() OVER (PARTITION BY order_id 
    ORDER BY (unit_price * quantity) DESC) AS numeric), 2) AS order_cume_dist
FROM  
  order_details;

  -- Este SELECT calcula o total de venda por item (unit_price * quantity)
-- e, para cada item dentro do mesmo pedido (order_id), calcula duas métricas de ranking:

-- 1. PERCENT_RANK(): indica a **posição relativa** do item dentro do pedido,
--    com base no valor total da venda. Vai de 0 (menor posição) até 1 (maior),
--    ignorando empates. Por exemplo:
--    - Maior valor => 1.00
--    - Menor valor => 0.00
--    - Se houver 3 itens, os percent_ranks serão 0.00, 0.50, 1.00

-- 2. CUME_DIST(): indica a **proporção acumulada** de itens com valor **maior ou igual**
--    ao valor do item atual dentro do pedido. Vai de 0 < x ≤ 1, incluindo empates.
--    Exemplo com 4 itens: se 3 forem maiores ou iguais ao atual, cume_dist = 3/4 = 0.75

-- Ambas as funções usam PARTITION BY order_id para fazer os cálculos **separadamente por pedido**,
-- e ordenam os itens de cada pedido pelo total da venda em ordem decrescente (DESC).


-- NTILE()

SELECT first_name, last_name, title,
   NTILE(3) OVER (ORDER BY first_name) AS group_number
FROM employees;


-- LAG(), LEAD()
-- LAG(): Permite acessar o valor da linha anterior dentro de um conjunto de resultados. Isso é particularmente útil para fazer comparações com a linha atual ou identificar tendências ao longo do tempo.
-- LEAD(): Permite acessar o valor da próxima linha dentro de um conjunto de resultados, possibilitando comparações com a linha subsequente.

SELECT 
  customer_id, 
  TO_CHAR(order_date, 'YYYY-MM-DD') AS order_date, 
  shippers.company_name AS shipper_name, 
  LAG(freight) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS previous_order_freight, 
  freight AS order_freight, 
  LEAD(freight) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS next_order_freight
FROM 
  orders
JOIN 
  shippers ON shippers.shipper_id = orders.ship_via;