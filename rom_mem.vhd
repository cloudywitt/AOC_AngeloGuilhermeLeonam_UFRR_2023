------------------------------------------------------------
-- Memoria de Instruçoes (ROM)
--
-- Armazena todas as instruçoes do programa a ser
-- executado pelo processador.
-- Capacidade: 256 bits (32 bytes).
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_mem is
	-- como se fossem declaraçao de constantes, para reduzir magic numbers
	generic(
		BITS_NUM : natural := 16 -- numero de bits do processador
	);
	
	port(
		CLOCK					: in std_logic;
		ENDERECO_RECEBIDO	: in std_logic_vector(BITS_NUM-1 downto 0);
		INSTRUCAO_CUSPIDA	: out std_logic_vector(BITS_NUM-1 downto 0)
    );
end entity;

architecture main of rom_mem is
	-- Define o tipo da memoria (aqui, literalmente um array de instrucoes de 16 bits cada).
    type rom_tipo is array(0 to 2**BITS_NUM-1) of std_logic_vector(BITS_NUM-1 downto 0);
	 
	 -- declaraçao do sinal rom_mem do tipo ROM
    signal rom_mem: rom_tipo := ( -- cria todo o vetor da ram (tipo declarado acima) para ser referenciado como função abaixo
        0 => "0000000001010000",
        1 => "0000000001010101",
        2 => "0000000001011010",
        3 => "0000000001011111",
        4 => "0000000000000001",
        5 => "0000000000010001",
        6 => "0000000000100001",
	others => "0000000000000000"
	);
    begin
        process (CLOCK)
		  begin
				-- converte a instruçao de binario para inteiro para referenciar um lugar na memoria
            INSTRUCAO_CUSPIDA <= rom_mem(to_integer(unsigned(ENDERECO_RECEBIDO))); 
        end process;
end architecture;  
