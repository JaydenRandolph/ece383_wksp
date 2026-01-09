----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2026 10:30:00 PM
-- Design Name: 
-- Module Name: scancode_decoder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for scancode_decoder.vhd
--              Applies all valid 4-bit inputs (at least one 1) and
--              checks that O1O0 outputs the index of the most significant 1.
-- Dependencies: scancode_decoder.vhd
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scancode_decoder_tb is
--  Port ( );
end scancode_decoder_tb;

architecture Behavioral of scancode_decoder_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component scancode_decoder
        Port ( 
               I3 : in std_logic;
               I2 : in std_logic;
               I1 : in std_logic;
               I0 : in std_logic;
               O1 : out std_logic;
               O0 : out std_logic
              );
    end component;

    -- Signals to connect to the UUT
    signal I3, I2, I1, I0 : std_logic := '0';
    signal O1, O0         : std_logic;

begin

    -- Instantiate the UUT
    UUT: scancode_decoder
        Port map (
            I3 => I3,
            I2 => I2,
            I1 => I1,
            I0 => I0,
            O1 => O1,
            O0 => O0
        );

    -- Stimulus and checking process
    stim_proc: process
        variable expected : std_logic_vector(1 downto 0);
    begin

        -- Input 0001 -> MSB index = 0 -> O1O0 = 00
        I3 <= '0'; I2 <= '0'; I1 <= '0'; I0 <= '1'; wait for 10 ns;
        expected := "00";
        assert (O1 & O0 = expected)
            report "Test failed for input 0001" severity error;

        -- Input 0010 -> MSB index = 1 -> O1O0 = 01
        I3 <= '0'; I2 <= '0'; I1 <= '1'; I0 <= '0'; wait for 10 ns;
        expected := "01";
        assert (O1 & O0 = expected)
            report "Test failed for input 0010" severity error;

        -- Input 0011 -> MSB index = 1 -> O1O0 = 01
        I3 <= '0'; I2 <= '0'; I1 <= '1'; I0 <= '1'; wait for 10 ns;
        expected := "01";
        assert (O1 & O0 = expected)
            report "Test failed for input 0011" severity error;

        -- Input 0100 -> MSB index = 2 -> O1O0 = 10
        I3 <= '0'; I2 <= '1'; I1 <= '0'; I0 <= '0'; wait for 10 ns;
        expected := "10";
        assert (O1 & O0 = expected)
            report "Test failed for input 0100" severity error;

        -- Input 0101 -> MSB index = 2 -> O1O0 = 10
        I3 <= '0'; I2 <= '1'; I1 <= '0'; I0 <= '1'; wait for 10 ns;
        expected := "10";
        assert (O1 & O0 = expected)
            report "Test failed for input 0101" severity error;

        -- Input 0110 -> MSB index = 2 -> O1O0 = 10
        I3 <= '0'; I2 <= '1'; I1 <= '1'; I0 <= '0'; wait for 10 ns;
        expected := "10";
        assert (O1 & O0 = expected)
            report "Test failed for input 0110" severity error;

        -- Input 0111 -> MSB index = 2 -> O1O0 = 10
        I3 <= '0'; I2 <= '1'; I1 <= '1'; I0 <= '1'; wait for 10 ns;
        expected := "10";
        assert (O1 & O0 = expected)
            report "Test failed for input 0111" severity error;

        -- Input 1000 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '0'; I1 <= '0'; I0 <= '0'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1000" severity error;

        -- Input 1001 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '0'; I1 <= '0'; I0 <= '1'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1001" severity error;

        -- Input 1010 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '0'; I1 <= '1'; I0 <= '0'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1010" severity error;

        -- Input 1011 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '0'; I1 <= '1'; I0 <= '1'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1011" severity error;

        -- Input 1100 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '1'; I1 <= '0'; I0 <= '0'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1100" severity error;

        -- Input 1101 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '1'; I1 <= '0'; I0 <= '1'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1101" severity error;

        -- Input 1110 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '1'; I1 <= '1'; I0 <= '0'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1110" severity error;

        -- Input 1111 -> MSB index = 3 -> O1O0 = 11
        I3 <= '1'; I2 <= '1'; I1 <= '1'; I0 <= '1'; wait for 10 ns;
        expected := "11";
        assert (O1 & O0 = expected)
            report "Test failed for input 1111" severity error;

        -- End simulation
        wait;
    end process;

end Behavioral;


--Used ChatGPT to generate this testbench (per the syllabus this is allowed. did not use it to write source code)