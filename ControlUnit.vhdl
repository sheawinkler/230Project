library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
	port (
			opCode 									:in std_logic_vector(3 downto 0);
			Cond 										:in std_logic_vector(3 downto 0);
			opx 										:in std_logic_vector(2 downto 0);
			S 											:in std_logic;
			-- NCVZ used in PS --
			PS											:in std_logic_vector(3 downto 0);
			mfc 										:in std_logic;
			clock, reset 							:in std_logic;
			
			alu_op, c_select, y_select			:out std_logic_vector(1 downto 0);
			rf_write, b_select 					:out std_logic;
			a_inv, b_inv 							:out std_logic;
			extend 									:out std_logic_vector(1 downto 0);
			ir_enable, ma_select 				:out std_logic;
			mem_read, mem_write 					:out std_logic;
			pc_select, pc_enable, inc_select	:out std_logic
		);
		
end ControlUnit;

architecture archOne of ControlUnit is


	signal wmfc	:std_logic;
	shared variable stage: integer:= 0;

	
begin
	PROCESS(clock, reset)
	BEGIN
		IF(rising_edge(clock))THEN
		
			IF(reset = '1') THEN	
				stage := 0;
			END IF;
			
			IF((mfc = '1' or wmfc = '0')) THEN
				stage := stage mod 5 + 1;
			END IF;
		
		-- instruction fetch (stage 1)
		IF(stage = 1) THEN
			
			wmfc <= '1';
			alu_op <= "00";
			c_select <= "01";
			y_select <= "00";
			rf_write <= '0';
			b_select <= '0';
			a_inv <= '0';
			b_inv <= '0';
			extend <= "00";
			ir_enable <= '1';
			ma_select <= '1';
			mem_read <= '1';
			mem_write <= '0';
			pc_select <= '1';
			pc_enable<= mfc;
			inc_select <= '0';
			
		-- register load
		ELSIF(stage = 2) THEN
			
			wmfc <= '0';
			ir_enable <= '0';
			mem_read <= '0';
			pc_enable <= '0';
		
		-- ALU, branch, jump operation
		ELSIF(stage = 3) THEN
			-- R-type instructions
			IF(opCode(3) = '0' AND opCode(2) = '0') THEN
				IF(opCode(1) = '0' AND opCode(0) = '1') THEN
					-- This is for JR, just fill in the values for the if statement
				ELSIF(opCode(1) = '0' AND opCode(0) = '0') THEN
					-- This is for the other instructions
					IF(opx = "111")THEN
						-- AND insturction
						alu_op <= "00";
					ELSIF(opx = "110")THEN
						-- OR insturction
						alu_op <= "01";
					ELSIF(opx = "101")THEN
						-- XOR insturction
						alu_op <= "10";
					ELSIF(opx = "100")THEN
						-- ADD insturction
						alu_op <= "11";
					ELSIF(opx = "011")THEN
						-- SUB insturction
						alu_op <= "11";
						b_inv <= '1';
					END IF;
				END IF;
			END IF;
				
		-- Memory stage
		ELSIF(stage = 4) THEN
			-- R-type instructions
			IF(opCode(3) = '0' AND opCode(2) = '0') THEN
				IF(opCode(1) = '0' AND opCode(2) = '1') THEN
					--This is for JR, just fill in the values for the if statement
					--We will have to set some flags here in the future
				END IF;
			END IF;
		
		-- Write back stage
		ELSIF(stage = 5) THEN
			--R-type instructions
			IF(opCode(3) = '0' AND opCode(2) = '0') THEN
				IF(opCode(1) = '0' AND opCode(0) = '1') THEN
					--This is for JR, just fill in the values for the if statement
				ELSIF(opCode(1) = '0' AND opCode(0) = '0') THEN
					rf_write <= '1';
				END IF;
			END IF;
		END IF;
		
		END IF;
	END PROCESS;

	
	


end archOne;
