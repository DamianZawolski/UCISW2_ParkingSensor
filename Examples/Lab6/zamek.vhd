----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:10 01/15/2024 
-- Design Name: 
-- Module Name:    zamek - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zamek is
    Port ( DO : in  STD_LOGIC_VECTOR (7 downto 0);
           E0 : in  STD_LOGIC;
           F0 : in  STD_LOGIC;
           DO_Rdy : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           Y : out  STD_LOGIC;
           Line : out  STD_LOGIC_VECTOR (63 downto 0);
           Blank : out  STD_LOGIC_VECTOR (15 downto 0));
end zamek;

architecture Behavioral of zamek is
	type state is (q0, q1, q2, q3, q4);
	signal state_curr, state_next : state;
	
begin
	
	
	
	process(CLK)
	begin
		if ( rising_edge(CLK) and DO_Rdy = '1' and F0 = '0') then	
			state_curr <= state_next;
		end if;
	end process;

	process(DO, state_curr)
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
			if DO = x"3A" then
				state_next <= q1;
			else
				state_next <= q0;
			end if;
		end case;
	end process;
	
	process(state_curr)
	begin
		
		case state_curr is
		
		when q0 =>
			Line <= x"0000000000000000";
			Y <= '0'; 
		
		when q1 =>
			Line <= x"0000000000000001";
			Y <= '0'; 
		
			
		when q2 =>
			Line <= x"0000000000000002";
			Y <= '0'; 
		
		when q3 =>
			Line <= x"0000000000000003";
			Y <= '0'; 
		
		when q4 =>
			Line <= x"0000000000000004";
			Y <= '1'; 
		
		end case;
	end process;

	Blank <= x"FFFE";


end Behavioral;

