-- 
-- ULA (UAL) do processador
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_signed.all;
USE ieee.std_logic_arith.all;

ENTITY ula_proclag IS
PORT(
	a, b : in std_logic_vector(16-1 downto 0); -- entrada para registradores
	ula_controle : in std_logic_vector(3-1 downto 0); -- seletor de função (funct)
	ula_resultado : out std_logic_vector(16-1 downto 0); -- resultado de saída da ula
	zero : out std_logic -- bandeira/sinalizador zero
	);
END ula_proclag;

ARCHITECTURE Comportamento OF ula_proclag IS -- código
SIGNAL resultado : std_logic_vector(16-1 downto 0);


BEGIN
PROCESS(ula_controle, a, b)
BEGIN
	CASE ula_controle IS -- define a operação da ULA (funct)
	-- funct
	WHEN "000" =>
		resultado <= a + b; -- operação de adição (add)
	WHEN "001" =>
		resultado <= a - b; -- operação de subtração (sub)
	--
	WHEN "010" => 
		resultado <= a and b; -- and
	WHEN "011" =>
   		resultado <= a or b; -- or
   --
	WHEN "100" => -- verificação de beq (branch equal)
   		IF (a<b xor a>b) THEN 
   			resultado <= x"0001"; -- flag para a < b ou a > b
   		ELSE
   			resultado <= x"0000"; -- flag para a = b
   		END IF;
	--
	WHEN OTHERS =>
		resultado <= a + b; -- add
	--
	END CASE;
END PROCESS;
	zero <= '1' when resultado = x"0000" else '0';
	ula_resultado <= resultado;
END Comportamento;
