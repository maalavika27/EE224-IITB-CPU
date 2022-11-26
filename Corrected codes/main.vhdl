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
--Including the components
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
		port (A,B: in std_logic_vector(15 downto 0) ;Sig_16BIT: in std_logic;Y: out std_logic_vector(15 downto 0));
	end component;
	
	component MUX_4x1_16BIT is 
		port (D3,D2,D1,D0 : in std_logic_vector(15 downto 0);C_1,C_0: in std_logic; Y : out std_logic_vector(15 downto 0));
	end component;
	
	component DEMUX_1X2_16BIT is 
		port (A : in std_logic_vector(15 downto 0) ;S_16BIT : in std_logic;
				Y1,Y0 : out std_logic_vector(15 downto 0));
	end component;
	
	component MUX_8X1_16BIT is 
	  port (A7,A6,A5,A4,A3,A2,A1,A0 :in std_logic_vector( 15 downto 0);
       S_2,S_1,S_0: in std_logic;Y : out std_logic_vector(15 downto 0));
	 end component;
	 
	 component MUX_4x1_3BIT is 
			port(A,B,C,D: in std_logic_vector(2 downto 0);S1,S0: in std_logic; Y: out std_logic_vector(2 downto 0));
	end component;
	
	component lmsm is
		port( imm:in std_logic_vector(8 downto 0);
		q:in std_logic;
		clock:in std_logic;
		r_add: out std_logic_vector(2 downto 0));
	end component;

--Signals used
	type state is (s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15);
	signal state_present,state_next: state:=s1;
	signal m1_op,pc_op,t4_op,m2_op,m3_op,m_data,dm_op1,dm_op2,se10_op,se7_op,m5_op,rf_d1,rf_d2,m6_op,m7_op,t1_op,t2_op,t3_op,m8_op,m9_op,
			 alu_x,alu_c,alu_z: std_logic_vector(15 downto 0);
	signal t1_11_9,t1_5_3,t1_8_6,lmsm_op,y: std_logic_vector(2 downto 0);
	signal t1_8_0: std_logic_vector(8 downto 0);
	signal t1_5_0: std_logic_vector(5 downto 0);
	signal a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,q,r,s,pc_w,t1_w,t2_w,t3_w,t4_w,mem_w,mem_r,rf_w,carry_next,zero_next,carry_present,zero_present: std_logic:='0';
	signal sel: std_logic_vector(1 downto 0);
	
begin
-- Instantiation the components
	rf: register_file port map(clock,reset,pc_w,rf_w,
										y,t1_8_6,y,
										m5_op,m1_op,
										rf_d1,rf_d2,pc_op);
	memory_main: memory port map(m2_op,m3_op,
										  m_data,
										  clock,mem_r,mem_w);
	t1: temporary_register port map(clock,reset,
										     dm_op2,t1_op,
											  t1_w);
	t2: temporary_register port map(clock,reset,
										     m6_op,t2_op,
											  t2_w);
	t3: temporary_register port map(clock,reset,
										     m7_op,t3_op,
											  t3_w);
	t4: temporary_register port map(clock,reset,
										     pc_op,t4_op,
											  t4_w);
	alu_main: alu port map(clock,
								  m8_op,m9_op,
								  sel,
								  alu_x,alu_c,alu_z);
	se7_main: se7 port map(t1_8_0,
								  se7_op);
	se10_main: se10 port map(t1_5_0,
								  se10_op);
	lmsm_main: lmsm port map(t1_8_0,
									 q,clock,
									 lmsm_op);
	m1: MUX_1X2_16BIT port map(t3_op,alu_x,a,m1_op);
	m2: MUX_4x1_16BIT port map("0000000000000000",pc_op,t3_op,t2_op,b,c,m2_op);
	m3: MUX_1X2_16BIT port map(t2_op,t3_op,s,m3_op);
	m4: MUX_4x1_3BIT port map (t1_11_9,t1_5_3,t1_8_6,lmsm_op,e,f,y);
	m5: MUX_4x1_16BIT port map("0000000000000000",t2_op,t3_op,t4_op,j,k,m5_op);
	m6: MUX_1X2_16BIT port map(rf_d1,alu_x,g,m6_op);
	m7: MUX_4x1_16BIT port map(alu_x,rf_d2,rf_d1,dm_op1,h,i,m7_op);
	m8: MUX_8X1_16BIT port map("0000000000000000","0000000000000000","0000000000000000",t3_op,t4_op,pc_op,t2_op,se7_op,r,l,m,m8_op);
	m9: MUX_4x1_16BIT port map("0000000000000000",se10_op,t3_op,"0000000000000010",n,p,m9_op);
	demux: DEMUX_1X2_16BIT port map(m_data,d,dm_op2,dm_op1);
	
--Breaking the t1_op signal into the required parts
	t1_11_9<=t1_op(11 downto 9);
	t1_8_6<=t1_op(8 downto 6);
	t1_5_3<=t1_op(5 downto 3);
	t1_8_0<=t1_op(8 downto 0);
	t1_5_0<=t1_op(5 downto 0);
	
--Clock process
clk_process: process(clock,reset)
	begin
	if (reset = '1') then
		state_present <= s1;
	elsif (clock='1' and clock' event) then
		state_present <= state_next;
		carry_present <= carry_next;
		zero_present <= zero_next
	else
		null;
	end if;
end process;
--State Transition process
state_transition: process(state_present,t1_op)
	begin
	case state_present is
	when s1=>
		a<='1';
		b<='1';
		c<='0';
		d<='1';
		e<='0';
		f<='0';
		g<='0';
		h<='0';
		i<='0';
		j<='0';
		k<='0';
		l<='1';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='1';
		s<='0';
		mem_r<='1';
		mem_w<='0';
		pc_w<='1';
		t1_w<='1';
		t2_w<='0';
		t3_w<='0';
		t4_w<='0';
		sel<="00";
		rf_w<='0';
		state_next<=s2;
	when s2=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='1';
		i<='0';
		j<='0';
		k<='0';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='1';
		t3_w<='1';
		t4_w<='0';
		sel<="11";
		rf_w<='0';
		if (t1_op(15 downto 12) = "0000") then
			state_next<=s3;
		elsif (t1_op(15 downto 12) = "0001") then
			state_next<=s6;
		elsif (t1_op(15 downto 12) = "0010") then
			state_next<=s5;
		elsif (t1_op(15 downto 12) = "0011") then
			state_next<=s7;
		elsif (t1_op(15 downto 13) = "010") then
			state_next<=s8;
		elsif (t1_op(15 downto 12) = "0110") then
			state_next<=s11;
		elsif (t1_op(15 downto 12) = "0111") then
			state_next<=s12;
		elsif (t1_op(15 downto 12) = "1100") then
			state_next<=s13;
		elsif (t1_op(15 downto 13) = "100") then
			state_next<=s14;
		else
			null;
		end if;
	when s3=>
		if (t1_op (1 downto 0) = "00") then
			pc_w<='0';
			t1_w<='0';
			t2_w<='1';
			t3_w<='0';
			t4_w<='0';
			mem_w<='0';
			mem_r<='0';
			rf_w<='0';
			a<='0';
			b<='0';
			c<='0';
			d<='0';
			e<='0';
			f<='0';
			g<='1';
			h<='0';
			i<='0';
			j<='0';
			k<='0';
			l<='0';
			m<='1';
			n<='0';
			p<='1';
			q<='0';
			r<='0';
			s<='0';
			sel<="00";
			carry_next<=alu_c;
			zero_next<=alu_x;
		elsif (t1_op (1 downto 0) = "10") then
			if (carry_present = '1') then --INSERT CARRY 
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='0';
				g<='1';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='1';
				n<='0';
				p<='1';
				q<='0';
				r<='0';
				s<='0';
				sel<="00";
				carry_next<=alu_c;
				zero_next<=alu_x;
			else 
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='1';
				g<='0';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='0';
				n<='0';
				p<='0';
				q<='0';
				r<='0';
				s<='0';
				sel<="11"; 
			end if;
		elsif (t1_op (1 downto 0) = "01") then
			if (zero_present = '1') then --INSERT ZERO
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='0';
				g<='1';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='1';
				n<='0';
				p<='1';
				q<='0';
				r<='0';
				s<='0';
				sel<="00";
				carry_next<=alu_c;
				zero_next<=alu_x;
			else 
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='1';
				g<='0';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='0';
				n<='0';
				p<='0';
				q<='0';
				r<='0';
				s<='0';
				sel<="11";
			end if;
		else null;
		end if;
		state_next<=s4;
	when s4=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='0';
		i<='0';
		j<='1';
		k<='0';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='0';
		t3_w<='0';
		t4_w<='0';
		sel<="11";
		rf_w<='1';
		state_next<=s1;
	when s5=>
		if (t1_op (1 downto 0) = "00") then
			pc_w<='0';
			t1_w<='0';
			t2_w<='1';
			t3_w<='0';
			t4_w<='0';
			mem_w<='0';
			mem_r<='0';
			rf_w<='0';
			a<='0';
			b<='0';
			c<='0';
			d<='0';
			e<='0';
			f<='0';
			g<='1';
			h<='0';
			i<='0';
			j<='0';
			k<='0';
			l<='0';
			m<='1';
			n<='0';
			p<='1';
			q<='0';
			r<='0';
			s<='0';
			sel<="01";
			zero_next<=alu_z;
		elsif (t1_op (1 downto 0) = "10") then
			if (carry_present = '1') then --INSERT CARRY 
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='0';
				g<='1';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='1';
				n<='0';
				p<='1';
				q<='0';
				r<='0';
				s<='0';
				sel<="01";
				zero_next<=alu_z;
			else 
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='1';
				g<='0';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='0';
				n<='0';
				p<='0';
				q<='0';
				r<='0';
				s<='0';
				sel<="11"; 
			end if;
		elsif (t1_op (1 downto 0) = "01") then
			if (zero_present = '1') then --INSERT ZERO
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='0';
				g<='1';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='1';
				n<='0';
				p<='1';
				q<='0';
				r<='0';
				s<='0';
				sel<="01";
				zero_next<=alu_z;
			else 
				pc_w<='0';
				t1_w<='0';
				t2_w<='1';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='1';
				g<='0';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='0';
				n<='0';
				p<='0';
				q<='0';
				r<='0';
				s<='0';
				sel<="11";
			end if;
		else null;
		end if;
		state_next<=s4;
	when s6=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='1';
		h<='0';
		i<='0';
		j<='0';
		k<='0';
		l<='0';
		m<='1';
		n<='1';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='1';
		t3_w<='0';
		t4_w<='0';
		sel<="00";
		rf_w<='0';
		carry_next<=alu_c;
		zero_next<=alu_x;
		state_next<=s4;
	when s7=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='1';
		h<='0';
		i<='0';
		j<='0';
		k<='0';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='1';
		t3_w<='0';
		t4_w<='0';
		sel<="10";
		rf_w<='0';
		state_next<=s4;
	when s8=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='1';
		i<='1';
		j<='0';
		k<='0';
		l<='0';
		m<='0';
		n<='1';
		p<='0';
		q<='0';
		r<='1';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='0';
		t3_w<='1';
		t4_w<='0';
		sel<="00";
		rf_w<='0';
		if (t1_op(15 downto 12) = "0100") then
			state_next<=s9;
		elsif (t1_op(15 downto 12) = "0101") then
			state_next<=s10;
		else null;
		end if;
	when s9=>
		a<='0';
		b<='0';
		c<='1';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='0';
		i<='0';
		j<='0';
		k<='1';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='1';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='0';
		t3_w<='1';
		t4_w<='0';
		sel<="11";
		rf_w<='1';
		state_next<=s1;
	when s10=>
		a<='0';
		b<='0';
		c<='1';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='0';
		i<='0';
		j<='0';
		k<='0';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='1';
		pc_w<='0';
		t1_w<='0';
		t2_w<='0';
		t3_w<='0';
		t4_w<='0';
		sel<="11";
		rf_w<='0';
		state_next<=s1;
	when s11=>
		state_next<=s1;
	when s12=>
		state_next<=s1;
	when s13=>
		if (t1_op(14)='1') then
			if (t2_op=t3_op) then
				pc_w<='1';
				t1_w<='0';
				t2_w<='0';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='1';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='0';
				g<='0';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='1';
				m<='1';
				n<='1';
				p<='0';
				q<='0';
				r<='0';
				s<='0';
				sel<="00";
			else --nothing must be done
				pc_w<='0';
				t1_w<='0';
				t2_w<='0';
				t3_w<='0';
				t4_w<='0';
				mem_w<='0';
				mem_r<='0';
				rf_w<='0';
				a<='0';
				b<='0';
				c<='0';
				d<='0';
				e<='0';
				f<='0';
				g<='0';
				h<='0';
				i<='0';
				j<='0';
				k<='0';
				l<='0';
				m<='0';
				n<='0';
				p<='0';
				q<='0';
				r<='0';
				s<='0';
				sel<="11";
			end if;	
		else 
			pc_w<='1';
			t1_w<='0';
			t2_w<='0';
			t3_w<='0';
			t4_w<='0';
			mem_w<='0';
			mem_r<='0';
			rf_w<='0';
			a<='1';
			b<='0';
			c<='0';
			d<='0';
			e<='0';
			f<='0';
			g<='0';
			h<='0';
			i<='0';
			j<='0';
			k<='0';
			l<='1';
			m<='1';
			n<='1';
			p<='0';
			q<='0';
			r<='0';
			s<='0';
			sel<="00";
		end if;
		state_next<=s1;
	when s14=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='0';
		i<='0';
		j<='0';
		k<='0';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='0';
		t3_w<='0';
		t4_w<='0';
		sel<="11";
		rf_w<='1';
		if (t1_op(15 downto 12) = "1000") then
			state_next<=s13;
		elsif (t1_op(15 downto 12) = "1001") then
			state_next<=s15;
		else null;
		end if;
	when s15=>
		a<='0';
		b<='0';
		c<='0';
		d<='0';
		e<='0';
		f<='0';
		g<='0';
		h<='0';
		i<='0';
		j<='0';
		k<='0';
		l<='0';
		m<='0';
		n<='0';
		p<='0';
		q<='0';
		r<='0';
		s<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='1';
		t1_w<='0';
		t2_w<='0';
		t3_w<='0';
		t4_w<='0';
		sel<="11";
		rf_w<='0';
		state_next<=s1;
	when others=>
		null;
	end case;
end process;

end bhv;
	