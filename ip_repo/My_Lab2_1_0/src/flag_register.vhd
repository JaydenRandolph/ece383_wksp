------------------------------------------------------------------------------------------
-- Flag Register: Logic to be used in Lab 3 for flag
-- C2C Jayden Randolph, 05Mar2026
------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flag_register is
    Port ( clk : in STD_LOGIC;
           set : in STD_LOGIC;
           Q : out STD_LOGIC;
           clear : in STD_LOGIC;
           reset_n : in STD_LOGIC);
end flag_register;

architecture Behavioral of flag_register is

begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			if reset_n = '0' then
				Q <= '0'; --resets to 0
		    elsif(set = '1' and clear = '0') then
				Q <= '1';
		    elsif(set = '0' and clear = '1') then
				Q <= '0';
			end if;
		end if;
	end process;

	
end Behavioral;
