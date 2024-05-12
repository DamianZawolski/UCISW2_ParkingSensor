
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity zamek_LCD_write is

    Port (  DATA : in  STD_LOGIC_VECTOR (12 downto 0); -- rozszerzony wektor
            RST : in  STD_LOGIC;
            CLK : in  STD_LOGIC;
            Line : out  STD_LOGIC_VECTOR (63 downto 0);
            Blank : out  STD_LOGIC_VECTOR (15 downto 0));
);
			  
end zamek_LCD_write;

architecture Behavioral of zamek_LCD_write is

	type state is (q0, q1);
    
	signal state_curr, state_next : state;


	-- wartość hex każdej cyfry w zapisie dziesiętnym
	signal jednosci, dziesietne, setne, tysieczne: unsigned(3 downto 0);

	
begin
	
	process(CLK)
	begin
		if ( rising_edge(CLK) ) then	
			state_curr <= state_next;
		end if;
	end process;
	
	-- Wypisywanie 
	-- process(CLK)
	-- begin
	-- 	if( rising_edge(CLK) ) then
	-- 		if(DO_Rdy = '1' and F0 = '0' and state_next = q4) then
	-- 			WE <= '1';
	-- 			DI <= D1;
	-- 		elsif(state_next = q6) then
	-- 			DI <= D2;
	-- 			WE <= '1';
	-- 		elsif(DO_Rdy = '0' and F0 = '0') then
	-- 			WE <= '0';	
	-- 		end if;
	-- 	end if;
	-- end process;
	

	process(DATA)
        variable binary_number : integer;
    begin
        -- Konwersja STD_LOGIC_VECTOR na integer(liczbe dziesietna)
        binary_number := to_integer(unsigned(DATA));

        tysieczne <= to_unsigned((binary_number / 1000) mod 10, 4);
        setne <= to_unsigned((binary_number / 100) mod 10, 4);
        dziesiete <= to_unsigned((binary_number / 10) mod 10, 4);
		jednosci <= to_unsigned(binary_number mod 10, 4);
    end process;
	
	process(state_curr, BUSY, DATA)
	begin
		state_next <= state_curr;
		case state_curr is

		when q0 =>

			if BUSY = '0' then
				state_next <= q1;
			end if;
        when q1 =>
    		state_next <= q0;
		
		end case;
	end process;
	
	process(state_curr)
	begin
		
		case state_curr is
		 -- to musi podawać ascii a nie wartość liczby!!!!
		 -- linia reprezentuje 16 znaków -> 64bit
		 -- co daja 4 bity na znak. Tymczasem 
        when q1 =>
            Line <= x"000000000000"
		when others =>
            Line <= x"0000000000000000";
		end case;

	end process;

	Blank <= x"FFF0";   -- osatnie cztery pola do zapisu.


	ascii_tysieczne <= character'val(to_integer(tysieczne) + 48);
    ascii_setne <= character'val(to_integer(setne) + 48);
    ascii_dziesiete <= character'val(to_integer(dziesiete) + 48);
    ascii_jednosci <= character'val(to_integer(jednosci) + 48);



end Behavioral;

