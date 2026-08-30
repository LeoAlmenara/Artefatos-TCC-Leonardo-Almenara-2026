--C1--

SELECT
    nome_categoria,
    COUNT(*) AS quantidade_produtos
FROM "Produtos"
GROUP BY nome_categoria
ORDER BY quantidade_produtos DESC
LIMIT 100;

--C2--

SELECT
    pedido_id,
    funcionario_id,
    empresa_id,
    nome_empresa,
    data_pedido,
    data_fatura,
    status,
    metodo_pagamento,
    data_pagamento,
    taxa_entrega
FROM "Pedidos"
WHERE status = 'Faturado';

--C3--

SELECT
    pedido_compra_id,
    fornecedor_id,
    nome_fornecedor,
    telefone_fornecedor,
    status,
    data_envio,
    data_aprovacao,
    data_recebimento,
    valor_pagamento,
    metodo_pagamento
FROM "Pedidos_Compra"
WHERE status = 'Recebido';

--C4--

SELECT
    pedido_id,
    e.empresa_id,
    e.nome_empresa,
    cidade_empresa,
    telefone_empresa,
    data_pedido,
    data_fatura,
    data_envio,
    status,
    funcionario_id,
    nome_funcionario,
    metodo_pagamento,
    taxa_entrega
FROM "Pedidos" P
JOIN "Empresas" e
    ON p.empresa_id = e.empresa_id
WHERE data_pedido >= '2025-01-01'
  AND data_pedido < '2026-01-01'
ORDER BY empresa_id, data_pedido;

--C5--

SELECT
    pc.pedido_compra_id,
    pc.fornecedor_id,
    pc.nome_fornecedor,
    pc.telefone_fornecedor,
    pc.status AS status_pedido_compra,
    pc.data_envio,
    pc.data_recebimento AS data_recebimento_pedido,
    ipc.item_pedido_compra_id,
    ipc.quantidade,
    ipc.custo_unitario,
    ipc.data_recebimento AS data_recebimento_item,
    p.produto_id,
    p.nome_produto,
    p.codigo_produto,
    p.nome_categoria,
    p.custo_unitario_padrao
FROM "Pedidos_Compra" pc
JOIN "Itens_Pedido_Compra" ipc
    ON ipc.pedido_compra_id = pc.pedido_compra_id
JOIN "Produtos" p
    ON p.produto_id = ipc.produto_id;

--C6--

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
    ORDER BY
        ie.produto_id,
        ie.data_inventario DESC,
        ie.inventario_estoque_id DESC
)
SELECT
    p.produto_id,
    p.nome_produto,
    p.codigo_produto,
    vp.quantidade_total_vendida,
    ea.quantidade_estoque AS quantidade_estoque_atual,
    ea.data_inventario AS data_estoque_atual
FROM "Produtos" p
JOIN vendas_por_produto vp
    ON vp.produto_id = p.produto_id
LEFT JOIN estoque_atual ea
    ON ea.produto_id = p.produto_id;

--C7--

SELECT
    p.produto_id,
    p.nome_produto,
    p.codigo_produto,
    p.nome_categoria,
    SUM(ip.quantidade) AS quantidade_total_vendida,
    SUM(ip.quantidade * ip.preco_unitario * (1 - ip.desconto / 100.0)) AS faturamento_total,
    AVG(ip.preco_unitario) AS preco_medio_venda,
    COUNT(DISTINCT ip.pedido_id) AS qtd_pedidos_distintos,
    COUNT(DISTINCT ped.empresa_id) AS qtd_empresas_distintas
FROM "Itens_Pedido" ip
JOIN "Produtos" p
    ON p.produto_id = ip.produto_id
JOIN "Pedidos" ped
    ON ped.pedido_id = ip.pedido_id
GROUP BY
    p.produto_id,
    p.nome_produto,
    p.codigo_produto,
    p.nome_categoria;

--C8--

SELECT
    e.empresa_id AS fornecedor_id,
    e.nome_empresa AS nome_fornecedor,
    e.cidade,
    COUNT(DISTINCT pc.pedido_compra_id) AS qtd_pedidos_compra,
    SUM(ipc.quantidade) AS qtd_total_itens_adquiridos,
    SUM(ipc.quantidade * ipc.custo_unitario) AS valor_total_aquisicoes,
    AVG(ipc.custo_unitario) AS custo_medio_unitario,
    COUNT(DISTINCT p.produto_id) AS qtd_produtos_distintos,
    COUNT(DISTINCT p.nome_categoria) AS qtd_categorias_distintas
FROM "Itens_Pedido_Compra" ipc
JOIN "Pedidos_Compra" pc
    ON pc.pedido_compra_id = ipc.pedido_compra_id
JOIN "Produtos" p
    ON p.produto_id = ipc.produto_id
JOIN "Empresas" e
    ON e.empresa_id = pc.fornecedor_id
GROUP BY
    e.empresa_id,
    e.nome_empresa,
    e.cidade;

--C9--

WITH vendas_produto AS (
    SELECT
        ip.produto_id,
        SUM(ip.quantidade) AS qtd_vendida
    FROM "Itens_Pedido" ip
    GROUP BY ip.produto_id
),
estoque_atual AS (
    SELECT DISTINCT ON (ie.produto_id)
        ie.produto_id,
        ie.quantidade_estoque,
        ie.data_inventario
    FROM "Inventario_Estoque" ie
    ORDER BY ie.produto_id, ie.data_inventario DESC
),
compras_produto AS (
    SELECT
        ipc.produto_id,
        SUM(ipc.quantidade) AS qtd_comprada,
        AVG(ipc.custo_unitario) AS custo_medio_aquisicao,
        MAX(ipc.data_recebimento) AS data_ultima_aquisicao,
        COUNT(DISTINCT pc.pedido_compra_id) AS qtd_pedidos_compra
    FROM "Itens_Pedido_Compra" ipc
    JOIN "Pedidos_Compra" pc
        ON pc.pedido_compra_id = ipc.pedido_compra_id
    GROUP BY ipc.produto_id
)
SELECT
    p.produto_id,
    p.nome_produto,
    p.nivel_reposicao,
    p.nivel_estoque_desejado,
    COALESCE(vp.qtd_vendida, 0) AS qtd_total_vendida,
    ea.quantidade_estoque AS qtd_estoque_atual,
    ea.data_inventario AS data_estoque_atual,
    COALESCE(cp.qtd_comprada, 0) AS qtd_total_comprada,
    cp.custo_medio_aquisicao,
    cp.data_ultima_aquisicao,
    cp.qtd_pedidos_compra,
    CASE
        WHEN ea.quantidade_estoque IS NULL THEN 'SEM REGISTRO DE ESTOQUE'
        WHEN ea.quantidade_estoque <= p.nivel_reposicao THEN 'REPOSIÇÃO NECESSÁRIA'
        ELSE 'ESTOQUE ADEQUADO'
    END AS situacao_reposicao
FROM "Produtos" p
LEFT JOIN vendas_produto vp ON vp.produto_id = p.produto_id
LEFT JOIN estoque_atual ea ON ea.produto_id = p.produto_id
LEFT JOIN compras_produto cp ON cp.produto_id = p.produto_id;

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