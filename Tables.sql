DROP TRIGGER gerar_bonificacao_entrega;
 
DROP TABLE tb_bonificacao;
DROP TABLE tb_entrega;
DROP TABLE tb_armazena;
DROP TABLE tb_armazem;
DROP TABLE tb_pacote;
DROP TABLE tb_entregador;
DROP TABLE tb_remetente;
 
--CRIAÇÃO TABELA REMETENTE
CREATE TABLE tb_remetente OF tp_remetente(
  cpf PRIMARY KEY,
  nome NOT NULL,
  data_nasc NOT NULL,
  telefones NOT NULL,
  endereco NOT NULL,
  data_cadastro NOT NULL
);
/
--CRIAÇÃO TABELA ENTREGADOR
CREATE TABLE tb_entregador OF tp_entregador(
  cpf PRIMARY KEY,
  nome NOT NULL,
  data_nasc NOT NULL,
  telefones NOT NULL,
  endereco NOT NULL,
  salario NOT NULL,
  pis NOT NULL,
  supervisor SCOPE IS tb_entregador
  --Uma coluna do tipo REF pode referenciar objetos do tipo indicado que estejam em qualquer tabela
  --Para restringir o escopo de referências para uma única tabela usamos SCOPE IS
) NESTED TABLE dependentes STORE AS tb_dependentes;
/
--CRIAÇÃO TABELA PACOTE
CREATE TABLE tb_pacote OF tp_pacote(
  id_pacote PRIMARY KEY,
  valor NOT NULL,
  endereco_entrega NOT NULL,
  data_armazenamento NOT NULL
);
/
--CRIAÇÃO TABELA ARMAZÉM
CREATE TABLE tb_armazem OF tp_armazem(
  cnpj PRIMARY KEY,
  capacidade_pacotes NOT NULL,
  endereco NOT NULL
) NESTED TABLE pagamentos STORE AS tb_pagamentos;
/
--CRIAÇÃO TABELA ARMAZÉM
CREATE TABLE tb_armazena OF tp_armazena(
  --A opção WITH ROWID é apenas uma pista, uma vez que quando é usada
  --Oracle compara o OID do objeto com o OID na REF. 
  --Se ocorrer um match, Oracle usará o índice OID
  --WITH ROWID não é suportado para referências de escopo
  id_armazena PRIMARY KEY,
  armazem WITH ROWID REFERENCES tb_armazem NOT NULL,
  remetente SCOPE IS tb_remetente NOT NULL
) NESTED TABLE pacotes STORE AS tb_ref_pacotes;
/
--CRIAÇÃO TABELA ENTREGA
CREATE TABLE tb_entrega OF tp_entrega(
  id_entrega PRIMARY KEY,
  entregador SCOPE IS tb_entregador NOT NULL,
  pacote WITH ROWID REFERENCES tb_pacote NOT NULL,
  data_de_entrega NOT NULL
);
/
--CRIAÇÃO TABELA BONIFICAÇÃO
CREATE TABLE tb_bonificacao OF tp_bonificacao(
    id_bonificacao PRIMARY KEY,
    valor NOT NULL,
    descricao NOT NULL
) NESTED TABLE entregas_bonificadas STORE AS tb_entregas_bonificadas;
/
--CRIAÇÃO TRIGGER GERAÇÃO DE BONIFICAÇÃO
CREATE OR REPLACE TRIGGER gerar_bonificacao_entrega
AFTER INSERT
ON tb_entrega
REFERENCING NEW AS entrega
FOR EACH ROW
DECLARE
  data_armazenamento_pacote DATE;
  diferenca_datas NUMBER;
BEGIN
  SELECT DEREF(:entrega.pacote).data_armazenamento INTO data_armazenamento_pacote FROM DUAL;
 
  diferenca_datas := :entrega.data_de_entrega - data_armazenamento_pacote;
 
  IF diferenca_datas <= 1 THEN
    INSERT INTO TABLE(SELECT B.entregas_bonificadas FROM tb_bonificacao B WHERE id_bonificacao = 1)
    VALUES(:entrega.id_entrega);
  ELSIF diferenca_datas <= 3 THEN
    INSERT INTO TABLE(SELECT B.entregas_bonificadas FROM tb_bonificacao B WHERE id_bonificacao = 2)
    VALUES(:entrega.id_entrega);
  ELSIF diferenca_datas <= 5 THEN
    INSERT INTO TABLE(SELECT B.entregas_bonificadas FROM tb_bonificacao B WHERE id_bonificacao = 3)
    VALUES(:entrega.id_entrega);
  END IF;
END;
/
 
 
 

