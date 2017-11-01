library ieee;
use ieee.std_logic_1164.all;

entity DataPath is
	port (
			--ControlUnit inputs
			Reset 			:in std_logic;
			Clock 			:in std_logic;
			IR					:IN std_logic_vector(23 downto 0);
			
			
			ALU_out_test 				: out std_logic_vector(15 downto 0);
			PS_out_test					: out std_logic_vector(3 downto 0);
			DataD_test					: out std_logic_vector(15 downto 0);			
			RA_output_test				: out std_logic_vector(15 downto 0);
			RB_output_test				: out std_logic_vector(15 downto 0);
			Immediate_output_test	: out std_logic_vector(15 downto 0);
			RM_output_test				: out std_logic_vector(15 downto 0);
			RZ_output_test				: out std_logic_vector(15 downto 0)
		);
		
end DataPath;

architecture archOne of DataPath is

	component Mux16Bit2To1
		port (
			a, b : in std_logic_vector(15 downto 0);
			y : out std_logic_vector(15 downto 0);
			s : in std_logic
			
		);
	end component;

	component reg16
		port (
			data									:IN std_logic_vector(15 downto 0);
			enable, reset, Clock				:IN std_logic;
			output								:OUT std_logic_vector(15 downto 0)
		);
	end component;
	
	component RegisterFile
		port (
			Reset : 		in std_logic;
			Enable : 	in std_logic;
			Clock : 		in std_logic;
			RegD : 		in std_logic_vector(3 downto 0);
			RegT : 		in std_logic_vector(3 downto 0);
			RegS : 		in std_logic_vector(3 downto 0);
			DataD : 		in std_logic_vector(15 downto 0);
		
			DataS : 		out std_logic_vector(15 downto 0);
			DataT : 		out std_logic_vector(15 downto 0)
		);
	end component;
	
	component ALU16Bit
		port (
			A,B 			: in std_logic_vector(15 downto 0);
			A_inv,B_inv : in std_logic;
			alu_op 		: in std_logic_vector(1 downto 0);
			ALU_out 		: out std_logic_vector(15 downto 0);
			N,C,Z,V 		: out std_logic
		);
	end component;

	component ControlUnit
		port (
			opCode 									:in std_logic_vector(3 downto 0);
			Cond 										:in std_logic_vector(3 downto 0);
			opx 										:in std_logic_vector(2 downto 0);
			S 											:in std_logic;
			-- NCVZ used in PS --			
			PS											:in std_logic_vector(3 downto 0);
			mfc 										:in std_logic;
			clock, reset 							:in std_logic;
			
			alu_op, c_select, y_select			:out std_logic_vector(1 downto 0);
			rf_write, b_select 					:out std_logic;
			a_inv, b_inv 							:out std_logic;
			extend 									:out std_logic_vector(1 downto 0);
			ir_enable, ma_select 				:out std_logic;
			mem_read, mem_write 					:out std_logic;
			pc_select, pc_enable, inc_select	:out std_logic
		);
	end component;	

	component mux16bit3to1
		port(
			in1,in2,in3		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			sel				: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			result			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;

	component Reg24
		PORT(
			data									:IN std_logic_vector(23 downto 0);
			enable, reset, Clock				:IN std_logic;
			output								:OUT std_logic_vector(23 downto 0)
		);
	end component;
	
	component immediate
		port(
			immed				: in std_logic_vector(6 downto 0);
			extend			: in std_logic_vector(1 downto 0);
			immedEx			: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component PS
		port(	
			N, C, V, Z					:IN std_logic;
			enable, reset, Clock		:IN std_logic;
			output						:OUT std_logic_vector (3 DOWNTO 0)
		);			
	end component;
	
	---------------
	--- Signals ---
		
	signal	ir_enable, N, C, V, Z, mfc : std_logic;
	signal	rf_write, b_select, a_inv, b_inv : std_logic;
	signal	ma_select, mem_read, mem_write : std_logic;
	signal	pc_select, pc_enable, inc_select : std_logic;
	signal	alu_op, c_select, y_select, extend : std_logic_vector(1 downto 0);
	signal	RegD, RegT, RegS, PS_out : std_logic_vector(3 downto 0);
	signal	immed : std_logic_vector(6 downto 0);
	signal 	DataD, DataS, DataT, RA_output, RB_output: std_logic_vector(15 downto 0);
	signal 	ALU_out, RZ_output, RM_output, MuxY_Mem, Ret_Address: std_logic_vector(15 downto 0);
	signal 	MuxB_Output, MuxY_Output, Immediate_output: std_logic_vector(15 downto 0);
	signal 	IR_output: std_logic_vector(23 downto 0);
	
begin

	--- Instruction Register ---
	
	InstructionReg: Reg24 PORT MAP(IR, ir_enable, Reset, Clock, IR_output);
	
	--- PS ---

	PS1: PS PORT MAP(N, C, V, Z, '1', reset, Clock, PS_out);

	
	--- Control Unit ---
	
	ControlUnit1: ControlUnit PORT MAP(
		--Inputs--
			--OpCode--
			IR_output(23 downto 20),
			--Cond--
			IR_output(19 downto 16),
			--opx--
			IR_output(14 downto 12),
			--S--
			IR_output(15),
			--Flags and other signals inputs--
			--NCVZ used in PS_out--
			PS_out, 
			mfc, Clock, Reset,
			
		--Outputs--
			alu_op, c_select, y_select,
			rf_write, b_select,
			a_inv, b_inv,
			extend,
			ir_enable, ma_select,
			mem_read, mem_write,
			pc_select, pc_enable, inc_select
			);

	--- RegisterFile ---

	RegisterFile1: RegisterFile PORT MAP(
		--Inputs--
			Reset, 
			
			-- Enable --
			rf_write, 
			
			Clock,
			
			-- RegD --
			IR_output(11 downto 8),
			
			-- RegS --
			IR_output(7 downto 4),
			
			-- RegT --
			IR_output(3 downto 0),

			-- DataD --
			DataD,
			 
		--Outputs--
			DataS, DataT
			);
	

	--- Register RA ---
	
	RegRA: reg16 PORT MAP(DataS, '1' , Reset, Clock, RA_output);
			 
	--- Register RB ---
	
	RegRB: reg16 PORT MAP(DataT, '1' , Reset, Clock, RB_output);	
	
	
	
	

	--- Immediate Value ---
	
	Immediate1: immediate PORT MAP(immed, extend, Immediate_output);
	
	
	--- MuxB ---
	
	MuxB: Mux16Bit2To1 PORT MAP(
	
			-- "0" S bit --
			RB_output,
			
			-- "1" S bit --
			Immediate_output,
			
			-- MuxB Output --
			MuxB_Output,	
			
			-- S bit --
			b_select
			

	
	);

	--- ALU ---
	
	ALU: ALU16Bit PORT MAP(
		-- Inputs --
			-- InA --
			RA_output,
			
			-- InB --
			MuxB_Output,
			
			-- Control Unit Flags --
			a_inv,b_inv,
			alu_op,
			
		-- Outputs --
			ALU_out,
			N,C,Z,V
			);
	
	

	
	--- Register RZ ---
	RegRZ: reg16 PORT MAP(ALU_out, '1' , Reset, Clock, RZ_output);	

	--- Register RM ---	
	RegRM: reg16 PORT MAP(RB_output, '1' , Reset, Clock, RM_output);	
	
	--- MuxY ---
	MuxY: mux16bit3to1 PORT MAP(
			-- "00" S bit --
			RZ_output,
			
			-- "01" S bit --
			MuxY_Mem,
			
			-- "10" S bit --
			Ret_Address,
			
			-- S bit --
			y_select,
			
			-- MuxY Output --
			MuxY_Output
			);
	
	--- Register RY ---		
	RegRY: reg16 PORT MAP(MuxY_Output, '1' , Reset, Clock, DataD);	
	
	--- Test Outputs for the Simulation ---
			ALU_out_test <= ALU_out;
			PS_out_test <= PS_out;
			DataD_test	<= Datad;			
			RA_output_test	<= RA_output;		
			RB_output_test	<= RB_output;		
			Immediate_output_test  <= Immediate_output;
			RM_output_test  <= RM_output;			
			RZ_output_test	 <= RZ_output;
			
	
end archOne;