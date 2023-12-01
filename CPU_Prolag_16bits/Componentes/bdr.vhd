------------------------------------------------------------
-- Banco de Registradores (BDR)
--
-- Armazena os registradores com seus respectivos valores e
-- realiza as operaç~oes de escrita e leitura.
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bdr is 
	port(
		-- Entradas
		CLOCK : IN std_logic;
		ESC_REG : IN std_logic; -- sinal de controle
		REG1_ENDERECO : IN std_logic_vector(2 downto 0);
		REG2_ENDERECO : IN std_logic_vector(2 downto 0);
		ENDERECO_REG_ESC : IN std_logic_vector(2 downto 0); -- Escrita em registradores
		DADO_ESC : IN std_logic_vector(15 downto 0);
		
		-- Saídas
		REG1_VALOR : OUT std_logic_vector(15 downto 0);
		REG2_VALOR : OUT std_logic_vector(15 downto 0)
	);
end entity;

architecture main of bdr is
	type bdr_tipo is array(2 downto 0) of std_logic_vector(15 downto 0);
	
	signal banco_de_reg : bdr_tipo;
begin
	process(CLOCK) -- faz executar o process toda vez q os valores dentro mudam
	begin
		if rising_edge(CLOCK) then
		-- Operação de escrita em registradores
			if (ESC_REG = '1') then
				banco_de_reg(to_integer(unsigned(ENDERECO_REG_ESC))) <= DADO_ESC;
			end if;
		end if;
		-- Operação de leitura de registradores
		REG1_VALOR <= banco_de_reg(to_integer(unsigned(REG1_ENDERECO)));
		REG2_VALOR <= banco_de_reg(to_integer(unsigned(REG2_ENDERECO)));
	end process;
end architecture;
