----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 01:13:13 AM
-- Design Name: 
-- Module Name: lec11_cu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lec11_cu is
    Port ( 
        clk: in  STD_LOGIC;
		reset : in  STD_LOGIC;
		kbClk: in std_logic;
		cw: out STD_LOGIC_VECTOR(3 downto 0);
		sw: in STD_LOGIC;
		busy: out std_logic);
end lec11_cu;

architecture Behavioral of lec11_cu is

    --copied a lot of my code from HW7 to make things organized
	type state_type is (WaitStart, Start, kbClkRise, Shift, kbClkFall, CountIncr, Load);
	signal state: state_type;
	
	--ChatGPT code to let me display strings on the waveform
	attribute keep : string;
    attribute mark_debug : string;

    attribute keep of state : signal is "true";
    attribute mark_debug of state : signal is "true";
    --end ChatGPT code (all from HW7)
   

begin

  -----------------------------------------------------------------------
   --    CONTROL UNIT
   -----------------------------------------------------------------------
   state_process: process(clk)
	 begin
		if (rising_edge(clk)) then
			if (reset = '0') then 
				state <= WaitStart;
			else
				case state is
				    when WaitStart =>
				        if(kbClk = '0') then state <= Start; end if;
					when Start =>
						if(sw = '0') then state <= kbClkRise; else state <= Load; end if;
					when kbClkRise =>
						if (kbClk = '0') then state <= Shift; end if;
					when Shift =>
						state <= kbClkFall;		
				    when kbClkFall =>
				        if(kbClk = '1') then state <= CountIncr; end if;
				    when CountIncr =>
				        state <= Start;
				    when Load =>
				        state <= WaitStart;
				end case;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------------
	--			OUTPUT EQUATIONS
	--	
	--		cw is counter control:  00 is hold; 01 is increment; 11 is reset	
	------------------------------------------------------------------------------	
	busy <= '0' when state = WaitStart else
	        '1';
	
	cw <=   "0011" when state = WaitStart  else
			"0100" when state = Shift else
			"0001" when state = CountIncr else
			"1011" when state = Load else
			"0000";


end Behavioral;
