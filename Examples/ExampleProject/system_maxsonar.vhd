library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity system_maxsonar is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           echo : in  STD_LOGIC;
           measure : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           alarm : OUT STD_LOGIC;           
		     trigger : OUT std_logic;
		     data_valid : OUT std_logic;
           an : OUT std_logic_vector(7 downto 0);
		     ca : OUT std_logic;
		     cb : OUT std_logic;
		     cc : OUT std_logic;
		     cd : OUT std_logic;
		     ce : OUT std_logic;
		     cf : OUT std_logic;
		     cg : OUT std_logic
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
   
   COMPONENT bin2bcd
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		num_bin : IN std_logic_vector(12 downto 0);          
		ud : OUT std_logic_vector(3 downto 0);
		dec : OUT std_logic_vector(3 downto 0);
		cen : OUT std_logic_vector(3 downto 0);
		mil : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
   
   COMPONENT visualize7seg
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ud : IN std_logic_vector(3 downto 0);
		dec : IN std_logic_vector(3 downto 0);
		cen : IN std_logic_vector(3 downto 0);
		mil : IN std_logic_vector(3 downto 0);          
		an : OUT std_logic_vector(7 downto 0);
		ca : OUT std_logic;
		cb : OUT std_logic;
		cc : OUT std_logic;
		cd : OUT std_logic;
		ce : OUT std_logic;
		cf : OUT std_logic;
		cg : OUT std_logic
		);
	END COMPONENT;
   
   signal ud, dec, cen, mil : std_logic_vector(3 downto 0);
   signal num_bin : std_logic_vector(12 downto 0);
   signal start : std_logic;         
   signal distance : std_logic_vector(10 downto 0);
   signal distance_extended : std_logic_vector(12 downto 0);
   type state_type is (continuous, unitary);
   signal state: state_type;
   signal clk_length : unsigned(26 downto 0);

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
   
   Inst_bin2bcd: bin2bcd PORT MAP(
		clk => clk,
		reset => reset,
		num_bin => distance_extended,
		ud => ud,
		dec => dec,
		cen => cen,
		mil => mil
	);
   
   Inst_visualize7seg: visualize7seg PORT MAP(
		clk => clk,
		reset => reset,
		ud => ud,
		dec => dec,
		cen => cen,
		mil => mil,
		an => an,
		ca => ca,
		cb => cb,
		cc => cc,
		cd => cd,
		ce => ce,
		cf => cf,
		cg => cg
	);
   
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
   
   Pclk_muylength:process(clk, reset)
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

