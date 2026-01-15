----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2026 10:31:37 AM
-- Design Name: 
-- Module Name: hw3_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw3_tb is
--  Port ( );
end hw3_tb;

architecture Behavioral of hw3_tb is

    --the hw3 "box" I built and want to test
    component hw3
        Port ( d : in unsigned (7 downto 0);
               h : out STD_LOGIC);
    end component;
    
    --wires that will hook up to the hw3 "box" I want to test
    signal d_tb : unsigned (7 downto 0);
    signal h_tb : std_logic;

begin

--wires up the "test switches" to the hw3 "box" I'm testing
uut: hw3 port map(
        d => d_tb,
        h => h_tb
    );
    
    
-- "hands flipping the switches" part of my code
    stim_proc: process
    begin
    --Used ChatGPT past here to make my test cases
        -- multiple of 17 → LED should be on
        d_tb <= x"00"; wait for 10 ns;
        d_tb <= x"11"; wait for 10 ns;
        d_tb <= x"22"; wait for 10 ns;
        d_tb <= x"33"; wait for 10 ns;
        d_tb <= x"44"; wait for 10 ns;
        d_tb <= x"55"; wait for 10 ns;
        d_tb <= x"66"; wait for 10 ns;
        d_tb <= x"77"; wait for 10 ns;
    
        -- not multiples of 17 → LED should be off
        d_tb <= x"01"; wait for 10 ns;
        d_tb <= x"10"; wait for 10 ns;
        d_tb <= x"20"; wait for 10 ns;
        d_tb <= x"7F"; wait for 10 ns;

    wait; -- stop simulation
end process;
        


end Behavioral;
