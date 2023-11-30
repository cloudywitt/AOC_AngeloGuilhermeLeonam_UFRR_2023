-- Processador
library ieee;
use ieee.std_logic_1164.all;

entity prolag is 
	port(
		CLOCK : IN std_logic;
		
		-- sa´idas dos componentes (n~ao usado por dentro)
		PC_SAIDA : OUT std_logic_vector(15 downto 0);
		
		ROM_SAIDA : OUT std_logic_vector(15 downto 0)
		
		BDR_SAIDA_1, BDR_SAIDA_2 : OUT std_logic_vector(15 downto 0);
		
		-- Ula
		ULA_RESULTADO : OUT std_logic_vector(15 downto 0);
		ULA_OVERFLOW  : OUT std_logic;
		
		RAM_SAIDA : OUT std_logic_vector(15 downto 0);
		
		MUX_2X1_SAIDA : OUT std_logic_vector(15 downto 0);
	);
end entity;

architecture main of prolag is

-- Banco de Registradores
component bdr is 
	port(
		CLOCK : IN std_logic;
		ESC_REG : IN std_logic;
		REG1_ENDERECO : IN std_logic_vector(2 downto 0);
		REG2_ENDERECO : IN std_logic_vector(2 downto 0);
		ENDERECO_REG_ESC : IN std_logic_vector(2 downto 0);
		DADO_ESC : IN std_logic_vector(15 downto 0);
		
		-- Sa´idas
		REG1_VALOR : OUT std_logic_vector(15 downto 0);
		REG2_VALOR : OUT std_logic_vector(15 downto 0)
	);
end component;

-- Program Counter
component pc is
	generic(
		BITS_NUM : natural := 16
	);
	
	port(
		CLOCK			    	: IN std_logic;
		ENDERECO_ENTRADA	: IN std_logic_vector (BITS_NUM-1 downto 0);
		ENDERECO_SAIDA  	: OUT std_logic_vector (BITS_NUM-1 downto 0)
	);
end component;

-- Unidade de Controle
component uc is
	port(
		CLOCK  : IN std_logic;
		OPCODE : IN std_logic_vector(3 downto 0);
		FUNCT	 : IN std_logic_vector(2 downto 0);
		REG_DEST     : OUT std_logic;
		BRANCH		 : OUT std_logic;
		LER_MEM      : OUT std_logic;
		MEM_PARA_REG : OUT std_logic;
		ULA_OP       : OUT std_logic_vector(2 downto 0);
		ESC_MEM      : OUT std_logic;
		ULA_FONT     : OUT std_logic;
		ESC_REG      : OUT std_logic
	);
end component;

-- Mem´oria de Instruç~oes (ROM)
component rom_mem is
	generic(
		BITS_NUM : natural := 16
	);
	
	port(
		CLOCK					: in std_logic;
		ENDERECO_RECEBIDO	: in std_logic_vector(BITS_NUM-1 downto 0);
		INSTRUCAO_CUSPIDA	: out std_logic_vector(BITS_NUM-1 downto 0)
    );
end component;

-- Extensor de 6 para 16 bits
component bit_extensor_6_to_16 IS
PORT(
		ex_in: in std_logic_vector(6-1 downto 0);
		ex_out: out std_logic_vector(16-1 downto 0)
		);
END bit_extensor_6_to_16;

-- Extensor de 12 para 16 bits
component bit_extensor_12_to_16 IS
PORT(
		ex_in: in std_logic_vector(12-1 downto 0);
		ex_out: out std_logic_vector(16-1 downto 0)
	 );
END bit_extensor_12_to_16;

-- Mem´oria de Dados (RAM)
component ram_proclag IS
PORT(
		Clock, ram_LerMem, ram_EscMem: in std_logic;
		ram_end_acessado: in std_logic_vector(16-1 downto 0);
		ram_dado_escrever: in std_logic_vector(16-1 downto 0);
		ram_dado_lido: out std_logic_vector(16-1 downto 0)
		);
END ram_proclag;

-- Unidade L´ogica Aritm´etica
component ula_proclag IS
PORT(
	a, b : in std_logic_vector(16-1 downto 0);
	ula_controle : in std_logic_vector(3-1 downto 0);
	ula_resultado : out std_logic_vector(16-1 downto 0);
	zero : out std_logic
	);
END ula_proclag;


signal pc_saida : std_logic_vector(15 downto 0);
signal rom_saida : std_logic_vector(15 downto 0);
signal
