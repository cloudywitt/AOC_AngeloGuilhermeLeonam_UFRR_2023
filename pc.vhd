------------------------------------------------------------
-- Program Counter (PC)
--
-- Responsavel por armazenar o endereço da proxima
-- instruçao (do banco de instruçoes) a ser executada.
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pc is
	-- como se fossem declaraçao de constantes, para reduzir magic numbers
	generic(
		BITS_NUM : natural := 16 -- numero de bits do processador
	);
	
	port(
		--- Sinal de clock: responsavel por sincronizar a execuçao dos componentes
		CLOCK			    	: IN std_logic;
		ENDERECO_ENTRADA	: IN std_logic_vector (BITS_NUM-1 downto 0);
		ENDERECO_SAIDA  	: OUT std_logic_vector (BITS_NUM-1 downto 0)
	);
end entity;

architecture main of pc is
begin
	process(CLOCK)
	begin
		if rising_edge(CLOCK) then
			ENDERECO_SAIDA <= ENDERECO_ENTRADA;
		end if;
	end process;
end architecture;
