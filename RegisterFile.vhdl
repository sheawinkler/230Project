library ieee;
use ieee.std_logic_1164.all;

entity RegisterFile is
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
		
end RegisterFile;

architecture archOne of RegisterFile is

	component Mux16bit16to1
		port (
			d0, d1, d2, d3, d4, d5, d6, d7 	: in std_logic_vector(15 downto 0);
			d8, d9, dA, dB, dC, dD, dE, dF 	: in std_logic_vector(15 downto 0);
			sel 										: in std_logic_vector(3 downto 0);
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
	
	
	component Decoder4to16
		port (
			sel 				: in std_logic_vector(3 downto 0);
			output 			: out std_logic_vector(15 downto 0)
		);
	end component;


	signal 	DecodeOut, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15 : std_logic_vector(15 downto 0);
	signal	And1, And2, And3, And4, And5, And6, And7, And8, And9, And10, And11, And12, And13, And14, And15 : std_logic;
	
begin
		Q0 <= "0000000000000000";
		Decoder: Decoder4to16 PORT MAP(RegD, DecodeOut);
		
		And1 <= DecodeOut(1) and Enable;
		And2 <= DecodeOut(2) and Enable;
		And3 <= DecodeOut(3) and Enable;
		And4 <= DecodeOut(4) and Enable;

		And5 <= DecodeOut(5) and Enable;
		And6 <= DecodeOut(6) and Enable;
		And7 <= DecodeOut(7) and Enable;
		And8 <= DecodeOut(8) and Enable;

		And9 <= DecodeOut(9) and Enable;
		And10 <= DecodeOut(10) and Enable;
		And11 <= DecodeOut(11) and Enable;
		And12 <= DecodeOut(12) and Enable;

		And13 <= DecodeOut(13) and Enable;
		And14 <= DecodeOut(14) and Enable;
		And15 <= DecodeOut(15) and Enable;
		
		
		Register1: reg16 PORT MAP(DataD, And1, Reset, Clock, Q1);
		Register2: reg16 PORT MAP(DataD, And2, Reset, Clock, Q2);
		Register3: reg16 PORT MAP(DataD, And3, Reset, Clock, Q3);
		Register4: reg16 PORT MAP(DataD, And4, Reset, Clock, Q4);

		Register5: reg16 PORT MAP(DataD, And5, Reset, Clock, Q5);
		Register6: reg16 PORT MAP(DataD, And6, Reset, Clock, Q6);
		Register7: reg16 PORT MAP(DataD, And7, Reset, Clock, Q7);
		Register8: reg16 PORT MAP(DataD, And8, Reset, Clock, Q8);

		Register9: reg16 PORT MAP(DataD, And9, Reset, Clock, Q9);
		Register10: reg16 PORT MAP(DataD, And10, Reset, Clock, Q10);
		Register11: reg16 PORT MAP(DataD, And11, Reset, Clock, Q11);
		Register12: reg16 PORT MAP(DataD, And12, Reset, Clock, Q12);

		Register13: reg16 PORT MAP(DataD, And13, Reset, Clock, Q13);
		Register14: reg16 PORT MAP(DataD, And14, Reset, Clock, Q14);
		Register15: reg16 PORT MAP(DataD, And15, Reset, Clock, Q15);		
		
		
		MuxS: Mux16bit16to1 PORT MAP(Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, RegS, DataS);
		MuxT: Mux16bit16to1 PORT MAP(Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, RegT, DataT);
	
end archOne;