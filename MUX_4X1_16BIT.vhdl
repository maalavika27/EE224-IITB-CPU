Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_4x1_16BIT is 
  port (D3,D2,D1,D0 : in std_logic_vector(15 downto 0);C_1,C_0: in std_logic; Y3,Y2,Y1,Y0 : out std_logic_vector(3 downto 0));
  end entity MUX_4x1_16BIT ;


architecture Struct of MUX_4x1_16BIT is

component MUX_4X1_4BIT is 
  port (D33,D32,D31,D30,D23,D22,D21,D20,D13,D12,D11,D10,D03,D02,D01,D00,C00,C11: in std_logic;Y3,Y2, Y1 ,Y0 : out std_logic);
  end component MUX_4X1_4BIT ;


  --signal y_1,y_0 : std_logic;
  
  begin 
   M1 : MUX_4X1_4BIT port map (D33=>D3(15),D32=>D3(14),D31=>D3(13),D30=>D3(12),D23=>D3(11),D22=>D3(10),D21=>D3(9),D20=>D3(8),D13=>D3(7),D12=>D3(6),D11=>D3(5),D10=>D3(4),D03=>D3(3),D02=>D3(2),D01=>D3(1),D00=>D3(0),C00=>C_0,C11=>C_1,Y3=>Y3(3),Y2=>Y3(2),Y1=>Y3(1),Y0=>Y3(0));
	M2 : MUX_4X1_4BIT port map (D33=>D2(15),D32=>D2(14),D31=>D2(13),D30=>D2(12),D23=>D2(11),D22=>D2(10),D21=>D2(9),D20=>D2(8),D13=>D2(7),D12=>D2(6),D11=>D2(5),D10=>D2(4),D03=>D2(3),D02=>D2(2),D01=>D2(1),D00=>D2(0),C00=>C_0,C11=>C_1,Y3=>Y2(3),Y2=>Y2(2),Y1=>Y2(1),Y0=>Y2(0));
	M3 : MUX_4X1_4BIT port map (D33=>D1(15),D32=>D1(14),D31=>D1(13),D30=>D1(12),D23=>D1(11),D22=>D1(10),D21=>D1(9),D20=>D1(8),D13=>D1(7),D12=>D1(6),D11=>D1(5),D10=>D1(4),D03=>D1(3),D02=>D1(2),D01=>D1(1),D00=>D1(0),C00=>C_0,C11=>C_1,Y3=>Y1(3),Y2=>Y1(2),Y1=>Y1(1),Y0=>Y1(0));
	M4 : MUX_4X1_4BIT port map (D33=>D0(15),D32=>D0(14),D31=>D0(13),D30=>D0(12),D23=>D0(11),D22=>D0(10),D21=>D0(9),D20=>D0(8),D13=>D0(7),D12=>D0(6),D11=>D0(5),D10=>D0(4),D03=>D0(3),D02=>D0(2),D01=>D0(1),D00=>D0(0),C00=>C_0,C11=>C_1,Y3=>Y0(3),Y2=>Y0(2),Y1=>Y0(1),Y0=>Y0(0));
	

   
 
  
end Struct;