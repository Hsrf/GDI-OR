-- Testar procedures de entregador e remetente
DECLARE
entregador tp_entregador;
remetente tp_remetente;
BEGIN
    SELECT VALUE(p) INTO entregador FROM tb_entregador p WHERE p.cpf = '293.344.570-07';
    entregador.detalhes();
    SELECT VALUE(p) INTO remetente FROM tb_remetente p WHERE p.cpf = '905.200.960-02';
    remetente.detalhes();
END;
/
-- Mostrar entregas bonificadas para cada tipo de bonificação
SELECT * FROM TABLE(SELECT B.entregas_bonificadas FROM tb_bonificacao B WHERE id_bonificacao = 1);
SELECT * FROM TABLE(SELECT B.entregas_bonificadas FROM tb_bonificacao B WHERE id_bonificacao = 2);
SELECT * FROM TABLE(SELECT B.entregas_bonificadas FROM tb_bonificacao B WHERE id_bonificacao = 3);
/
-- Testar ORDER de bonificação
DECLARE
    bonificacao1 tp_bonificacao;
    bonificacao2 tp_bonificacao;
    cmp INTEGER;
BEGIN
    SELECT VALUE(B) INTO bonificacao1 FROM tb_bonificacao B WHERE id_bonificacao = 2;
    SELECT VALUE(B) INTO bonificacao2 FROM tb_bonificacao B WHERE id_bonificacao = 1;
    cmp := bonificacao1.compararBonificacaoPorQuantidadeDeEntregas(bonificacao2);
    IF cmp = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Bonificação mais aplicada:');
        DBMS_OUTPUT.PUT_LINE('Valor:' || TO_CHAR(bonificacao1.valor));
        DBMS_OUTPUT.PUT_LINE('Descrição:' || TO_CHAR(bonificacao1.descricao));
    ELSIF cmp = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Bonificação mais aplicada:');
        DBMS_OUTPUT.PUT_LINE('Valor:' || TO_CHAR(bonificacao2.valor));
        DBMS_OUTPUT.PUT_LINE('Descrição:' || TO_CHAR(bonificacao2.descricao));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ambas bonificações foram aplicadas em mesma quantidade.');
    END IF;
END;
/
-- Testar função de pagamento do armazém
DECLARE
    armazem tp_armazem;
BEGIN
    SELECT VALUE(A) INTO armazem FROM tb_armazem A WHERE cnpj = '34.773.659/0001-00';
    armazem.pagarEntregador('293.344.570-07');
END;
/
-- Mostrar pagamentos para armazem selecionado
SELECT P.entregador.cpf, valor, data_de_pagamento FROM TABLE(SELECT A.pagamentos FROM tb_armazem A WHERE cnpj = '34.773.659/0001-00') P;
 
 
 


