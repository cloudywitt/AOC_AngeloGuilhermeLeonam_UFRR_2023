------------------------------------------------------------
-- Memoria de Instruçoes (ROM)
--
-- Armazena todas as instruções do programa a ser
-- executado pelo processador.
-- Capacidade: 256 bits (32 bytes).
------------------------------------------------------------
-- Instruções Disponíveis
--
-- add
-- 0001 | rs  | rd  |  rt  | 000
--
-- sub
-- 0001 | rs  | rd  |  rt  | 001
--
-- addi
-- 0010 | rs | rd | endereço -- endereço máximo: 2**6 - 1 == 63
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
-- 0111 | salto -- maior salto possível: 2**12 - 1 == 4095
--
-- num de reg: 8 de 16 bits
-- 
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_mem is
	port(
		CLOCK					: in std_logic;
		ENDERECO_RECEBIDO	: in std_logic_vector(15 downto 0);
		INSTRUCAO_CUSPIDA	: out std_logic_vector(15 downto 0)
    );
end entity;

architecture main of rom_mem is
	-- Define o tipo da memória (aqui, literalmente um array de instrucoes de 16 bits cada).
    type rom_tipo is array(0 to 2**12-1) of std_logic_vector(15 downto 0); -- aproximadamente 131 bytes
	 
	 -- declaração do sinal rom_mem do tipo ROM
    signal rom_mem: rom_tipo := ( -- cria todo o vetor da ram (tipo declarado acima) para ser referenciado como função abaixo
        -- Teste do beq
        0 => "0010000001000010", -- addi $t0, $zero, 2
        1 => "0010000010000010", -- addi $t1, $zero, 2
        2 => "0110001010000100", -- beq $t0, $t1, 100 (pula para a instrução 4)
        3 => "0111000000000000", -- j 0 (ignorado)
        4 => "0001001010011001", -- sub $t2, $t0, $t1

        -- Teste Load e Store
        -- 0 => "0010000001000101", -- addi $t0, $zero, 5
        -- 1 => "0010000010000001", -- addi $t1, $zero, 1
		  -- 2 => "0101010001000101", -- sw $t0, 5, $t1 (joga $t0 em 5 + $t1)
		  -- 3 => "0100010011000101", -- lw $t2, 5, $t1 (carrega 5 + $t1 em $t2)
		  -- 4 => "0001011000011000", -- add $t2, $t2, $zero
	
        -- Teste do j
        -- 0 => "0010000001000000", -- addi $t0, $zero, 0
        -- 1 => "0010001001000001", -- addi $t0, $t0, 1
        -- 2 => "0111000000000001", -- j 1

        -- Soma dos naturais até 3
        -- 0 => "0010000001000001", -- addi $t0, $zero, 1 (inicializa $t0 com 1)
        -- 1 => "0010000010000000", -- addi $t1, $zero, 0 (incializa a variável soma em 0)
        -- 2 => "0010000100000100", -- addi $s0, $zero, 4 (define o valor de parada)
        -- 3 => "0110001100000111", -- beq $t0, $s0, 7 (salta para fora se iguais)
        -- 4 => "0001001010010000", -- add $t1, $t0, $t1 (soma o atual inteiro)
        -- 5 => "0010001001000001", -- addi $t0, $t0, 1 (incrementa a variável de apoio)
        -- 6 => "0111000000000011", -- j 3 (volta para o beq)
        -- 7 => "0001010000010000", -- add $t1, $t1, $zero (verifica a soma)
        others => "0000000000000000" -- por começar os opcodes do 1, o tudo 0 não dá nada
	);
    begin
        process (CLOCK)
		  begin
            -- converte a instrução de binário para inteiro para referenciar um lugar na memória
            INSTRUCAO_CUSPIDA <= rom_mem(to_integer(unsigned(ENDERECO_RECEBIDO))); 
        end process;
end architecture;  
