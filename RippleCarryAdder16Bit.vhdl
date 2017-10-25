library ieee;
use ieee.std_logic_1164.all;

entity RippleCarryAdder16Bit is
	port (
		A,B : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		F : out std_logic_vector(15 downto 0);
		C14,C15 : out std_logic
	);
end RippleCarryAdder16Bit;

architecture RippleCarryAdder16Bit_arc of RippleCarryAdder16Bit is

component FullAdder is
	port (
		A,B,Cin : in std_logic;
		S,Cout : out std_logic
	);
end component;

signal C0out,C1out,C2out,C3out,C4out,C5out,C6out,C7out,C8out,C9out,C10out,C11out,C12out,C13out,C14out: std_logic;
	
begin

	Gate0 : FullAdder port map(A(0),B(0),Cin,F(0),C0out);
	Gate1 : FullAdder port map(A(1),B(1),C0out,F(1),C1out);
	Gate2 : FullAdder port map(A(2),B(2),C1out,F(2),C2out);
	Gate3 : FullAdder port map(A(3),B(3),C2out,F(3),C3out);
	Gate4 : FullAdder port map(A(4),B(4),C3out,F(4),C4out);
	Gate5 : FullAdder port map(A(5),B(5),C4out,F(5),C5out);
	Gate6 : FullAdder port map(A(6),B(6),C5out,F(6),C6out);
	Gate7 : FullAdder port map(A(7),B(7),C6out,F(7),C7out);
	Gate8 : FullAdder port map(A(8),B(8),C7out,F(8),C8out);
	Gate9 : FullAdder port map(A(9),B(9),C8out,F(9),C9out);
	Gate10 : FullAdder port map(A(10),B(10),C9out,F(10),C10out);
	Gate11 : FullAdder port map(A(11),B(11),C10out,F(11),C11out);
	Gate12 : FullAdder port map(A(12),B(12),C11out,F(12),C12out);
	Gate13 : FullAdder port map(A(13),B(13),C12out,F(13),C13out);
	Gate14 : FullAdder port map(A(14),B(14),C13out,F(14),C14out);
	Gate15 : FullAdder port map(A(15),B(15),C14out,F(15),C15);
	
	C14 <= C14out;
	
end RippleCarryAdder16Bit_arc;
	