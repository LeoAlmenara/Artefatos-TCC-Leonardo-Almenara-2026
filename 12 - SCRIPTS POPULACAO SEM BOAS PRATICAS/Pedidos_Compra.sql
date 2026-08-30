WITH
empresas AS (
    SELECT
        array_agg(empresa_id ORDER BY empresa_id) AS ids,
        array_agg(nome_empresa ORDER BY empresa_id) AS nomes,
        array_agg(telefone_comercial ORDER BY empresa_id) AS telefones
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
    status,
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
    data_alteracao,
    nome_fornecedor,
    telefone_fornecedor
)

SELECT

    e.ids[idx_empresa],

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base + INTERVAL '1 day',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base + INTERVAL '2 days',

    (ARRAY[
        'Pendente',
        'Em Aprovação',
        'Aprovado',
        'Enviado',
        'Recebido',
        'Faturado',
        'Pago',
        'Cancelado'
    ])[status_idx],

    data_base + ((floor(random()*15)+5) || ' days')::interval,

    ROUND((random()*300)::numeric,2),

    ROUND((random()*1500)::numeric,2),

    data_base + ((floor(random()*30)+20) || ' days')::interval,

    ROUND((500 + random()*9500)::numeric,2),

    (ARRAY[
        'PIX',
        'Boleto',
        'Transferência',
        'TED',
        'Cartão Corporativo'
    ])[floor(random()*5+1)],

    'Pedido de compra gerado automaticamente para testes.',

    f.ids[(floor(random()*array_length(f.ids,1))+1)::int],

    data_base,

    CASE
        WHEN alterado THEN f.ids[(floor(random()*array_length(f.ids,1))+1)::int]
        ELSE NULL
    END,

    CASE
        WHEN alterado THEN data_base + (random()*INTERVAL '365 days')
        ELSE NULL
    END,

    e.nomes[idx_empresa],

    e.telefones[idx_empresa]

FROM
(
    SELECT
        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day' AS data_base,
        (floor(random()*300)+1)::int AS idx_empresa,
        (floor(random()*8)+1)::int AS status_idx,
        (random() < 0.30) AS alterado
    FROM generate_series(1,120000)
) base
CROSS JOIN empresas e
CROSS JOIN funcionarios f;
