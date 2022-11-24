Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity DEMUX_1X2_16BIT is 
  port (A3,A2,A1,A0 : in std_logic_vector(3 downto 0) ;S_16BIT : in std_logic;
  Y7,Y6,Y5,Y4,Y3,Y2, Y1 ,Y0 : out std_logic_vector(3 downto 0));
  end entity DEMUX_1X2_16BIT ;


architecture Struct of DEMUX_1X2_16BIT is
 
component DEMUX_1X2_4BIT is 
  port (A3,A2,A1,A0,S_4BIT: in std_logic; Y7,Y6,Y5,Y4,Y3,Y2, Y1 ,Y0 : out std_logic);
  end component DEMUX_1X2_4BIT ;


    
  begin 
   M1 : DEMUX_1X2_4BIT port map (A3=>A3(3), A2=>A3(2), A1=>A3(1), A0 =>A3(0), S_4BIT =>S_16BIT,Y7=>Y7(3),Y6=>Y7(2),Y5=>Y7(1),Y4=>Y7(0),Y3=>Y6(3),Y2=>Y6(2),Y1=>Y6(1),Y0=>Y6(0));
   M2 : DEMUX_1X2_4BIT port map (A3=>A2(3), A2=>A2(2), A1=>A2(1), A0 =>A2(0), S_4BIT =>S_16BIT,Y7=>Y5(3),Y6=>Y5(2),Y5=>Y5(1),Y4=>Y5(0),Y3=>Y4(3),Y2=>Y4(2),Y1=>Y4(1),Y0=>Y4(0));
	M3 : DEMUX_1X2_4BIT port map (A3=>A1(3), A2=>A1(2), A1=>A1(1), A0 =>A1(0), S_4BIT =>S_16BIT,Y7=>Y3(3),Y6=>Y3(2),Y5=>Y3(1),Y4=>Y3(0),Y3=>Y2(3),Y2=>Y2(2),Y1=>Y2(1),Y0=>Y2(0));
   M4 : DEMUX_1X2_4BIT port map (A3=>A0(3), A2=>A0(2), A1=>A0(1), A0 =>A0(0), S_4BIT =>S_16BIT,Y7=>Y1(3),Y6=>Y1(2),Y5=>Y1(1),Y4=>Y1(0),Y3=>Y0(3),Y2=>Y0(2),Y1=>Y0(1),Y0=>Y0(0));	
	
	
  
end Struct;