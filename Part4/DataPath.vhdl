library ieee;
use ieee.std_logic_1164.all;

entity DataPath is
	port (
			--ControlUnit inputs
			--Reset 			:in std_logic;
			Clock 			:in std_logic;
			
			KEY		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			SW			:	 IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			
			IAG_test						: out std_logic_vector(15 downto 0);
			Mem_address_test			: out std_logic_vector(9 downto 0);
			Data_out_test				: out std_logic_vector(23 downto 0);
			IR_output_test				: out std_logic_vector(23 downto 0);
			ALU_out_test 				: out std_logic_vector(15 downto 0);
			PS_out_test					: out std_logic_vector(3 downto 0);
			DataD_test					: out std_logic_vector(15 downto 0);			
			RA_output_test				: out std_logic_vector(15 downto 0);
			RB_output_test				: out std_logic_vector(15 downto 0);
			Immediate_output_test	: out std_logic_vector(15 downto 0);
			RM_output_test				: out std_logic_vector(15 downto 0);
			RZ_output_test				: out std_logic_vector(15 downto 0);
			
			LEDG		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0		:	 OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
		
end DataPath;

architecture archOne of DataPath is

	component Mux16Bit2To1
		port (
			A, B : in std_logic_vector(15 downto 0);
			sel : in std_logic;
			multiOut : out std_logic_vector(15 downto 0)
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
			N,Z,V,C 		: out std_logic
		);
	end component;

	component ControlUnit
		port (
			opCode 									:in std_logic_vector(3 downto 0);
			Cond 										:in std_logic_vector(3 downto 0);
			opx 										:in std_logic_vector(2 downto 0);
			S 											:in std_logic;
			-- NZVC used in PS --			
			PS											:in std_logic_vector(3 downto 0);
			mfc 										:in std_logic;
			clock, reset 							:in std_logic;
			--mem_addr									:in std_logic_vector(3 downto 0);
			ps_enable								:out std_logic;
			alu_op, c_select, y_select			:out std_logic_vector(1 downto 0);
			rf_write, b_select 					:out std_logic;
			a_inv, b_inv 							:out std_logic;
			extend 									:out std_logic_vector(1 downto 0);
			ir_enable, ma_select 				:out std_logic;
			mem_read, mem_write 					:out std_logic;
			pc_select, pc_enable, inc_select	:out std_logic
			--mdo_select								:out std_logic
			
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
			N, Z, V, C					:IN std_logic;
			enable, reset, Clock		:IN std_logic;
			output						:OUT std_logic_vector (3 DOWNTO 0)
		);			
	end component;

	component MemoryInterface
		port(	
		MEM_read		:	 IN STD_LOGIC;
		MEM_write		:	 IN STD_LOGIC;
		DataIn		:	 IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		Address		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		clock		:	 IN STD_LOGIC;
		DataOut		:	 OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		MFC		:	 OUT STD_LOGIC
		);			
	end component;
		
	component MuxMA
		port(	
		IAG			:	in std_logic_vector(15 downto 0);
		RegRZ			:	in std_logic_vector(15 downto 0);
		MA_Select		:	in std_logic;
		memAddr			:	out std_logic_vector(9 downto 0)
		);			
	end component;
	
	component InstructionAddressGenerator
		port(	
		RA		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		PC_select		:	 IN STD_LOGIC;
		PC_enable		:	 IN STD_LOGIC;
		clock		:	 IN STD_LOGIC;
		aclr		:	 IN STD_LOGIC;
		Immediate		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		INC_select		:	 IN STD_LOGIC;
		MuxY		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		Address		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);			
	end component;
	
	component MuxC
		port(	
		IR26,IR21		:	in std_logic_vector(3 downto 0);
		LINK				:	in std_logic_vector(3 downto 0);
		c_Select			:	in std_logic_vector(1 downto 0);
		regRD				:	out std_logic_vector(3 downto 0)
		);			
	end component;
	
	COMPONENT IO_MemoryInterface
		PORT(
		clock		:	 IN STD_LOGIC;
		mem_write		:	 IN STD_LOGIC;
		mem_addr		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		mem_data		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		KEY		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		SW		:	 IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		data_out		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		LEDG		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX0		:	 OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;	

	---------------
	--- Signals ---
		
	signal	ir_enable, N, Z, V, C, mfc, Reset, ps_enable: std_logic;
	signal	rf_write, b_select, a_inv, b_inv : std_logic;
	signal	ma_select, mem_read, mem_write, aclr : std_logic;
	signal	pc_select, pc_enable, inc_select : std_logic;
	signal	alu_op, c_select, y_select, extend : std_logic_vector(1 downto 0);
	signal	RegD, RegT, RegS, PS_out, Link : std_logic_vector(3 downto 0);
	signal	immed : std_logic_vector(6 downto 0);
	signal	Mem_address			:	std_logic_vector(9 downto 0);
	signal 	DataD, DataS, DataT, RA_output, RB_output, MemInterAddress: std_logic_vector(15 downto 0);
	signal 	ALU_out, RZ_output, RM_output, MuxY_Mem, Ret_Address: std_logic_vector(15 downto 0);
	signal 	MuxB_Output, MuxY_Output, Immediate_output, IAG: std_logic_vector(15 downto 0);
	signal 	IR_output, Data_out, MemInterDataIn: std_logic_vector(23 downto 0);
	
	signal	mdo_select :STD_LOGIC;
	signal	MuxMDO_Output, dataIO_out :STD_LOGIC_VECTOR(15 downto 0);
	signal	mem_addr		:	  STD_LOGIC_VECTOR(3 DOWNTO 0);
	--signal	KEY		:	  STD_LOGIC_VECTOR(3 DOWNTO 0);
	--signal	SW		:	  STD_LOGIC_VECTOR(9 DOWNTO 0);
	--signal	LEDG		:	  STD_LOGIC_VECTOR(7 DOWNTO 0);
	--signal	HEX0		:	  STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	
begin

	Reset <= Not (KEY(0));

	--- Instruction Register ---
	InstructionReg: Reg24 PORT MAP(Data_out,	ir_enable, Reset, Clock, IR_output);
	
	--- PS ---
	PS1: PS PORT MAP(N, Z, V, C, ps_enable, reset, Clock, PS_out);

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
			--NZVC used in PS_out--
			PS_out, 
			--mfc switch back for phase 3!!!!!!!!!!!!!!!!--
			'1', 
			Clock, Reset,
			--Checks to see if IO is activated
			--mem_addr,
		--Outputs--
			--
			ps_enable,
			alu_op, c_select, y_select,
			rf_write, b_select,
			a_inv, b_inv,
			extend,
			ir_enable, ma_select,
			mem_read, mem_write,
			pc_select, pc_enable, inc_select
			--mdo_select
			);

	
	--- RegisterFile ---
	RegisterFile1: RegisterFile PORT MAP(
		--Inputs--
			Reset, 
			-- Enable --
			rf_write, 
			Clock,
			-- RegD / Add C--
			RegD,
			-- RegS / Add A--
			IR_output(7 downto 4),
			-- RegT / Add B--
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
	Immediate1: immediate PORT MAP(IR_output(14 downto 8), extend, Immediate_output);
	
	--- MuxB ---
	MuxB: Mux16Bit2To1 PORT MAP(
	
			-- "0" S bit --
			RB_output,
			
			-- "1" S bit --
			Immediate_output,
			
			-- S bit --
			b_select,
			
			-- MuxB Output --
			MuxB_Output	
	);

	
	--- ALU ---
	ALU1: ALU16Bit PORT MAP(
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
			N,Z,V,C
			);

	--- Register RZ ---
	RegRZ: reg16 PORT MAP(ALU_out, '1' , Reset, Clock, RZ_output);	

	--- Register RM ---	
	RegRM: reg16 PORT MAP(RB_output, '1' , Reset, Clock, RM_output);	
	
	--- MuxY ---
	MuxY: mux16bit3to1 PORT MAP(
			-- "00" S bit --
			RZ_output,
			
			-- "01" S bit from memory or IO--
			MuxMDO_Output,
			
			-- "10" S bit --
			Ret_Address,
			
			-- S bit --
			y_select,
			
			-- MuxY Output --
			MuxY_Output
			);
	
	--- Register RY ---	
	RegRY: reg16 PORT MAP(MuxY_Output, '1' , Reset, Clock, DataD);
	
	--These are the inputs for MainMemory. -Molly
		--address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		--clock		: IN STD_LOGIC  := '1';
		--data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		--wren		: IN STD_LOGIC ;
		--q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	
	--These are the inputs and outputs for MemoryInterface (not MainMemory). -Molly
		--inputs and outputs for MainMemory
		--MEM_read :  IN  STD_LOGIC;
		--MEM_write :  IN  STD_LOGIC;
		--clock :  IN  STD_LOGIC;
		--Address :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		--DataIn :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		--MFC :  OUT  STD_LOGIC;
		--DataOut :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)	

	--- MainMemory ---
	MemInterAddress <= "000000" & Mem_address;
	MemInterDataIn  <= "00000000" & RM_output;
	
	MemoryInterface1: MemoryInterface PORT MAP(
			--MEM_read
			mem_read,
			--MEM_write
			mem_write,
			--DataIn
			MemInterDataIn,
			--Address
			MemInterAddress,
			--clock
			Clock,
			--DataOut
			Data_out,
			--MFC
			mfc
			);
	
		--inputs and outputs for MuxMA
		--IAG			:	in std_logic_vector(15 downto 0);
		--RegRZ			:	in std_logic_vector(15 downto 0);
		--MA_Select		:	in std_logic;
		--Mem_address			:	out std_logic_vector(9 downto 0)
	
	--- MuxMA ---
	MuxMA1: MuxMA PORT MAP(
			-- Instruction Address Generator --MA_Select 1--
			IAG,
			-- MA_Select 0 
			RZ_output,
			-- Select bit
			ma_select,
			-- address
			Mem_address
			);
	
		--inputs and outputs for instruction address generator
		--RA		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		--PC_select		:	 IN STD_LOGIC;
		--PC_enable		:	 IN STD_LOGIC;
		--clock		:	 IN STD_LOGIC;
		--aclr		:	 IN STD_LOGIC;
		--Immediate		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		--INC_select		:	 IN STD_LOGIC;
		--MuxY		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		--Address		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	
	--- Instruction Address Generator ---
	InstructionAddressGenerator1: InstructionAddressGenerator PORT MAP(
			-- RA input
			RA_output,
			-- Mux PC select
			pc_select,			
			-- PC enable
			pc_enable,	
			-- Clock
			Clock,
			-- Clear
			Reset,
			-- Immediate Value
			Immediate_output,		
			-- Mux inc select
			inc_select,
			-- MuxY output
			Ret_Address,
			-- Memory Address
			IAG
			);
			
	--- MuxC inputs and outputs
		--IR26,IR21			:	in std_logic_vector(3 downto 0);
		--constant LINK			:	std_logic_vector(3 downto 0):= "1111" ;
		--c_Select			:	in std_logic_vector(1 downto 0);
		--regRD				:	out std_logic_vector(3 downto 0)
		
	--- MuxC ---
	MuxC1: MuxC PORT MAP(
			-- Select 00 bit for IR RegD
			IR_output(11 downto 8),
			-- Select 01 bit for IR RegT
			IR_output(3 downto 0),
			-- Select 10 bit Return Address
			"1111",
			-- Select bit
			c_select,
			-- output to Register RegD or "Address C"
			RegD
			);
	
		-- I O --
		--clock		:	 IN STD_LOGIC;
		--mem_write		:	 IN STD_LOGIC;
		--mem_addr		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		--mem_data		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		--KEY		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		--SW		:	 IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		--data_out		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		--LEDG		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		--HEX0		:	 OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

	--- IO_MemoryInterface
	mem_addr <= RZ_output(15 DOWNTO 12);
	
	mdo_select <= mem_addr(3) or mem_addr(2) or mem_addr(1) or mem_addr(0);
	
	IO_MemoryInterface1: IO_MemoryInterface PORT MAP(
			Clock,
			--mem_write
			mem_write,
			--last 4 bits of mem_addr, if any are 1 activate IO
			mem_addr,
			--data in from RM before transformed into 24 bits
			RM_output,
			--Push Button in
			KEY,
			--Slider in
			SW,
			--Data out got to MuxMDO
			dataIO_out,
			--LedG
			LEDG,
			--Hex display
			HEX0
			);
	

	
		--- MuxMDO go to MuxY ---
	MuxMDO: Mux16Bit2To1 PORT MAP(
			-- "0" S bit select from Memory --
			Data_out(15 downto 0),
			-- "1" S bit select from IO --
			dataIO_out,
			-- S bit --
			mdo_select,
			-- MuxY Input --
			MuxMDO_Output	
	);
	
	
		--- Test Outputs for the Simulation ---
			IR_output_test <= IR_output;
			ALU_out_test <= ALU_out;
			PS_out_test <= PS_out;
			DataD_test	<= Datad;			
			RA_output_test	<= RA_output;		
			RB_output_test	<= RB_output;		
			Immediate_output_test  <= Immediate_output;
			RM_output_test  <= RM_output;			
			RZ_output_test	 <= RZ_output;
			Mem_address_test <= Mem_address;
			Data_out_test <= Data_out;
			IAG_test <= IAG;

end archOne;