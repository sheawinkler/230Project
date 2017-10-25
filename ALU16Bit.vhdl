library ieee;
use ieee.std_logic_1164.all;

entity ALU16Bit is
	port (
		A,B : in std_logic_vector(15 downto 0);
		A_inv,B_inv : in std_logic;
		alu_op : in std_logic_vector(1 downto 0);
		ALU_out : out std_logic_vector(15 downto 0);
		N,C,Z,V : out std_logic
	);
end ALU16Bit;

architecture ALU16Bit_arc of ALU16Bit is

component Mux16Bit2To1 is
	port (
		a, b : in std_logic_vector(15 downto 0);
		y : out std_logic_vector(15 downto 0);
		s : in std_logic
	);
end component;

component Mux16Bit4To1 is
	port (
		a, b, c, d : in std_logic_vector(15 downto 0);
		y : out std_logic_vector(15 downto 0);
		s : in std_logic_vector(1 downto 0)
	);
end component;

component FullAdder is
	port (
		A,B,Cin : in std_logic;
		S,Cout : out std_logic
	);
end component;

component RippleCarryAdder16Bit is
	port (
		A,B : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		F : out std_logic_vector(15 downto 0);
		C14,C15 : out std_logic
	);
end component;

signal Aout, Bout, S : std_logic_vector(15 downto 0);
signal Cout14, Cout15: std_logic;

begin
	gate0: Mux16Bit2To1 port map(A, (not A), Aout, A_inv);
	gate1: Mux16Bit2To1 port map(B, (not B), Bout, B_inv);
	gate2: RippleCarryAdder16Bit port map(Aout, Bout, (A_inv or B_inv), S, Cout14, Cout15);
	gate3: Mux16Bit4To1 port map((Aout and Bout), (Aout or Bout), (Aout xor Bout), S, ALU_out, alu_op);
	
	N <= S(15);
	Z <= (not S(0)) and (not S(1)) and (not S(2)) and (not S(3)) and (not S(4)) and (not S(5)) and (not S(6)) and (not S(7)) and (not S(8)) and (not S(9)) and (not S(10)) and (not S(11)) and (not S(12)) and (not S(13)) and (not S(14));
	V <= Cout14 xor Cout15;
	C <= Cout15;

end ALU16Bit_arc;