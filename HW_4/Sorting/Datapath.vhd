library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Datapath is
generic(
	w:integer := 8;
	k:integer := 4
);
  port (
  	clk: in std_logic;
  	DataIn: in std_logic_vector(w-1 downto 0);
  	Radd : in std_logic_vector(k-1 downto 0);
  	WrInit: in std_logic;
  	s:in std_logic;
  	Rd: in std_logic;
  	DataOut: out std_logic_vector(w-1 downto 0);
  	MiltMj: out std_logic;
  	zi: out std_logic;  
  	zj: out std_logic;    
  	Wr : in std_logic;
  	Li : in std_logic;
  	Ei : in std_logic;
  	Lj : in std_logic;
  	Ej : in std_logic
  );
end Datapath;

architecture mixed of Datapath is

constant N : integer := 2**k;

signal i: unsigned(k-1 downto 0);
signal j: unsigned(k-1 downto 0);
signal Addr: std_logic_vector(k-1 downto 0);
signal DINA_in : std_logic_vector(w-1 downto 0);
signal Mi : std_logic_vector(w-1 downto 0);
signal Mj : std_logic_vector(w-1 downto 0);
signal WEA_in : std_logic;

begin

DINA_in <= Datain when s = '0' else Mj;
WEA_in <= Wrinit when s = '0' else Wr;
Addr <= RAdd when s = '0' else std_logic_vector(i);

DPRAM: entity work.RAM 
generic map(w=>w, 
   k=>k)
port map(
  DINA => DINA_in,
  DINB => Mi,
  DOUTA => Mi,
  DOUTB => Mj,
  ADDRA => Addr,
  ADDRB => std_logic_vector(j),
  WEA => WEA_in,
  WEB => Wr,
  clk => clk
);

counterI: process(clk)
begin
if rising_edge(clk) then
    if Li = '1' then
        i <= (others => '0');
    elsif Ei = '1' then
        i <= i + 1;
    end if;          
end if;
end process;

counterJ: process(clk)
begin
if rising_edge(clk) then
    if Lj = '1' then
        j <= i + 1;
    elsif Ej = '1' then
        j <= j + 1;
    end if;          
end if;
end process;

zi <= '1' when i = to_unsigned(N-2, k) else '0';
zj <= '1' when j = to_unsigned(N-1, k) else '0';

MiltMj <= '1' when unsigned(Mi) < unsigned(Mj) else '0';

DataOut <= Mi when Rd = '1' else (others => '0');

end mixed;


