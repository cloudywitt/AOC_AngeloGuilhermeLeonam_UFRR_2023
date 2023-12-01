------------------------------------------------------------
-- Memoria de Instruçoes (ROM)
--
-- Armazena todas as instruçoes do programa a ser
-- executado pelo processador.
-- Capacidade: 256 bits (32 bytes).
------------------------------------------------------------
-- Instruç~oes Dispon´iveis
-- add
-- 0001 | rs  | rd  |  rt  | 000
--
-- sub
-- 0001 | rs  | rd  |  rt  | 001
--
-- addi
-- 0010 | rs | rd | endereço
--
-- subi
-- 0011 | rs | rd | endereço
--
-- lw
-- 0100 | rs | rd | endereço
-- 
-- sw
-- 0101 | rs | rd | endereço
-- 
-- beq
-- 0110 | rs | rd | endereço
--
-- j
-- 0111 | salto
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
    type rom_tipo is array(0 to 2**BITS_NUM-1) of std_logic_vector(BITS_NUM-1 downto 0); -- aproximadamente 131 bytes
	 
	 -- declaração do sinal rom_mem do tipo ROM
    signal rom_mem: rom_tipo := ( -- cria todo o vetor da ram (tipo declarado acima) para ser referenciado como função abaixo
       -- 0 => "0010001001000010", -- addi $t1, $t1, 2
        --1 => "0010010010000010", -- addi $t2, $t2, 2
        --2 => "0110001010000100", -- beq $t1, $t2, 100 (instruç~ao 4)
        --3 => "0010000001011111", -- add $t3, $t1, $t2 (ser´a ignorado)
		  --4 => "0001001010011000", -- add $t3, $t1, $t2
		  
		  --0 => "0010001001000110",  -- addi $t1, $t1, 2
		--	1 => "0101000001000101", -- sw $t1, 5, $t0
		-- 2 => "0100000010000101", -- lw $t2, 5, $t0
	
			0 => "0010000000000001", -- addi $t0, $t0, 1
			1 => "0111000000000000", -- j 0
	others => "0000000000000000"
	);
    begin
        process (CLOCK)
		  begin
				-- converte a instruçao de binario para inteiro para referenciar um lugar na memória
            INSTRUCAO_CUSPIDA <= rom_mem(to_integer(unsigned(ENDERECO_RECEBIDO))); 
        end process;
end architecture;  
