----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Stefan, Aja
-- 
-- Create Date:    22:15:14 16/11/2019 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity top is
	port(clk_i : in std_logic;
			rst_i : in std_logic;
			led7_seg_o : out std_logic_vector(7 downto 0);
			led7_an_o : out std_logic_vector(3 downto 0);
			sw7_i : in std_logic;
			
			addr_o : OUT std_logic_vector(17 downto 0);
			ce10_o : OUT std_logic;
			ub10_o : OUT std_logic;
			lb10_o : OUT std_logic;
			ce11_o : OUT std_logic;
			ub11_o : OUT std_logic;
			lb11_o : OUT std_logic;
			
			oe_o : OUT std_logic;
			we_o : OUT std_logic;
			data_io : INOUT std_logic_vector(31 downto 0));		

end top;

architecture Behavioral of top is

		COMPONENT ram_test
	PORT(
		clk_i : IN std_logic;
		rst_i : IN std_logic;    
		data_io : INOUT std_logic_vector(31 downto 0);      
		good_count_o : OUT std_logic_vector(11 downto 0);
		bad_count_o : OUT std_logic_vector(3 downto 0);
		addr_o : OUT std_logic_vector(17 downto 0);
		ce10_o : OUT std_logic;
		ub10_o : OUT std_logic;
		lb10_o : OUT std_logic;
		ce11_o : OUT std_logic;
		ub11_o : OUT std_logic;
		lb11_o : OUT std_logic;
		oe_o : OUT std_logic;
		we_o : OUT std_logic
		);
	END COMPONENT;
	
	
	COMPONENT led_driver
	PORT(
		clk_i : IN std_logic;
		rst_i : IN std_logic;
		digit_0 : IN std_logic_vector(3 downto 0);
		digit_1 : IN std_logic_vector(3 downto 0);
		digit_2 : IN std_logic_vector(3 downto 0);
		digit_3 : IN std_logic_vector(3 downto 0);          
		led7_an_o : OUT std_logic_vector(3 downto 0);
		led7_seg_o : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal CLKFX : std_logic;
	signal ram_ctrl_clock : std_logic;

	signal bad_count_o : std_logic_vector(3 downto 0);
	signal good_count_o : std_logic_vector(11 downto 0);


begin

	  DCM_inst : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 5,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 12, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 0.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "NONE", --"1X",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLK0 => open, --CLK0,     -- 0 degree DCM CLK ouptput
      CLK180 => open, --CLK180, -- 180 degree DCM CLK output
      CLK270 => open, --CLK270, -- 270 degree DCM CLK output
      CLK2X => open, --CLK2X,   -- 2X DCM CLK output
      CLK2X180 => open, --CLK2X180, -- 2X, 180 degree DCM CLK out
      CLK90 => open, --CLK90,   -- 90 degree DCM CLK output
      CLKDV => open, --CLKDV,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => CLKFX,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => open, --CLKFX180, -- 180 degree CLK synthesis out
      LOCKED => open, --LOCKED, -- DCM LOCK status output
      PSDONE => open, --PSDONE, -- Dynamic phase adjust done output
      STATUS => open, --STATUS, -- 8-bit DCM status bits output
      CLKFB => '0', --CLKFB, -- DCM clock feedback
      CLKIN => clk_i, --CLKIN,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',--PSCLK, -- Dynamic phase adjust clock input
      PSEN => '0',--PSEN,   -- Dynamic phase adjust enable input
      PSINCDEC => '0',--PSINCDEC, -- Dynamic phase adjust increment/decrement
      RST => rst_i        -- DCM asynchronous reset input
   );
	


	Inst_ram_test: ram_test PORT MAP(
		clk_i => ram_ctrl_clock,
		rst_i => rst_i,
		good_count_o => good_count_o,
		bad_count_o => bad_count_o,
		addr_o => addr_o,
		data_io => data_io,
		ce10_o => ce10_o,
		ub10_o => ub10_o,
		lb10_o => lb10_o,
		ce11_o => ce11_o,
		ub11_o => ub11_o,
		lb11_o => lb11_o,
		oe_o => oe_o,
		we_o => we_o
	);
	
        -- https://www.xilinx.com/support/documentation/user_guides/ug572-ultrascale-clocking.pdf
	inst_bufg : BUFGMUX PORT MAP( -- clock switching
		O => ram_ctrl_clock,
		I0 => clk_i,
		I1 => CLKFX,
		S => sw7_i
	);
	
	Inst_led_driver: led_driver PORT MAP(
		clk_i => clk_i,
		rst_i => rst_i,
		digit_0 => good_count_o(3 downto 0),
		digit_1 => good_count_o(7 downto 4),
		digit_2 => good_count_o(11 downto 8),
		digit_3 => bad_count_o,
		led7_an_o => led7_an_o,
		led7_seg_o => led7_seg_o
	);



end Behavioral;

