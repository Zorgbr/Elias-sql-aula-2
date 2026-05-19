--aula 2

create table cliente (
id int not null,
nome varchar(50) not null,
cpf varchar(11) not null,
constraint pk_id_cliente primary key (id)
)
 
create table produto(
id int not null,
descricao varchar(100) not null,
cod_barras varchar(14),
valor decimal(16,2)
)
 
alter table produto add constraint pk_id_produto primary key (id)
 
alter table produto add column situacao boolean not null
 
alter table produto alter column descricao type varchar(200)
 
alter table produto drop column situacao
drop table produto

--aula 4

drop table if exists pedido;
drop table if exists cliente;

create table cliente (
    id INT primary key,
    nome VARCHAR(100) not null
);

create table pedido (
    id INT primary key,
    clienteId INT not null,
    total DECIMAL(10, 2),

    constraint fk_pedido_cliente
        foreign key (clienteId)
        references cliente(id)
);


INSERT INTO cliente (id, nome) VALUES
(1, 'Ana Souza'),
(2, 'Bruno Lima'),
(3, 'Carla Mendes');


INSERT INTO pedido (id, clienteId, total) VALUES
(101, 1, 250.00),
(102, 1, 89.90),
(103, 2, 120.50),
(104, 3, 560.00);

-- Aula 5 
drop table if exists pedidos;
drop table if exists produtos;
drop table if exists leads_potenciais;
drop table if exists clientes;

CREATE TABLE public.clientes (
	id int NOT NULL,
	nome varchar(50) NOT NULL,
	cidade varchar(50) NULL,
	CONSTRAINT clientes_pkey PRIMARY KEY (id)
);

CREATE TABLE public.leads_potenciais (
	id int NOT NULL,
	nome varchar(50) NULL,
	email varchar(50) NULL,
	CONSTRAINT leads_potenciais_pkey PRIMARY KEY (id)
);

CREATE TABLE public.produtos (
	id int NOT NULL,
	nomeproduto varchar(100) NOT NULL,
	precopadrao numeric(10, 2) NULL,
	CONSTRAINT produtos_pkey PRIMARY KEY (id)
);


CREATE TABLE public.pedidos (
	id int NOT NULL,
	clienteid int NULL,
	produtoid int NULL,
	quantidade int NULL,
	precovenda numeric(10, 2) NULL,
	CONSTRAINT pedidos_pkey PRIMARY KEY (id),
	CONSTRAINT fk_cliente_pedido FOREIGN KEY (clienteid) REFERENCES public.clientes(id),
	CONSTRAINT fk_produto_pedido FOREIGN KEY (produtoid) REFERENCES public.produtos(id)
);

INSERT INTO Produtos (Id, NomeProduto, PrecoPadrao) VALUES
(10, 'Notebook Pro', 4500.00),
(11, 'Rato Sem Fio', 120.00),
(12, 'Monitor 24"', 950.00),
(13, 'Teclado Mecânico', 350.00),
(14, 'Webcam HD', 250.00),
(15, 'Smartphone High', 2800.00),
(16, 'Placa de Vídeo', 6000.00);

INSERT INTO Clientes (Id, Nome, Cidade) VALUES
(1, 'Maria Silva', 'São Paulo'),
(2, 'João Pereira', 'Rio de Janeiro'),
(3, 'Ana Costa', 'Curitiba'),
(4, 'Ricardo Santos', 'Belo Horizonte'),
(5, 'Beatriz Oliveira', 'Porto Alegre'),
(6, 'Carlos Souza', 'Salvador'),
(7, 'Fernanda Lima', 'Recife'),
(8, 'Paulo Rocha', 'Brasília');

INSERT INTO Pedidos (Id, ClienteID, ProdutoID, Quantidade, PrecoVenda) VALUES
(101, 1, 10, 1, 4500.00), -- Maria comprou Notebook
(102, 1, 11, 2, 110.00),  -- Maria comprou 2 Ratos (com desconto)
(103, 2, 12, 1, 950.00),  -- João comprou Monitor
(104, 4, 13, 1, 350.00),  -- Ricardo comprou Teclado
(105, 5, 15, 1, 2800.00), -- Beatriz comprou Smartphone
(106, 1, 14, 1, 250.00),  -- Maria comprou Webcam
(107, 6, 14, 1, 250.00),  -- Carlos comprou Webcam
(108, 2, 11, 1, 120.00),  -- João comprou Rato
(109, 7, 10, 1, 4300.00); -- Fernanda comprou Notebook (com desconto)


INSERT INTO Leads_Potenciais (Id, Nome, Email) VALUES
(1, 'Maria Silva', 'maria@email.com'),     -- Já é cliente
(2, 'João Pereira', 'joao@email.com'),     -- Já é cliente
(3, 'Roberto Alves', 'roberto@test.com'),   -- Apenas Lead
(4, 'Sónia Mendes', 'sonia@test.com'),     -- Apenas Lead
(5, 'Lucas Neto', 'lucas@test.com'),       -- Apenas Lead
(6, 'Daniela Paz', 'daniela@test.com');    -- Apenas Lead

-- DQL --INNER JOIN
--Retorna apenas as linhas onde há um encontro perfeito entre as tabelas. No nosso caso, mostra apenas clientes que fizeram pedidos e produtos que foram vendidos.

SELECT C.Nome, P.NomeProduto, Ped.Quantidade
FROM Pedidos Ped
INNER JOIN Clientes C ON Ped.ClienteID = C.Id
INNER JOIN Produtos P ON Ped.ProdutoID = P.Id;

--LEFT JOIN
--Retorna todos os registros da tabela da esquerda (Clientes), mesmo que não haja pedidos. É ideal para nós identificarmos clientes "inativos".

SELECT C.Nome, Ped.Id
FROM Clientes C
LEFT JOIN Pedidos Ped ON C.Id = Ped.ClienteID
WHERE Ped.Id IS NULL;

-- RIGHT JOIN
-- Funciona como o Left Join, mas prioriza a tabela da direita (Produtos). Mostra todos os produtos, incluindo aqueles que nunca foram vendidos.

SELECT P.NomeProduto, P.Id, Ped.Id
FROM Pedidos Ped
RIGHT JOIN Produtos P ON Ped.ProdutoID = P.Id;


--FULL OUTER JOIN
--Retorna todos os registros de ambas as tabelas, unindo os dados quando há correspondência e preenchendo com NULL onde não há.

SELECT C.Nome, Ped.Id
FROM Clientes C
FULL OUTER JOIN Pedidos Ped ON C.id = Ped.ClienteID;

-- Aula 6
-- Maria Silva e João Pereira aparecem em ambas as tabelas, 
-- mas o UNION mostrará cada nome apenas uma vez.
SELECT nome FROM clientes
UNION
SELECT nome FROM leads_potenciais;

-- Aqui, 'Maria Silva' aparecerá duas vezes, 
-- pois o UNION ALL não filtra registros repetidos.
-- Você quer saber o volume total de registros de nomes para uma auditoria, contando cada ocorrência.
SELECT nome FROM clientes
UNION ALL
SELECT nome FROM leads_potenciais;


-- Retornará apenas 'Maria Silva' e 'João Pereira', 
-- pois são os únicos nomes presentes em ambas as tabelas.
-- No nosso dataset, isso serve para identificar quais leads já se tornaram clientes.
SELECT nome FROM clientes
INTERSECT
SELECT nome FROM leads_potenciais



-------------------------------------------------------
SELECT 
    UPPER(nome) AS Nome_Maiusculo,
    CONCAT(nome, ' - ', cidade) AS Etiqueta_Cliente
FROM clientes;

SELECT 
    nome,
    LOWER(LEFT(nome, 3)) AS Prefixo_Login,
    SUBSTRING(email, 1, 5) AS Inicio_Email
FROM leads_potenciais;

SELECT 
    id AS Pedido_ID,
    quantidade,
    precovenda,
    (quantidade * precovenda) AS Valor_Total_Linha
FROM pedidos;


SELECT 
    pR.nomeproduto,
    pr.precopadrao,
    p.precovenda,
    (pr.precopadrao - p.precovenda) AS Desconto_Aplicado
FROM pedidos p
JOIN produtos pr ON p.produtoid = pr.id;

SELECT 
    nome,
    COALESCE(cidade, 'Cidade não informada') AS Localizacao
FROM clientes;


SELECT 
    id AS Pedido_ID,
    precovenda,
    CASE 
        WHEN precovenda >= 4000 THEN 'Venda de Alto Valor'
        WHEN precovenda >= 1000 THEN 'Venda Média'
        ELSE 'Venda de Baixo Valor'
    END AS Classificacao_Venda
FROM pedidos;


SELECT 
    nome,
    LENGTH(LOWER(LEFT(nome, 5))) AS Tamanho_Processado
FROM clientes;


-- Aula 7
-- Este comando mostra o resumo total da operação. É o ponto de partida para entender o volume de dinheiro e produtos movimentados.

SELECT 
    COUNT(*) AS total_pedidos,
    SUM(quantidade) AS total_itens_vendidos,
    AVG(precovenda) AS media_preco_venda,
    MIN(precovenda) AS menor_venda,
    MAX(precovenda) AS maior_venda
FROM pedidos;


-- Quem são os clientes mais valiosos (Vip's). Usamos o JOIN para trazer o nome do cliente em vez de apenas o ID.
SELECT 
    c.nome, 
    SUM(p.quantidade * p.precovenda) AS total_gasto
FROM clientes c
JOIN pedidos p ON c.id = p.clienteid
GROUP BY c.nome
ORDER BY total_gasto DESC;


-- Este exemplo é ótimo para mostrar como o GROUP BY funciona com nomes de produtos e como contar quantas vezes cada item sai
SELECT 
    pr.nomeproduto, 
    COUNT(pe.id) AS vezes_vendido,
    SUM(pe.quantidade) AS qtd_total_unidades,
    SUM(pe.quantidade * pe.precovenda) AS receita_total
FROM produtos pr
LEFT JOIN pedidos pe ON pr.id = pe.produtoid
GROUP BY pr.nomeproduto
ORDER BY qtd_total_unidades DESC;


-- Entender o comportamento regional. Qual cidade traz mais receita?
SELECT 
    c.cidade, 
    COUNT(p.id) AS num_pedidos,
    SUM(p.quantidade * p.precovenda) AS faturamento_regional
FROM clientes c
JOIN pedidos p ON c.id = p.clienteid
GROUP BY c.cidade
ORDER BY faturamento_regional DESC;


-- O Filtro Pós-Agrupamento (HAVING)
SELECT 
    c.nome, 
    SUM(p.quantidade * p.precovenda) AS total_gasto
FROM clientes c
JOIN pedidos p ON c.id = p.clienteid
GROUP BY c.nome
HAVING SUM(p.quantidade * p.precovenda) > 1000
ORDER BY total_gasto DESC;

-- Aula 8 

DROP PROCEDURE public.transferencia(int4, int4, numeric);

CREATE OR REPLACE PROCEDURE public.transferencia(IN p_in_origem integer, IN p_in_destino integer, IN valor numeric)
LANGUAGE plpgsql
AS $procedure$
BEGIN
update conta set saldo = saldo - valor where id = p_in_origem;
update conta set saldo = saldo + valor where id = p_in_destino;

exception
when others then
rollback;

raise notice 'Erro na transferencia %', SQLERRM;
END;
$procedure$
;

call transferencia(1, 2, 30)

grant select on table conta to usuario_teste

try:
result = 10 / 0 # This will raise a ZeroDivisionError
except ZeroDivisionError:
print("You cannot divide by zero!")
finally:
print("Execution complete.")

-- Aula 9 
trigger_validar_cpf CREATE OR REPLACE FUNCTION trg_validar_cpf()
RETURNS TRIGGER AS $$
BEGIN
IF NOT validar_cpf(NEW.cpf) THEN
RAISE EXCEPTION 'CPF inválido: %', NEW.cpf;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validar_cpf_clientes
BEFORE INSERT ON clientes
FOR EACH ROW
EXECUTE FUNCTION trg_validar_cpf();

--funcao_validar_cpf CREATE OR REPLACE FUNCTION public.validar_cpf(cpf text)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
DECLARE
cpf_limpo TEXT;
soma INT;
resto INT;
i INT;
dig1 INT;
dig2 INT;
BEGIN
-- remove caracteres não numéricos
cpf_limpo := regexp_replace(cpf, '[^0-9]', '', 'g');

-- tamanho inválido
IF length(cpf_limpo) <> 11 THEN
RETURN FALSE;
END IF;

-- elimina CPFs inválidos conhecidos
IF cpf_limpo ~ '^(.)\1{10}$' THEN
RETURN FALSE;
END IF;

-- cálculo do 1º dígito
soma := 0;
FOR i IN 1..9 LOOP
soma := soma + (substring(cpf_limpo, i, 1)::INT * (11 - i));
END LOOP;

resto := soma % 11;
IF resto < 2 THEN
dig1 := 0;
ELSE
dig1 := 11 - resto;
END IF;

-- cálculo do 2º dígito
soma := 0;
FOR i IN 1..10 LOOP
soma := soma + (substring(cpf_limpo, i, 1)::INT * (12 - i));
END LOOP;

resto := soma % 11;
IF resto < 2 THEN
dig2 := 0;
ELSE
dig2 := 11 - resto;
END IF;

-- valida dígitos finais
IF dig1 = substring(cpf_limpo, 10, 1)::INT AND
dig2 = substring(cpf_limpo, 11, 1)::INT THEN
RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
END;
$function$
;

-- Aula 10 
 TCL CREATE TABLE conta (
id SERIAL PRIMARY KEY,
titular VARCHAR(100),
saldo NUMERIC(10,2) CHECK (saldo >= 0)
);

INSERT INTO conta (id, titular, saldo)
VALUES
(1, 'João', 1000),
(2, 'Maria', 500);



UPDATE conta
SET saldo = saldo - 100
WHERE id = 1;

UPDATE conta
SET saldo = -500
WHERE id = 2;



BEGIN;

UPDATE conta
SET saldo = saldo - 100
WHERE id = 1;

-- ERRO
UPDATE conta
SET saldo = -500
WHERE id = 2;

ROLLBACK;


CREATE OR REPLACE PROCEDURE transferencia(
origem INT,
destino INT,
valor NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE conta
SET saldo = saldo - valor
WHERE id = origem;

UPDATE conta
SET saldo = saldo + valor
WHERE id = destino;

EXCEPTION
WHEN OTHERS THEN

ROLLBACK;

RAISE NOTICE 'Erro na transferência: %', SQLERRM;
END;
$$;

CALL transferencia(1, 2, 100);
