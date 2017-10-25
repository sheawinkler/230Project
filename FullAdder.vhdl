library ieee;
use ieee.std_logic_1164.all;
--S(A,B,Cin) = A xor B xor Cin
--Cout(A,B,Cin) = (A and B) or (A and Cin) or (B and Cin)
entity FullAdder is
	port (
		A,B,Cin : in std_logic;
		S,Cout : out std_logic
	);
end FullAdder;

architecture FullAdder_arc of FullAdder is
begin

	S <= A xor B xor Cin;
	Cout <= (A and B) or (A and Cin) or (B and Cin);

end FullAdder_arc;