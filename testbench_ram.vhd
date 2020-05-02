--------------------------------------------------------------------------------
-- Company: 
-- Engineer: Stefan, Aja
-- 
-- Create Date:   22:31:16 16/11/2019 
-- Design Name:   
-- Module Name:   C:/Documents/testbench_ram.vhd
-- Project Name:  mem_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY testbench_ram IS
END testbench_ram;
 
ARCHITECTURE behavior OF testbench_ram IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         led7_seg_o : OUT  std_logic_vector(7 downto 0);
         led7_an_o : OUT  std_logic_vector(3 downto 0);
         sw7_i : IN  std_logic;
         addr_o : OUT  std_logic_vector(17 downto 0);
         ce10_o : OUT  std_logic;
         ub10_o : OUT  std_logic;
         lb10_o : OUT  std_logic;
         ce11_o : OUT  std_logic;
         ub11_o : OUT  std_logic;
         lb11_o : OUT  std_logic;
         oe_o : OUT  std_logic;
         we_o : OUT  std_logic;
         data_io : INOUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
	COMPONENT ram
	PORT(
		ncs_i : IN std_logic;
		addr_i : IN std_logic_vector(17 downto 0);
		nwe_i : IN std_logic;
		noe_i : IN std_logic;       
		data_io : INOUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal sw7_i : std_logic := '0';

	--BiDirs
   signal data_io : std_logic_vector(31 downto 0);

 	--Outputs
   signal led7_seg_o : std_logic_vector(7 downto 0);
   signal led7_an_o : std_logic_vector(3 downto 0);
   signal addr_o : std_logic_vector(17 downto 0);
   signal ce10_o : std_logic;
   signal ub10_o : std_logic;
   signal lb10_o : std_logic;
   signal ce11_o : std_logic;
   signal ub11_o : std_logic;
   signal lb11_o : std_logic;
   signal oe_o : std_logic;
   signal we_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          led7_seg_o => led7_seg_o,
          led7_an_o => led7_an_o,
          sw7_i => sw7_i,
          addr_o => addr_o,
          ce10_o => ce10_o,
          ub10_o => ub10_o,
          lb10_o => lb10_o,
          ce11_o => ce11_o,
          ub11_o => ub11_o,
          lb11_o => lb11_o,
          oe_o => oe_o,
          we_o => we_o,
          data_io => data_io
        );
		  
	Inst_ram1: ram PORT MAP(
		ncs_i => ce10_o,
		addr_i => addr_o,
		data_io => data_io(31 downto 16),
		nwe_i => we_o,
		noe_i => oe_o
	);
	
	Inst_ram2: ram PORT MAP(
		ncs_i => ce11_o,
		addr_i => addr_o,
		data_io => data_io(15 downto 0),
		nwe_i => we_o,
		noe_i => oe_o
	);
	
	

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
		sw7_i <= '1';
		
      rst_i <= '1';
		wait for clk_i_period*3;
		rst_i <= '0';
		
		
		
		
		
		
		

      -- insert stimulus here 

      wait;
   end process;

END;
