----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:30 01/15/2024 
-- Design Name: 
-- Module Name:    zamek_LCD_write - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zamek_LCD_write is

    Port ( DO : in  STD_LOGIC_VECTOR (7 downto 0);
           E0 : in  STD_LOGIC;
           F0 : in  STD_LOGIC;
           DO_Rdy : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  BUSY : in STD_LOGIC;
           Y : out  STD_LOGIC;
           DI : out  STD_LOGIC_VECTOR (7 downto 0);
           WE : out  STD_LOGIC
);
			  
end zamek_LCD_write;

architecture Behavioral of zamek_LCD_write is

	type state is (q0, q1, q2, q3, q4, q5, q6, q7);
	signal state_curr, state_next : state;
	signal timer : natural range 0 to 50000001 := 0;
	constant D1 : std_logic_vector(7 downto 0) := x"4D";
	constant D2 : std_logic_vector(7 downto 0) := x"44";
	constant timer_max : natural := 50000000;
	--constant timer_max : natural := 200;
	signal timer_over : std_logic := '0';
	
begin
	
	
	--DI <= D1;
	
	process(CLK)
	begin
		if ( rising_edge(CLK) and ((DO_Rdy = '1' and F0 = '0') or timer_over = '1' or state_curr = q4 or state_curr = q5 or state_curr = q6)) then	
			state_curr <= state_next;
		end if;
	end process;
	
	-- Wypisywanie
	process(CLK)
	begin
		if( rising_edge(CLK) ) then
			if(DO_Rdy = '1' and F0 = '0' and state_next = q4) then
				WE <= '1';
				DI <= D1;
			elsif(state_next = q6) then
				DI <= D2;
				WE <= '1';
			elsif(DO_Rdy = '0' and F0 = '0') then
				WE <= '0';	
			end if;
		end if;
	end process;
	
	process(CLK)
	begin
		if (rising_edge(CLK)) then
			if(state_curr = q7) then
				if (timer = timer_max) then
					timer_over <= '1';
					timer <= 0;
				else
					timer <= timer + 1;
					timer_over <= '0';
				end if;
			else
				timer <= 0;
				timer_over <= '0';
			end if;
		end if;
	end process;
	
	process(DO, state_curr, BUSY, timer_over)
	begin
		state_next <= state_curr;
		case state_curr is
		when q0 =>
			if DO= x"3A" then
				state_next <= q1;
			else
				state_next <= q0;
			end if;
		when q1 =>
			if DO = x"23" then
				state_next <= q2;
			elsif DO = x"3A" then
				state_next <= q1;
			else
				state_next <= q0;
			end if;
		when q2 =>
			if DO = x"1B" then
				state_next <= q3;
			elsif DO = x"3A" then
				state_next <= q1;
			else
				state_next <= q0;
			end if;
		when q3 =>
			if DO = x"42" then
				state_next <= q4;
			elsif DO = x"3A" then
				state_next <= q1;
			else
				state_next <= q0;
			end if;
		when q4 =>
			state_next <= q5;
		when q5 =>
			if BUSY = '0' then
				state_next <= q6;
			end if;
		when q6 =>
			state_next <= q7;
		when q7 =>
			if timer_over = '1' then
				state_next <= q0;
			end if;
		end case;
	end process;
	
	process(state_curr)
	begin
		
		case state_curr is
		
		when q0 =>
			Y <= '0'; 
		when q1 =>
			Y <= '0'; 
		when q2 =>
			Y <= '0'; 
		when q3 =>
			Y <= '0'; 
		when others =>
			Y <= '1';
		end case;
	end process;



end Behavioral;

