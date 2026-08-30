WITH
empresas AS (
    SELECT
        array_agg(empresa_id ORDER BY empresa_id) AS ids,
        array_agg(nome_empresa ORDER BY empresa_id) AS nomes,
        array_agg(cidade ORDER BY empresa_id) AS cidades,
        array_agg(telefone_comercial ORDER BY empresa_id) AS telefones
    FROM "Empresas"
),
funcionarios AS (
    SELECT
        array_agg(funcionario_id ORDER BY funcionario_id) AS ids,
        array_agg(nome || ' ' || sobrenome ORDER BY funcionario_id) AS nomes
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
    status,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao,
    nome_empresa,
    cidade_empresa,
    telefone_empresa,
    nome_funcionario
)

SELECT

    f.ids[idx_funcionario],

    e.ids[idx_empresa],

    data_base,

    data_base + INTERVAL '1 day',

    data_base + ((floor(random()*7)+1) || ' days')::interval,

    ROUND((random()*100)::numeric,2),

    (ARRAY[
        'PIX',
        'Cartão de Crédito',
        'Cartão de Débito',
        'Boleto',
        'Transferência'
    ])[floor(random()*5+1)],

    data_base + ((floor(random()*30)+1) || ' days')::interval,

    'Pedido gerado automaticamente para testes.',

    (ARRAY[
        'Pendente',
        'Faturado',
        'Pago',
        'Separando',
        'Enviado',
        'Entregue',
        'Cancelado',
        'Devolvido'
    ])[status_idx],

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

    e.cidades[idx_empresa],

    e.telefones[idx_empresa],

    f.nomes[idx_funcionario]

FROM
(
    SELECT
        TIMESTAMP '2018-01-01'
            + (random()*3000) * INTERVAL '1 day' AS data_base,
        (floor(random()*300)+1)::int AS idx_empresa,
        (floor(random()*8000)+1)::int AS idx_funcionario,
        (floor(random()*8)+1)::int AS status_idx,
        (random() < 0.30) AS alterado
    FROM generate_series(1,800000)
) base

CROSS JOIN empresas e
CROSS JOIN funcionarios f;
