
library ieee;
use ieee.std_logic_1164.all;

entity Mux16bit16to1 is
		port (
			d0, d1, d2, d3, d4, d5, d6, d7 	: in std_logic_vector(15 downto 0);
			d8, d9, dA, dB, dC, dD, dE, dF 	: in std_logic_vector(15 downto 0);
			sel 										: in std_logic_vector(3 downto 0);
			f			 								: out std_logic_vector(15 downto 0)
		);
end Mux16bit16to1;

architecture archOne of Mux16bit16to1 is
	
begin

	with sel select 
	f			<= d0 when "0000",
					d1 when "0001",
					d2 when "0010",
					d3 when "0011",
					d4 when "0100",
					d5 when "0101",
					d6 when "0110",
					d7 when "0111",
					d8 when "1000",
					d9 when "1001",
					dA when "1010",
					dB when "1011",
					dC when "1100",
					dD when "1101",
					dE when "1110",
					dF when "1111",
					"0000000000000000" when others;
		
	
end archOne;