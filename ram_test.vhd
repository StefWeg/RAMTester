library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_test is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           good_count_o : out  STD_LOGIC_VECTOR (11 downto 0);
           bad_count_o : out  STD_LOGIC_VECTOR (3 downto 0);
           addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           data_io : inout  STD_LOGIC_VECTOR (31 downto 0);
           ce10_o : out  STD_LOGIC;
           ub10_o : out  STD_LOGIC;
           lb10_o : out  STD_LOGIC;
           ce11_o : out  STD_LOGIC;
			  ub11_o : out  STD_LOGIC;
           lb11_o : out  STD_LOGIC;
           oe_o : out  STD_LOGIC;
           we_o : out  STD_LOGIC);
end ram_test;

architecture Behavioral of ram_test is
	-- uncomment below line for implementation only
	constant test_end : std_logic_vector(17 downto 0):="111111111111111111";
	
	-- uncomment below line for simulation only
	--constant test_end : std_logic_vector(17 downto 0):="000000000000000111";
	
	-- chip enable (1- chip enabled, 0- chip off)
	signal ce : std_logic;
	signal we, oe: std_logic;
	type sm_states is (RST_FLAG,WRITE1,READ1,WRITE2,READ2,CNT_ACT);
	signal state: sm_states;
	signal addr : std_logic_vector(17 downto 0);
	signal data_tmp : std_logic_vector(31 downto 0);
	signal good_count : STD_LOGIC_VECTOR (11 downto 0);
	signal bad_count : STD_LOGIC_VECTOR (3 downto 0);
	signal error_flag : std_logic;
	signal aux_cnt : integer range 0 to 15;
begin
	lb10_o <= '0';
	ub10_o <= '0';
	lb11_o <= '0';
	ub11_o <= '0';
	ce10_o <= not ce;
	ce11_o <= not ce;
	oe_o	 <= not oe;
	we_o	 <= not we;
	good_count_o <= good_count;
	bad_count_o  <= bad_count;
	addr_o <= addr;
	
	process(clk_i,rst_i)
	begin
		if rst_i ='1' then
			state <= RST_FLAG;
			addr 	<= (others =>'0');
			ce		<= '0';
			oe		<= '0';
			we		<= '0';
			good_count <= (others =>'0');
			bad_count <= (others =>'0');
			aux_cnt <= 0;
			data_io <= (others => 'Z');
			data_tmp <= (others =>'0');
			error_flag <='0';
		elsif Rising_Edge(clk_i) then
			--good_count <= X"A98";
			--bad_count <= X"7";
			case state is
				when RST_FLAG => 	error_flag <='0';
										state <= WRITE1;
										aux_cnt<=0;
										addr <= (others =>'0');
				when WRITE1	  =>	aux_cnt <= aux_cnt + 1;
										data_io<=X"55555555";
										case aux_cnt is
											when 0 =>		
											when 1 => 	ce<='1'; we<='1'; oe<='0';
											when 2 =>	ce<='1'; we<='0'; oe<='0';
											when 3 => 	addr <= addr + 1;
															aux_cnt <= 0;
															if addr = test_end then
																state <= READ1;
																addr <= (others => '0');
																data_io <= (others => 'Z');
															end if;
											when others => null;
										end case;
				when READ1	  => 	aux_cnt <= aux_cnt + 1;
										case aux_cnt is
											when 0 =>	ce<='1'; we<='0'; oe<='1';	
											when 1 => 	addr <= addr + 1;
															data_tmp <= data_io;
											when 2 =>	aux_cnt <= 1;
															if data_tmp /= X"55555555" then
																error_flag <= '1';
															end if;
															if addr = test_end then
																state <= WRITE2;
																aux_cnt <= 0;
																addr <= (others => '0');
																oe<='0';
															end if;
											when others => null;
										end case;
			
				when WRITE2	  =>	aux_cnt <= aux_cnt + 1;
										data_io<=X"AAAAAAAA";
										case aux_cnt is
											when 0 =>		
											when 1 => 	ce<='1'; we<='1'; oe<='0';
											when 2 =>	ce<='1'; we<='0'; oe<='0';
											when 3 => 	addr <= addr + 1;
															aux_cnt <= 0;
															if addr = test_end then
																state <= READ2;
																addr <= (others => '0');
																data_io <= (others => 'Z');
															end if;
											when others => null;
										end case;
				when READ2	  => 	aux_cnt <= aux_cnt + 1;
										case aux_cnt is
											when 0 =>	ce<='1'; we<='0'; oe<='1';	
											when 1 => 	addr <= addr + 1;
															data_tmp <= data_io;
											when 2 =>	aux_cnt <= 1;
															if data_tmp /= X"AAAAAAAA" then
																error_flag <= '1';
															end if;
															if addr = test_end then
																state <= CNT_ACT;
																aux_cnt <= 0;
																addr <= (others => '0');
																oe<='0';
															end if;
											when others => null;
										end case;
				when CNT_ACT  => 	if error_flag = '1' then
											bad_count <= bad_count + 1;
										else
											good_count <= good_count + 1;
										end if;
										state <= RST_FLAG;
			end case;
		end if;
	end process;
end Behavioral;

