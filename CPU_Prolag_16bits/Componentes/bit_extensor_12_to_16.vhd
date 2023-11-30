LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- entidade 

ENTITY bit_extensor_12_to_16 IS
PORT(
		ex_in: in std_logic_vector(12-1 downto 0); -- 12 bits entram
		ex_out: out std_logic_vector(16-1 downto 0) -- 16 bits na saída
	 );
END bit_extensor_12_to_16;

-- arquitetura

ARCHITECTURE extensivo OF bit_extensor_12_to_16 IS
BEGIN
	ex_out(15) <= '0';
	ex_out(14) <= '0';
	ex_out(13) <= '0';	
	ex_out(12) <= '0';
	ex_out(11) <= ex_in(11);
	ex_out(10) <= ex_in(10);
	ex_out(9)  <= ex_in(9);
	ex_out(8)  <= ex_in(8);
	ex_out(7)  <= ex_in(7);
	ex_out(6)  <= ex_in(6);
	ex_out(5)  <= ex_in(5);
	ex_out(4)  <= ex_in(4);
	ex_out(3)  <= ex_in(3);
	ex_out(2)  <= ex_in(2);
	ex_out(1)  <= ex_in(1);
	ex_out(0)  <= ex_in(0);
END extensivo;