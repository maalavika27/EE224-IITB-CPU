library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity memory is 
port(
    M_add, M_inp : in std_logic_vector(15 downto 0);
    M_data : out std_logic_vector(15 downto 0);
    clock, Mem_R, Mem_W : in std_logic;
)

architecture behav of memory is
type array_of_vectors is array (2e16  downto 0) of std_logic_vector(15 downto 0);
signal memory_storage : array_of_vectors := (others => "0000000000000000");
begin
memory_write: process(clock, Mem_W, M_inp, M_add)
    begin
        if(clock' event and clock = '1') then
            if (Mem_W = 1) then
                memory_storage(to_integer(unsigned(M_add))) <= M_inp;
            else 
                null;
            end if;
        else
            null;
        end if;
    end process;

memory_read: process(clock, Mem_R, M_add)
    begin
    if(clock' event and clock = '1') then
        if (Mem_R = 1) then
            M_data <= memory_storage(to_integer(unsigned(M_add))) ;
        else
            null;
        end if;
    else
        null;
    end if;
    end process;
end architecture behav;