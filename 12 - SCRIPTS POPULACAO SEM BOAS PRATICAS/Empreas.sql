INSERT INTO "Empresas"
(
    nome_empresa,
    tipo_empresa,
    telefone_comercial,
    endereco,
    cidade,
    nome_estado,
    sigla_estado,
    cep,
    website,
    observacoes,
    cadastrado_por,
    data_cadastro,
    alterado_por,
    data_alteracao
)

SELECT

CASE tipo_empresa_id

    WHEN 1 THEN 'EFV Matriz'
    WHEN 2 THEN 'EFV Filial ' || cidade || ' ' || LPAD(id::text,3,'0')
    WHEN 3 THEN 'EFV Centro de Distribuição ' || cidade
    WHEN 4 THEN 'Fornecedor ' || cidade
    WHEN 5 THEN 'Transportadora ' || cidade
    WHEN 6 THEN 'Marketplace EFV'
    WHEN 7 THEN 'Loja EFV ' || cidade
    WHEN 8 THEN 'E-commerce EFV'
    WHEN 9 THEN 'Representante ' || cidade
    ELSE 'Assistência Técnica ' || cidade

END,

CASE tipo_empresa_id

    WHEN 1 THEN 'Matriz'
    WHEN 2 THEN 'Filial'
    WHEN 3 THEN 'Centro de Distribuição'
    WHEN 4 THEN 'Fornecedor'
    WHEN 5 THEN 'Transportadora'
    WHEN 6 THEN 'Marketplace'
    WHEN 7 THEN 'Loja Física'
    WHEN 8 THEN 'E-commerce'
    WHEN 9 THEN 'Representante Comercial'
    ELSE 'Assistência Técnica'

END,

'(' ||
LPAD((floor(random()*89)+11)::text,2,'0')
|| ') '
||
LPAD((floor(random()*9000)+1000)::text,4,'0')
|| '-'
||
LPAD((floor(random()*9000)+1000)::text,4,'0'),

'Rua ' ||
(floor(random()*300)+1)
|| ', Nº '
||
(floor(random()*5000)+1),

cidade,

CASE estado_id
    WHEN 1 THEN 'Paraná'
    WHEN 2 THEN 'São Paulo'
    WHEN 3 THEN 'Rio de Janeiro'
    WHEN 4 THEN 'Minas Gerais'
    WHEN 5 THEN 'Santa Catarina'
    WHEN 6 THEN 'Rio Grande do Sul'
    WHEN 7 THEN 'Goiás'
    WHEN 8 THEN 'Distrito Federal'
    WHEN 9 THEN 'Bahia'
    WHEN 10 THEN 'Pernambuco'
    WHEN 11 THEN 'Ceará'
    WHEN 12 THEN 'Amazonas'
    WHEN 13 THEN 'Pará'
    WHEN 14 THEN 'Mato Grosso do Sul'
    WHEN 15 THEN 'Espírito Santo'
    WHEN 16 THEN 'Mato Grosso'
    WHEN 17 THEN 'Tocantins'
    WHEN 18 THEN 'Rondônia'
    WHEN 19 THEN 'Acre'
    WHEN 20 THEN 'Roraima'
    WHEN 21 THEN 'Amapá'
    WHEN 22 THEN 'Maranhão'
    WHEN 23 THEN 'Piauí'
    WHEN 24 THEN 'Rio Grande do Norte'
    WHEN 25 THEN 'Paraíba'
    WHEN 26 THEN 'Alagoas'
    ELSE 'Sergipe'
END,

CASE estado_id
    WHEN 1 THEN 'PR'
    WHEN 2 THEN 'SP'
    WHEN 3 THEN 'RJ'
    WHEN 4 THEN 'MG'
    WHEN 5 THEN 'SC'
    WHEN 6 THEN 'RS'
    WHEN 7 THEN 'GO'
    WHEN 8 THEN 'DF'
    WHEN 9 THEN 'BA'
    WHEN 10 THEN 'PE'
    WHEN 11 THEN 'CE'
    WHEN 12 THEN 'AM'
    WHEN 13 THEN 'PA'
    WHEN 14 THEN 'MS'
    WHEN 15 THEN 'ES'
    WHEN 16 THEN 'MT'
    WHEN 17 THEN 'TO'
    WHEN 18 THEN 'RO'
    WHEN 19 THEN 'AC'
    WHEN 20 THEN 'RR'
    WHEN 21 THEN 'AP'
    WHEN 22 THEN 'MA'
    WHEN 23 THEN 'PI'
    WHEN 24 THEN 'RN'
    WHEN 25 THEN 'PB'
    WHEN 26 THEN 'AL'
    ELSE 'SE'
END,

replace(
    LPAD((floor(random()*99999))::text,5,'0')
    || '-'
    || LPAD((floor(random()*999))::text,3,'0'),
'-',''
)::int,

'https://www.efv.com.br',

'Empresa gerada automaticamente para testes.',

(floor(random()*8000)+1)::int,

data_cadastro,

CASE
    WHEN alterado THEN (floor(random()*8000)+1)::int
    ELSE NULL
END,

CASE
    WHEN alterado
        THEN data_cadastro + (random() * INTERVAL '365 days')
    ELSE NULL
END

FROM
(

SELECT

gs id,

(floor(random()*10)+1)::int tipo_empresa_id,

(floor(random()*27)+1)::int estado_id,

(random() < 0.30) AS alterado,

TIMESTAMP '2015-01-01'
    + (random()*3650) * INTERVAL '1 day'
    AS data_cadastro,

(
ARRAY[
'Maringá',
'Londrina',
'Curitiba',
'Cascavel',
'Foz do Iguaçu',
'Ponta Grossa',
'São Paulo',
'Campinas',
'Ribeirão Preto',
'Santos',
'Rio de Janeiro',
'Niterói',
'Belo Horizonte',
'Uberlândia',
'Goiânia',
'Brasília',
'Florianópolis',
'Joinville',
'Blumenau',
'Porto Alegre',
'Caxias do Sul',
'Salvador',
'Recife',
'Fortaleza',
'Manaus',
'Belém',
'Campo Grande'
]
)[floor(random()*27+1)] cidade

FROM generate_series(1,300) gs

) dados;