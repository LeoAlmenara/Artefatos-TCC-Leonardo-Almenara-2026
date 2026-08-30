
--C1--

SELECT
    cp.nome_categoria,
    COUNT(*) AS quantidade_produtos
FROM "Produtos" p
JOIN "Categorias_Produtos" cp
    ON cp.categoria_produto_id = p.categoria_produto_id
GROUP BY
    cp.categoria_produto_id,
    cp.nome_categoria
ORDER BY quantidade_produtos DESC
LIMIT 100;


--C2--

SELECT
    p.pedido_id,
    p.data_pedido,
    p.empresa_id,
    p.funcionario_id,
    sp.status AS nome_status
FROM "Pedidos" p
JOIN "Status_Pedido" sp
    ON p.status_pedido_id = sp.status_pedido_id
WHERE sp.status = 'Faturado';

--C3--

SELECT
    pc.pedido_compra_id,
    pc.fornecedor_id,
    pc.data_envio,
    pc.data_recebimento,
    pc.valor_pagamento,
    sc.status AS situacao_compra
FROM "Pedidos_Compra" pc
JOIN "Status_Pedido_Compra" sc
    ON pc.status_pedido_compra_id = sc.status_pedido_compra_id
WHERE sc.status = 'Recebido';

--C4--

SELECT
    p.pedido_id,
    p.data_pedido,
    e.nome_empresa,
    e.cidade,
    p.taxa_entrega,
    p.metodo_pagamento,
    p.data_pagamento
FROM "Pedidos" p
JOIN "Empresas" e
    ON p.empresa_id = e.empresa_id
WHERE p.data_pedido >= '2025-01-01'
  AND p.data_pedido < '2026-01-01'
ORDER BY p.empresa_id, data_pedido;

--C5--

SELECT
    pc.pedido_compra_id,
    pc.fornecedor_id,
    ipc.item_pedido_compra_id,
    p.produto_id,
    p.nome_produto,
    p.codigo_produto,
    ipc.quantidade,
    ipc.custo_unitario,
    ipc.data_recebimento
FROM "Pedidos_Compra" pc
JOIN "Itens_Pedido_Compra" ipc
    ON ipc.pedido_compra_id = pc.pedido_compra_id
JOIN "Produtos" p
    ON p.produto_id = ipc.produto_id;

--C6--

WITH vendas_por_produto AS (
    SELECT
        ip.produto_id,
        SUM(ip.quantidade) AS quantidade_vendida
    FROM "Itens_Pedido" ip
    GROUP BY ip.produto_id
),
estoque_atual AS (
    SELECT DISTINCT ON (ie.produto_id)
        ie.produto_id,
        ie.quantidade_estoque,
        ie.data_inventario
    FROM "Inventario_Estoque" ie
    ORDER BY
        ie.produto_id,
        ie.data_inventario DESC,
        ie.inventario_estoque_id DESC
)
SELECT
    p.produto_id,
    p.nome_produto,
    p.codigo_produto,
    vp.quantidade_vendida,
    ea.quantidade_estoque,
    ea.data_inventario AS data_ultimo_inventario
FROM "Produtos" p
JOIN vendas_por_produto vp
    ON vp.produto_id = p.produto_id
LEFT JOIN estoque_atual ea
    ON ea.produto_id = p.produto_id;

--C7--

SELECT
    p.produto_id,
    p.nome_produto,
    SUM(ip.quantidade) AS quantidade_total_vendida,
    SUM(ip.quantidade * ip.preco_unitario * (1 - ip.desconto / 100)) AS faturamento_total,
    AVG(ip.preco_unitario) AS preco_medio_venda,
    COUNT(DISTINCT ip.pedido_id) AS qtd_pedidos,
    COUNT(DISTINCT e.empresa_id) AS qtd_empresas_compradoras
FROM "Itens_Pedido" ip
JOIN "Pedidos" ped
    ON ped.pedido_id = ip.pedido_id
JOIN "Produtos" p
    ON p.produto_id = ip.produto_id
JOIN "Empresas" e
    ON e.empresa_id = ped.empresa_id
GROUP BY p.produto_id, p.nome_produto;

--C8--

SELECT
    e.empresa_id AS fornecedor_id,
    e.nome_empresa AS fornecedor,
    COUNT(DISTINCT pc.pedido_compra_id) AS qtd_pedidos_compra,
    SUM(ipc.quantidade) AS qtd_total_itens_adquiridos,
    SUM(ipc.quantidade * ipc.custo_unitario) AS valor_total_aquisicoes,
    AVG(ipc.custo_unitario) AS custo_medio_unitario,
    COUNT(DISTINCT ipc.produto_id) AS qtd_produtos_distintos,
    COUNT(DISTINCT p.categoria_produto_id) AS qtd_categorias_distintas
FROM "Itens_Pedido_Compra" ipc
JOIN "Pedidos_Compra" pc
    ON pc.pedido_compra_id = ipc.pedido_compra_id
JOIN "Empresas" e
    ON e.empresa_id = pc.fornecedor_id
JOIN "Produtos" p
    ON p.produto_id = ipc.produto_id
GROUP BY e.empresa_id, e.nome_empresa;

--C9--

WITH vendas_por_produto AS (
    SELECT
        ip.produto_id,
        SUM(ip.quantidade) AS quantidade_total_vendida
    FROM "Itens_Pedido" ip
    GROUP BY ip.produto_id
),
estoque_atual AS (
    SELECT DISTINCT ON (ie.produto_id)
        ie.produto_id,
        ie.quantidade_estoque,
        ie.data_inventario
    FROM "Inventario_Estoque" ie
    ORDER BY ie.produto_id, ie.data_inventario DESC, ie.inventario_estoque_id DESC
),
compras_por_produto AS (
    SELECT
        ipc.produto_id,
        SUM(ipc.quantidade) AS quantidade_total_adquirida,
        AVG(ipc.custo_unitario) AS custo_medio_aquisicao,
        MAX(pc.data_recebimento) AS data_ultima_compra
    FROM "Itens_Pedido_Compra" ipc
    JOIN "Pedidos_Compra" pc
        ON pc.pedido_compra_id = ipc.pedido_compra_id
    GROUP BY ipc.produto_id
)
SELECT
    p.produto_id,
    p.nome_produto,
    COALESCE(v.quantidade_total_vendida, 0) AS quantidade_total_vendida,
    e.quantidade_estoque AS quantidade_estoque_atual,
    p.nivel_reposicao,
    p.nivel_estoque_desejado,
    COALESCE(c.quantidade_total_adquirida, 0) AS quantidade_total_adquirida,
    c.custo_medio_aquisicao,
    c.data_ultima_compra,
    CASE
        WHEN e.quantidade_estoque IS NULL THEN 'SEM REGISTRO DE ESTOQUE'
        WHEN e.quantidade_estoque <= p.nivel_reposicao THEN 'REPOSIÇÃO NECESSÁRIA'
        ELSE 'ESTOQUE ADEQUADO'
    END AS status_reposicao
FROM "Produtos" p
LEFT JOIN vendas_por_produto v
    ON v.produto_id = p.produto_id
LEFT JOIN estoque_atual e
    ON e.produto_id = p.produto_id
LEFT JOIN compras_por_produto c
    ON c.produto_id = p.produto_id;

--C10--

WITH vendas_por_empresa AS (
    SELECT
        ped.empresa_id,
        COUNT(DISTINCT ip.pedido_id) AS qtd_pedidos_venda,
        SUM(ip.quantidade) AS qtd_itens_vendidos,
        SUM(
            ip.quantidade
            * ip.preco_unitario
            * (1 - ip.desconto / 100.0)
        ) AS valor_total_vendas,
        COUNT(DISTINCT ip.produto_id) AS qtd_produtos_vendidos
    FROM "Itens_Pedido" ip
    JOIN "Pedidos" ped
        ON ped.pedido_id = ip.pedido_id
    GROUP BY ped.empresa_id
),
compras_por_empresa AS (
    SELECT
        pc.fornecedor_id AS empresa_id,
        COUNT(DISTINCT ipc.pedido_compra_id) AS qtd_pedidos_compra,
        SUM(ipc.quantidade) AS qtd_itens_adquiridos,
        SUM(
            ipc.quantidade
            * ipc.custo_unitario
        ) AS valor_total_aquisicoes,
        COUNT(DISTINCT ipc.produto_id) AS qtd_produtos_adquiridos
    FROM "Itens_Pedido_Compra" ipc
    JOIN "Pedidos_Compra" pc
        ON pc.pedido_compra_id = ipc.pedido_compra_id
    GROUP BY pc.fornecedor_id
),
estoque_atual AS (
    SELECT DISTINCT ON (ie.produto_id)
        ie.produto_id,
        ie.quantidade_estoque
    FROM "Inventario_Estoque" ie
    ORDER BY
        ie.produto_id,
        ie.data_inventario DESC,
        ie.inventario_estoque_id DESC
),
estoque_global AS (
    SELECT
        COUNT(*) AS produtos_com_estoque,
        (SELECT COUNT(*) FROM "Produtos") - COUNT(*) AS produtos_sem_estoque,
        COUNT(*) FILTER (
            WHERE ea.quantidade_estoque <= p.nivel_reposicao
        ) AS produtos_abaixo_reposicao,
        SUM(ea.quantidade_estoque) AS estoque_total_disponivel
    FROM estoque_atual ea
    JOIN "Produtos" p
        ON p.produto_id = ea.produto_id
)
SELECT
    e.empresa_id,
    e.nome_empresa,

    COALESCE(v.qtd_pedidos_venda, 0) AS qtd_pedidos_venda,
    COALESCE(v.qtd_itens_vendidos, 0) AS qtd_itens_vendidos,
    COALESCE(v.valor_total_vendas, 0) AS valor_total_vendas,
    COALESCE(v.qtd_produtos_vendidos, 0) AS qtd_produtos_vendidos,

    COALESCE(c.qtd_pedidos_compra, 0) AS qtd_pedidos_compra,
    COALESCE(c.qtd_itens_adquiridos, 0) AS qtd_itens_adquiridos,
    COALESCE(c.valor_total_aquisicoes, 0) AS valor_total_aquisicoes,
    COALESCE(c.qtd_produtos_adquiridos, 0) AS qtd_produtos_adquiridos,

    eg.produtos_com_estoque,
    eg.produtos_sem_estoque,
    eg.produtos_abaixo_reposicao,
    eg.estoque_total_disponivel

FROM "Empresas" e
LEFT JOIN vendas_por_empresa v
    ON v.empresa_id = e.empresa_id
LEFT JOIN compras_por_empresa c
    ON c.empresa_id = e.empresa_id
CROSS JOIN estoque_global eg;