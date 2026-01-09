----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2026 09:21:17 PM
-- Design Name: 
-- Module Name: scancode_decoder - Behavioral
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

entity scancode_decoder is
--redid this with C/Alves' help - your video had the wrong file name, so I just left this as HW 2's file name
    Port ( 
           I3 : in std_logic;
           I2 : in std_logic;
           I1 : in std_logic;
           I0 : in std_logic;
           O1 : out std_logic;
           O0 : out std_logic
          );
     
--this has the wrong name but it still works      
end scancode_decoder;

architecture Behavioral of scancode_decoder is

begin

    O1 <= I3 or I2;
    O0 <= (I1 and (not I2)) or I3;
    

end Behavioral;
