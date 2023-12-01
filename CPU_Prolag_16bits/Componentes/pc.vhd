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
	port(
        CLOCK				: IN std_logic;
		ENDERECO_ENTRADA	: IN std_logic_vector (15 downto 0);
		ENDERECO_SAIDA  	: OUT std_logic_vector (15 downto 0)
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
