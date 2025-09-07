-- Qual foi o total de receitas no ano de 1997?
-- Precisamos calcular o total: (od.unit_price * od.quantity) * (1-od.discount) as total_price

CREATE VIEW total_revenues_1997_view AS
SELECT SUM((od.unit_price * od.quantity) * (1-od.discount)) AS total_price 
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

-- Faça uma análise de crescimento mensal e o cálculo de YTD
-- Receitas Mensais
CREATE VIEW view_receitas_acumuladas AS
WITH ReceitasMensais AS (
    SELECT
        EXTRACT(YEAR FROM orders.order_date) AS Ano,
        EXTRACT(MONTH FROM orders.order_date) AS Mes,
        SUM(order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)) AS Receita_Mensal
    FROM
        orders
    INNER JOIN
        order_details ON orders.order_id = order_details.order_id
    GROUP BY
        EXTRACT(YEAR FROM orders.order_date),
        EXTRACT(MONTH FROM orders.order_date)
),
ReceitasAcumuladas AS (
    SELECT
        Ano,
        Mes,
        Receita_Mensal,
        SUM(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) AS Receita_YTD
    FROM
        ReceitasMensais
)
SELECT
    Ano,
    Mes,
    Receita_Mensal,
    Receita_Mensal - LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) AS Diferenca_Mensal,
    Receita_YTD,
    (Receita_Mensal - LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes)) / LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) * 100 AS Percentual_Mudanca_Mensal
FROM
    ReceitasAcumuladas
ORDER BY
    Ano, Mes;