------------------------------------------------------------
-- Unidade de Controle (UC)
--
-- Controla as unidades funcionais através de sinais de 
-- controle (flags).
------------------------------------------------------------
-- Conjunto de Instruções
-- Tipo R (add, sub):
-- OP | RS | RD | RT | FUNCT |
--  4 | 3  | 3  | 3  |   3   |
-- 
-- Tipo I (addi, subi, lw, sw, beq):
-- OP | RS | RD | ENDEREÇO
--  4 | 3  | 3  |  6
-- 
-- Tipo J (j):
-- OP | SALTO
--  4 | 12
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
	port(
		-- Entradas
		CLOCK  : IN std_logic;
		OPCODE : IN std_logic_vector(3 downto 0);
		FUNCT	 : IN std_logic_vector(2 downto 0);
		-- TODO: receber também o funct da instrução para substituir aqueal mini uc lá em baixo?
		
		-- Sinais de Controle (Flags)
		REG_DEST     : OUT std_logic; -- Define se vai escrever em rd (sinal 1) ou rt (sinal 0)
		BRANCH		 : OUT std_logic; -- Lança o sinal positivo quando o salto depende do resultado de uma operação da ULA
		LER_MEM      : OUT std_logic; -- Joga o conteúdo do endereço dado na saída da memória
		MEM_PARA_REG : OUT std_logic; -- O valor de escrita no registrador vem da memória se ativo, do contrário vem da ULA
		ULA_OP       : OUT std_logic_vector(2 downto 0);
		ESC_MEM      : OUT std_logic; -- Define se vai escrever em Memória o dado no campo de dado no endereço informado
		ULA_FONT     : OUT std_logic; -- Define de onde vem o valor do segundo operando da ULA (do BDR, 1, ou da extensão de bits, 0)
		ESC_REG      : OUT std_logic  -- Decide se vai ou não escrever no BDR
	);
end entity;

architecture main of uc is
begin
	process(OPCODE, CLOCK)
	begin
        case OPCODE is -- referencia: pg 445 do livro do Patterson e do Hennessy
				-- Instruções do Tipo R
				when "0001" => -- add ou sub
                REG_DEST     <= '1'; -- Escreve no endereço dado pelo registrador rd
                BRANCH       <= '0';
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0'; -- O valor n~ao vem a ser escrito no BDR n~ao vem da mem´oria
                ULA_OP       <= FUNCT;
                ESC_MEM      <= '0';
                ULA_FONT     <= '0'; -- O segundo operando da ula vem da segunda sa´ida do BDR
                ESC_REG      <= '1'; -- Define a que vai escrever no Bando de Registradores
				-- Instruções do Tipo I
					  when "0010" => -- addi
                REG_DEST     <= '0'; -- n~ao importa, ´e amrmazenado em rt de qualquer jeito
                BRANCH       <= '0';
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0';
                ULA_OP       <= "000"; -- soma
                ESC_MEM      <= '0';
                ULA_FONT     <= '1'; -- O segundo operando da ula vem do extensor
                ESC_REG      <= '1';
				when "0011" => -- subi
                REG_DEST     <= '0';
                BRANCH       <= '0';
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0';
                ULA_OP       <= "001";
                ESC_MEM      <= '0';
                ULA_FONT     <= '1';
                ESC_REG      <= '1';
				when "0100" => -- lw
					 REG_DEST     <= '0';
                BRANCH       <= '0';
                LER_MEM      <= '1';
                MEM_PARA_REG <= '1'; -- o valor da saída de memória vai para o BDR
                ULA_OP       <= "000"; -- soma, pois vai calcular o endereço
                ESC_MEM      <= '0';
                ULA_FONT     <= '1'; -- o segundo operando da ula vem do extensor
                ESC_REG      <= '1';
				when "0101" => -- sw
					 REG_DEST     <= '0';
                BRANCH       <= '0';
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0';
                ULA_OP       <= "000"; -- soma, pois vai calcular o endereço
                ESC_MEM      <= '1';
                ULA_FONT     <= '1'; -- o segundo operando da ula vem do extensor
                ESC_REG      <= '0';
				when "0110" => -- beq
					 REG_DEST     <= '0';
                BRANCH       <= '1'; -- Pode relizar o salto
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0';
                ULA_OP       <= "111";
                ESC_MEM      <= '0';
                ULA_FONT     <= '0'; -- o segundo operando da ula vem do bdr
                ESC_REG      <= '0';
				when "0111" => -- j
					 REG_DEST     <= '0';
                BRANCH       <= '1'; -- Realiza o salto
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0';
                ULA_OP       <= "100"; -- a ula vai jogar o zero para realizar o salto
                ESC_MEM      <= '0';
                ULA_FONT     <= '1';
                ESC_REG      <= '0';
				when others =>
                REG_DEST     <= '0';
                BRANCH       <= '0';
                LER_MEM      <= '0';
                MEM_PARA_REG <= '0';
                ULA_OP       <= "000";
                ESC_MEM      <= '0';
                ULA_FONT     <= '0';
                ESC_REG      <= '0';
        end case;
    end process;
end architecture;
