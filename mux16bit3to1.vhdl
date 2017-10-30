library ieee;
use ieee.std_logic_1164.all;

entity mux16bit3to1 is
	port (
		in1,in2,in3		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end mux16bit3to1;

architecture arc of mux16bit3to1 is

begin
	with sel select
		result <= in1 when "00",
		in2 when "01",
		in3 when "10",
		"0000000000000000" when others;
		
end arc;