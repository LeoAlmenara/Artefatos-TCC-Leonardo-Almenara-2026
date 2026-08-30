WITH
pedidos AS (
    SELECT array_agg(pedido_compra_id ORDER BY pedido_compra_id) AS ids
    FROM "Pedidos_Compra"
),
produtos AS (
    SELECT array_agg(produto_id ORDER BY produto_id) AS ids
    FROM "Produtos"
),
funcionarios AS (
    SELECT array_agg(funcionario_id ORDER BY funcionario_id) AS ids
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
    data_alteracao
)

SELECT

    pdc.ids[(floor(random()*array_length(pdc.ids,1))+1)::int],

    pr.ids[(floor(random()*array_length(pr.ids,1))+1)::int],

    CASE
        WHEN random() < 0.80 THEN
            (floor(random()*100)+1)::numeric
        ELSE
            ((floor(random()*100)+1)::numeric + 0.5)
    END,

    ROUND(
        (10 + random()*4990)::numeric,
        2
    ),

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    NOW()

FROM generate_series(1,450000)

CROSS JOIN pedidos pdc
CROSS JOIN produtos pr
CROSS JOIN funcionarios f;