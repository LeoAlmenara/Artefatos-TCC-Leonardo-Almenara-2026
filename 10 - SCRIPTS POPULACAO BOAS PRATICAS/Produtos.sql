INSERT INTO "Produtos"
(
    codigo_produto,
    nome_produto,
    descricao_produto,
    custo_unitario_padrao,
    preco_unitario,
    nivel_reposicao,
    nivel_estoque_desejado,
    quantidade_por_unidade,
    descontinuado,
    quantidade_minima_reposicao,
    categoria_produto_id,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    'PROD' || LPAD(id::text, 6, '0'),

    'Produto ' || LPAD(id::text, 6, '0'),

    'Produto gerado automaticamente para testes.',

    custo,

    ROUND(
        (custo * (1.20 + random() * 0.60))::numeric,
        2
    ),

    (floor(random() * 30) + 10)::int,

    (floor(random() * 150) + 50)::int,

    CASE
        WHEN random() < 0.80 THEN '1'
        ELSE
            (
                ARRAY[
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '10',
                    '12',
                    '20',
                    '24',
                    '50',
                    '100'
                ]
            )[floor(random()*11 + 1)]
    END,

    (random() < 0.05),

    (floor(random() * 20) + 5)::int,

    (floor(random() * 190) + 1)::int,

    (floor(random() * 8000) + 1)::int,

    TIMESTAMP '2018-01-01'
        + (random() * 3000) * INTERVAL '1 day',

    (floor(random() * 8000) + 1)::int,

    NOW()

FROM
(
    SELECT

        gs AS id,

        ROUND(
            (10 + random() * 4990)::numeric,
            2
        ) AS custo

    FROM generate_series(1,50000) AS gs

) dados;