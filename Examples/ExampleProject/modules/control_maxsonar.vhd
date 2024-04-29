library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity control_maxsonar is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           echo : in  STD_LOGIC;
           trigger : out  STD_LOGIC;
           data_valid : out  STD_LOGIC;
           distance : out  STD_LOGIC_VECTOR (10 downto 0));
end control_maxsonar;

architecture Behavioral of control_maxsonar is

   type state_type is (s0,s1,s2);
   signal state: state_type;
   signal count: unsigned(10 downto 0);
   signal clki: std_logic;
   signal cont_echo: unsigned(10 downto 0);

begin

   P1_clk:process(clk, reset)
   begin
      if (reset = '1') then
         count <= (others => '0');
      elsif rising_edge(clk) then
         if count < 1450 then
            count <= count + 1;
         else
            count <= (others => '0');
         end if;
      end if;
   end process;
   clki <= count(10);
   
   Pprincipal:process(clki, reset)
   begin
      if (reset = '1') then
         state <= s0;
         cont_echo <= (others => '0');
         data_valid <= '0';
         distance <= (others => '0');
         trigger <= '0';
      elsif rising_edge(clki) then
         case state is
            when s0 =>           -- Wait for start to activate trigger
               data_valid <= '0';
               cont_echo <= (others => '0'); -- Reset count echo
               if start = '1' then
                  trigger <= '1';
                  state <= s1;             
               end if;
               
            when s1 =>           -- Deactivate trigger after 14.5us
               trigger <= '0';
               if echo = '1' then
                  state <= s2;
               end if;
 
            when s2 =>
               if echo = '0' then
                  distance <= std_logic_vector(cont_echo/4);
                  data_valid <= '1';
                  state <= s0;
               else
                  if cont_echo < 1600 then
                     cont_echo <= cont_echo + 1;
                  end if;
               end if;          
         end case;
      end if;
   end process;

end Behavioral;

