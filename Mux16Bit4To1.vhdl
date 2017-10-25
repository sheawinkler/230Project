library ieee;
use ieee.std_logic_1164.all;

entity Mux16Bit4To1 is
	port (
		a, b, c, d : in std_logic_vector(15 downto 0);
		y : out std_logic_vector(15 downto 0);
		s : in std_logic_vector(1 downto 0)
	);
end Mux16Bit4To1;

architecture Mux16Bit4To1_arc of Mux16Bit4To1 is
begin
	with s SELECT
	y <= a when "00",
		  b when "01",
		  c when "10",
		  d when "11",
		  "0000000000000000" when others;
	
end Mux16Bit4To1_arc;