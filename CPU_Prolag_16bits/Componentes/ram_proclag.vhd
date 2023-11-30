-- Código em VHDL que descreve a memória RAM do processador "Prolag"

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ram_proclag IS
PORT(
		Clock, ram_LerMem, ram_EscMem: in std_logic; -- clock e flags da UC
		ram_end_acessado: in std_logic_vector(16-1 downto 0);
		ram_dado_escrever: in std_logic_vector(16-1 downto 0);
		ram_dado_lido: out std_logic_vector(16-1 downto 0)
		);
END ram_proclag;

ARCHITECTURE procedimento OF ram_proclag IS

SIGNAL int: integer;
SIGNAL ram_endereco: std_logic_vector(8-1 downto 0);

TYPE mem_de_dados is array (0 to 255) OF std_logic_vector(16-1 downto 0);

SIGNAL RAM: mem_de_dados := ( (others => (others => '0') ) ); -- mesmo que mem_de_dados := others => "0000000000000000"

BEGIN

	ram_endereco <= ram_end_acessado (8 downto 1);
	
	PROCESS(clock)
	
		BEGIN
			IF(rising_edge(clock)) THEN -- crista da onda
				IF(ram_EscMem = '1') THEN
				RAM(to_integer ( unsigned (ram_endereco) ) ) <= ram_dado_escrever;
				END IF;
			END IF;
	END PROCESS;
		ram_dado_lido <= RAM( to_integer (unsigned (ram_endereco) ) ) WHEN (ram_LerMem = '1') ELSE x"0000";
END procedimento;
