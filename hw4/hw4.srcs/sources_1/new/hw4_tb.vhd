----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2026 08:57:06 AM
-- Design Name: 
-- Module Name: counter_tb - Behavioral
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

entity hw4_tb is
--  Port ( );
end hw4_tb;

architecture Behavioral of hw4_tb is

    component counter is
        generic (
            num_bits : integer := 4;
            max_value : integer := 9
        );
        port ( clk : in STD_LOGIC;
            reset_n : in STD_LOGIC;
            ctrl : in STD_LOGIC;
            roll : out STD_LOGIC;
            Q : out unsigned(num_bits-1 downto 0));
        end component;

    signal clk_tb : std_logic := '0';
    signal reset_n_tb : std_logic := '1';
    signal ctrl_tb : std_logic := '0';
    signal roll_connector : std_logic;
    signal Q0_tb : unsigned(3 downto 0);
    signal Q1_tb : unsigned(3 downto 0);
    
    constant period : time := 10ns; --John helped me set this up


begin

LSB_digit: counter 
generic map (
    num_bits => 4,
    max_value => 9
    )
port map(
    clk => clk_tb,
    reset_n => reset_n_tb,
    ctrl => ctrl_tb,
    roll => roll_connector,
    Q => Q0_tb
    );
    
MSB_digit : counter 
generic map (
    num_bits => 4,
    max_value => 9
    )
port map(
    clk => clk_tb,
    reset_n => reset_n_tb,
    ctrl => roll_connector,
    roll => open, --chatGPT taught me how to do this so it is left "unwired" but still runs
    Q => Q1_tb
    );


    clock : process --John walked me through how to set up the clock with half low and half hot
    begin
        clk_tb <= '0';
        wait for period/2;
        clk_tb <= '1';
        wait for period/2;
    end process;
    
    --proves reset works
    reset_n_tb <= '0', '1' after 20 ns;
    
    --from HW4 tip
    ctrl_tb <= '1' after 30 ns, '0' after 70 ns, '1' after 80 ns, '0' after 150 ns, '1' after 160 ns, '0' after 170 ns, '1' after 180 ns;

end Behavioral;
