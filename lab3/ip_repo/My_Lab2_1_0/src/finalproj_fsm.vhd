----------------------------------------------------------------------------------
-- Name:	C2C Jayden Randolph
-- Date:	Spring 2026
-- File:    finalproj_fsm.vhd
-- HW:	    Final Project
-- Pupr:	Final Project (USAFA Pinball) Finite State Machine for the write circuitry.  
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
 
 
entity finalproj_fsm is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (5 downto 0);
           game_cw : out  STD_LOGIC_VECTOR (3 downto 0);
           left_paddle_cw : out STD_LOGIC_VECTOR(3 downto 0);
           right_paddle_cw : out STD_LOGIC_VECTOR(3 downto 0));
end finalproj_fsm;
 
architecture Behavioral of finalproj_fsm is
 
	type game_state is (Pause, Playing, Reset, Game_Over);
	type left_paddle_state is (L1, L2_1, L3, L2_2);
	type right_paddle_state is (R1, R2_1, R3, R2_2);
	signal game : game_state := Pause;
	signal left_paddle : left_paddle_state := L1;
	signal right_paddle : right_paddle_state := R1;
	signal left_animation_cntr : integer := 0; --chooses how long it takes for animation to occur
	signal right_animation_cntr : integer := 0;
	signal animation_timer_max : integer := 1670000; --asked ChatGPT for it's recommended max value for a smooth NES-pinball animation on a 100MHz clock
	constant button_A : integer := 0;
	constant button_B : integer := 1;
	constant button_Select : integer := 2;
	constant button_Start : integer := 3;
	constant ball_lost : integer := 4;
	constant game_over_sw : integer := 5;
	
begin
 
	-------------------------------------------------------------------------------
	--		SW		meaning
	--		
	-------------------------------------------------------------------------------
	state_proces: process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				game <= Reset;
				left_paddle <= L1;
				right_paddle <= R1;
				left_animation_cntr <= 0;
				right_animation_cntr <= 0;
			else 
				case game is 
				    when Pause =>
				       if (sw(button_Start) = '1') --'start' pressed
				           then game <= Playing;
				       end if;
					when Playing =>
					   if(sw(button_Start) = '1') then --'start' pressed
                           game <= Pause;
                       end if;
                       if (sw(button_Select) = '1') then --'reset' pressed
                           game <= Reset;
                       end if;
                       if (sw(game_over_sw) = '1') then --'ball_lives = 0'
                           game <= Game_Over; 
                       end if;
					when Reset =>
					   game <= Pause;			
					when Game_Over =>
					   game <= Reset;
				end case;
			--Animates the paddles. Created it like this so the paddles' states are independent of each other; you can press 
			--the right paddle in the middle of the left paddle's animation and vice versa.
				if game = Playing then
				    case left_paddle is
				        when L1 =>
				            if ((sw(button_B) = '1') and (left_animation_cntr >= animation_timer_max)) then --'B' pressed
                                left_paddle <= L2_1;
                                left_animation_cntr <= 0;
                            else
                                left_animation_cntr <= left_animation_cntr + 1;				            
				            end if;
				        when L2_1 =>
				            if (left_animation_cntr >= animation_timer_max) then
                                left_paddle <= L3;
                                left_animation_cntr <= 0;
                            else
                                left_animation_cntr <= left_animation_cntr + 1;				            
				            end if;	
				        when L3 =>
				            if (left_animation_cntr >= animation_timer_max) then
                                left_paddle <= L2_2;
                                left_animation_cntr <= 0;
                            else
                                left_animation_cntr <= left_animation_cntr + 1;				            
				            end if;			            
				        when L2_2 =>
				            if (left_animation_cntr >= animation_timer_max) then
                                left_paddle <= L1;
                                left_animation_cntr <= 0;
                            else
                                left_animation_cntr <= left_animation_cntr + 1;				            
				            end if;
				    end case;
				    case right_paddle is
				        when R1 =>
				            if ((sw(button_A) = '1') and (right_animation_cntr >= animation_timer_max)) then --'A' pressed
                                right_paddle <= R2_1;
                                right_animation_cntr <= 0;
                            else
                                right_animation_cntr <= right_animation_cntr + 1;				            
				            end if;
				        when R2_1 =>
				            if (right_animation_cntr >= animation_timer_max) then
                                right_paddle <= R3;
                                right_animation_cntr <= 0;
                            else
                                right_animation_cntr <= right_animation_cntr + 1;				            
				            end if;	
				        when R3 =>
				            if (right_animation_cntr >= animation_timer_max) then
                                right_paddle <= R2_2;
                                right_animation_cntr <= 0;
                            else
                                right_animation_cntr <= right_animation_cntr + 1;				            
				            end if;			            
				        when R2_2 =>
				            if (right_animation_cntr >= animation_timer_max) then
                                right_paddle <= R1;
                                right_animation_cntr <= 0;
                            else
                                right_animation_cntr <= right_animation_cntr + 1;				            
				            end if;
				    end case;
				end if;				            		    
			end if;
		end if;
	end process;
 
	-------------------------------------------------------------------------------
	--  CW output table
	--		See FSM for full cw labels
	game_cw <= "0001" when game = Pause else
	      "0010" when game = Playing else
	      "0100" when game = Reset else
	      "1000" when game = Game_Over else
	      "0000";	
	left_paddle_cw <= "0001" when left_paddle = L1 else
	      "0010" when left_paddle = L2_1 else
	      "0100" when left_paddle = L3 else
	      "1000" when left_paddle = L2_2 else
	      "0000";	
	right_paddle_cw	<= "0001" when right_paddle = R1 else
	      "0010" when right_paddle = R2_1 else
	      "0100" when right_paddle = R3 else
	      "1000" when right_paddle = R2_2 else
	      "0000";	
	-------------------------------------------------------------------------------
end Behavioral;
 