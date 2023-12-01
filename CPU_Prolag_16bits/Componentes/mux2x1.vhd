library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
	port(
		E0, E1: in std_logic_vector(15 downto 0);
		SELETOR: in std_logic;
		SAIDA			: out std_logic_vector(15 downto 0)
	);
end entity;

architecture main of mux2x1 is
begin

	process(E0, E1, SELETOR) is
	begin
		if (SELETOR = '0') then 
			SAIDA <= E0;
		else
			SAIDA <= E1;
		end if;
	end process;
end architecture;