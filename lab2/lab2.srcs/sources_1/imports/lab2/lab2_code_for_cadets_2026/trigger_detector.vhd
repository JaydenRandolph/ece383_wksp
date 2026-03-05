----------------------------------------------------------------------------------
-- While the monitored_signal crosses the threshold, trigger is set
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trigger_detector is
    port (
        clk              : in  std_logic;
        reset_n          : in  std_logic;
        threshold        : in  unsigned; --triggerVolt
        ready            : in  std_logic;
        monitored_signal : in  unsigned; --current
        crossed_trigger  : out std_logic
    );
end entity trigger_detector;

architecture trigger_detector_arch of trigger_detector is
    signal previous : unsigned(15 downto 7);
    
    signal L : std_logic;
    signal G : std_logic;
    
    
begin

    -- Register to hold previous value
    process (clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                previous <= (others => '0');
            elsif ready = '1' then
                if (previous < threshold) then
                    L <= '1';
                else
                    L <= '0'; end if;
                if (monitored_signal > threshold) then
                    G <= '1';
                else 
                    G <= '0'; end if;
                previous <= monitored_signal;
            else
                L <= '0';
                G <= '0';
                previous <= (others => '0');
            end if;
        end if;
    end process;

    crossed_trigger <= G and L;

end architecture trigger_detector_arch;
