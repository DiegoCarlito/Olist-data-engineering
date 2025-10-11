-- =====       Engenharia de Dados com Olist       =====
--
--                      SCRIPT DE CRIACAO (DDL)
--
-- Data Criacao ...........: 11/10/2025
-- Autor(es) ..............: Diego Souza
-- Banco de Dados .........: PostgreSQL (via Docker)
-- Base de Dados (nome) ...: olist_lakehouse
--
-- PROJETO => 01 Base de Dados
--         => 01 Tabela
--         => 00 Visoes
--         => 00 Perfis (role)
--         => 00 Usuarios
--         => 00 Sequencias
--         => 00 Triggers
--         => 00 Procedimentos
--         => 00 Funcoes
-- ---------------------------------------------------------

DROP TABLE IF EXISTS pedidos;

CREATE TABLE pedidos (
    id_item_pedido VARCHAR(64) PRIMARY KEY,
    id_pedido VARCHAR(32) NOT NULL,
    id_cliente VARCHAR(32) NOT NULL,
    id_produto VARCHAR(32) NOT NULL,
    id_vendedor VARCHAR(32) NOT NULL,
    status_pedido VARCHAR(20) NOT NULL,
    data_compra TIMESTAMP NOT NULL,
    data_aprovacao TIMESTAMP,
    data_envio_transportadora TIMESTAMP,
    data_entrega_cliente TIMESTAMP,
    data_estimada_entrega TIMESTAMP,
    preco_item NUMERIC(10, 2) NOT NULL,
    valor_frete NUMERIC(10, 2) NOT NULL,
    categoria_produto VARCHAR(100),
    cidade_cliente VARCHAR(100),
    estado_cliente VARCHAR(2),
    cidade_vendedor VARCHAR(100),
    estado_vendedor VARCHAR(2),
    tipo_pagamento VARCHAR(30),
    parcelas_pagamento INTEGER,
    valor_pagamento NUMERIC(10, 2),
    nota_avaliacao INTEGER,
    tempo_entrega_dias INTEGER,
    atraso_na_entrega BOOLEAN
);
