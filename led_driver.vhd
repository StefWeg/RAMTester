----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Stefan, Aja
-- 
-- Create Date:    23:01:37 16/11/2019 
-- Design Name: 
-- Module Name:    led_driver - Behavioral 
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

entity led_driver is
	port( clk_i : in std_logic;
			rst_i : in std_logic;
			digit_0 : in std_logic_vector(3 downto 0);
			digit_1 : in std_logic_vector(3 downto 0);
			digit_2 : in std_logic_vector(3 downto 0);
			digit_3 : in std_logic_vector(3 downto 0);				
			led7_an_o : out std_logic_vector(3 downto 0) := (others => '0');
			led7_seg_o : out std_logic_vector(7 downto 0) := (others => '0'));			
end led_driver;

architecture Behavioral of led_driver is

	function to7seg(digit : std_logic_vector(3 downto 0)) return std_logic_vector is
		variable seg : std_logic_vector(7 downto 0);
	begin
		seg := x"00";
		case digit is 
			when x"0" => seg := "00000011";
			when x"1" => seg := "10011111";
			when x"2" => seg := "00100101";
			when x"3" => seg := "00001101";
			when x"4" => seg := "10011001";
			when x"5" => seg := "01001001";
			when x"6" => seg := "01000001";
			when x"7" => seg := "00011111";
			when x"8" => seg := "00000001";
			when x"9" => seg := "00001001";
			when x"a" => seg := "00010001";
			when x"b" => seg := "11000001";
			when x"c" => seg := "01100011";
			when x"d" => seg := "10000101";
			when x"e" => seg := "01100001";
			when x"f" => seg := "01110001";
			when others => seg := "11111111";
		end case;
		
		return (seg);
	end function;
	
	signal counter : integer range 0 to 3;	
	signal div : integer range 0 to 50000000;	
	constant d : integer := 50000; -- 1 kHz
	signal div_clk_o : std_logic;
	
begin

	divider : process(clk_i, rst_i)
	begin
		if (rst_i = '1') then
			div_clk_o <= '0';
			div <= 0;
		elsif (rising_edge(clk_i)) then		
			if (div < d/2) then
				div_clk_o <= '0';
			elsif (div < d - 1) then
				div_clk_o <= '1';
			end if;
			
			if(div = d - 1) then 
				div <= 0;
			else
				div <= div + 1;
			end if;
		end if;

	end process; 
	
	
	process (div_clk_o, rst_i) 
	begin 
		if(rst_i = '1') then
			led7_an_o <= "0000";
			led7_seg_o <= "00000000";
			counter <= 0;
		elsif (rising_edge(div_clk_o)) then
			case counter is
				when 0 => led7_an_o <= "1110"; led7_seg_o <= to7seg(digit_0);
				when 1 => led7_an_o <= "1101"; led7_seg_o <= to7seg(digit_1);
				when 2 => led7_an_o <= "1011"; led7_seg_o <= to7seg(digit_2);
				when 3 => led7_an_o <= "0111"; led7_seg_o <= to7seg(digit_3);
				when others => led7_an_o <= "1111";
			end case;			
			
			if (counter >= 3) then 
				counter <= 0;
			else			
				counter <= counter + 1;
			end if;
			
		end if;
	end process;
end Behavioral;

