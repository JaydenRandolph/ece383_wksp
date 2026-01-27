----------------------------------------------------------------------------------
-- Lt Col James Trimble, 16-Jan-2025
-- color_mapper (previously scope face) determines the pixel color value based on the row, column, triggers, and channel inputs 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity color_mapper is
    Port ( color : out color_t;
           position: in coordinate_t;
		   trigger : in trigger_t;
           ch1 : in channel_t;
           ch2 : in channel_t);
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal trigger_color : color_t := YELLOW; 
-- Add other colors you want to use here

signal is_vertical_gridline, is_horizontal_gridline, is_within_grid, is_trigger_time, is_trigger_volt, is_ch1_line, is_ch2_line,
    is_horizontal_hash, is_vertical_hash : boolean := false;

-- Fill in values here
constant grid_start_row : integer := 20;
constant grid_stop_row : integer := 420;
constant grid_start_col : integer := 20;
constant grid_stop_col : integer := 620;
constant num_horizontal_gridblocks : integer := 8;
constant num_vertical_gridblocks : integer := 10;
constant center_column : integer := 320;
constant center_row : integer := 220;
constant hash_size : integer := 5;
constant hash_horizontal_spacing : integer := 15;
constant hash_vertical_spacing : integer := 10;

begin

-- Assign values to booleans here
is_horizontal_gridline <= true when ((position.row - 20) mod 50 = 0) 
                          else false;
is_vertical_gridline <= true when ((position.col - 20) mod 60 = 0)
                        else false;
is_within_grid <= true when (((position.row - 20) < 401) and ((position.col - 20) < 601))
                  else false;
                  
                  
                  --trigger.t is where the yellow triangle is on the x-axis
                  --trigger.v is where the yellow triangle (a different one) is on the y-axis
is_trigger_time <= true when (trigger.t = '1')
                   else false;
is_trigger_volt <= true when (trigger.v = '1')
                   else false;
is_ch1_line <= true when (ch1.active = '1')
               else false;
is_ch2_line <= true when (ch2.active = '1')
               else false;
is_horizontal_hash <= true when ((position.row - 20) mod 15 = 0)
                      else false;
is_vertical_hash <= true when ((position.row - 20) mod 10 = 0)
                    else false;

-- Use your booleans to choose the color
color <=        trigger_color when (is_trigger_time or is_trigger_volt) else -- You can do multiple lines like this
                                   

end color_mapper_arch;
