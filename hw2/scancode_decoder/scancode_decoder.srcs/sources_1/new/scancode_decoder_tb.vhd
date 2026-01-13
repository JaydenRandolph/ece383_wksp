----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/09/2026 10:11:55 AM
-- Design Name: 
-- Module Name: scancode_decoder_tb - Behavioral
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

entity scancode_decoder_tb is
--  Port ( );
end scancode_decoder_tb;

architecture Behavioral of scancode_decoder_tb is
component scancode_decoder
    Port ( scancode : in STD_LOGIC_VECTOR (7 downto 0);
           decoded_value : out STD_LOGIC_VECTOR (3 downto 0)
           );
    end component;

signal scancode_tb : std_logic_vector(7 downto 0);
signal decoded_value_tb : std_logic_vector(3 downto 0);

begin

uut: scancode_decoder port map(
        scancode => scancode_tb,
        decoded_value => decoded_value_tb
    );
    
    ---Used ChatGPT for sim_proc part
        stim_proc: process
    begin
        -- Digit 0
        scancode_tb <= x"45";
        wait for 10 ns;

        -- Digit 1
        scancode_tb <= x"16";
        wait for 10 ns;

        -- Digit 2
        scancode_tb <= x"1E";
        wait for 10 ns;

        -- Digit 3
        scancode_tb <= x"26";
        wait for 10 ns;

        -- Digit 4
        scancode_tb <= x"25";
        wait for 10 ns;

        -- Digit 5
        scancode_tb <= x"2E";
        wait for 10 ns;

        -- Digit 6
        scancode_tb <= x"36";
        wait for 10 ns;

        -- Digit 7
        scancode_tb <= x"3D";
        wait for 10 ns;

        -- Digit 8
        scancode_tb <= x"3E";
        wait for 10 ns;

        -- Digit 9
        scancode_tb <= x"46";
        wait for 10 ns;

        -- End simulation
        wait;
    end process;


end Behavioral;
