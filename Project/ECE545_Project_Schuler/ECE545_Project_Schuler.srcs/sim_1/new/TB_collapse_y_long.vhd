library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_collapse_y_long is
--  Port ( );
end TB_collapse_y_long;

architecture Behavioral of TB_collapse_y_long is

signal clk, rst, rd_y, en : std_logic := '0';
signal y_long : m2_mat_1d := ( others => ( others => '0' ) );
signal y, y_expected : std_logic_vector( 3 downto 0 ) := ( others => '0' );

CONSTANT CLK_PERIOD : time := 20 ns;

begin

dut: entity work.collapse_y_long
  port map(
    clk => clk,
    rst => rst,
    en => en,
    rd_y => rd_y,
    y_long => y_long,
    y => y
  );

clk <= not clk after CLK_PERIOD/2;

process
  FILE y_long_golden_file : text open READ_MODE is "y_long_golden.ascii";
  FILE y_golden_file : text open READ_MODE is "y_golden.ascii";
  variable vector_line : line;
  variable vector_valid : boolean;
  
  variable file_y_long_data : std_logic_vector( 3 downto 0 );
  variable file_y_data : std_logic_vector( 3 downto 0 );
begin
  
  rst <= '1';
  
  -- Pre read data into y_long
  --while not endfile( y_long_golden_file ) loop
  for y_long_golden_idx in 0 to (2*PKG_M)-1 loop
    readline( y_long_golden_file, vector_line );
    hread( vector_line, file_y_long_data , good=>vector_valid );
    next when not vector_valid;
    
    y_long(y_long_golden_idx) <= file_y_long_data;
  end loop;
  
  wait for 2*CLK_PERIOD;
  
  rst <= '0';
  en <= '1';

  wait until rd_y = '1';
  
  --while not endfile( y_golden_file ) loop
  for y_golden_idx in 0 to (PKG_M)-1 loop
    readline( y_golden_file, vector_line );
    hread( vector_line, file_y_data , good=>vector_valid );
    next when not vector_valid;

    y_expected <= file_y_data;
    
    wait for CLK_PERIOD;
    
  end loop;
  
  wait until rd_y = '0';
  en <= '0';

  
  wait;
end process;

end Behavioral;
