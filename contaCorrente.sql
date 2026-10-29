DROP DATABASE IF EXISTS contaCorrente;

CREATE TABLE cliente (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(200),
    data_nascimento DATE NOT NULL
);

CREATE TABLE conta (
	id_conta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    saldo DECIMAL(10,2),
    limiteConta DECIMAL(10,2),
    ativo BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_conta_cliente
		FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);
    
CREATE TABLE movimentacao (
	id_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
    id_tipo_movimentacao INT NOT NULL,
    id_conta INT NOT NULL,
    valor DECIMAL(10,2),
    data_hora DATETIME NOT NULL,
    
    CONSTRAINT fk_movimentacao_tipoMovimentacao
        FOREIGN KEY (id_tipo_movimentacao)
        REFERENCES tipoMovimentacao(id_tipo_movimentacao),
        
	CONSTRAINT fk_movimentacao_conta
        FOREIGN KEY (id_conta)
        REFERENCES conta(id_conta)
);

CREATE TABLE tipoMovimentacao (
	id_tipo_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL
);




    