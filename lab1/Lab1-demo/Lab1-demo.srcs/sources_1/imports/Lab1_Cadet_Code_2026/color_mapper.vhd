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
signal gridline_color : color_t := WHITE;
signal ch1_color : color_t := GREEN;
signal ch2_color : color_t := RED;
signal background_color : color_t := BLACK; 

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
is_within_grid <= true when ((position.row >= grid_start_row) and (position.row <= grid_stop_row)
                  and (position.col >= grid_start_col) and (position.col <= grid_stop_col))
                  else false;

is_horizontal_gridline <= true when is_within_grid and((position.row - grid_start_row) mod 50 = 0) 
                          else false;
is_vertical_gridline <= true when is_within_grid and ((position.col - grid_start_col) mod 60 = 0)
                        else false;

--0 <= abs(col - trigger.t) <= 5 - (row - 20)
--__ <= "within ____ of the trigger position" <= "makes 5x5 square" ("makes the square into a triangle")

is_trigger_time <= true when (is_within_grid and (((abs(to_integer(position.col) - to_integer(trigger.t))) <= (hash_size - (to_integer(position.row) - grid_start_row))) and (0 <= (hash_size - (to_integer(position.row) - grid_start_row)))))
                   else false;
is_trigger_volt <= true when (is_within_grid and (((abs(to_integer(position.row) - to_integer(trigger.v))) <= (hash_size - (to_integer(position.col) - grid_start_col))) and (0 <= (hash_size - (to_integer(position.col) - grid_start_col)))))
                   else false;
is_ch1_line <= true when (is_within_grid and (ch1.active = '1'))
               else false;
is_ch2_line <= true when (is_within_grid and (ch2.active = '1'))
               else false;
               
--0 <= abs(position.row - 20) % 15 <= 5               
               
is_horizontal_hash <= true when (is_within_grid and ((((position.col - grid_start_col) mod hash_horizontal_spacing) <= hash_size)))
                      else false;
is_vertical_hash <= true when (is_within_grid and ((((position.row - grid_start_row) mod hash_vertical_spacing) <= hash_size)))
                    else false;

-- Use your booleans to choose the color
color <= gridline_color when (is_horizontal_gridline or is_vertical_gridline or is_horizontal_hash or is_vertical_hash) else
         trigger_color when (is_trigger_time or is_trigger_volt) else
         ch1_color when (is_ch1_line) else --works
         ch2_color when (is_ch2_line) else --works
         background_color;
                                   

end color_mapper_arch;
