Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity ram is

  generic (	words: 		integer := 10; -- no of words
				addr_width: integer := 18; -- addr width
				data_width:	integer := 16;
				at: 			time    := 2 ns); --read acces time

  port (ncs_i    : in std_logic;        -- not chip select
        addr_i   : in std_logic_vector(addr_width-1 downto 0);
        data_io  : inout std_logic_vector(data_width-1 downto 0);
        nwe_i    : in std_logic;        -- not write enable
        noe_i    : in std_logic        -- not output enable 
       );

end ram;

architecture ram of ram is
	type mem_t is array (0 to words-1 ) of std_logic_vector (data_width-1 downto 0);
	signal memory : mem_t;

begin

      
process      
   begin
      data_io <=(others =>'Z') ;
      loop
         if ncs_i = '0' then
            if nwe_i = '0' then
               --- write cycle
               memory(conv_integer(addr_i)) <= data_io after at;
            elsif nwe_i = '1' then 
               -- read cycle
               if noe_i = '0' then
                  data_io <= memory(conv_integer(addr_i)) after at;
               else 
                  data_io <= (others =>'Z');
               end if;
            else
               data_io <= (others =>'Z');
            end if;
         else
            data_io <= (others =>'Z');
         end if;

         wait on ncs_i, nwe_i, noe_i, addr_i, data_io;
      end loop;
   end process;
end ram;
