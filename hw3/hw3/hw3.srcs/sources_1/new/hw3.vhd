----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2026 10:31:37 AM
-- Design Name: 
-- Module Name: hw3 - Behavioral
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
--arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw3 is
    Port ( d : in unsigned (7 downto 0);
           h : out STD_LOGIC);
end hw3;

architecture Behavioral of hw3 is

begin

    h <= '1' when d = x"00" or d = x"11" or d = x"22" or d = x"33" or d = x"44" or d = x"55" or d = x"66" or d = x"77" or d = x"88" or d = x"99" or d = x"AA" or d = x"BB" or d = x"CC" or d = x"DD" or d = x"EE" or d = x"FF" else
         '0';

end Behavioral;
