
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity LCD_controller is

    Port (  DATA : in  STD_LOGIC_VECTOR (15 downto 0); -- 15 bitów zawierające zakodowany BCD dystans
            RST : in  STD_LOGIC;
            CLK : in  STD_LOGIC;
            Line : out  STD_LOGIC_VECTOR (63 downto 0);
            Blank : out  STD_LOGIC_VECTOR (15 downto 0)
);
			  
end LCD_controller;

architecture Behavioral of LCD_controller is


	
begin

	Line <= x"000000000000" & DATA;
	Blank <= x"FFF0";   -- osatnie trzy pola do zapisu.


end Behavioral;
