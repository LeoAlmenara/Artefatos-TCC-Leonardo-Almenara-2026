WITH
pedidos AS (
    SELECT
        array_agg(pedido_id ORDER BY pedido_id) AS ids
    FROM "Pedidos"
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

INSERT INTO "Itens_Pedido"
(
    pedido_id,
    produto_id,
    quantidade,
    preco_unitario,
    desconto,
    status_pedido_id,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao,
    codigo_produto,
    nome_produto
)

SELECT

    p.ids[idx_pedido],

    pr.ids[idx_produto],

    (floor(random()*10)+1)::int,

    ROUND((20 + random()*4980)::numeric,2),

    ROUND((random()*20)::numeric,2),

    (floor(random()*8)+1)::int,

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
        (floor(random()*800000)+1)::int AS idx_pedido,
        (floor(random()*50000)+1)::int AS idx_produto,

        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day'
            AS data_cadastro,

        (random() < 0.30) AS alterado

    FROM generate_series(1,3500000)

) base

CROSS JOIN pedidos p
CROSS JOIN produtos pr
CROSS JOIN funcionarios f;
