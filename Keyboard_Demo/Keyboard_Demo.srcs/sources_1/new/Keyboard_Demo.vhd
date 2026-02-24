

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Keyboard_Demo is
  port ( clk         : in std_logic;
         rst         : in std_logic;
         oled_sdin   : out std_logic;
         oled_sclk   : out std_logic;
         oled_dc     : out std_logic;
         oled_res    : out std_logic;
         oled_vbat   : out std_logic;
         oled_vdd    : out std_logic; 
         led         : out std_logic_vector(7 downto 0);
         ps2_clk     : in std_logic;
         ps2_data    : in std_logic;
         ja          : out std_logic_vector(1 downto 0));
end Keyboard_Demo;

architecture Behavioral of Keyboard_Demo is

        component oled_ctrl
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic; 
            switch      : in STD_LOGIC_VECTOR(7 downto 0)
        );
        end component;
        
        component lec11
	       port(
	        clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			kbClk: in std_logic;
			kbData: in std_logic;
			scan: out std_logic_vector(7 downto 0);
			busy: out std_logic);
        end component;

        signal scan_code : std_logic_vector(7 downto 0);
        signal busy : std_logic;

begin

        oled : oled_ctrl
        port map (
            clk => clk,
            rst => rst,
            oled_sdin => oled_sdin,
            oled_sclk => oled_sclk,
            oled_dc => oled_dc,
            oled_res => oled_res,
            oled_vbat => oled_vbat,
            oled_vdd => oled_vdd, 
            switch => scan_code);
            
        ps2_receiver : lec11
        port map (
            clk => clk,
            reset => rst,
            kbClk => ps2_clk,
            kbData => ps2_data,
            scan => scan_code,
            busy => busy);

        led <= scan_code;
        ja(0) <= ps2_clk;
        ja(1) <= ps2_data;

end Behavioral;
