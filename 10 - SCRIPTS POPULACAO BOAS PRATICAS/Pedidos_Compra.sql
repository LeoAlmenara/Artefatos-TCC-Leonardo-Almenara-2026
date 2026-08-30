WITH
empresas AS (
    SELECT array_agg(empresa_id ORDER BY empresa_id) AS ids
    FROM "Empresas"
),
funcionarios AS (
    SELECT array_agg(funcionario_id ORDER BY funcionario_id) AS ids
    FROM "Funcionarios"
)

INSERT INTO "Pedidos_Compra"
(
    fornecedor_id,
    enviado_por,
    data_envio,
    aprovado_por,
    data_aprovacao,
    status_pedido_compra_id,
    data_recebimento,
    taxa_entrega,
    valor_impostos,
    data_pagamento,
    valor_pagamento,
    metodo_pagamento,
    observacoes,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    e.ids[(floor(random()*array_length(e.ids,1))+1)::int],

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base + INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base + INTERVAL '2 days',

    (floor(random()*8)+1)::int,

    data_base + ((floor(random()*15)+5) || ' days')::interval,

    ROUND((random()*300)::numeric,2),

    ROUND((random()*1500)::numeric,2),

    data_base + ((floor(random()*30)+20) || ' days')::interval,

    ROUND((500 + random()*9500)::numeric,2),

    (
        ARRAY[
            'PIX',
            'Boleto',
            'Transferência',
            'TED',
            'Cartão Corporativo'
        ]
    )[floor(random()*5+1)],

    'Pedido de compra gerado automaticamente para testes.',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base,

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    NOW()

FROM
(
    SELECT
        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day' AS data_base

    FROM generate_series(1,120000)
) base

CROSS JOIN empresas e
CROSS JOIN funcionarios f;