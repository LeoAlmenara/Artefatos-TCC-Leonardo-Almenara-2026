INSERT INTO "Funcionarios"
(
    sobrenome,
    nome,
    email,
    cargo,
    telefone_principal,
    telefone_secundario,
    titulo,
    privilegio,
    observacoes,
    anexos,
    usuario,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

    sobrenome,

    nome,

    LOWER(nome || '.' || sobrenome || id || '@efv.com.br'),

    cargo,

    telefone,

    NULL,

    cargo,

    CASE
        WHEN cargo = 'Diretor Geral' THEN 'Administrador'
        WHEN cargo IN ('Gerente Comercial','Supervisor de Loja') THEN 'Gerente'
        WHEN cargo IN (
            'Analista Financeiro',
            'Analista Fiscal',
            'Analista Contábil',
            'Analista de RH',
            'Analista de TI',
            'Comprador',
            'Assistente Administrativo'
        ) THEN 'Supervisor'
        ELSE 'Operacional'
    END,

    'Funcionário gerado automaticamente para testes.',

    NULL,

    LOWER(
        LEFT(nome,1) ||
        regexp_replace(sobrenome,' ','','g') ||
        id
    ),

    1,

TIMESTAMP '2018-01-01'
    + (random()*3000) * INTERVAL '1 day',

CASE
    WHEN random() < 0.30 THEN 1
    ELSE NULL
END,

CASE
    WHEN random() < 0.30
        THEN NOW() - (random() * INTERVAL '365 days')
    ELSE NULL
END

FROM
(
    SELECT

        gs AS id,

        sobrenome,

        nome,

        (
            floor(random()*90000000000)::bigint
            + 10000000000
        ) AS telefone,

        CASE
            WHEN r <= 35 THEN 'Vendedor'
            WHEN r <= 53 THEN 'Operador de Caixa'
            WHEN r <= 65 THEN 'Estoquista'
            WHEN r <= 73 THEN 'Assistente Administrativo'
            WHEN r <= 78 THEN 'Comprador'
            WHEN r <= 82 THEN 'Analista Financeiro'
            WHEN r <= 86 THEN 'Analista Fiscal'
            WHEN r <= 89 THEN 'Analista Contábil'
            WHEN r <= 92 THEN 'Analista de RH'
            WHEN r <= 95 THEN 'Analista de TI'
            WHEN r <= 97 THEN 'Supervisor de Loja'
            WHEN r <= 99 THEN 'Gerente Comercial'
            ELSE 'Diretor Geral'
        END AS cargo

    FROM
    (
        SELECT

            gs,

            (floor(random()*100)+1)::int AS r,

            (
                ARRAY[
'João','Maria','José','Ana','Carlos','Lucas','Pedro','Paulo','Marcos','Fernanda',
'Juliana','Patrícia','Rafael','Gabriel','Mateus','Bruno','Amanda','Camila','Larissa',
'Gustavo','Felipe','Eduardo','Ricardo','André','Vinicius','Diego','Thiago','Daniel',
'Beatriz','Isabela','Natália','Roberta','Vanessa','Fábio','Renato','Leandro','Leonardo',
'Rodrigo','Marcelo','Cristiano','Aline','Bianca','Cláudia','Denise','Elaine','Tatiane',
'Carolina','Luana','Priscila'
                ]
            )[floor(random()*49+1)] AS nome,

            (
                ARRAY[
'Silva','Souza','Oliveira','Santos','Lima','Costa','Ferreira','Pereira',
'Almeida','Rodrigues','Gomes','Martins','Rocha','Barbosa','Ribeiro',
'Carvalho','Araújo','Melo','Fernandes','Dias','Monteiro','Teixeira',
'Correia','Moreira','Cardoso','Freitas','Machado','Vieira','Batista',
'Nogueira','Moura','Campos','Cavalcante','Peixoto','Rezende',
'Farias','Castro','Sales','Pinto','Assis','Leite','Fonseca',
'Cunha','Borges','Tavares','Aguiar','Coelho','Alves','Barros'
                ]
            )[floor(random()*49+1)] AS sobrenome

        FROM generate_series(1,8000) gs

    ) dados

) funcionarios;