use contaCorrente;

INSERT INTO cliente
(nome, cpf, telefone, email, endereco, data_nascimento)
VALUES
('Marcela Alves', '23748950348', '41999934560', 'marcela@email.com', 'Rua de tal, 567', '2001-12-19');

select* from Cliente order by nome;