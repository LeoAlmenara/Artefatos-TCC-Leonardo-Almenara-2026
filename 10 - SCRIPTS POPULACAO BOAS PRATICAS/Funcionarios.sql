INSERT INTO "Funcionarios"
(
    sobrenome,
    nome,
    email,
    cargo,
    telefone_principal,
    telefone_secundario,
    titulo,
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
    END,

    '(' ||
    LPAD((floor(random()*89)+11)::text,2,'0') ||
    ') 9' ||
    LPAD((floor(random()*9999))::text,4,'0') ||
    '-' ||
    LPAD((floor(random()*9999))::text,4,'0'),

    NULL,

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
    END,

    'Funcionário gerado automaticamente para testes.',

    NULL,

    LOWER(
        LEFT(nome,1) ||
        regexp_replace(sobrenome,' ','','g') ||
        id
    ),

    NULL,

    TIMESTAMP '2018-01-01'
        + (random()*3000) * INTERVAL '1 day',

    NULL,

    NOW()

FROM
(
    SELECT

        gs id,

        (floor(random()*100)+1)::int r,

        (
            ARRAY[
'João','Maria','José','Ana','Carlos','Lucas','Pedro','Paulo','Marcos','Fernanda',
'Juliana','Patrícia','Rafael','Gabriel','Mateus','Bruno','Amanda','Camila','Larissa',
'Gustavo','Felipe','Eduardo','Ricardo','André','Vinicius','Diego','Thiago','Daniel',
'Beatriz','Isabela','Natália','Roberta','Vanessa','Fábio','Renato','Leandro','Leonardo',
'Rodrigo','Marcelo','Cristiano','Aline','Bianca','Cláudia','Denise','Elaine','Tatiane',
'Carolina','Luana','Priscila'
            ]
        )[floor(random()*49+1)] nome,

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
        )[floor(random()*49+1)] sobrenome

    FROM generate_series(1,8000) gs

) dados;