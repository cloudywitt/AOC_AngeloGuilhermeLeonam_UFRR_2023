-- Extensor de 6 bits para 16 bits

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- entidade ;

ENTITY bit_extensor_6_to_16 IS
PORT(
		ex_in: in std_logic_vector(6-1 downto 0); -- 6 bits entram
		ex_out: out std_logic_vector(16-1 downto 0) -- 16 bits na saída
		);
END bit_extensor_6_to_16;

-- arquitetura

ARCHITECTURE Conversao OF bit_extensor_6_to_16 IS
BEGIN
	ex_out(15) <= '0';
	ex_out(14) <= '0';
	ex_out(13) <= '0';	
	ex_out(12) <= '0';
	ex_out(11) <= '0';
	ex_out(10) <= '0';
	ex_out(9)  <= '0';
	ex_out(8)  <= '0';
	ex_out(7)  <= '0';
	ex_out(6)  <= '0';
	ex_out(5)  <= ex_in(5);
	ex_out(4)  <= ex_in(4);
	ex_out(3)  <= ex_in(3);
	ex_out(2)  <= ex_in(2);
	ex_out(1)  <= ex_in(1);
	ex_out(0)  <= ex_in(0);
END Conversao;
