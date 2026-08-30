WITH
empresas AS (
    SELECT array_agg(empresa_id ORDER BY empresa_id) AS ids
    FROM "Empresas"
),
produtos AS (
    SELECT array_agg(produto_id ORDER BY produto_id) AS ids
    FROM "Produtos"
),
funcionarios AS (
    SELECT array_agg(funcionario_id ORDER BY funcionario_id) AS ids
    FROM "Funcionarios"
)

INSERT INTO "Fornecedores_Produtos"
(
    fornecedor_id,
    produto_id,
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

    e.ids[(floor(random()*array_length(e.ids,1))+1)::int],

    p.ids[(floor(random()*array_length(p.ids,1))+1)::int],

    'FORN-' || LPAD(gs::text,8,'0'),

    ROUND((5 + random()*4500)::numeric,2),

    (floor(random()*50)+1)::int,

    (floor(random()*30)+1)::int,

    (random() < 0.30),

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    NOW()

FROM generate_series(1,100000) gs

CROSS JOIN empresas e
CROSS JOIN produtos p
CROSS JOIN funcionarios f;