library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lmsm is
	port( imm:in std_logic_vector(8 downto 0);
	q:in std_logic;
	clock:in std_logic;
	r_add: out std_logic_vector(2 downto 0));
end lmsm;

architecture bhv of lmsm is
signal i : integer := 0; 
signal r_add_next: std_logic_vector(2 downto 0) := "000";
begin

clock_process : process (clock,r_add_next)
--in next clock cycle, r_add output is given value r_add_next got from get_radd process
begin
	if (clock'event and clock='1') then
		r_add <= r_add_next;
	else null;
	end if;
end process;

get_radd : process (imm,i,r_add_next)
--given particular imm, i, update what r_add comes next
begin
	if (imm(i)='0' or i>7) then	
		null;
	else
		if (i<4) then
			r_add_next(2) <= '0';
		else 
			r_add_next(2) <= '1';
		end if;
		if (i=0 or i=4) then
			r_add_next(1 downto 0) <= "00";
		elsif (i=1 or i=5) then
			r_add_next(1 downto 0) <= "01";
		elsif (i=2 or i=6) then
			r_add_next(1 downto 0) <= "10";
		elsif (i=3 or i=7) then
			r_add_next(1 downto 0) <= "11";
		else null;
		end if; 
	end if;	
end process;

change_i : process (q,i)
--whenever q changes from 0 to 1, it means that we want i to update to the i+1
--if i=8, then we want i=0 instantiation
begin
	if (q='1') then 
		i <= i+1;
	elsif (i>7) then
		i <= 0;
	else null;
	end if;
end process;

end architecture;		
		
