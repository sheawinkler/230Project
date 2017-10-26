library ieee;
use ieee.std_logic_1164.all;

entity DataPath is
	port (
			--ControlUnit inputs
			Clock 			:in std_logic;
			Reset 			:in std_logic;
			IR					:IN std_logic_vector(23 downto 0);
			N, C, V, Z 		:in std_logic;
			
			--Immediate inputs
			immed				: in std_logic_vector(6 downto 0);
			extend			: in std_logic_vector(1 downto 0);
			
			--DataPath output feed into 
			DataOut			:out std_logic_vector(15 downto 0)
			
		);
		
end DataPath;

architecture archOne of DataPath is

	component Mux16Bit2To1
		port (
			d0, d1,									: in std_logic_vector(15 downto 0);
			sel 										: in std_logic;
			f			 								: out std_logic_vector(15 downto 0)
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
			N, C, V, Z 								:in std_logic;
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
	
	signal 	 : std_logic_vector(15 downto 0);
	signal	 : std_logic;
	
begin

end archOne;