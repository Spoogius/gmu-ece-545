library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sorting is
  generic(
   	w:integer := 8;
	k:integer := 4
  );
  port(
  	clk: in std_logic;
  	reset: in std_logic;
  	DataIn: in std_logic_vector(w-1 downto 0);
  	Radd : in std_logic_vector(k-1 downto 0);
  	WrInit: in std_logic;
  	s: in std_logic;
  	Rd: in std_logic;
  	DataOut: out std_logic_vector(w-1 downto 0);
  	Done: out std_logic
 );
end Sorting;

architecture structural of Sorting is

-- status signals
signal MiltMj : std_logic;
signal zi : std_logic;
signal zj : std_logic;

--control signals
signal Wr : std_logic;
signal Li : std_logic;
signal Ei : std_logic;
signal Lj : std_logic;
signal Ej : std_logic;

begin

Sorting_datapath: entity work.Datapath(mixed)
generic map (
    w=>w, 
    k=>k
)
port map(
  	clk => clk,
  	DataIn => DataIn,
  	Radd => RAdd,
  	WrInit => WrInit,
  	s => s,
  	Rd => Rd,
  	DataOut => DataOut,
  	MiltMj => MiltMj,
  	zi => zi,
  	zj => zj,
  	Wr => Wr,
  	Li => Li,
  	Ei => Ei,
  	Lj => Lj,
  	Ej => Ej
);

Sorting_controller: entity work.Controller(behavioral)
port map(
  	clk => clk,
  	reset => reset,
  	s => s,
  	MiltMj => MiltMj,
  	zi => zi, 
  	zj => zj,    
  	Wr => Wr,
  	Li => Li,
  	Ei => Ei,
  	Lj => Lj,
  	Ej => Ej,
	Done => Done
);

end structural;
