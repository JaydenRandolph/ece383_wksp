----------------------------------------------------------------------------------
-- C2C Jayden Randolph, 05Mar2026
-- Debouncer implemented from Lab 1
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

entity debouncer is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

constant delay_value : integer := 2000000;

signal current_state : std_logic := '0';
signal counter : unsigned(20 downto 0) := (others  => '0'); --from prev hw; initializes as 0

begin

process(clk)

begin
    if(rising_edge(clk)) then
        if(reset_n = '0') then
            counter <= (others => '0');
            current_state <= '0';
        elsif(btn_in = current_state) then --only move once "the dust has settled"
            counter <= (others => '0');    
        elsif(counter = delay_value) then --20ms delay
            current_state <= btn_in;
            counter <= (others => '0');    
        else 
            counter <= counter + 1;
        end if;
        btn_out <= current_state;
    end if;
end process;

end Behavioral;
