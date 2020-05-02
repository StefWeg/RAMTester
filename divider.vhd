----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Stefan, Aja
-- 
-- Create Date:    23:56:58 16/11/2019 
-- Design Name: 
-- Module Name:    divider - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity divider is
	generic( d : integer := 1);	
	port(	clk_i : in std_logic;
			rst_i : in std_logic;
			div_clk_o : out std_logic);			
end divider;


architecture Behavioral of divider is
	signal counter : integer range 0 to 50000 := 0;
begin
	process(clk_i, rst_i)
	begin
		if (rst_i = '1') then
			div_clk_o <= '0';
			counter <= 0;
		elsif (rising_edge(clk_i)) then		
			if (counter < d/2) then
				div_clk_o <= '0';
			elsif (counter < d - 1) then
				div_clk_o <= '1';
			end if;
			
			if(counter = d - 1) then 
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	
	end process;



end Behavioral;

