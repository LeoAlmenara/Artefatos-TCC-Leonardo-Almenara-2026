-- =====================================================
-- TODOS OS FUNCIONÁRIOS RECEBEM UM PRIVILÉGIO
-- =====================================================

INSERT INTO "Privilegios_Funcionarios"
(
    funcionario_id,
    privilegio_id,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    funcionario_id,

    (floor(random()*20)+1)::int,

    1,

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    NULL,

    NOW()

FROM "Funcionarios";


-- =====================================================
-- APROXIMADAMENTE METADE RECEBE UM SEGUNDO PRIVILÉGIO
-- =====================================================

INSERT INTO "Privilegios_Funcionarios"
(
    funcionario_id,
    privilegio_id,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    funcionario_id,

    (floor(random()*20)+1)::int,

    1,

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    1,

    NOW()

FROM "Funcionarios"

WHERE random() < 0.50;