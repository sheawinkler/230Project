library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
	port (
			opCode 									:in std_logic_vector(3 downto 0);
			Cond 										:in std_logic_vector(3 downto 0);
			opx 										:in std_logic_vector(2 downto 0);
			S 											:in std_logic;
			-- NZVC used in PS --
			PS											:in std_logic_vector(3 downto 0);
			mfc 										:in std_logic;
			clock, reset 							:in std_logic;
			--mem_addr									:in std_logic_vector(3 downto 0);
			ps_enable								:out std_logic;
			alu_op, c_select, y_select			:out std_logic_vector(1 downto 0);
			rf_write, b_select 					:out std_logic;
			a_inv, b_inv 							:out std_logic;
			extend 									:out std_logic_vector(1 downto 0);
			ir_enable, ma_select 				:out std_logic;
			mem_read, mem_write 					:out std_logic;
			pc_select, pc_enable, inc_select	:out std_logic
			--mdo_select								:out std_logic
		);
		
end ControlUnit;

architecture archOne of ControlUnit is


	signal wmfc, excute_enable	:std_logic;
	shared variable stage: integer:= 0;

	
begin
	PROCESS(clock, reset)
	BEGIN
	IF(falling_edge(clock)) THEN
	--Add an enabe signal (like the wmfc signal) to represent whether or not the instruction should be executed
	--Check the flags to match the condition passed in, and change the enable signal
	--Using if and else statements, check through each Cond and see if the correct flags are set.
	--If the flags are set correctly, then the instruction should execute normally.
	--If not, then a disable signal should be turned on.
	--Check the value of this disable signal in stages 3-5 before doing any decoding in them.
	--(See ProjectPart4 handout for instructions described above.)
		IF (S = '1') THEN
		excute_enable <= '0';
	--B-type instructions: Branch(br) AND Branch and Link (bal)
			--conditional instructions (from conditional table in project overview)
			--IF(opCode(3) = '1' AND opCode(2) = '0' AND opCode(1) = '0') THEN
				--IF(opCode(1) = '0') THEN
					--conditional bits NZVC
					--Always
					IF (Cond = "0000") THEN
						--no flag?
						excute_enable <= '1';
					--Never
					ElSIF (Cond = "0001") THEN
						--no flag?
						excute_enable <= '0';
					--Equal
					ELSIF (Cond = "0010" AND PS(2) = '1') THEN
						--set Z = '1'; (Z)
						excute_enable <= '1';
					--Not Equal
					ELSIF (Cond = "0011" AND PS(2) = '0') THEN
						--set Z = '0'; (NOT Z)
						excute_enable <= '1';
					--Overflow
					ELSIF (Cond = "0100" AND PS(1) = '1') THEN
						--set V = '1'; (V)
						excute_enable <= '1';
					--No Overflow
					ELSIF (Cond = "0101" AND PS(1) = '0') THEN
						--set V = '0'; (NOT V)
						excute_enable <= '1';
					--Negative
					ELSIF (Cond = "0110" AND PS(3) = '1') THEN
						--set N = '1'; (N)
						excute_enable <= '1';
					--Positive or Zero
					ELSIF (Cond = "0111" AND PS(3) = '0') THEN
						--set N = '0'; (NOT N)
						excute_enable <= '1';
					--Unsigned higher or same
					ELSIF (Cond = "1000" AND PS(0) = '1') THEN
						--set C = '1'; (C)
						excute_enable <= '1';
					--Unsigned lower
					ELSIF (Cond = "1001" AND PS(0) = '0') THEN
						--set C = '0'; (NOT C)
						excute_enable <= '1';
					--Unsigned higher
					ELSIF (Cond = "1010" AND (PS(0) = '1' AND PS(3) = '0')) THEN
						-- (C AND (NOT Z)
						excute_enable <= '1';
					--Unsigned Lower or same
					ELSIF (Cond = "1011" AND (PS(0) = '0' OR PS(2) = '1')) THEN
						-- (NOT C) OR Z
						excute_enable <= '1';
					--Greater than
					ELSIF (Cond = "1100" AND (PS(2) = '0' AND ((PS(3) = '1' AND PS(1) = '1') OR (PS(3) = '0' AND PS(1) = '0')))) THEN
						--(NOT Z) AND ((N AND V) OR ((NOT N AND (NOT V)))
						excute_enable <= '1';
					--Less than
					ELSIF (Cond = "1101" AND ((PS(3) = '1' AND PS(1) = '0') OR (PS(2) = '0' AND PS(1) = '1'))) THEN
						--(N AND (NOT V) OR ((NOT Z) AND V)
						excute_enable <= '1';
					--Greater than or equal
					ELSIF (Cond = "1110" AND ((PS(3) = '1' AND PS(1) = '1') OR (PS(3) = '0' AND PS(1) = '0'))) THEN
						--(N AND V) OR ((NOT N) AND (NOT V))
						excute_enable <= '1';
					--Less than or equal
					ELSIF (Cond = "1111" AND (PS(2) = '1' OR ((PS(3) = '1' AND PS(1) = '0') OR (PS(2) = '0' AND PS(1) = '1')))) THEN
						--Z OR (((N AND (NOT V)) OR ((NOT Z) AND V)))
						excute_enable <= '1';
					ELSE
						excute_enable <= '0';
					END IF;
				ELSIF (S = '0') THEN
				excute_enable <= '1';
			END IF;
		

	
	END IF;
	
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
			ps_enable <= '0';
			
		-- register load
		ELSIF(stage = 2) THEN
			
			wmfc <= '0';
			ir_enable <= '0';
			mem_read <= '0';
			pc_enable <= '0';
		
		-- ALU, branch, jump operation
		ELSIF(stage = 3) THEN
			-- R-type instructions
			IF(opCode(3) = '0' AND opCode(2) = '0' AND excute_enable = '1') THEN
				b_select <= '0'; --All R-type instructions select RB not Immediate value in MuxB. -Molly
				IF(opCode(1) = '0' AND opCode(0) = '1') THEN
					-- This is for JR, just fill in the values for the if statement.
				ELSIF(opCode(1) = '1' AND opCode(0) = '0') THEN
					-- This is for CMP.
					ps_enable <= '1';
				ELSIF (opCode(1) = '1' AND opCode(0) = '0') THEN
					-- This is for SLL instructions.  We haven't implemented this yet. -Molly
				ELSIF(opCode(1) = '0' AND opCode(0) = '0') THEN
					-- This is for the other R-type instructions.
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
				
			
			--D-type instructions
			ELSIF(opCode(3) = '0' AND opCode(2) = '1' AND excute_enable = '1') THEN
				--Is the following IF statement necessary if b_select and alu_op are the same for LW/SW/Addi??? -Molly
				--IF(opCode(1) = '1' AND opCode(0) = '0') THEN
					--Addi (which is used for LW and SW in Stage 3)
					b_select <= '1';
					alu_op <= "11";
				--END IF;
				
				
			END IF;
	
		-- Memory stage
		ELSIF(stage = 4) THEN
			-- R-type instructions
			IF(opCode(3) = '0' AND opCode(2) = '0' AND excute_enable = '1') THEN
				y_select <= "00"; --Select the result from the ALU for R-type instructions. -Molly
				IF(opCode(1) = '0' AND opCode(2) = '1') THEN
					--This is for JR, just fill in the values for the if statement
					--We will have to set some flags here in the future
					--Do we set flags with cmp, branch, or jr???????????? -Molly 
				END IF;
				
			--D-type instructions	
			--LW and SW (Stage 4)
			ELSIF(opCode(3) = '0' AND opCode(2) = '1' AND excute_enable = '1') THEN
				ma_select <= '0';
				IF(opCode(1) = '0' AND opCode(0) = '0') THEN
					--LW instructions
					mem_read <= '1';
					y_select <= "01";
				ELSIF(opCode(1) = '0' AND opCode(0) = '1') THEN
					--SW instructions
					mem_write <= '1';
					
					--while(!mfc)
						--Wait for mfc
					--end while loop 
				END IF;
				
			--B-type instructions
			--Branch conditional instructions (from conditional table in project overview..not sure if this is right stage --Shea)
			ELSIF(opCode(3) = '1' AND opCode(2) = '0') THEN
				IF(opCode(1) = '0' AND opCode(0) = '0') THEN
				
				
				
				--Branch and Link (bal)
				ELSIF (opCode(1) = '0' AND opCode(0) = '1') THEN
				y_select <= "10";
				END IF;
				
			END IF;
		
		-- Write back stage
		ELSIF(stage = 5) THEN
			--R-type instructions
			IF(opCode(3) = '0' AND opCode(2) = '0' AND excute_enable = '1') THEN
				IF(opCode(1) = '0' AND opCode(0) = '1') THEN
					--This is for JR, just fill in the values for the if statement
				ELSIF(opCode(1) = '0' AND opCode(0) = '0') THEN
					rf_write <= '1';
					c_select <= "01"; --I think this goes here? (See PowerPoints) -Molly
				END IF;
			
			--D-type instructions (LW)
			ELSIF(opCode(3) = '0' AND opCode(2) = '1' AND excute_enable = '1') THEN
				IF(opCode(1) = '0' AND opCode(0) = '0') THEN
					--LW instructions
					rf_write <= '1';
					c_select <= "00";
				END IF;
				ELSIF(opCode(1) = '1' AND opCode(0) = '0') THEN
					--addi instructions
					rf_write<= '1';
					alu_op <= "11";
			END IF;
		END IF;
	END IF;
	END PROCESS;

end archOne;