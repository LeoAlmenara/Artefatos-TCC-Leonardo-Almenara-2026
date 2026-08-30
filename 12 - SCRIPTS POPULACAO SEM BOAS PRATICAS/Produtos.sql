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
    nome_categoria,
    nome_fornecedor,
    codigo_fornecedor,
    preco_compra,
    quantidade_minima_pedido,
    prazo_entrega_dias,
    fornecedor_padrao,
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

    ROUND((custo * (1.20 + random() * 0.60))::numeric,2),

    (floor(random() * 30) + 10)::int,

    (floor(random() * 150) + 50)::int,

    CASE
        WHEN random() < 0.80 THEN '1'
        ELSE
            (ARRAY['2','3','4','5','6','10','12','20','24','50','100'])[floor(random()*11 + 1)]
    END,

    (random() < 0.05),

    (floor(random() * 20) + 5)::int,

    'Categoria ' || LPAD(categoria_id::text,3,'0'),

    'Fornecedor ' || LPAD(fornecedor_id::text,3,'0'),

    'FOR' || LPAD(fornecedor_id::text,6,'0'),

    ROUND((custo * (0.85 + random()*0.13))::numeric,2),

    (floor(random()*96)+5)::int,

    (floor(random()*29)+2)::int,

    (random() < 0.80),

    (floor(random()*8000)+1)::int,

    data_cadastro,

    CASE
        WHEN alterado THEN (floor(random()*8000)+1)::int
        ELSE NULL
    END,

    CASE
        WHEN alterado
            THEN data_cadastro + (random()*INTERVAL '365 days')
        ELSE NULL
    END

FROM
(
    SELECT
        gs AS id,

        ROUND((10 + random()*4990)::numeric,2) AS custo,

        (floor(random()*190)+1)::int AS categoria_id,

        (floor(random()*300)+1)::int AS fornecedor_id,

        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day'
            AS data_cadastro,

        (random() < 0.30) AS alterado

    FROM generate_series(1,50000) AS gs

) dados;
