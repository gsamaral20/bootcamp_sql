-- Desafio Aula 03

-- 1. Cria um relatório para todos os pedidos de 1996 e seus clientes (152 linhas)
select * 
from orders
where order_date > '1995-12-31' and order_date < '1997-01-01';

-- Cria um relatório para todos os pedidos de 1996 e seus clientes (152 linhas)
SELECT *
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1996; -- EXTRACT(part FROM date) part pode ser YEAR, MONTH, DAY, etc

-- 2. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem funcionários (5 linhas)

select e.city, count(distinct e.employee_id) as qtd_funcionarios, count(distinct customer_id) as qtd_clientes
from employees e
left join customers c on e.city = c.city
group by e.city

-- 3. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem clientes (69 linhas)

select c.city, count(distinct e.employee_id) as qtd_funcionarios, count(distinct customer_id) as qtd_clientes
from employees e
right join customers c on e.city = c.city
group by c.city


-- 4.Cria um relatório que mostra o número de funcionários e clientes de cada cidade (71 linhas)
SELECT
	COALESCE(e.city, c.city) AS cidade,
	COUNT(DISTINCT e.employee_id) AS numero_de_funcionarios,
	COUNT(DISTINCT c.customer_id) AS numero_de_clientes
FROM employees e 
FULL JOIN customers c ON e.city = c.city
GROUP BY e.city, c.city
ORDER BY cidade;

-- A função COALESCE retorna o primeiro valor não nulo entre os argumentos.
-- Neste caso, usamos COALESCE(e.city, c.city) para garantir que, mesmo quando a cidade existir só na tabela de funcionários ou só na tabela de clientes, 
-- ainda assim teremos o nome da cidade exibido na coluna 'cidade'.


-- 5. Cria um relatório que mostra a quantidade total de produtos encomendados.
-- Mostra apenas registros para produtos para os quais a quantidade encomendada é menor que 200 (5 linhas)
select o.product_id, p.product_name, sum(o.quantity) as qtd_encomendada
from order_details o
join products p on p.product_id = o.product_id
group by o.product_id, p.product_name
having sum(o.quantity) < 200
order by sum(o.quantity) desc;
 
-- 6. Cria um relatório que mostra o total de pedidos por cliente desde 31 de dezembro de 1996.
-- O relatório deve retornar apenas linhas para as quais o total de pedidos é maior que 15 (5 linhas)
SELECT customer_id, COUNT(order_id) AS qtd_pedidos
FROM orders
WHERE order_date > '1996-12-31'
GROUP BY customer_id
HAVING COUNT(order_id) > 15;
