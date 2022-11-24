library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;

library work;
use work.Gates.all;

entity main is
	port(clock, reset: in std_logic);
end main;

architecture bhv of main is
	component alu is
		port (
		clock: in std_logic;
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		sel: in std_logic_vector(1 downto 0);
		X: out std_logic_vector(15 downto 0);
		C: out std_logic;
		Z: out std_logic);
	end component;
	
	component se7 is
		port (A: in std_logic_vector(8 downto 0);
				outp: out std_logic_vector(15 downto 0));
	end component;
	
	component se10 is
		port (A: in std_logic_vector(8 downto 0);
				outp: out std_logic_vector(15 downto 0));
	end component;
	
	component temporary_register is
		port (clock, reset: in std_logic; 
        temp_write : in std_logic_vector(15 downto 0);
        temp_read : out std_logic_vector(15 downto 0);
        temp_W : in std_logic);
	end component;
	
	component register_file is 
-- PC is R7 so incorporating it in register file itself
		port(
			clock, reset, PC_w, RF_W : in std_logic;
			A1, A2, A3 : in std_logic_vector(2 downto 0);
			D3, PC_write : in std_logic_vector(15 downto 0);
			D1, D2, PC_read : out std_logic_vector(15 downto 0));
	end component;
	
	component memory is 
		port(
			 M_add, M_inp : in std_logic_vector(15 downto 0);
			 M_data : out std_logic_vector(15 downto 0);
			 clock, Mem_R, Mem_W : in std_logic);
	end component;
	
	component MUX_2_1  is
		port (S, A, B: in std_logic; Y: out std_logic);
	end component;
	
	component MUX_4_1  is
	  port (C1, C0, D3, D2, D1, D0: in std_logic; Y: out std_logic);
	end component;
	
	component MUX_1X2_4BIT is 
	  port (A3,A2,A1,A0,B3,B2,B1,B0,Sig_4BIT: in std_logic;Y3,Y2, Y1 ,Y0 : out std_logic);
	end component;
	
	component MUX_4X1_4BIT is 
	  port (D33,D32,D31,D30,D23,D22,D21,D20,D13,D12,D11,D10,D03,D02,D01,D00,C00,C11: in std_logic;Y3,Y2, Y1 ,Y0 : out std_logic);
	end component;
	
	component MUX_1X2_16BIT is 
		port (A3,A2,A1,A0,B3,B2,B1,B0: in std_logic_vector(3 downto 0) ;Sig_16BIT: in std_logic;Y3,Y2, Y1 ,Y0 : out std_logic_vector(3 downto 0));
	end component;
	
	component MUX_4x1_16BIT is 
		port (D3,D2,D1,D0 : in std_logic_vector(15 downto 0);C_1,C_0: in std_logic; Y3,Y2,Y1,Y0 : out std_logic_vector(3 downto 0));
	end component;
	
	component DEMUX_1X2_16BIT is 
		port (A3,A2,A1,A0 : in std_logic_vector(3 downto 0) ;S_16BIT : in std_logic;
				Y7,Y6,Y5,Y4,Y3,Y2, Y1 ,Y0 : out std_logic_vector(3 downto 0));
	end component;
	
	component MUX_8X1_16BIT is 
	  port (A3,A2,A1,A0 :in std_logic_vector(31 downto 0);
			 S_2,S_1,S_0: in std_logic;Y3,Y2,Y1,Y0 : out std_logic_vector(3 downto 0));
	 end component;

	signal m1_op,pc_op,t4_op,m2_op,m3_op,m_data,dm_op1,dm_op2,se10_op,se7_op,m5_op,rf_d1,rf_d2,m6_op,m7_op,t2_op,t3_op,m8_op,m9_op,
			 alu_x,alu_c,alu_z: std_logic_vector(15 downto 0);
	signal t1_11_9,t1_5_3,t1_8_6,y: std_logic_vector(2 downto 0);
	signal t1_8_0: std_logic_vector(8 downto 0);
	signal t1_5_0: std_logic_vector(5 downto 0);
	signal a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,q,r,s,pc_w,t1_w,t2_w,t3_w,t4_w,mem_w,mem_r,rf_w: std_logic;
	signal sel: std_logic_vector(1 downto 0);
	
begin
	
end bhv;
	