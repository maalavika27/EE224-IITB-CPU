Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_8X1_16BIT is 
  port (A3,A2,A1,A0 :in std_logic_vector( 31 downto 0);
       S_2,S_1,S_0: in std_logic;Y3,Y2,Y1,Y0 : out std_logic_vector(3 downto 0));
  end entity MUX_8X1_16BIT ;


architecture Struct of MUX_8X1_16BIT is

component MUX_8X1_4BIT is 
  port (A37,A36,A35,A34,A33,A32,A31,A30,
        A27,A26,A25,A24,A23,A22,A21,A20,
		  A17,A16,A15,A14,A13,A12,A11,A10,
		  A07,A06,A05,A04,A03,A02,A01,A00,
       S2,S1,S0: in std_logic;Y_out3,Y_out2,Y_out1,Y_out0 : out std_logic);
  end component MUX_8X1_4BIT ;



  --signal y_31,y_30,y_21,y_20,y_11,y_10,y_01,y_00 : std_logic;
  
  begin 
   M1 : MUX_8X1_4BIT port map (A37=>A3(31),A36=>A3(30),A35=>A3(29),A34=>A3(28),A33=>A3(27),A32=>A3(26),A31=>A3(25),A30=>A3(24),
                               A27=>A3(23),A26=>A3(22),A25=>A3(21),A24=>A3(20),A23=>A3(19),A22=>A3(18),A21=>A3(17),A20=>A3(16),
		                         A17=>A3(15),A16=>A3(14),A15=>A3(13),A14=>A3(12),A13=>A3(11),A12=>A3(10),A11=>A3(9),A10=>A3(8),
		                         A07=>A3(7),A06=> A3(6),A05=> A3(5),A04=> A3(4),A03=> A3(3),A02=> A3(2),A01=> A3(1),A00=>A3(0),
                               S2=>S_2,S1=>S_1,S0=>S_0,
										 Y_out3=>Y3(3),Y_out2=>Y3(2),Y_out1=>Y3(1),Y_out0=>Y3(0));
										 
	M2 : MUX_8X1_4BIT port map(A37=>A2(31),A36=>A2(30),A35=>A2(29),A34=>A2(28),A33=>A2(27),A32=>A2(26),A31=>A2(25),A30=> A2(24),
                               A27=>A2(23),A26=>A2(22),A25=>A2(21),A24=>A2(20),A23=>A2(19),A22=>A2(18),A21=>A2(17),A20=>A2(16),
		                         A17=>A2(15),A16=>A2(14),A15=>A2(13),A14=>A2(12),A13=>A2(11),A12=>A2(10),A11=>A2(9),A10=> A2(8),
		                         A07=>A2(7),A06=> A2(6),A05=> A2(5),A04=> A2(4),A03=> A2(3),A02=> A2(2),A01=> A2(1),A00=> A2(0),
                               S2=>S_2,S1=>S_1,S0=>S_0,
										 Y_out3=>Y2(3),Y_out2=>Y2(2),Y_out1=>Y2(1),Y_out0=>Y2(0));
										 
	M3 : MUX_8X1_4BIT port map (A37=>A1(31),A36=>A1(30),A35=>A1(29),A34=>A1(28),A33=>A1(27),A32=>A1(26),A31=>A1(25),A30=>A1(24),
                               A27=>A1(23),A26=>A1(22),A25=>A1(21),A24=>A1(20),A23=>A1(19),A22=>A1(18),A21=>A1(17),A20=>A1(16),
		                         A17=>A1(15),A16=>A1(14),A15=>A1(13),A14=>A1(12),A13=>A1(11),A12=>A1(10),A11=>A1(9),A10=> A1(8),
		                         A07=> A1(7),A06=> A1(6),A05=>A1(5),A04=> A1(4),A03=> A1(3),A02=> A1(2),A01=> A1(1),A00=> A1(0),
                               S2=>S_2,S1=>S_1,S0=>S_0,
										 Y_out3=>Y1(3),Y_out2=>Y1(2),Y_out1=>Y1(1),Y_out0=>Y1(0));
										 
	M4 : MUX_8X1_4BIT port map (A37=>A0(31),A36=>A0(30),A35=>A0(29),A34=>A0(28),A33=>A0(27),A32=>A0(26),A31=>A0(25),A30=>A0(24),
                               A27=>A0(23),A26=>A0(22),A25=>A0(21),A24=>A0(20),A23=>A0(19),A22=>A0(18),A21=>A0(17),A20=>A0(16),
		                         A17=>A0(15),A16=>A0(14),A15=>A0(13),A14=>A0(12),A13=>A0(11),A12=>A0(10),A11=>A0(9),A10=> A0(8),
		                         A07=>A0(7),A06=> A0(6),A05=> A0(5),A04=> A0(4),A03=> A0(3),A02=> A0(2),A01=> A0(1),A00=> A0(0),
                               S2=>S_2,S1=>S_1,S0=>S_0,
										 Y_out3=>Y0(3),Y_out2=>Y0(2),Y_out1=>Y0(1),Y_out0=>Y0(0));									 
	

   
 
  
end Struct;