library ieee;
use ieee.std_logic_1164.all;

entity MuxMA is
	port(
		IAG			:	in std_logic_vector(15 downto 0);
		RegRZ			:	in std_logic_vector(15 downto 0);
		MA_Select		:	in std_logic;
		memAddr			:	out std_logic_vector(9 downto 0)
	);
	
end MuxMA;

architecture arc_MA of MuxMA is

begin
--architecture will have to use a buffer to reduce 16 bits to 10 bit output
	with MA_Select select
		memAddr <= RegRZ(9 downto 0) when '0',
		IAG(9 downto 0) when '1',
		"0000000000" when others;
end arc_MA;

