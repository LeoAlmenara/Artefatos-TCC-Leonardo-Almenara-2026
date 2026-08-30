WITH
produtos AS (
    SELECT array_agg(produto_id ORDER BY produto_id) AS ids
    FROM "Produtos"
),
funcionarios AS (
    SELECT array_agg(funcionario_id ORDER BY funcionario_id) AS ids
    FROM "Funcionarios"
)

INSERT INTO "Inventario_Estoque"
(
    data_inventario,
    produto_id,
    quantidade_estoque,
    quantidade_esperada,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    TIMESTAMP '2018-01-01'
        + (random() * 3000) * INTERVAL '1 day',

    p.ids[(floor(random()*array_length(p.ids,1))+1)::int],

    CASE
        WHEN random() < 0.80 THEN
            (
                floor(quantidade_esperada + ((random()*40)-20))
            )::numeric
        ELSE
            (
                floor(quantidade_esperada + ((random()*40)-20))
                + 0.5
            )::numeric
    END,

    quantidade_esperada,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    TIMESTAMP '2018-01-01'
        + (random() * 3000) * INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    NOW()

FROM
(
    SELECT

        CASE
            WHEN random() < 0.80 THEN
                (floor(random()*451)+50)::numeric
            ELSE
                ((floor(random()*451)+50)::numeric + 0.5)
        END AS quantidade_esperada

    FROM generate_series(1,500000)

) q

CROSS JOIN produtos p
CROSS JOIN funcionarios f;