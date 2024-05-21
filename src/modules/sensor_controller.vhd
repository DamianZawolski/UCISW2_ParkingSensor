-- uS = 1/1 000 000 s
-- spartan CLK?? 50mH => f = 1/50 000 000 s
-- uS = 50 cykli zegara
-- triger pulse = 500 cykli zegara
-- echo Pulse = <900 , 5000>, over 5000 cycles => no Object Detected
-- 10mS gap to next echo trigger pulse => 10 * 1000 * 50 = 500 000 cycles ???


-- UWAGI
-- coś jest zepsute z tym signal clki. Wydaje mi się, że on jest do odliczania czasu pomiedzy wysłaniem triger pulse a sonic burst albo coś w tym stylu (fig-4 z dokumentacji)
-- według mnie zmieni się on tylko raz i dlatego pomiar jest jednokrotny zamiast ciągły (kolejne stany są za ifem: 'elsif rising_edge(clki) then')

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
entity sensor_controller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           echo : in  STD_LOGIC;
           trigger : out  STD_LOGIC;
           data_valid : out  STD_LOGIC;                     -- Ustawiane na 1 gdy zostanie odczytany nowy pomiar, może być clockiem (??)
           distance : out  STD_LOGIC_VECTOR (10 downto 0)); -- 11 bitów 
end sensor_controller;

architecture Behavioral of sensor_controller is

    -- s0 = waiting for trigger pulse
    -- s1 = waiting for echo
    -- s2 = echo recieved, calucate distance, validate result
   type state_type is (s0,s1,s2);           
   signal state: state_type;
   signal count: unsigned(10 downto 0);
   signal clki: std_logic;
   signal cont_echo: unsigned(10 downto 0);

begin

   P1_clk:process(clk, reset)
   begin
      if (reset = '1') then
         count <= (others => '0');  -- sets all bits in vector to 0
      elsif rising_edge(clk) then
         if count < 1450 then       -- ???
            count <= count + 1;
         else
            count <= (others => '0');
         end if;
      end if;
   end process;
   clki <= count(10);               -- zostanie zmienione na 1 gdy licznik osi¹gnie 1024?
   
   Pprincipal:process(clki, reset)
   begin
      if (reset = '1') then
         state <= s0;
         cont_echo <= (others => '0');
         data_valid <= '0';
         distance <= (others => '0');
         trigger <= '0';
      elsif rising_edge(clki) then  -- everytime clki is changed to 1 => count = 1024 start process
         case state is
            when s0 =>           -- Wait for start to activate trigger
               data_valid <= '0';
               cont_echo <= (others => '0'); -- Reset count echo
               if start = '1' then
                  trigger <= '1';
                  state <= s1;             
               end if;
               
            when s1 =>                  -- Deactivate trigger after 14.5us
               trigger <= '0';
               if echo = '1' then       -- echo = '1' means that wave has already been send but did not come back yet
                  state <= s2;
               end if;
 
            when s2 =>
               if echo = '0' then       -- echo = 0, wave came back
                  distance <= std_logic_vector(cont_echo/4); -- why /4?? we should divide by 58 according to manual, można próbnie zmienć na 64
                  data_valid <= '1';
                  state <= s0;
               else
                  if cont_echo < 1600 then
                     cont_echo <= cont_echo + 1;
                  end if;
                  -- nie wiem czy nie trzeba dać jakiegoś else if gdy sygnał nie zostanie złapany żeby coś zwróciło i poszło do s0. TU też może sie blokować 
               end if;          
         end case;
      end if;
   end process;

end Behavioral;
