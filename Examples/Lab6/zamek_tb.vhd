--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:42:34 01/15/2024
-- Design Name:   
-- Module Name:   D:/lab6 - ucisw/lab6/zamek_tb.vhd
-- Project Name:  lab6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: zamek
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY zamek_tb IS
END zamek_tb;
 
ARCHITECTURE behavior OF zamek_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT zamek
    PORT(
         DO : IN  std_logic_vector(7 downto 0);
         E0 : IN  std_logic;
         F0 : IN  std_logic;
         DO_Rdy : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         Y : OUT  std_logic;
         Line : OUT  std_logic_vector(63 downto 0);
         Blank : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal DO : std_logic_vector(7 downto 0) := (others => '0');
   signal E0 : std_logic := '0';
   signal F0 : std_logic := '0';
   signal DO_Rdy : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal Y : std_logic;
   signal Line : std_logic_vector(63 downto 0);
   signal Blank : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
 
 	type hex_array_type is array(0 to 16) of std_logic_vector(7 downto 0);
	signal hex_array : hex_array_type;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: zamek PORT MAP (
          DO => DO,
          E0 => E0,
          F0 => F0,
          DO_Rdy => DO_Rdy,
          RST => RST,
          CLK => CLK,
          Y => Y,
          Line => Line,
          Blank => Blank
        );

	hex_array(0) <=  x"3B";
	hex_array(1) <=  x"3B";
	hex_array(2) <=  x"3A"; -- M
	hex_array(3) <=  x"23"; -- D
	hex_array(4) <=  x"1B"; -- S
	hex_array(5) <=  x"42"; -- K
	hex_array(6) <=  x"3B";
	hex_array(7) <=  x"3B";
	hex_array(8) <=  x"3A"; -- M
	hex_array(9) <=  x"23"; -- D
	hex_array(10) <=  x"1B"; -- S
	hex_array(11) <=  x"3A"; -- M
	hex_array(12) <=  x"23"; -- D
	hex_array(13) <=  x"1B"; -- S
	hex_array(14) <=  x"42"; -- K
	hex_array(15) <=  x"3B";
	hex_array(16) <=  x"3B";
	
	CLK_process : PROCESS
	BEGIN
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
	END PROCESS;

-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
		for i in 0 to 16 loop
			-- Sym 1
			DO <= hex_array(i);
			F0 <= '0';
			DO_Rdy <= '1';
			
			wait for 10 ns;
			DO_Rdy <= '0';
			wait for 20 ns;
			
			F0 <= '1';
			DO_Rdy <= '1';
			
			
			wait for 10 ns;
			DO_Rdy <= '0';
			wait for 70 ns;
			

		end loop;
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
