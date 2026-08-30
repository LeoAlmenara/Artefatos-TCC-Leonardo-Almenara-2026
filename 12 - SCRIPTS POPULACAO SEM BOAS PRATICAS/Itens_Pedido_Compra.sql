WITH
pedidos AS (
    SELECT
        array_agg(pedido_compra_id ORDER BY pedido_compra_id) AS ids
    FROM "Pedidos_Compra"
),
produtos AS (
    SELECT
        array_agg(produto_id ORDER BY produto_id) AS ids,
        array_agg(codigo_produto ORDER BY produto_id) AS codigos,
        array_agg(nome_produto ORDER BY produto_id) AS nomes
    FROM "Produtos"
),
funcionarios AS (
    SELECT
        array_agg(funcionario_id ORDER BY funcionario_id) AS ids
    FROM "Funcionarios"
)

INSERT INTO "Itens_Pedido_Compra"
(
    pedido_compra_id,
    produto_id,
    quantidade,
    custo_unitario,
    data_recebimento,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao,
    codigo_produto,
    nome_produto
)

SELECT

    pdc.ids[idx_pedido],

    pr.ids[idx_produto],

    (floor(random()*100)+1)::int,

    ROUND((10 + random()*4990)::numeric,2),

    data_recebimento,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_cadastro,

    CASE
        WHEN alterado THEN f.ids[(floor(random()*array_length(f.ids,1))+1)::int]
        ELSE NULL
    END,

    CASE
        WHEN alterado THEN data_cadastro + (random()*INTERVAL '365 days')
        ELSE NULL
    END,

    pr.codigos[idx_produto],

    pr.nomes[idx_produto]

FROM
(
    SELECT
        (floor(random()*120000)+1)::int AS idx_pedido,
        (floor(random()*50000)+1)::int AS idx_produto,
        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day' AS data_recebimento,
        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day' AS data_cadastro,
        (random() < 0.30) AS alterado
    FROM generate_series(1,450000)
) base

CROSS JOIN pedidos pdc
CROSS JOIN produtos pr
CROSS JOIN funcionarios f;
