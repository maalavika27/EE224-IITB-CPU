library ieee;
use ieee.std_logic_1164.all;

entity alu is
	port (
	clock: in std_logic;
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	sel: in std_logic_vector(1 downto 0);
	X: out std_logic_vector(15 downto 0);
	C: out std_logic;
	Z: out std_logic);
end alu;

architecture a1 of alu is
function add(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0))
	return std_logic_vector is
	variable sum : std_logic_vector(15 downto 0) := (others => '0');
	variable carry : std_logic_vector(15 downto 0) := (others => '0');
	begin
		L1: for i in 0 to 15 loop
			if i = 0 then
				sum(i) := A(i) xor B(i) xor '0';
			carry(i) := A(i) and B(i);
			else 
				sum(i) := A(i) xor B(i) xor carry(i-1);
			carry(i) := (A(i) and B(i)) or (carry(i-1) and (A(i) xor B(i)));
			end if;
		end loop L1;
	return carry(15) & sum;
end add;

function nanded(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0))
	return std_logic_vector is
	variable outp : std_logic_vector(15 downto 0) := (others => '0');
	begin
		for i in 0 to 15 loop
			outp(i) := A(i) nand B(i);
		end loop;
	return outp;
end nanded;

function shift7(A: in std_logic_vector(15 downto 0))
	return std_logic_vector is
	variable outp : std_logic_vector(15 downto 0) := (others => '0');
	begin
		for i in 0 to 8 loop
			outp(i+7) := A(i);
		end loop;
		for i in 0 to 6 loop
			outp(i) := '0';
		end loop;
	return outp;
end shift7;

begin
	process(A,B,clock)
	variable carry_n_add : std_logic_vector(16 downto 0);
	begin
		if (clock'event and clock='1') then
			case sel is
				when "00" =>
					carry_n_add := add(A,B);
					C <= carry_n_add(16);
					X <= carry_n_add(15 downto 0);
				when "01" =>
					X <= nanded(A,B);
				when "10" =>
					X <= shift7(A);
				when others =>
					null;
			end case;
		else
			null;
		end if;
	end process;
end a1;