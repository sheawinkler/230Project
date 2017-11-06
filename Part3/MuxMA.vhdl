library ieee;
use ieee.std_logic_1164.all;

entity MuxMA is
	port(
		IAG			:	in (23 downto 0);
		RegRZ		:	in (15 downto 0);
		MA_Select		:	--not sure how many bits in (1 downto 0); **have no idea what select bit is**
		memAddr		:	out(9 downto 0)
	);
	
end MuxMA;

architecture arc_MA of MuxMA is

begin

end arc_MA;

