WITH
produtos AS (
    SELECT
        array_agg(produto_id ORDER BY produto_id) AS ids,
        array_agg(codigo_produto ORDER BY produto_id) AS codigos,
        array_agg(nome_produto ORDER BY produto_id) AS nomes
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
    data_alteracao,
    codigo_produto,
    nome_produto
)

SELECT

    data_inventario,

    p.ids[idx],

    CASE
        WHEN random() < 0.80 THEN
            floor(quantidade_esperada + ((random()*40)-20))::numeric
        ELSE
            floor(quantidade_esperada + ((random()*40)-20))::numeric + 0.5
    END,

    quantidade_esperada,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_cadastro,

    CASE
        WHEN alterado THEN f.ids[(floor(random()*array_length(f.ids,1))+1)::int]
        ELSE NULL
    END,

    CASE
        WHEN alterado THEN data_cadastro + (random() * INTERVAL '365 days')
        ELSE NULL
    END,

    p.codigos[idx],

    p.nomes[idx]

FROM
(
    SELECT

        CASE
            WHEN random() < 0.80 THEN
                (floor(random()*451)+50)::numeric
            ELSE
                (floor(random()*451)+50)::numeric + 0.5
        END AS quantidade_esperada,

        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day'
            AS data_inventario,

        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day'
            AS data_cadastro,

        (random() < 0.30) AS alterado,

        (floor(random()*50000)+1)::int AS idx

    FROM generate_series(1,500000)

) q

CROSS JOIN produtos p
CROSS JOIN funcionarios f;
