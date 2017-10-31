LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PS IS
	PORT(
			N, C, V, Z					:IN std_logic;
			enable, reset, Clock		:IN std_logic;
			output						:OUT std_logic_vector (3 DOWNTO 0)
	);
END PS;

ARCHITECTURE behavior OF PS IS
BEGIN
	PROCESS(Clock, reset)
	BEGIN
		IF(reset = '1') THEN	
			output <= "0000";
		ELSIF(rising_edge(Clock)) THEN
			IF(enable = '1') THEN
				output(3) <= N;
				output(2) <= C;
				output(1) <= V;
				output(0) <= Z;
			END IF;
		END IF;
	END PROCESS;
END behavior;