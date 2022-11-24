library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 

entity register_file is 
-- PC is R7 so incorporating it in register file itself
port(
    clock, reset, PC_write_enable, RF_W : in std_logic;
    A1, A2, A3 : in std_logic_vector(2 downto 0);
    D3, PC_write : in std_logic_vector(15 downto 0);
    D1, D2, PC_read : out std_logic_vector(15 downto 0);
)
end entity register_file;

architecture behav of register_file is
type reg_array_type is array (0 to 7) of std_logic_vector(15 downto 0);
signal registers : reg_array_type;
begin 
RF_writing : process(clock, reset, PC_write_enable, RF_W, D3, A3)
    begin
        if (reset = 1) then
            L1 : for i in 0 to 7 loop
                registers(i) <= "0000000000000000";
            end loop L1;

        elsif(clock' event and clock = '1') then
            if (RF_W = '1') then
                registers(to_integer(unsigned(A3))) <= D3;
            else
                null;
            end if;
            if (PC_write_enable = '1') then
                registers(7) <= PC_write;
            else
                null;
            end if;
        else
            null;
        end if;
    end process RF_writing;

D1 <= registers(to_integer(unsigned(A1)));
D2 <= registers(to_integer(unsigned(A2)));
PC_read <= registers(7);
end architecture behav;
