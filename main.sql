-- Definição
Create database  if not exists Ecommerce;
use Ecommerce;

create table vendedor(
	idVendedor int primary key,
    CNPJ char(15) unique,
    CPF char(11) unique,
    Nome varchar(100) not null,
    contato char(11) not null,
    endereço varchar(200)
);

create table produto(
	idProduto int auto_increment primary key,
    descricao varchar(30) not null,
    categoria enum('eletrônico', 'vestuário', 'brinquedos', 'Alimentos') not null,
    quantidade int,
    valorUnidade float,
    idVendedor int,
    
    foreign key (idVendedor) references vendedor(idVendedor)
);

create table cliente(
	idCliente int auto_increment primary key,
    nome varchar(30) not null,
	CPF char(11) unique,
    CNPJ char(15) unique,
    endereco varchar(50) not null,
    tipo enum('PF', 'PJ') not null
);

create table pagamentos(
	idPagamento int primary key,
    idCliente int,
    tipo enum('Boleto', 'Cartão', 'Pix'),
    
   foreign key (idCliente) references cliente(idCliente)
);

create table pedidos(
	idPedido int auto_increment primary key,
    idCliente int,
    idProduto int,
    valor float,
    idPagamento int,
    status enum('Processando', 'cancelado', 'confirmado') default 'Processando',
    
    foreign key(idCliente) references cliente(idCliente),
    foreign key(idPagamento) references pagamentos(idPagamento),
    foreign key(idProduto) references produto(idProduto)
);

create table entrega(
	idEntega int,
    CodigoDeRastreio varchar(20),
    idPedido int,
    status enum('processando', 'Em trânsito', 'Entregue', 'devolvido'),
	foreign key(idPedido) references pedidos(idPedido)
);

-- Instançiações 

INSERT INTO vendedor (idVendedor, CNPJ, CPF, Nome, contato, endereço)
VALUES
(1, '12345678901234', NULL, 'Vendedor 1', '98765432101', 'Rua A, 123'),
(2, NULL, '01234567890', 'Vendedor 2', '98765432102', 'Rua B, 456'),
(3, '56789012345678', NULL, 'Vendedor 3', '98765432103', 'Rua C, 789'),
(4, NULL, '34567890123', 'Vendedor 4', '98765432104', 'Rua D, 1011'),
(5, '90123456789012', NULL, 'Vendedor 5', '98765432105', 'Rua E, 1213');

INSERT INTO produto (descricao, categoria, quantidade, valorUnidade, idVendedor)
VALUES
('Produto 1', 'eletrônico', 10, 499.99, 1),
('Produto 2', 'vestuário', 20, 39.99, 2),
('Produto 3', 'brinquedos', 15, 29.99, 3),
('Produto 4', 'Alimentos', 50, 5.99, 4),
('Produto 5', 'eletrônico', 8, 899.99, 5);

INSERT INTO cliente (nome, CPF, CNPJ, endereco, tipo)
VALUES
('Cliente 1', '12345678901', NULL, 'Av. X, 123', 'PF'),
('Cliente 2', '23456789012', NULL, 'Rua Y, 456', 'PF'),
('Cliente 3', NULL, '34567890123', 'Praça Z, 789', 'PJ'),
('Cliente 4', NULL, '45678901234', 'Rua W, 1011', 'PJ'),
('Cliente 5', '56789012345', NULL, 'Rua V, 1213', 'PF');

INSERT INTO pagamentos (idPagamento, idCliente, tipo)
VALUES
(1, 1, 'Boleto'),
(2, 2, 'Cartão'),
(3, 3, 'Pix'),
(4, 4, 'Boleto'),
(5, 5, 'Cartão');

INSERT INTO pedidos (idCliente, idProduto, valor, idPagamento, status)
VALUES
(1, 1, 499.99, 1, 'confirmado'),
(2, 2, 39.99, 2, 'Processando'),
(3, 3, 29.99, 3, 'cancelado'),
(4, 4, 5.99, 4, 'confirmado'),
(5, 5, 899.99, 5, 'Processando');

INSERT INTO entrega (idEntega, CodigoDeRastreio, idPedido, status)
VALUES
(1, 'AB123456', 1, 'Em trânsito'),
(2, 'CD789012', 2, 'processando'),
(3, 'EF345678', 3, 'Entregue'),
(4, 'GH901234', 4, 'devolvido'),
(5, 'IJ567890', 5, 'processando');

-- Consultas
SELECT * FROM vendedor;

SELECT * FROM produto WHERE valorUnidade > 50;

SELECT idProduto, descricao, quantidade, valorUnidade, (quantidade * valorUnidade) AS valorTotal FROM produto;

SELECT * FROM cliente ORDER BY nome;

SELECT categoria, AVG(quantidade) AS media_quantidade FROM produto GROUP BY categoria HAVING media_quantidade > 15;

SELECT pe.idPedido, pe.valor, pr.descricao AS produto, cl.nome AS cliente
FROM pedidos pe
JOIN produto pr ON pe.idProduto = pr.idProduto
JOIN cliente cl ON pe.idCliente = cl.idCliente;
