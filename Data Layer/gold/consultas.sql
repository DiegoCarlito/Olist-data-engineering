-- 1. VISÃO COMERCIAL: Receita Total e Ticket Médio por Mês
-- Pergunta: Como está a evolução do faturamento?
SELECT 
    t.nr_ano,
    t.nr_mes,
    t.nm_mes,
    COUNT(DISTINCT f.nk_id_pedido) AS total_pedidos,
    SUM(f.vlr_total) AS receita_total,
    ROUND(AVG(f.vlr_total), 2) AS ticket_medio
FROM dw.ft_vendas f
JOIN dw.dim_tempo t ON f.sk_tempo = t.sk_tempo
GROUP BY t.nr_ano, t.nr_mes, t.nm_mes
ORDER BY t.nr_ano, t.nr_mes;

-- 2. VISÃO COMERCIAL: Top 10 Categorias de Produto
-- Pergunta: Quais produtos geram mais receita?
SELECT 
    p.nm_categoria,
    SUM(f.vlr_total) AS receita_total,
    COUNT(*) AS qtd_itens_vendidos
FROM dw.ft_vendas f
JOIN dw.dim_produto p ON f.sk_produto = p.sk_produto
WHERE p.nm_categoria IS NOT NULL
GROUP BY p.nm_categoria
ORDER BY receita_total DESC
LIMIT 10;

-- 3. VISÃO LOGÍSTICA: Performance de Entrega por Estado
-- Pergunta: Onde estão nossos gargalos de entrega?
SELECT 
    c.sg_estado AS estado_cliente,
    ROUND(AVG(f.qtd_dias_entrega), 1) AS media_dias_entrega,
    COUNT(CASE WHEN f.fl_atraso = true THEN 1 END) AS total_atrasos,
    ROUND(
        (COUNT(CASE WHEN f.fl_atraso = true THEN 1 END)::NUMERIC / COUNT(*)) * 100, 
    2) AS taxa_atraso_percentual
FROM dw.ft_vendas f
JOIN dw.dim_cliente c ON f.sk_cliente = c.sk_cliente
GROUP BY c.sg_estado
ORDER BY media_dias_entrega DESC;

-- 4. VISÃO SATISFAÇÃO: Impacto do Atraso na Nota (NPS Simulado)
-- Pergunta: Como o atraso afeta a avaliação do cliente?
SELECT 
    CASE WHEN f.fl_atraso = true THEN 'Com Atraso' ELSE 'No Prazo' END AS status_entrega,
    ROUND(AVG(f.nota_avaliacao), 2) AS nota_media,
    COUNT(*) AS total_avaliacoes
FROM dw.ft_vendas f
WHERE f.nota_avaliacao IS NOT NULL
GROUP BY f.fl_atraso;

-- 5. VISÃO GERAL: KPIs Acumulados (Card Principal)
SELECT 
    SUM(vlr_total) AS receita_total_acumulada,
    COUNT(DISTINCT nk_id_pedido) AS total_pedidos,
    ROUND(AVG(qtd_dias_entrega), 1) AS tempo_medio_entrega_geral
FROM dw.ft_vendas;