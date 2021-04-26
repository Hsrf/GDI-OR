--Inserindo pacote
INSERT INTO tb_pacote VALUES(
    tp_pacote(1, 10, tp_endereco('51020-000', 'Rua Brasil', 187, 'Pina', 'Recife', 'PE'), to_date('23/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_pacote VALUES(
    tp_pacote(2, 379, tp_endereco('52010-020', 'Rua Padre Bernadino', 229, 'Boa  viagem', 'Recife', 'PE'), to_date('23/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_pacote VALUES(
    tp_pacote(3, 270, tp_endereco('57080-000', 'Rua da UFPE', 890, 'Derby', 'Recife', 'PE'), to_date('24/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_pacote VALUES(
    tp_pacote(4, 100, tp_endereco('50010-700', 'Rua da Macaxeira', 129, 'Madalena', 'Recife', 'PE'), to_date('25/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_pacote VALUES(
    tp_pacote(5, 78, tp_endereco('56030-030', 'Rua Dom Pedro', 41, 'Torre', 'Recife', 'PE'), to_date('26/04/2021','dd/mm/yyyy'))
);
 
--Inserindo remetente
INSERT INTO tb_remetente VALUES(
    tp_remetente('905.200.960-02', 'Igor Simões', to_date('14/08/1998','dd/mm/yyyy'), tp_telefones(tp_telefone('81988772458'), tp_telefone('81944782479')), tp_endereco('56030-031', 'Rua Marechal Deodoro', 12, 'Paulista', 'Recife', 'PE'), to_date('11/02/2020','dd/mm/yyyy'))
);
INSERT INTO tb_remetente VALUES(
    tp_remetente('716.609.050-28', 'João Pedro Jordão', to_date('11/06/55','dd/mm/yyyy'), tp_telefones(tp_telefone('81981781937'), tp_telefone('81944332465')), tp_endereco('56030-031', 'Rua Coronal da fonseca', 190, 'Boa Viagem', 'Recife', 'PE'), to_date('30/03/2020','dd/mm/yyyy'))
);
INSERT INTO tb_remetente VALUES(
    tp_remetente('561.509.440-00', 'Abigail Pereira', to_date('05/12/1967','dd/mm/yyyy'), tp_telefones(tp_telefone('81985552333')), tp_endereco('52050-021', 'Av Conselheiro Aguiar', 170, 'Torre', 'Recife', 'PE'), to_date('22/01/2021','dd/mm/yyyy'))
);
INSERT INTO tb_remetente VALUES(
    tp_remetente('229.100.720-37', 'Alexandre Gaules', to_date('07/09/1984','dd/mm/yyyy'), tp_telefones(tp_telefone('81982359928')), tp_endereco('56030-332', 'Av Má Viagem', 899, 'Derby', 'Recife', 'PE'), to_date('09/08/2021','dd/mm/yyyy'))
);
 
--Inserindo entregador
INSERT INTO tb_entregador VALUES(
    tp_entregador('009.817.070-85', 'Joaozinho da cunha', to_date('05/05/1979','dd/mm/yyyy'), tp_telefones(tp_telefone('81988772456'), tp_telefone('81944782400')), tp_endereco('56030-031', 'Rua dos brother', 15, 'Boa Viagem', 'Recife', 'PE'), 4650, null, tp_possui(tp_dependente('Maria', 1)), '148.94809.28-8')
);
INSERT INTO tb_entregador VALUES(
    tp_entregador('574.416.290-98', 'Vinicius Queiroz', to_date('01/05/1999','dd/mm/yyyy'), tp_telefones(tp_telefone('81981781922'), tp_telefone('81944332411')), tp_endereco('56030-031', 'Rua Desembargador Joao', 255, 'Boa Viagem', 'Recife', 'PE'), 2000,  (SELECT REF(E) FROM tb_entregador E WHERE cpf = '009.817.070-85'), tp_possui(tp_dependente('Maria', 1)),'307.21666.30-4')
);
INSERT INTO tb_entregador VALUES(
    tp_entregador('293.344.570-07', 'Pedro Buarque', to_date('22/12/1967','dd/mm/yyyy'), tp_telefones(tp_telefone('81985552320')), tp_endereco('52050-021', 'Rua do Lazer', 993, 'Tamarineira', 'Recife', 'PE'), 1200, null, tp_possui(tp_dependente('Maria', 1)),'428.75501.40-6')
);
INSERT INTO tb_entregador VALUES(
    tp_entregador('246.276.220-58', 'Lucas Neves', to_date('11/01/1984','dd/mm/yyyy'), tp_telefones(tp_telefone('81982359949')), tp_endereco('56030-332', 'Rua da Joana', 89, 'Piedade', 'Recife', 'PE'), 2700, (SELECT REF(E) FROM tb_entregador E WHERE cpf = '293.344.570-07'), tp_possui(tp_dependente('Igor Franca', 1), tp_dependente('Joaozinho', 2)), '474.21452.34-6')
);
 
--Inserindo armazem
INSERT INTO tb_armazem VALUES(
    tp_armazem('60.790.739/0001-76', 500, tp_endereco('59030-123', 'Rua da Laranjeira', 25, 'Boa Viagem', 'Recife', 'PE'), tp_nt_pagamentos())
);
INSERT INTO tb_armazem VALUES(
    tp_armazem('65.586.378/0001-64', 1000, tp_endereco('56030-456', 'Rua Maria do Bom Jesus', 253, 'Piedade', 'Recife', 'PE'), tp_nt_pagamentos())
);
INSERT INTO tb_armazem VALUES(
    tp_armazem('34.773.659/0001-00', 250, tp_endereco('51030-146', 'Rua do Frevo', 11, 'Boa Vista', 'Recife', 'PE'), tp_nt_pagamentos())
);
INSERT INTO tb_armazem VALUES(
    tp_armazem('92.819.308/0001-81', 700, tp_endereco('55030-999', 'Rua João Bosco', 94, 'Pina', 'Recife', 'PE'), tp_nt_pagamentos())
);
-- Inserindo bonificação
INSERT INTO tb_bonificacao VALUES(
    tp_bonificacao(1, 15, 'Entrega feita em até 1 dia',tp_nt_id_entregas())
);
 
INSERT INTO tb_bonificacao VALUES(
tp_bonificacao(2, 7, 'Entrega feita em até 3 dias',tp_nt_id_entregas())
);
 
INSERT INTO tb_bonificacao VALUES(
tp_bonificacao(3, 2, 'Entrega feita em até 5 dias',tp_nt_id_entregas())
);
 
-- Inserindo entrega
INSERT INTO tb_entrega VALUES(
    tp_entrega(1, (SELECT REF(A) FROM tb_entregador A WHERE cpf='009.817.070-85'), (SELECT REF(P) FROM tb_pacote P where id_pacote=1), to_date('24/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_entrega VALUES(
    tp_entrega(2, (SELECT REF(A) FROM tb_entregador A WHERE cpf='574.416.290-98'), (SELECT REF(P) FROM tb_pacote P where id_pacote=2), to_date('25/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_entrega VALUES(
    tp_entrega(3, (SELECT REF(A) FROM tb_entregador A WHERE cpf='293.344.570-07'), (SELECT REF(P) FROM tb_pacote P where id_pacote=3), to_date('28/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_entrega VALUES(
    tp_entrega(4, (SELECT REF(A) FROM tb_entregador A WHERE cpf='293.344.570-07'), (SELECT REF(P) FROM tb_pacote P where id_pacote=4), to_date('29/04/2021','dd/mm/yyyy'))
);
INSERT INTO tb_entrega VALUES(
    tp_entrega(5, (SELECT REF(A) FROM tb_entregador A WHERE cpf='574.416.290-98'), (SELECT REF(P) FROM tb_pacote P where id_pacote=5), to_date('29/04/2021','dd/mm/yyyy'))
);
-- Inserindo armazena
INSERT INTO tb_armazena VALUES(
    tp_armazena(1, (SELECT REF(R) FROM tb_remetente R WHERE cpf='905.200.960-02'), tp_nt_ref_pacotes(tp_ref_pacote((SELECT REF(P) FROM tb_pacote P where id_pacote=1))), (SELECT REF(A) FROM tb_armazem A WHERE cnpj='60.790.739/0001-76'), 120)
);
 
INSERT INTO tb_armazena VALUES(
    tp_armazena(2, (SELECT REF(R) FROM tb_remetente R WHERE cpf='716.609.050-28'), tp_nt_ref_pacotes(tp_ref_pacote((SELECT REF(P) FROM tb_pacote P where id_pacote=2))), (SELECT REF(A) FROM tb_armazem A WHERE cnpj='60.790.739/0001-76'), 120)
);
 
INSERT INTO tb_armazena VALUES(
    tp_armazena(3, (SELECT REF(R) FROM tb_remetente R WHERE cpf='229.100.720-37'), tp_nt_ref_pacotes(tp_ref_pacote((SELECT REF(P) FROM tb_pacote P where id_pacote=3))), (SELECT REF(A) FROM tb_armazem A WHERE cnpj='60.790.739/0001-76'), 120)
);
 

