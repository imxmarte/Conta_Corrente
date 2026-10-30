DROP DATABASE IF EXISTS ContaCorrente;
CREATE DATABASE ContaCorrente;
USE ContaCorrente;

CREATE TABLE IF NOT EXISTS Cliente (
	idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(200),
    data_nascimento DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS ContasCorrentes (
	idConta INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    saldo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    limiteCredito DECIMAL(10,2) DEFAULT 0.00,
    ativo BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_conta_Cliente
		FOREIGN KEY (idCliente)
        REFERENCES Cliente(idCliente)
);
  
CREATE TABLE IF NOT EXISTS tipoMovimentacoes (
	idTipoMovimentacoes INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Movimentacoes (
	idMovimentacoes INT PRIMARY KEY AUTO_INCREMENT,
    idTipoMovimentacoes INT NOT NULL,
    idConta INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_hora DATETIME NOT NULL,
    
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
 
Before INSERT ON Movimentacoes
FOR EACH ROW
BEGIN
	DECLARE v_saldo DECIMAL(10,2);
	DECLARE v_LimiteCredito DECIMAL(10,2);
    
	SELECT saldo, LimiteCredito
	INTO v_saldo, v_limiteCredito
	From ContasCorrentes
	Where idConta = NEW.idConta;

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
END$$

DELIMITER ;

DROP USER IF EXISTS 'Admin'@'localhost';
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'admin1234';
GRANT ALL PRIVILEGES ON contaCorrente.* TO 'Admin'@'localhost';

DROP USER IF EXISTS 'Correntista'@'localhost';
CREATE USER 'Correntista'@'localhost' IDENTIFIED BY 'corren1234';
GRANT INSERT ON ContaCorrente.Cliente TO 'Correntista'@'localhost';
GRANT INSERT ON ContaCorrente.ContasCorrentes TO 'Correntista'@'localhost';
GRANT INSERT ON ContaCorrente.Movimentacoes TO 'Correntista'@'localhost';
GRANT SELECT ON ContaCorrente.* TO 'Correntista'@'localhost';


    
