INSERT INTO "Empresas"
(
    nome_empresa,
    tipo_empresa_id,
    telefone_comercial,
    endereco,
    cidade,
    estado_id,
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

tipo_empresa_id,

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

estado_id,

LPAD((floor(random()*99999))::text,5,'0')
||
'-'
||
LPAD((floor(random()*999))::text,3,'0'),

'https://www.efv.com.br',

'Empresa gerada automaticamente para testes.',

(floor(random()*8000)+1)::int,

TIMESTAMP '2015-01-01'
+
(random()*3650) * INTERVAL '1 day',

(floor(random()*8000)+1)::int,

NOW()

FROM
(

SELECT

gs id,

(floor(random()*10)+1)::int tipo_empresa_id,

(floor(random()*27)+1)::int estado_id,

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