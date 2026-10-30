use contaCorrente;

INSERT INTO cliente
(nome, cpf, telefone, email, endereco, data_nascimento)
VALUES
('Ana Machado', '22222233331','9 81274091', 'anamachado@gmail.com', 'rua das flores', '1987-12-25'),
('Joana Maria', '11134567890','9 94809930','joanamaria@gmail.com', 'rua do Carmo', '1970-02-01'),
('Carlos Sobrinho','99988877710','9 92223355', 'carlossobrinho@hotmail.com', 'rua José França', '1960-01-19'),
('Matheus Augusto', '11022287655','9 88223301', 'matheus.augusto@gmail.com', 'rua xv de novembro', '2000-10-11'),
('Marcela Alves', '23748950348', '41999934560', 'marcela@email.com', 'Rua de tal, 567', '2001-12-19');

INSERT INTO ContasCorrentes
(idCliente, saldo, LimiteCredito, ativo) 
VALUES
	(1, 200.00, 00.00, TRUE),
  (2, 4800.00, 5000.00, TRUE),
  (3, 50.00, 00.00, TRUE),
  (4, 00.00, 00.00, TRUE),
  (5, 100.00, 20.00, TRUE);

INSERT INTO tipoMovimentacoes (tipo)
VALUES
('DEPOSITO'),
('SAQUE');

INSERT INTO Movimentacoes
(idTipoMovimentacoes, idConta, valor, data_hora)
VALUES
(1, 1, 100.00, '2025-10-01 11:11:10'),
(2, 1, 50.00,  '2025-10-29 19:50:30'),
(1, 1, 80.00,  '2025-11-10 14:30:50'),

(1, 2, 1000.00, '2025-12-24 08:00:20'),
(2, 2, 500.00,  '2026-01-15 11:30:00'),
(1, 2, 200.00,  '2026-02-17 15:50:10'),

(1, 3, 100.00, '2026-03-22 14:00:32'),
(2, 3, 30.00,  '2026-04-30 10:30:00'),
(1, 3, 50.00,  '2026-05-09 06:00:25'),

(1, 4, 200.00, '2026-06-20 09:30:55'),
(2, 4, 50.00,  '2026-07-31 11:45:00'),
(1, 4, 100.00, '2026-08-08 08:08:08'),

(1, 5, 150.00, '2026-09-12 10:20:00'),
(2, 5, 40.00,  '2026-10-15 14:35:00'),
(1, 5, 75.00,  '2026-11-20 09:15:00');

select* from Cliente order by nome;

SELECT * FROM ContasCorrentes;

SELECT * FROM tipoMovimentacoes;

SELECT * FROM Movimentacoes;

SHOW TRIGGERS FROM ContaCorrente;
