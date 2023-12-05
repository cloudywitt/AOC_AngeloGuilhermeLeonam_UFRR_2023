-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "12/04/2023 19:27:24"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          prolag
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY prolag_vhd_vec_tst IS
END prolag_vhd_vec_tst;
ARCHITECTURE prolag_arch OF prolag_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL BDR_SAIDA_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL BDR_SAIDA_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL CLOCK : STD_LOGIC;
SIGNAL MEM_TO_REG_S : STD_LOGIC;
SIGNAL PC_SAIDA : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL R_DEST : STD_LOGIC;
SIGNAL RAM_SAIDA : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ROM_SAIDA : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ULA_RESULTADO : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ULA_Z : STD_LOGIC;
COMPONENT prolag
	PORT (
	BDR_SAIDA_1 : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	BDR_SAIDA_2 : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	CLOCK : IN STD_LOGIC;
	MEM_TO_REG_S : BUFFER STD_LOGIC;
	PC_SAIDA : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	R_DEST : BUFFER STD_LOGIC;
	RAM_SAIDA : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	ROM_SAIDA : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	ULA_RESULTADO : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
	ULA_Z : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : prolag
	PORT MAP (
-- list connections between master ports and signals
	BDR_SAIDA_1 => BDR_SAIDA_1,
	BDR_SAIDA_2 => BDR_SAIDA_2,
	CLOCK => CLOCK,
	MEM_TO_REG_S => MEM_TO_REG_S,
	PC_SAIDA => PC_SAIDA,
	R_DEST => R_DEST,
	RAM_SAIDA => RAM_SAIDA,
	ROM_SAIDA => ROM_SAIDA,
	ULA_RESULTADO => ULA_RESULTADO,
	ULA_Z => ULA_Z
	);

-- CLOCK
t_prcs_CLOCK: PROCESS
BEGIN
LOOP
	CLOCK <= '0';
	WAIT FOR 5000 ps;
	CLOCK <= '1';
	WAIT FOR 5000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLOCK;
END prolag_arch;
