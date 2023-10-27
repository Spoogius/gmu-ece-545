library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

library std;
use std.textio.all;

entity Sorting_TB is
end Sorting_TB;

architecture Behavioral of Sorting_TB is

-- W = Data Width
-- N = Array Size
-- K >= log2(N)



-- Case i
CONSTANT N : integer := 16; CONSTANT W : integer := 8; CONSTANT K : integer := 4;
FILE InputFile  : TEXT OPEN READ_MODE is "case_i_input.ascii";
FILE OutputFile : TEXT OPEN READ_MODE is "case_i_output.ascii";

-- Case ii
--CONSTANT N : integer := 16; CONSTANT W : integer := 16; CONSTANT K : integer := 4;
--FILE InputFile  : TEXT OPEN READ_MODE is "case_ii/input.ascii";
--FILE OutputFile : TEXT OPEN READ_MODE is "case_ii/output.ascii";

-- Case iii
--CONSTANT N : integer := 32; CONSTANT W : integer := 16; CONSTANT K : integer := 5;
--FILE InputFile  : TEXT OPEN READ_MODE is "case_iii/input.ascii";
--FILE OutputFile : TEXT OPEN READ_MODE is "case_iii/output.ascii";

-- Sim Constants
CONSTANT ClkPeriod : time := 10ns;

-- TB Signals
signal clk     : std_logic := '0';
signal reset   : std_logic := '0';
signal DataIn  : std_logic_vector( W-1 downto 0 ) := (others => '0');
signal Radd    : std_logic_vector( K-1 downto 0 ) := (others => '0'); 
signal WrInit  : std_logic := '0';
signal s       : std_logic := '0';
signal Rd      : std_logic := '0';
signal DataOut : std_logic_vector( W-1 downto 0 ) := (others => '0' );
signal Done    : std_logic := '0';

signal DataOut_expected : std_logic_vector( W-1 downto 0 ) := ( others => '0' );

begin
  	
DUT: entity work.Sorting(structural)
  generic map(
    w => W,
    k => K
  )
  port map(
    -- Inputs
    clk => clk,
    reset => reset,
    DataIn => DataIn,
    Radd => Radd,
    WrInit => WrInit,
    s => s,
    Rd => Rd,
    -- Outputs
    DataOut => DataOut,
    Done => Done
  ); 
 
 
-- Define Clock
clk <= not clk after ClkPeriod/2;

process
-- Files IO Variables
variable VectorLine : line;
variable VectorValid : boolean;
variable space : character;

variable file_data : std_logic_vector( W-1 downto 0 ) := (others => '0'); 
variable file_addr : std_logic_vector( K-1 downto 0 ) := (others => '0'); 

variable addr_int : integer := 0;

variable ReportStatement : line;
--variable msg_str_time : string := "Time: ";
--variable msg_str_actual : string := "ns, Actual Output: 0x";
--variable msg_str_expected : string := "Expected Output: 0x";

begin

  reset <= '1';
  wait for 2*ClkPeriod;
 
  reset <= '0';
  wait for ClkPeriod;
  

  while not endfile (InputFile) loop
    
    readline(InputFile, VectorLine);
    
    hread(VectorLine, file_addr, good=>VectorValid );
    NEXT WHEN NOT VectorValid;
    read(VectorLine, space );
    hread(VectorLine, file_data);
    
    wait until falling_edge(clk);
    WrInit <= '1';
    Radd <= file_addr;
    DataIn <= file_data;
    
  end loop;
  
  wait for ClkPeriod;
  Radd <= ( others => '0' );
  
  WrInit <= '0';
  wait for 2*ClkPeriod;
  s <= '1';
  
  wait until (done = '1');
  s <= '0';
  wait until (done = '0');

  Rd <= '1';
  while not endfile (OutputFile) loop
    addr_int := addr_int + 1;
    Radd <= std_logic_vector( to_unsigned( addr_int, K ) );
    
    readline(OutputFile, VectorLine);
    
    hread(VectorLine, file_addr, good=>VectorValid );
    NEXT WHEN NOT VectorValid;
    read(VectorLine, space );
    hread(VectorLine, file_data);
  
    wait for ClkPeriod/8;
    DataOut_expected <= file_data;
    wait for ClkPeriod/8;
    
    if ( DataOut_expected /= DataOut ) then
      write( ReportStatement, "Time: " & integer'image( now / 1 ns ) & "ns, Actual Output: 0x" );
      hwrite( ReportStatement, DataOut );
      write( ReportStatement, string'(" Expected Output: 0x"));
      hwrite( ReportStatement, DataOut_expected );
      writeline( output, ReportStatement );
    end if;
      
    wait for 3*(ClkPeriod/4);
  end loop;
  
  Rd <= '0';
  DataOut_expected <= ( others => '0' );
  
  wait;
  

end process;
  

end Behavioral;
