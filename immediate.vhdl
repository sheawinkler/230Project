library ieee;
use ieee.std_logic_1164.all;

entity immediate is
	port(immed: in std_logic_vector(6 downto 0);
		 extend: in std_logic_vector(1 downto 0);
		 immedEx: out std_logic_vector(15 downto 0));
end immediate;

architecture arch of immediate is

begin
	process(immed, extend)
	begin
		if(extend = "00") then
			immedEx <= "000000000" & immed;
		else
			if(immed(6) = '0') then
				immedEx <= "000000000" & immed;
			else
				immedEx <= "111111111" & immed;
			end if;
		end if;
	end process;
end arch;