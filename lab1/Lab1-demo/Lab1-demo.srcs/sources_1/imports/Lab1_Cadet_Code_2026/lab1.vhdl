----------------------------------------------------------------------------------
--	Title
--  Name
--  Description
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity lab1 is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(4 downto 0);
		   led: out STD_LOGIC_VECTOR(1 downto 0);
		   sw: in STD_LOGIC_VECTOR(1 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end lab1;

architecture structure of lab1 is

    constant CENTER : integer := 0;
    constant DOWN : integer := 4;
    constant LEFT : integer := 2;
    constant RIGHT : integer := 3;
    constant UP : integer := 1;
    constant grid_start_row : integer := 20;
    constant grid_stop_row : integer := 420;
    constant grid_start_col : integer := 20;
    constant grid_stop_col : integer := 620;
    constant center_column : integer := 320;
    constant center_row : integer := 220;   

    signal trigger: trigger_t;
	signal pixel: pixel_t;
	signal ch1, ch2: channel_t;
	signal time_trigger_value : signed(10 downto 0);
	signal volt_trigger_value :  signed(10 downto 0);
	signal is_within_grid : boolean := false;
	
begin
   
-- Add numeric steppers for time and voltage trigger
trigger_t_stepper : numeric_stepper
  generic map(
    num_bits  => 11,
    max_value => 635,
    min_value => 5,
    delta => 15
  )
  port map(
    clk     => clk,
    reset_n => reset_n,             -- active-low synchronous reset
    en      => '1',                   -- enable
    up      => btn(RIGHT),             -- increment on rising edge
    down    => btn(LEFT),           -- decrement on rising edge
    q       => time_trigger_value   -- signed output
  );
    
trigger_v_stepper : numeric_stepper
  generic map(
    num_bits  => 11,
    max_value => 430,
    min_value => 10,
    delta => 10
  )
  port map(
    clk     => clk,
    reset_n => reset_n,             -- active-low synchronous reset
    en      => '1',                   -- enable
    up      => btn(UP),             -- increment on rising edge
    down    => btn(DOWN),           -- decrement on rising edge
    q       => volt_trigger_value   -- signed output
  );
-- Assign trigger.t and trigger.v
trigger.t <= unsigned(time_trigger_value);
trigger.v <= unsigned(volt_trigger_value);

-- Instantiate video
video1 : video
    port map(
    clk => clk,
    reset_n => reset_n,
    tmds => tmds,
    tmdsb => tmdsb,
    trigger => trigger,
    position => pixel.coordinate,
    ch1 => ch1,
    ch2 => ch2
    );
    
--Checks if within grid (copied from color mapper)
is_within_grid <= true when ((pixel.coordinate.row >= grid_start_row) and (pixel.coordinate.row <= grid_stop_row)
                  and (pixel.coordinate.col >= grid_start_col) and (pixel.coordinate.col <= grid_stop_col))
                  else false;
    
-- Determine if ch1 and or ch2 are active
    ch1.active <= '1' when (ch1.en = '1' and 
                  is_within_grid and 
                  (abs(to_integer(pixel.coordinate.row) - to_integer(pixel.coordinate.col)) = 0)) else --whole screen goes yellow if I don't have is_within_grid
                  '0';
    
    ch2.active <= '1' when (ch2.en = '1' and 
                  is_within_grid and 
                  (abs(to_integer(pixel.coordinate.row) - (440 - to_integer(pixel.coordinate.col))) = 0)) else 
                  '0';
    
-- Connect board hardware to signals
    ch1.en <= '1' when (sw = "01" or sw = "11") else '0';

    ch2.en <= '1' when (sw = "10" or sw = "11") else '0'; 
    
    led(0) <= '1' when (sw = "01" or sw = "11") else '0';
    
    led(1) <= '1' when (sw = "10" or sw = "11") else '0';
	
end structure;
