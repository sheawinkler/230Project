library ieee;
use ieee.std_logic_1164.all;

entity Decoder4to16 is
	port (
			sel 				: in std_logic_vector(3 downto 0);
			output 			: out std_logic_vector(15 downto 0)
		);
end Decoder4to16;

architecture archOne of Decoder4to16 is

	signal x : std_logic;
	
begin

	output(0) <= (not (sel(0))) and (not (sel(1))) and (not (sel(2))) and (not (sel(3)));
	output(1) <= ((sel(0))) and (not (sel(1))) and (not (sel(2))) and (not (sel(3)));
	output(2) <= (not (sel(0))) and ((sel(1))) and (not (sel(2))) and (not (sel(3)));
	output(3) <= ((sel(0))) and ((sel(1))) and (not (sel(2))) and (not (sel(3)));
	
	output(4) <= (not (sel(0))) and (not (sel(1))) and ((sel(2))) and (not (sel(3)));
	output(5) <= ((sel(0))) and (not (sel(1))) and ((sel(2))) and (not (sel(3)));
	output(6) <= (not (sel(0))) and ((sel(1))) and ((sel(2))) and (not (sel(3)));
	output(7) <= ((sel(0))) and ((sel(1))) and ((sel(2))) and (not (sel(3)));
	
	output(8) <= (not (sel(0))) and (not (sel(1))) and (not (sel(2))) and ((sel(3)));
	output(9) <= ((sel(0))) and (not (sel(1))) and (not (sel(2))) and ((sel(3)));
	output(10) <= (not (sel(0))) and ((sel(1))) and (not (sel(2))) and ((sel(3)));
	output(11) <= ((sel(0))) and ((sel(1))) and (not (sel(2))) and ((sel(3)));

	output(12) <= (not (sel(0))) and (not (sel(1))) and ((sel(2))) and ((sel(3)));
	output(13) <= ((sel(0))) and (not (sel(1))) and ((sel(2))) and ((sel(3)));
	output(14) <= (not (sel(0))) and ((sel(1))) and ((sel(2))) and ((sel(3)));
	output(15) <= ((sel(0))) and ((sel(1))) and ((sel(2))) and ((sel(3)));
end archOne;