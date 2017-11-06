library ieee;
use ieee.std_logic_1164.all;

entity MuxC is
	port(
		IR26,IR21			:	in std_logic_vector(3 downto 0);
		constant LINK		:	std_logic_vector(3 downto 0):= "1111" ;
		c_Select			:	in std_logic_vector(1 downto 0);
		addressC			:	out std_logic_vector(3 downto 0)
	);
	
end MuxC;

architecture arc_muxC of MuxC is

begin
	with c_Select select
		addressC <= IR26 when "00",
		IR21 when "01",
		LINK when "10"
end arc_muxC