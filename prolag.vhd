-- Processador
library ieee;
use ieee.std_logic_1164.all;
-- ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- use ieee.std_logic_arith.all;

entity prolag is 
	port(
		CLOCK : IN std_logic;
		
		-- saídas dos componentes (usados para monitoramento no waveform)
		PC_SAIDA : OUT std_logic_vector(15 downto 0);
		
		ROM_SAIDA : OUT std_logic_vector(15 downto 0);
		
		BDR_SAIDA_1, BDR_SAIDA_2 : OUT std_logic_vector(15 downto 0);
		
		-- Ula
		ULA_RESULTADO : OUT std_logic_vector(15 downto 0);
		
		RAM_SAIDA : OUT std_logic_vector(15 downto 0);
		R_DEST: OUT std_logic;
		MEM_TO_REG_S: OUT std_logic
		
		-- MUX_2X1_SAIDA : OUT std_logic_vector(15 downto 0)
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
		
		-- Saídas
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

-- Memória de Instruções (ROM)
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
END component;

-- Extensor de 12 para 16 bits
component bit_extensor_12_to_16 IS
PORT(
		ex_in: in std_logic_vector(12-1 downto 0);
		ex_out: out std_logic_vector(16-1 downto 0)
	 );
END component;

-- Memória de Dados (RAM)
component ram_proclag IS
PORT(
		Clock, ram_LerMem, ram_EscMem: in std_logic;
		ram_end_acessado: in std_logic_vector(16-1 downto 0);
		ram_dado_escrever: in std_logic_vector(16-1 downto 0);
		ram_dado_lido: out std_logic_vector(16-1 downto 0)
		);
END component;

-- Unidade Lógica Aritmética
component ula_proclag IS
PORT(
	a, b : in std_logic_vector(16-1 downto 0);
	ula_controle : in std_logic_vector(3-1 downto 0);
	ula_resultado : out std_logic_vector(16-1 downto 0);
	zero : out std_logic
	);
END component;

-- Multiplexador 2x1
component mux2x1 is
	port(
		E0, E1: in std_logic_vector(15 downto 0);
		SELETOR: in std_logic;
		SAIDA			: out std_logic_vector(15 downto 0)
	);
end component;

-- Multiplexador 2x1 de 3 bits
component mux2x1_3b is
	port(
		EN0, EN1 : in std_logic_vector(2 downto 0);
		SEL : in std_logic;
		S			: out std_logic_vector(2 downto 0)
	);
end component;


signal PC_S: std_logic_vector(15 downto 0);
signal ROM_S : std_logic_vector(15 downto 0);

-- Divisão da Instrução
-- alias OP: std_logic_vector(3 downto 0) is ROM_S(15 downto 12);
-- alias RD: std_logic_vector(2 downto 0) is ROM_S(11 downto 9);
-- alias RS: std_logic_vector(2 downto 0) is ROM_S(8 downto 6);
-- alias RT: std_logic_vector(2 downto 0) is ROM_S(5 downto 3);
-- alias F: std_logic_vector(2 downto 0) is ROM_S(2 downto 0);
-- signal OP: std_logic_vector(3 downto 0);
-- OP <= ROM_S(15 downto 12);
alias ENDERECO: std_logic_vector(5 downto 0) is ROM_S(5 downto 0);

-- alias SALTO: std_logic_vector(12 downto 0) is ROM_S(12 downto 0);

signal OP: std_logic_vector(3 downto 0);
signal RD: std_logic_vector(2 downto 0);
signal RS: std_logic_vector(2 downto 0);
signal RT: std_logic_vector(2 downto 0);
signal F: std_logic_vector(2 downto 0);
signal SALTO: std_logic_vector(11 downto 0);
-- signal R_entrada_1
-- signal r_entrada_2

-- Flags da UC
signal FLAG_REG_DEST, FLAG_BRANCH, FLAG_LER_MEM, FLAG_MEM_PARA_REG, FLAG_ESC_MEM, FLAG_ULA_FONT, FLAG_ESC_REG : std_logic;
signal FLAG_ULA_OP : std_logic_vector(2 downto 0);

-- signal de saida de ra saida de b do bdr
signal REG_SAIDA_1, REG_SAIDA_2 : std_logic_vector(15 downto 0);

-- Saidas da ula
signal RESULTADO_ULA: std_logic_vector(15 downto 0);
signal ZERO_ULA : std_logic;

signal EXTENSOR_PARA_ULA: std_logic_vector(15 downto 0); -- extensor de baixo
signal MUX_PARA_ULA: std_logic_vector(15 downto 0);
signal EXTENSOR_DO_ENDERECO: std_logic_vector(15 downto 0); --

signal MEM_PARA_MUX : std_logic_vector(15 downto 0);
signal MUX_DO_PC : std_logic_vector(15 downto 0);
signal MUX_REG_A_SER_ESCRITO : std_logic_vector(2 downto 0);
signal MUX_MEM_SAIDA : std_logic_vector(15 downto 0);

signal SAIDA_MEM : std_logic_vector(15 downto 0);
-- signal PC_ENTRADA : std_logic_vector(15 downto 0);

signal AND_0 : std_logic;

signal PC_INCREMENTADO : std_logic_vector(15 downto 0);

begin
	PORT_PC : pc port map(CLOCK, MUX_DO_PC, PC_S);
	PORT_ROM : rom_mem port map(CLOCK, PC_S, ROM_S);
	PORT_UC : uc port map(CLOCK, OP, F, FLAG_REG_DEST, FLAG_BRANCH, FLAG_LER_MEM, FLAG_MEM_PARA_REG, FLAG_ULA_OP, FLAG_ESC_MEM, FLAG_ULA_FONT, FLAG_ESC_REG);
	PORT_MUX_ENTRADA_BDR : mux2x1_3b port map(RS, RT, FLAG_REG_DEST, MUX_REG_A_SER_ESCRITO);
	PORT_BDR :bdr port map(CLOCK, FLAG_ESC_REG, RD, RS, MUX_REG_A_SER_ESCRITO, MUX_MEM_SAIDA, REG_SAIDA_1, REG_SAIDA_2);
	PORT_EXTENSOR_BAIXO : bit_extensor_6_to_16 port map(ENDERECO, EXTENSOR_PARA_ULA);
	PORT_EXTENSOR_DO_ENDERECO : bit_extensor_12_to_16 port map(SALTO, EXTENSOR_DO_ENDERECO);
	PORT_MUX_ULA_ENTRADA : mux2x1 port map(REG_SAIDA_2, EXTENSOR_PARA_ULA, FLAG_ULA_FONT, MUX_PARA_ULA);
	PORT_ULA : ula_proclag port map(REG_SAIDA_1, MUX_PARA_ULA, FLAG_ULA_OP, RESULTADO_ULA, ZERO_ULA);
	PORT_MEMORIA : ram_proclag port map(CLOCK, FLAG_LER_MEM, FLAG_ESC_MEM, RESULTADO_ULA, REG_SAIDA_2, SAIDA_MEM);
	PORT_MUX_MEM : mux2x1 port map(RESULTADO_ULA, SAIDA_MEM, FLAG_MEM_PARA_REG, MUX_MEM_SAIDA);
	                                      -- dangerous code below
	PORT_MUX_SALTO : mux2x1 port map(PC_INCREMENTADO, EXTENSOR_DO_ENDERECO, AND_0, MUX_DO_PC);-- see how to turn the increment into a separated signal

	OP <= ROM_S(15 downto 12);
	RD <= ROM_S(11 downto 9);
	RS <= ROM_S(8 downto 6);
	RT <= ROM_S(5 downto 3);
	F <= ROM_S(2 downto 0);
	SALTO <= ROM_S(11 downto 0);
	
	PC_INCREMENTADO <= std_logic_vector(unsigned(PC_S) + to_unsigned(1, PC_S'length));
	AND_0 <= FLAG_BRANCH and ZERO_ULA;
	MEM_TO_REG_S <= FLAG_MEM_PARA_REG;
	PC_SAIDA <= PC_S;	
	ROM_SAIDA <= ROM_S;
	-- SEM OS OP_S ETC
	R_DEST <= FLAG_REG_DEST;
	BDR_SAIDA_1 <= REG_SAIDA_1;
	BDR_SAIDA_2 <= REG_SAIDA_2;
	ULA_RESULTADO <= RESULTADO_ULA;
	
	-- ULA_OVERFLOW <= 
	RAM_SAIDA <= MUX_MEM_SAIDA;
--	MUX_2X1_SAIDA <= 
	-- MUX_DO_PC <= 
end architecture;	
