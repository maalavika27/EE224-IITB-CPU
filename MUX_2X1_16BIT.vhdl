Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_1X2_16BIT is 
  port (A3,A2,A1,A0,B3,B2,B1,B0: in std_logic_vector(3 downto 0) ;Sig_16BIT: in std_logic;Y3,Y2, Y1 ,Y0 : out std_logic_vector(3 downto 0));
  end entity MUX_1X2_16BIT ;


architecture Struct of MUX_1X2_16BIT is

 component MUX_1X2_4BIT is 
 port (A3,A2,A1,A0,B3,B2,B1,B0,Sig_4BIT: in std_logic;Y3,Y2, Y1 ,Y0 : out std_logic);
 end component MUX_1X2_4BIT ;

  --signal y_1,y_0 : std_logic;
  
  begin 
   M1 : MUX_1X2_4BIT port map (A3=>A3(3),B3=>B3(3),A2=>A3(2),B2=>B3(2),A1=>A3(1),B1=>B3(1),A0=>A3(0),B0=>B3(0),Sig_4BIT=>Sig_16BIT,Y3=>Y3(3),Y2=>Y3(2),Y1=>Y3(1),Y0=>Y3(0));
	M2 : MUX_1X2_4BIT port map (A3=>A2(3),B3=>B2(3),A2=>A2(2),B2=>B2(2),A1=>A2(1),B1=>B2(1),A0=>A2(0),B0=>B2(0),Sig_4BIT=>Sig_16BIT,Y3=>Y2(3),Y2=>Y2(2),Y1=>Y2(1),Y0=>Y2(0));
	M3 : MUX_1X2_4BIT port map (A3=>A1(3),B3=>B1(3),A2=>A1(2),B2=>B1(2),A1=>A1(1),B1=>B1(1),A0=>A1(0),B0=>B1(0),Sig_4BIT=>Sig_16BIT,Y3=>Y1(3),Y2=>Y1(2),Y1=>Y1(1),Y0=>Y1(0));
	M4 : MUX_1X2_4BIT port map (A3=>A0(3),B3=>B0(3),A2=>A0(2),B2=>B0(2),A1=>A0(1),B1=>B0(1),A0=>A0(0),B0=>B0(0),Sig_4BIT=>Sig_16BIT,Y3=>Y0(3),Y2=>Y0(2),Y1=>Y0(1),Y0=>Y0(0));
	

   
 
  
end Struct;