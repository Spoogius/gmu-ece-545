library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

library std;
use std.textio.all;

entity Sorting_TB is
end Sorting_TB;

architecture Behavioral of Sorting_TB is

-- WHEN RUNNING POST-SYNTHESIS or POST-IMPLEMENTATION SIMULATION
-- APPROPRIATE GENERIC VALUES FOR W AND K MUST BE SET UNDER
-- settings->general->Generics/Paramers 
-- AND THE GENERIC MAP () BLOCK DURING DUT INSTANTIATION MUST
-- BE COMMENTED OUT ON LINE 61-64.

-- Clock Period for behavior simulation
-- Comment out for Synth & Imp simulation
CONSTANT ClkPeriod : time := 10 ns; --4/3 * worst clock period

-- Case i
CONSTANT N : integer := 16; CONSTANT W : integer := 8; CONSTANT K : integer := 4;
FILE InputFile  : TEXT OPEN READ_MODE is "case_i_input.ascii";
FILE OutputFile : TEXT OPEN READ_MODE is "case_i_output.ascii";
--CONSTANT ClkPeriod : time := 28 ns; --4/3 * worst clock period - SYNTH
--CONSTANT ClkPeriod : time := 14 ns; --4/3 * worst clock period - IMP

-- Case ii
--CONSTANT N : integer := 16; CONSTANT W : integer := 16; CONSTANT K : integer := 4;
--FILE InputFile  : TEXT OPEN READ_MODE is "case_ii_input.ascii";
--FILE OutputFile : TEXT OPEN READ_MODE is "case_ii_output.ascii";
--CONSTANT ClkPeriod : time := 36 ns; --4/3 * worst clock period - SYNTH
--CONSTANT ClkPeriod : time := 20 ns; --4/3 * worst clock period - IMP

-- Case iii
--CONSTANT N : integer := 32; CONSTANT W : integer := 16; CONSTANT K : integer := 5;
--FILE InputFile  : TEXT OPEN READ_MODE is "case_iii_input.ascii";
--FILE OutputFile : TEXT OPEN READ_MODE is "case_iii_output.ascii";
--CONSTANT ClkPeriod : time := 36 ns; --4/3 * worst clock period - SYNTH
--CONSTANT ClkPeriod : time := 20 ns; --4/3 * worst clock period - IMP

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
  	
DUT: entity work.Sorting
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

begin

  -- Cycle Reset
  reset <= '1';
  wait for 2*ClkPeriod;
 
  reset <= '0';
  wait for ClkPeriod;
  while not endfile (InputFile) loop
    
    -- Read file line
    readline(InputFile, VectorLine);
    
    -- Parse and verify values
    hread(VectorLine, file_addr, good=>VectorValid );
    NEXT WHEN NOT VectorValid;
    read(VectorLine, space );
    hread(VectorLine, file_data);
    
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    
    -- Write Data into DUT
    Radd <= file_addr;
    DataIn <= file_data;
    WrInit <= '1';
    
  end loop;
  
  wait for ClkPeriod;
  
  WrInit <= '0';
  Radd <= ( others => '0' );
  s <= '1';
  
  -- Wait until finished
  wait until (done = '1');
  s <= '0';
  wait until (done = '0');
  wait for ClkPeriod;
  
  


  while not endfile (OutputFile) loop
    
    
    readline(OutputFile, VectorLine);
    
    hread(VectorLine, file_addr, good=>VectorValid );
    NEXT WHEN NOT VectorValid;
    read(VectorLine, space );
    hread(VectorLine, file_data);
  
    Radd <= std_logic_vector( file_addr );
    wait until rising_edge(clk);
    Rd <= '1';
    
    wait for ClkPeriod/8;
    DataOut_expected <= x"8" & file_data(11 downto 0 );
    
    wait for  5*(ClkPeriod/8);

    -- Compare read back data with expected output.
    -- Print ReportStatment if mismatched
    if ( DataOut_expected /= DataOut ) then
      write( ReportStatement, "Time: " & integer'image( now / 1 ns ) & "ns, Actual Output: 0x" );
      hwrite( ReportStatement, DataOut );
      write( ReportStatement, string'(" Expected Output: 0x"));
      hwrite( ReportStatement, DataOut_expected );
      writeline( output, ReportStatement );
    end if;
    wait for ClkPeriod/8;
  end loop;
  
  wait until rising_edge(clk);
  Rd <= '0';
  DataOut_expected <= ( others => '0' );
  
  wait;
  

end process;
  

end Behavioral;
