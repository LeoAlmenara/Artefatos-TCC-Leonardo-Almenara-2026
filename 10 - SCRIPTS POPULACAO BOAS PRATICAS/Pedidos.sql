WITH
empresas AS (
    SELECT array_agg(empresa_id ORDER BY empresa_id) AS ids
    FROM "Empresas"
),
funcionarios AS (
    SELECT array_agg(funcionario_id ORDER BY funcionario_id) AS ids
    FROM "Funcionarios"
)

INSERT INTO "Pedidos"
(
    funcionario_id,
    empresa_id,
    data_pedido,
    data_fatura,
    data_envio,
    taxa_entrega,
    metodo_pagamento,
    data_pagamento,
    observacoes,
    status_pedido_id,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    e.ids[(floor(random()*array_length(e.ids,1))+1)::int],

    data_base,

    data_base + INTERVAL '1 day',

    data_base + ((floor(random()*7)+1) || ' days')::interval,

    ROUND((random()*100)::numeric,2),

    (
        ARRAY[
            'PIX',
            'Cartão de Crédito',
            'Cartão de Débito',
            'Boleto',
            'Transferência'
        ]
    )[floor(random()*5+1)],

    data_base + ((floor(random()*30)+1) || ' days')::interval,

    'Pedido gerado automaticamente para testes.',

    (floor(random()*8)+1)::int,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    NOW()

FROM
(
    SELECT
        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day' AS data_base
    FROM generate_series(1,800000)
) base

CROSS JOIN empresas e
CROSS JOIN funcionarios f;