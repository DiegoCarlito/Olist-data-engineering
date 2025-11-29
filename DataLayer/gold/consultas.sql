-- 1. Receita Total e Ticket Médio por Mês (Visão Financeira)
SELECT 
    t.num_ano, t.num_mes, t.nom_mes,
    COUNT(DISTINCT f.ntk_idn_ped) AS total_pedidos,
    SUM(f.vlr_tot) AS receita_total,
    ROUND(AVG(f.vlr_tot), 2) AS ticket_medio
FROM dw.fat_ped f
JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY t.num_ano, t.num_mes, t.nom_mes
ORDER BY t.num_ano, t.num_mes;

-- 2. Top 10 Categorias por Receita (Curva ABC)
SELECT 
    p.nom_cat,
    SUM(f.vlr_tot) AS receita_total,
    COUNT(*) AS qtd_itens,
    ROUND((SUM(f.vlr_tot) / (SELECT SUM(vlr_tot) FROM dw.fat_ped)) * 100, 2) AS perc_receita_global
FROM dw.fat_ped f
JOIN dw.dim_pro p ON f.srk_pro = p.srk_pro
WHERE p.nom_cat <> 'unknown'
GROUP BY p.nom_cat
ORDER BY receita_total DESC
LIMIT 10;

-- 3. Performance Logística por Estado (Gargalos)
SELECT 
    c.sig_est,
    ROUND(AVG(f.qtd_dia_ent), 1) AS media_dias_entrega,
    COUNT(CASE WHEN f.flg_atr = true THEN 1 END) AS total_atrasos,
    ROUND((COUNT(CASE WHEN f.flg_atr = true THEN 1 END)::NUMERIC / COUNT(*)) * 100, 2) AS taxa_atraso_pct
FROM dw.fat_ped f
JOIN dw.dim_cli c ON f.srk_cli = c.srk_cli
GROUP BY c.sig_est
ORDER BY media_dias_entrega DESC;

-- 4. NPS Simulado: Impacto do Atraso na Nota
SELECT 
    CASE WHEN f.flg_atr = true THEN 'Com Atraso' ELSE 'No Prazo' END AS status_entrega,
    ROUND(AVG(f.num_ava), 2) AS nota_media,
    COUNT(*) AS volume_avaliacoes
FROM dw.fat_ped f
WHERE f.num_ava IS NOT NULL
GROUP BY f.flg_atr;

-- 5. Ranking de Vendedores: Quem mais fatura em SP?
WITH vendedores_sp AS (
    SELECT v.ntk_idn_vnd, SUM(f.vlr_tot) as faturamento
    FROM dw.fat_ped f
    JOIN dw.dim_vnd v ON f.srk_vnd = v.srk_vnd
    WHERE v.sig_est = 'SP'
    GROUP BY v.ntk_idn_vnd
)
SELECT *, RANK() OVER (ORDER BY faturamento DESC) as ranking
FROM vendedores_sp
LIMIT 10;

-- 6. Análise de Parcelamento: O brasileiro parcela muito?
SELECT 
    pag.nr_par as parcelas,
    COUNT(DISTINCT f.ntk_idn_ped) as qtd_pedidos,
    ROUND(AVG(f.vlr_tot), 2) as ticket_medio
FROM dw.fat_ped f
JOIN dw.dim_pag pag ON f.srk_pag = pag.srk_pag
GROUP BY pag.nr_par
ORDER BY pag.nr_par;

-- 7. Sazonalidade Semanal: Qual o dia mais forte de vendas?
SELECT 
    t.nom_dia_sem,
    COUNT(DISTINCT f.ntk_idn_ped) as total_pedidos,
    SUM(f.vlr_tot) as receita
FROM dw.fat_ped f
JOIN dw.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY t.nom_dia_sem
ORDER BY receita DESC;

-- 8. Produtos "Problemáticos": Categorias com pior nota média
SELECT 
    p.nom_cat,
    ROUND(AVG(f.num_ava), 2) as nota_media,
    COUNT(*) as total_vendas
FROM dw.fat_ped f
JOIN dw.dim_pro p ON f.srk_pro = p.srk_pro
GROUP BY p.nom_cat
HAVING COUNT(*) > 500 -- Filtrar irrelevantes
ORDER BY nota_media ASC
LIMIT 10;

-- 9. Receita por Região (Sudeste domina?)
SELECT 
    CASE 
        WHEN c.sig_est IN ('SP', 'RJ', 'MG', 'ES') THEN 'Sudeste'
        WHEN c.sig_est IN ('PR', 'SC', 'RS') THEN 'Sul'
        WHEN c.sig_est IN ('BA', 'PE', 'CE', 'MA', 'PB', 'RN', 'AL', 'SE', 'PI') THEN 'Nordeste'
        WHEN c.sig_est IN ('MT', 'MS', 'GO', 'DF') THEN 'Centro-Oeste'
        ELSE 'Norte'
    END AS regiao,
    SUM(f.vlr_tot) as receita_total
FROM dw.fat_ped f
JOIN dw.dim_cli c ON f.srk_cli = c.srk_cli
GROUP BY 1
ORDER BY receita_total DESC;

-- 10. KPIs Gerais Acumulados
SELECT 
    SUM(vlr_tot) AS receita_acumulada,
    COUNT(DISTINCT ntk_idn_ped) AS pedidos_totais,
    ROUND(AVG(qtd_dia_ent), 1) AS prazo_medio_geral
FROM dw.fat_ped;