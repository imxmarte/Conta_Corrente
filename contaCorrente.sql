DROP DATABASE IF EXISTS ContaCorrente;
CREATE DATABASE ContaCorrente;
USE ContaCorrente;

CREATE TABLE IF NOT EXISTS Cliente (
	idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(200),
    data_nascimento DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS ContasCorrentes (
	idConta INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    saldo DECIMAL(10,2),
    limiteCredito DECIMAL(10,2),
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
    valor DECIMAL(10,2),
    data_hora DATETIME NOT NULL,
    
    CONSTRAINT fk_Movimentacoes_tipoMovimentacoes
        FOREIGN KEY (idTipoMovimentacoes)
        REFERENCES tipoMovimentacoes(idTipoMovimentacoes),
        
	CONSTRAINT fk_Movimentacoes_ContasCorrentes
        FOREIGN KEY (idConta)
        REFERENCES ContasCorrentes(idConta)
);

DROP USER IF EXISTS 'Admin'@'localhost';
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'admin1234';
GRANT ALTER, INSERT, DELETE,  CREATE ON contaCorrente.* TO 'Admin'@'localhost';

DROP USER IF EXISTS 'Correntista'@'localhost';
CREATE USER 'Correntista'@'localhost' IDENTIFIED BY 'corren1234';
GRANT INSERT ON ContaCorrente.Cliente TO 'Correntista'@'localhost';
GRANT INSERT ON ContaCorrente.ContasCorrentes TO 'Correntista'@'localhost';
GRANT INSERT ON ContaCorrente.Movimentacoes TO 'Correntista'@'localhost';
GRANT SELECT ON ContaCorrente.* TO 'Correntista'@'localhost';


    