
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity LCD_controller is

    Port (  DATA : in  STD_LOGIC_VECTOR (10 downto 0); -- 11 bitów zawierające dystans
            RST : in  STD_LOGIC;
            CLK : in  STD_LOGIC;
            Line : out  STD_LOGIC_VECTOR (63 downto 0);
            Blank : out  STD_LOGIC_VECTOR (15 downto 0)
);
			  
end LCD_controller;

architecture Behavioral of LCD_controller is

	-- type state is (q0, q1);
    
	-- signal state_curr, state_next : state;


	-- wartoæ hex ka¿dej cyfry w zapisie dziesiêtnym
	signal jednosci, dziesietne, setne, tysieczne: unsigned(3 downto 0);

	
begin
	
	-- process(CLK)
	-- begin
	-- 	if ( rising_edge(CLK) ) then	
	-- 		state_curr <= state_next;
	-- 	end if;
	-- end process;
	

	process(DATA)
        variable binary_number : integer;
    begin
        -- Konwersja STD_LOGIC_VECTOR na integer(liczbe dziesietna)
        binary_number := to_integer(unsigned(DATA));

        --tysieczne <= to_unsigned((binary_number / 1000) mod 10, 4);
        --setne <= to_unsigned((binary_number / 100) mod 10, 4);
        --dziesietne <= to_unsigned((binary_number / 10) mod 10, 4);
		  --jednosci <= to_unsigned(binary_number mod 10, 4);
		  
    end process;
	
	-- process(state_curr, DATA)
	-- begin
	-- 	case state_curr is

	-- 	when q0 =>

	-- 		if BUSY = '0' then
	-- 			state_next <= q1;
	-- 		end if;
    --    when q1 =>
   	-- 	state_next <= q0;
		
	-- 	end case;
	-- end process;
	
	-- process(state_curr, DATA)
	-- begin
		
	-- 	case state_curr is
	-- 	 -- to musi podawaæ ascii a nie wartoæ liczby!!!!
	-- 	 -- linia reprezentuje 16 znaków -> 64bit
	-- 	 -- co daja 4 bity na znak. Tymczasem 
    --     when q1 =>
    --         Line <= x"0000000000000" & "0" & DATA;
	-- 	when others =>
    --         Line <= x"0000000000000000";
	-- 	end case;

	-- end process;

	Line <= x"0000000000000" & "0" & DATA;
	Blank <= x"FFF8";   -- osatnie trzy pola do zapisu.


	 --ascii_tysieczne <= character'val(to_integer(tysieczne) + 48);
    --ascii_setne <= character'val(to_integer(setne) + 48);
    --ascii_dziesiete <= character'val(to_integer(dziesiete) + 48);
    --ascii_jednosci <= character'val(to_integer(jednosci) + 48);



end Behavioral;
