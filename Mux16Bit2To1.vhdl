library ieee;
use ieee.std_logic_1164.all;

entity Mux16Bit2To1 is
	port (
		a, b : in std_logic_vector(15 downto 0);
		s : in std_logic;
		y : out std_logic_vector(15 downto 0)
	);
end Mux16Bit2To1;

architecture Mux16Bit2To1_arc of Mux16Bit2To1 is
begin
	with s SELECT
	y <= a when '0',
		  b when '1',
		  "0000000000000000" when others;
	
end Mux16Bit2To1_arc;