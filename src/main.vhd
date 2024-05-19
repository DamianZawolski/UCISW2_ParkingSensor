

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity system_maxsonar is
    Port (  clk : in  STD_LOGIC;        -- zegar 50mH
            reset : in  STD_LOGIC;      -- przycisk
            echo : in  STD_LOGIC;       -- pin ECHO
            measure : in  STD_LOGIC;    -- skad???
            mode : in  STD_LOGIC;       
            alarm : OUT STD_LOGIC;      -- dioda           
		      trigger : OUT std_logic;    -- pin TRIG
		      data_valid : OUT std_logic;
        );
end system_maxsonar;

architecture Behavioral of system_maxsonar is

   COMPONENT control_maxsonar
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		start : IN std_logic;
		echo : IN std_logic;          
		trigger : OUT std_logic;
		data_valid : OUT std_logic;
		distance : OUT std_logic_vector(10 downto 0)
		);
	END COMPONENT;

   -- TODO: Component LCD contorller


   signal ud, dec, cen, mil : std_logic_vector(3 downto 0);
   signal num_bin : std_logic_vector(12 downto 0);
   signal start : std_logic;         
   signal distance : std_logic_vector(10 downto 0);
   signal distance_extended : std_logic_vector(12 downto 0); -- to przekazujemy do LCD controller
   type state_type is (continuous, unitary);
   signal state: state_type;
   signal clk_length : unsigned(26 downto 0);   -- potezny licznik??

begin

   Inst_control_maxsonar: control_maxsonar PORT MAP(
		clk => clk,
		reset => reset,
		start => start,
		echo => echo,
		trigger => trigger,
		data_valid => data_valid,
		distance => distance
	);

   -- tu powinien być podłączony moduł odpowiedzialny za wypisayanie na LCD

   
    -- zarządznie tym czy pomiar jednorazowy czy ciągły
   Pprincipal:process(clk, reset)
   begin
      if (reset = '1') then
         state <= continuous;
         start <= '0';
      elsif rising_edge(clk) then
         case state is
            when continuous =>
               start <= '1';
               if mode = '0' then
                  state <= unitary;
               end if;
            when unitary =>
               start <= measure;
               if mode = '1' then
                  state <= continuous;
               end if;
         end case;
      end if;
   end process;

	      -- zarządzanie trybem ciągłym
    --Pprincipal: process(clk, reset)
    --begin
    --    if (reset = '1') then
    --        start <= '0';
    --    elsif rising_edge(clk) then
    --        start <= '1';
    --    end if;
   -- end process;

		
   
   Pclk_counter:process(clk, reset)
   begin
      if (reset = '1') then
         clk_length <= (others => '0');
      elsif rising_edge(clk) then
         clk_length <= clk_length + 1;
      end if;
   end process;
   
   distance_extended <= "00" & distance;

   alarm <= not clk_length(26) when (distance > "00001001011" and distance < "00001100100") else
             not clk_length(25) when (distance > "00000110010" and distance < "00001001011") else
             not clk_length(24) when (distance > "00000011001" and distance < "00000110010") else
             not clk_length(23) when (distance > "00000001010" and distance < "00000011001") else
             '0' when (distance < "00000001010") else
             '1';
   
end Behavioral;

