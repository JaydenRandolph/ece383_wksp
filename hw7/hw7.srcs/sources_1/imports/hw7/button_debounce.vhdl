--------------------------------------------------------------------
-- Name:	George York
-- Date:	Feb 2, 2021
-- File:	button_debounce.vhdl
-- HW:	    Template for HW7
--	Crs:	ECE 383
--
-- Purp:	For this debouncer, we assume the clock is slowed from 100MHz to 100KHz,
--          and the ringing time is less than 20ms
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;		
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity button_debounce is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			button: in STD_LOGIC;
			action: out STD_LOGIC);
end button_debounce;

architecture behavior of button_debounce is
	
	signal cw: STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
	signal sw: STD_LOGIC:= '0';
    constant delay_value : integer := 2000; --from my lab1
	type state_type is (InitCount, WaitInput, BtnPressed, WaitDprs, Debounce, SendSig);
	signal state: state_type;
	
	--ChatGPT code to let me display strings on the waveform
	attribute keep : string;
    attribute mark_debug : string;

    attribute keep of state : signal is "true";
    attribute mark_debug of state : signal is "true";
    --End ChatGPT code
	
	COMPONENT lec10    -- clock for 20 msec debounce delay
		generic (N: integer := 4);
		Port(	clk: in  STD_LOGIC;
				reset : in  STD_LOGIC;
				crtl: in std_logic_vector(1 downto 0);
				D: in unsigned (N-1 downto 0);
				Q: out unsigned (N-1 downto 0));
    END COMPONENT;
	
	-- these values are for 100KHz
    signal D : unsigned(10 downto 0) := (others => '0');
    signal Q : unsigned(10 downto 0);
        
begin
    ----------------------------------------------------------------------
	--   DATAPATH
	----------------------------------------------------------------------
	delay_counter: lec10 
    Generic map(N => 11)
	PORT MAP (
          clk => clk,
          reset => reset,
		  crtl => cw,
          D => D,
          Q => Q
        );	
	
	-- reminder: counter counter every other clock cycle!
   	-- these values are for 100KHz clock
    sw <= '1' when (to_integer(Q) >= delay_value) else '0';
    
   -----------------------------------------------------------------------
   --    CONTROL UNIT
   -----------------------------------------------------------------------
   state_process: process(clk)
	 begin
		if (rising_edge(clk)) then
			if (reset = '0') then 
				state <= InitCount;
			else
				case state is
					when InitCount =>
						state <= WaitInput;
					when WaitInput =>
						if (button = '1') then state <= BtnPressed; end if;
					when BtnPressed =>
						if (sw = '1') then state <= WaitDprs; end if;
					when WaitDprs =>
					    if (button = '0') then state <= Debounce; end if;
					when Debounce =>
					    if (sw = '1') then state <= SendSig; end if;
					when SendSig =>
					    state <= WaitInput;					
				end case;
			end if;
		end if;
	end process;


	------------------------------------------------------------------------------
	--			OUTPUT EQUATIONS
	--	
	--		cw is counter control:  00 is hold; 01 is increment; 11 is reset	
	------------------------------------------------------------------------------	
	cw <=   "11" when state = InitCount or state = SendSig or state = WaitDprs else
			"01" when state = BtnPressed or state = Debounce else
			"00";
				
	action <= '1' when state = SendSig else '0';
	
end behavior;