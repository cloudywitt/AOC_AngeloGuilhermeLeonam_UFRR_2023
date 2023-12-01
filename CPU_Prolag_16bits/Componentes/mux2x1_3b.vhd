-- Multiplexador 2x1 de 3 bits
library ieee;
use ieee.std_logic_1164.all;

entity mux2x1_3b is
	port(
		EN0, EN1 : in std_logic_vector(2 downto 0);
		SEL : in std_logic;
		S			: out std_logic_vector(2 downto 0)
	);
end entity;
architecture main of mux2x1_3b is
begin
	process(EN0, EN1, SEL) is
	begin
		if (SEL = '0') then 
			S<= EN0;
		else
			S <= EN1;
		end if;
	end process;
end architecture;
