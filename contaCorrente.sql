DROP DATABASE IF EXISTS ContaCorrente;
CREATE DATABASE ContaCorrente;
USE ContaCorrente;

CREATE TABLE IF NOT EXISTS Clientes (
      idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(200),
    data_nascimento DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS ContasCorrentes (
      idConta INT PRIMARY KEY AUTO_INCREMENT,
    numeroConta VARCHAR(10) NOT NULL UNIQUE,
    idCliente INT NOT NULL,
    saldo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    limiteCredito DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_limiteCredito CHECK (limiteCredito >= 0),
    CONSTRAINT chk_saldo_limite CHECK (saldo >= -limiteCredito),

    CONSTRAINT fk_ContasCorrentes_Clientes
            FOREIGN KEY (idCliente)
        REFERENCES Clientes(idCliente)
);

CREATE TABLE IF NOT EXISTS tipoMovimentacoes (
      idTipoMovimentacoes INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Movimentacoes (
      idMovimentacoes INT PRIMARY KEY AUTO_INCREMENT,
    idTipoMovimentacoes INT NOT NULL,
    idConta INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_hora DATETIME NOT NULL,

    CONSTRAINT chk_valor_positivo CHECK (valor > 0),

    CONSTRAINT fk_Movimentacoes_tipoMovimentacoes
        FOREIGN KEY (idTipoMovimentacoes)
        REFERENCES tipoMovimentacoes(idTipoMovimentacoes),

      CONSTRAINT fk_Movimentacoes_ContasCorrentes
        FOREIGN KEY (idConta)
        REFERENCES ContasCorrentes(idConta)
);

DROP TRIGGER IF EXISTS verificar_saque;
DELIMITER $$
CREATE TRIGGER verificar_saque
BEFORE INSERT ON Movimentacoes
FOR EACH ROW
BEGIN
      DECLARE v_saldo DECIMAL(10,2);
      DECLARE v_limiteCredito DECIMAL(10,2);

      SELECT saldo, limiteCredito
      INTO v_saldo, v_limiteCredito
      FROM ContasCorrentes
      WHERE idConta = NEW.idConta;

      IF NEW.idTipoMovimentacoes = 2
            AND NEW.valor > (v_saldo + v_limiteCredito) THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'SALDO INSUFICIENTE PARA SAQUE';

      END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS atualizar_saldo;
DELIMITER $$
CREATE TRIGGER atualizar_saldo
AFTER INSERT ON Movimentacoes
FOR EACH ROW
BEGIN
    IF NEW.idTipoMovimentacoes = 1 THEN
        UPDATE ContasCorrentes
        SET saldo = saldo + NEW.valor
        WHERE idConta = NEW.idConta;

    ELSEIF NEW.idTipoMovimentacoes = 2 THEN
        UPDATE ContasCorrentes
        SET saldo = saldo - NEW.valor
        WHERE idConta = NEW.idConta;
    END IF;
END $$
DELIMITER ;

DROP USER IF EXISTS 'Admin'@'localhost';
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'admin1234';
GRANT ALL PRIVILEGES ON ContaCorrente.* TO 'Admin'@'localhost';

DROP USER IF EXISTS 'Correntista'@'localhost';
CREATE USER 'Correntista'@'localhost' IDENTIFIED BY 'corren1234';
GRANT INSERT ON ContaCorrente.Clientes TO 'Correntista'@'localhost';
GRANT INSERT ON ContaCorrente.ContasCorrentes TO 'Correntista'@'localhost';
GRANT INSERT ON ContaCorrente.Movimentacoes TO 'Correntista'@'localhost';
GRANT SELECT ON ContaCorrente.* TO 'Correntista'@'localhost';

FLUSH PRIVILEGES;

INSERT INTO Clientes
(nome, cpf, telefone, email, endereco, data_nascimento)
VALUES
('Sylvaney Barros', '22222233331', '41985293964', 'joice.barros07@gmail.com', 'Rua Bororos, 376', '1991-03-07'),
('Renan da Silva', '11134567890', '41994809930', 'renandasilva@gmail.com', 'Rua do Carmo, 45', '1970-02-01'),
('Stephany Barbosa', '99988877710', '41987857013', 'stephanybarbosasil@gmail.com', 'Rua Anita Muller Palu, 162', '2007-02-20'),
('Marcela Alves', '23748950348', '41999934560', 'marcela@email.com', 'Rua de tal, 567', '2001-12-19');

INSERT INTO ContasCorrentes
(numeroConta, idCliente, saldo, limiteCredito, ativo)
VALUES
('0001-1', 1, 0.00, 0.00, TRUE),
('0002-2', 2, 0.00, 5000.00, TRUE),
('0003-3', 3, 0.00, 0.00, TRUE),
('0004-4', 4, 0.00, 0.00, TRUE);

INSERT INTO tipoMovimentacoes (idTipoMovimentacoes, tipo)
VALUES
(1, 'DEPOSITO'),
(2, 'SAQUE');

INSERT INTO Movimentacoes
(idTipoMovimentacoes, idConta, valor, data_hora)
VALUES

(1, 1, 500.00,  '2026-03-05 09:15:00'),
(2, 1, 120.00,  '2026-04-18 14:30:00'),
(1, 1, 250.00,  '2026-06-02 10:45:00'),

(1, 2, 1000.00, '2026-02-10 08:00:00'),
(2, 2, 3500.00, '2026-05-21 16:20:00'),
(1, 2, 800.00,  '2026-08-14 11:10:00'),

(1, 3, 300.00,  '2026-01-22 13:00:00'),
(2, 3, 80.00,   '2026-07-09 17:45:00'),
(1, 3, 150.00,  '2026-09-30 09:05:00'),

(1, 4, 1200.00, '2026-04-03 10:00:00'),
(2, 4, 450.00,  '2026-06-27 15:30:00'),
(2, 4, 200.00,  '2026-10-12 12:00:00');

SELECT * FROM Clientes ORDER BY nome;
SELECT * FROM ContasCorrentes;
SELECT * FROM tipoMovimentacoes;
SELECT * FROM Movimentacoes ORDER BY idConta, data_hora;
SHOW TRIGGERS FROM ContaCorrente;


    
