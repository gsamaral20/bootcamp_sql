-- Análise de vendas por pedidos
-- Quantos produtos únicos existem em cada pedido? 
-- Quantidade total de peças vendidas por pedido? 
-- Qual é o valor total vendido por produto?


SELECT 
	order_id,
	COUNT(DISTINCT product_id) AS unique_product,
	SUM(quantity) AS total_quantity,
	SUM(unit_price * quantity) AS total_price
FROM order_details
GROUP BY order_id
ORDER BY order_id;

-- Com Windows Function 

SELECT 
	DISTINCT order_id,
	COUNT(product_id) OVER (PARTITION BY order_id) AS unique_product,
	SUM(quantity) OVER (PARTITION BY order_id) AS total_quantity,
	SUM(unit_price * quantity) OVER (PARTITION BY order_id) AS total_price
FROM order_details
ORDER BY order_id;

-- Uma linha por pedido
SELECT 
	order_id,
	SUM(quantity) AS total_quantity
FROM order_details
GROUP BY order_id;

-- Uma linha por item, com o total do pedido
SELECT 
	order_id,
	product_id,
	quantity,
	SUM(quantity) OVER (PARTITION BY order_id) AS total_quantity
FROM order_details;

-- GROUP BY reduz o resultado para um resumo por grupo; 
-- WINDOW FUNCTION permite calcular agregados sem perder os detalhes individuais 
-- e utilizar partition by por diferentes colunas

-- Quais são os valores mínimo, 
-- máximo
-- e médio de frete pago por cada cliente? (tabela orders)

SELECT 
	customer_id,
	MIN(freight) AS min_freight,
	MAX(freight) AS max_freight,
	AVG(freight) AS avg_freight
FROM orders
GROUP BY customer_id
ORDER BY customer_id;

-- com Windows Function
SELECT 
	DISTINCT customer_id,
	MIN(freight) OVER(PARTITION BY orders) AS min_freight,
	MAX(freight) OVER(PARTITION BY orders) AS max_freight,
	AVG(freight) OVER(PARTITION BY orders) AS avg_freight
FROM orders
ORDER BY customer_id;

-- EXPLAIN ANALYZE mostra o plano de execução e o tempo real de cada etapa da consulta
EXPLAIN ANALYZE

SELECT 
	DISTINCT customer_id,
	MIN(freight) OVER(PARTITION BY orders) AS min_freight,
	MAX(freight) OVER(PARTITION BY orders) AS max_freight,
	AVG(freight) OVER(PARTITION BY orders) AS avg_freight
FROM orders
ORDER BY customer_id;
