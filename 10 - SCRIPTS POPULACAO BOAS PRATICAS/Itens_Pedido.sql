WITH
pedidos AS (
    SELECT array_agg(pedido_id ORDER BY pedido_id) AS ids
    FROM "Pedidos"
),
produtos AS (
    SELECT array_agg(produto_id ORDER BY produto_id) AS ids
    FROM "Produtos"
),
funcionarios AS (
    SELECT array_agg(funcionario_id ORDER BY funcionario_id) AS ids
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
    data_alteracao
)

SELECT

    p.ids[(floor(random()*array_length(p.ids,1))+1)::int],

    pr.ids[(floor(random()*array_length(pr.ids,1))+1)::int],

    CASE
        WHEN random() < 0.80 THEN
            (floor(random()*10)+1)::numeric
        ELSE
            ((floor(random()*10)+1)::numeric + 0.5)
    END,

    ROUND(
        (20 + random()*4980)::numeric,
        2
    ),

    ROUND(
        (random()*20)::numeric,
        2
    ),

    (floor(random()*8)+1)::int,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    NOW()

FROM generate_series(1,3500000)

CROSS JOIN pedidos p
CROSS JOIN produtos pr
CROSS JOIN funcionarios f;