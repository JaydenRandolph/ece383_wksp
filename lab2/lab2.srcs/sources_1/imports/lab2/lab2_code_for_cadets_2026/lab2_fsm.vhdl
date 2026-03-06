----------------------------------------------------------------------------------
-- Name:	C2C Jayden Randolph
-- Date:	05Mar2026
-- File:    lab2_fsm.vhd
-- HW:	    Lab 2 
-- Pupr:	Lab 2 Finite State Machine for the write circuitry.  
--
-- Doc:	Adapted from Dr Coulston's Lab exercise
-- 	
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lab2_fsm is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (2 downto 0);
           cw : out  STD_LOGIC_VECTOR (2 downto 0)); 
end lab2_fsm;

architecture Behavioral of lab2_fsm is

    type state_type is (CountReset, Count, CountReady, Write, StopWrite);
	signal state: state_type;
	
	signal state_dbg : std_logic_vector(2 downto 0);
	signal cw_dbg : std_logic_vector(2 downto 0);
	signal sw_dbg : std_logic_vector(2 downto 0);

	attribute keep : string; attribute mark_debug : string;
	attribute keep of state_dbg : signal is "true";
	attribute mark_debug of state_dbg : signal is "true";
	attribute keep of cw_dbg : signal is "true";
	attribute mark_debug of cw_dbg : signal is "true";
	attribute keep of sw_dbg : signal is "true";
	attribute mark_debug of sw_dbg : signal is "true";
	

begin

	-- convert enum -> slv for debug
    state_dbg <= std_logic_vector(to_unsigned(state_type'pos(state), state_dbg'length));   
	sw_dbg <= sw;

	-------------------------------------------------------------------------------
	--		SW		sw(0) = ready, sw(1) = last address, sw(2) = trigger
	--		
	-------------------------------------------------------------------------------
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then 
				state <= CountReset;
			else 
				case state is
					when CountReset =>
					   if(sw(2) = '1') then state <= Count; end if; --this is when I implement trigger
					when Count =>
					   state <= CountReady;
					when CountReady =>
					   if(sw(0) = '1') then state <= Write; end if;
					   if(sw(1) = '1') then state <= CountReset; end if;
					when Write =>
					   state <= StopWrite;
					when StopWrite =>
					   if(sw(0) = '0') then state <= Count; end if;
				end case;
			end if;
			
	   cw_dbg <= "000" when state = CountReset else
              "011" when state = Count else
              "110" when state = Write else
              "010" when state = CountReady or state = StopWrite;
			
		end if;
	end process;

	-------------------------------------------------------------------------------
	--  CW output table
	--		CW		cw(0) = ctrl, cw(1) = reset, cw(2) = write enable
	--		
	-------------------------------------------------------------------------------
	
        cw <= "000" when state = CountReset else
              "011" when state = Count else
              "110" when state = Write else
              "010" when state = CountReady or state = StopWrite;
             

end Behavioral;

