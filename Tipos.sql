DROP TYPE tp_bonificacao;
DROP TYPE tp_nt_id_entregas;
DROP TYPE tp_id_entrega;
DROP TYPE tp_entrega;
DROP TYPE tp_armazena;
DROP TYPE tp_armazem;
DROP TYPE tp_nt_pagamentos;
DROP TYPE tp_pagamento_entregador;
DROP TYPE tp_nt_ref_pacotes;
DROP TYPE tp_ref_pacote;
DROP TYPE tp_pacote;
DROP TYPE tp_entregador;
DROP TYPE tp_possui FORCE;
DROP TYPE tp_dependente FORCE;
DROP TYPE tp_remetente;
DROP TYPE tp_pessoa FORCE;
DROP TYPE tp_telefones FORCE;
DROP TYPE tp_telefone FORCE;
DROP TYPE tp_endereco FORCE;
 
--CRIANDO OBJETO ENDEREÇO
CREATE OR REPLACE TYPE tp_endereco AS OBJECT (
  cep VARCHAR2(9),
  rua VARCHAR2(30),
  numero_end NUMBER,
  bairro VARCHAR2(30),
  cidade VARCHAR2(15),
  estado VARCHAR2(2),
  complemento VARCHAR2(50),
 
--   The NOCOPY hint tells the PL/SQL compiler to pass OUT and IN OUT parameters by reference, rather than by value.
  CONSTRUCTOR FUNCTION tp_endereco(SELF IN OUT NOCOPY tp_endereco, Cep VARCHAR2, Rua VARCHAR2, Numero_end NUMBER, Bairro VARCHAR2, Cidade VARCHAR2, Estado VARCHAR2) RETURN SELF AS RESULT,
  MAP MEMBER FUNCTION compararPorCEP RETURN VARCHAR2
);
 
/
CREATE OR REPLACE TYPE BODY tp_endereco AS
    CONSTRUCTOR FUNCTION tp_endereco(SELF IN OUT NOCOPY tp_endereco, Cep VARCHAR2, Rua VARCHAR2, Numero_end NUMBER, Bairro VARCHAR2, Cidade VARCHAR2, Estado VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
      SELF.cep := Cep;
      SELF.rua := Rua;
      SELF.numero_end := Numero_end;
      SELF.bairro := Bairro;
      SELF.cidade := Cidade;
      SELF.estado := Estado;
      RETURN;
    END;
    MAP MEMBER FUNCTION compararPorCEP RETURN VARCHAR2 IS
    BEGIN
        RETURN cep;
    END;
END;
/
-- CRIANDO OBJETO TELEFONE
CREATE OR REPLACE TYPE tp_telefone AS OBJECT (
  numero_telefone VARCHAR2(11)
);
/
-- CRIANDO VARRAY DE TELEFONES EM UM TIPO
CREATE OR REPLACE TYPE tp_telefones AS VARRAY(3) OF tp_telefone;
/
--CRIANDO OBJETO PESSOA
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
  cpf VARCHAR2(14),
  nome VARCHAR2(30),
  data_nasc DATE,
  telefones tp_telefones,
  endereco tp_endereco,
 
  MAP MEMBER FUNCTION compararPorNome RETURN VARCHAR2,
  MEMBER PROCEDURE detalhes (SELF IN OUT NOCOPY tp_pessoa)
) NOT FINAL NOT INSTANTIABLE;
/
CREATE OR REPLACE TYPE BODY tp_pessoa AS
  MAP MEMBER FUNCTION compararPorNome RETURN VARCHAR2 IS
    n VARCHAR2 := nome;
  BEGIN
    return n;
  END;
END;
/
--CRIANDO OBJETO REMETENTE QUE HERDA DE PESSOA
CREATE OR REPLACE TYPE tp_remetente UNDER tp_pessoa(
  data_cadastro DATE,
 
  OVERRIDING MEMBER PROCEDURE detalhes (SELF IN OUT NOCOPY tp_remetente)
);
/
CREATE OR REPLACE TYPE BODY tp_remetente AS
  OVERRIDING MEMBER PROCEDURE detalhes (SELF IN OUT tp_remetente) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(nome || ' - '  || cpf);
    DBMS_OUTPUT.PUT_LINE('Data de Cadastro : ' || TO_CHAR(data_cadastro));
    DBMS_OUTPUT.PUT_LINE('Telefones:');
    FOR i IN telefones.first..telefones.last LOOP
    DBMS_OUTPUT.PUT_LINE('- ' || TO_CHAR(telefones(i).numero_telefone));
    END LOOP;
  END;
END;
/
--CRIANDO OBJETO DEPENDENTE
CREATE OR REPLACE TYPE tp_dependente AS OBJECT (
  nome VARCHAR2(30),
  numero INTEGER
);
/
--CRIANDO RELACIONAMENTO POSSUI
CREATE OR REPLACE TYPE tp_possui AS TABLE OF tp_dependente;
/
--CRIANDO OBJETO ENTREGADOR QUE HERDA DE PESSOA
CREATE OR REPLACE TYPE tp_entregador UNDER tp_pessoa(
  salario NUMBER,
  supervisor REF tp_entregador,
  dependentes tp_possui,
 
  OVERRIDING MEMBER PROCEDURE detalhes (SELF IN OUT NOCOPY tp_entregador),
  MEMBER FUNCTION getValorBonificacoes(SELF IN OUT NOCOPY tp_entregador) RETURN NUMBER
) NOT FINAL;
/
 
CREATE OR REPLACE TYPE BODY tp_entregador AS
  OVERRIDING MEMBER PROCEDURE detalhes (SELF IN OUT tp_entregador) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(nome || ' - '  || cpf);
    DBMS_OUTPUT.PUT_LINE('Salário : ' || TO_CHAR(salario));
    DBMS_OUTPUT.PUT_LINE('Telefones:');
    FOR i IN telefones.first..telefones.last LOOP
    DBMS_OUTPUT.PUT_LINE('- ' || TO_CHAR(telefones(i).numero_telefone));
    END LOOP;
  END;
    MEMBER FUNCTION getValorBonificacoes(SELF IN OUT NOCOPY tp_entregador) RETURN NUMBER IS
        quantidadeBonificacoes NUMBER;
        curCnt NUMBER;
        curBonificacao tp_bonificacao;
        valorTotal NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO quantidadeBonificacoes FROM tb_bonificacao;
        IF quantidadeBonificacoes > 0 THEN
            FOR curIdBonificacao IN 1..quantidadeBonificacoes
            LOOP
                SELECT VALUE(B) INTO curBonificacao FROM tb_bonificacao B WHERE id_bonificacao = curIdBonificacao;
 
                SELECT COUNT(E.entregador.cpf) INTO curCnt
                FROM tb_entrega E 
                WHERE id_entrega IN (SELECT id_entrega FROM TABLE(curBonificacao.entregas_bonificadas)) 
                    AND E.entregador.cpf = SELF.cpf;
                
                valorTotal := valorTotal + (curCnt*curBonificacao.valor);
            END LOOP;
        END IF;
        RETURN valorTotal;
    END;
END;
/
--CASCADE = Vai propagar a mudança para todos os tipos dependentes
ALTER TYPE tp_entregador
ADD ATTRIBUTE (pis VARCHAR2(14)) CASCADE;
/
--CRIANDO OBJETO PACOTE
CREATE OR REPLACE TYPE tp_pacote AS OBJECT (
  id_pacote INTEGER,
  valor NUMBER,
  endereco_entrega tp_endereco,
  data_armazenamento DATE
);
--DEFINIÇÃO PAGAMENTO
/
CREATE OR REPLACE TYPE tp_pagamento_entregador AS OBJECT (
  entregador REF tp_entregador,
  valor NUMBER, 
  data_de_pagamento TIMESTAMP
);
/
CREATE OR REPLACE TYPE tp_nt_pagamentos AS TABLE OF tp_pagamento_entregador;
/
--CRIANDO OBJETO ARMAZÉM
CREATE OR REPLACE TYPE tp_armazem AS OBJECT (
  cnpj VARCHAR2(19),
  capacidade_pacotes NUMBER,
  endereco tp_endereco,
  pagamentos tp_nt_pagamentos,
 
  FINAL MEMBER PROCEDURE pagarEntregador(SELF IN OUT NOCOPY tp_armazem, cpf_entregador VARCHAR2)
);
/
CREATE OR REPLACE TYPE BODY tp_armazem AS
    FINAL MEMBER PROCEDURE pagarEntregador(SELF IN OUT NOCOPY tp_armazem, cpf_entregador VARCHAR2) IS
        ref_entregador REF tp_entregador;
        entregador tp_entregador;
        valorBonificacoes NUMBER;
    BEGIN
        SELECT VALUE(E), REF(E) INTO entregador, ref_entregador FROM tb_entregador E WHERE cpf = cpf_entregador;
        valorBonificacoes := entregador.getValorBonificacoes();
        INSERT INTO TABLE(SELECT A.pagamentos FROM tb_armazem A WHERE cnpj = SELF.cnpj) VALUES (ref_entregador, entregador.salario + valorBonificacoes, SYSTIMESTAMP);
    END;
END;
--DEFINIÇÃO ARMAZENA
/
CREATE OR REPLACE TYPE tp_ref_pacote AS OBJECT (
  pacote REF tp_pacote
);
/
CREATE OR REPLACE TYPE tp_nt_ref_pacotes AS TABLE OF tp_ref_pacote
/
CREATE OR REPLACE TYPE tp_armazena AS OBJECT (
  id_armazena INTEGER,
  remetente REF tp_remetente,
  pacotes tp_nt_ref_pacotes,
  armazem REF tp_armazem,
  custo NUMBER
);
/
--DEFINIÇÃO DA ENTREGA
CREATE OR REPLACE TYPE tp_entrega AS OBJECT (
  id_entrega INTEGER,
  entregador REF tp_entregador,
  pacote REF tp_pacote,
  data_de_entrega DATE
);
/
CREATE OR REPLACE TYPE tp_id_entrega AS OBJECT(
  id_entrega INTEGER
);
/
CREATE OR REPLACE TYPE tp_nt_id_entregas AS TABLE OF tp_id_entrega;
/
--CRIANDO OBJETO BONIFICAÇÃO
CREATE OR REPLACE TYPE tp_bonificacao AS OBJECT (
  id_bonificacao INTEGER,
  valor NUMBER,
  descricao VARCHAR2(50),
  entregas_bonificadas tp_nt_id_entregas,
 
  ORDER MEMBER FUNCTION compararBonificacaoPorQuantidadeDeEntregas(SELF IN OUT NOCOPY tp_bonificacao, bonificacao tp_bonificacao) RETURN INTEGER
);
/
CREATE OR REPLACE TYPE BODY tp_bonificacao AS
  ORDER MEMBER FUNCTION compararBonificacaoPorQuantidadeDeEntregas(SELF IN OUT NOCOPY tp_bonificacao, bonificacao tp_bonificacao) RETURN INTEGER IS
    selfCnt NUMBER;
    otherCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO selfCnt
    FROM TABLE(SELF.entregas_bonificadas);
    SELECT COUNT(*) INTO otherCnt
    FROM TABLE(bonificacao.entregas_bonificadas);
 
    IF selfCnt > otherCnt THEN
      RETURN 1;
    ELSIF selfCnt < otherCnt THEN
      RETURN -1;
    ELSE
      RETURN 0;
    END IF;
  END;
END;
/
 
 

