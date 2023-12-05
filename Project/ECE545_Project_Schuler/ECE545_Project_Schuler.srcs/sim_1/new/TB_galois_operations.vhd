library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_galois_operations is
--  Port ( );
end TB_galois_operations;

architecture Behavioral of TB_galois_operations is

signal in_0, in_1, out_add, out_mul, out_add_expected, out_mul_expected : std_logic_vector( 3 downto 0 );
signal clk : std_logic := '0';

CONSTANT CLK_PERIOD : time := 20 ns;

begin

clk <= not clk after CLK_PERIOD/2;

dut_add: entity work.galois_add
  port map(
    in_0 => in_0,
    in_1 => in_1,
    out_0 => out_add
  );
  
dut_mul: entity work.galois_multiply
  port map(
    in_0 => in_0,
    in_1 => in_1,
    out_0 => out_mul
  );

process
  FILE galois_file: text open READ_MODE is "galois_operations.ascii";
  variable vector_line : line;
  variable space : character;
  variable vector_valid : boolean;
  
  variable file_in_0 : std_logic_vector( 3 downto 0 );
  variable file_in_1 : std_logic_vector( 3 downto 0 );
  variable file_out_add : std_logic_vector( 3 downto 0 );
  variable file_out_mul : std_logic_vector( 3 downto 0 );
  
  variable total_values : integer := 0;
  variable correct_values_add : integer := 0;
  variable correct_values_mul : integer := 0;
begin

  while not endfile(galois_file ) loop
    readline( galois_file, vector_line );
    
    hread( vector_line, file_in_0, good=>vector_valid );
    read( vector_line, space, good=>vector_valid );
    
    hread( vector_line, file_in_1, good=>vector_valid );
    read( vector_line, space, good=>vector_valid );
    
    hread( vector_line, file_out_add, good=>vector_valid );
    read( vector_line, space, good=>vector_valid );
    
    hread( vector_line, file_out_mul, good=>vector_valid );

    in_0 <= file_in_0;
    in_1 <= file_in_1;
    out_add_expected <= file_out_add;
    out_mul_expected <= file_out_mul;
    
    wait for CLK_PERIOD;
    total_values := total_values + 1;
    
    if out_add /= file_out_add then
      report "[Warning Add] in_0: " & to_hstring(in_0) & " in_1: " & to_hstring(in_1) & " Expected: " & to_hstring(file_out_add) & " Read: " & to_hstring(out_add)
              severity warning;
    else
       correct_values_add := correct_values_add + 1;       
    end if;
    
     if out_mul /= file_out_mul then
      report "[Warning Add] in_0: " & to_hstring(in_0) & " in_1: " & to_hstring(in_1) & " Expected: " & to_hstring(file_out_add) & " Read: " & to_hstring(out_add)
              severity warning;
    else
       correct_values_mul := correct_values_mul + 1;     
    end if;

  end loop;

  if correct_values_add = total_values then
    report
      "All " & integer'image(total_values) & " added values match the expected values in galois_operations.ascii"
        severity note;
  else
    report
      "[Error] " & integer'image(correct_values_add) & " out of " & integer'image(total_values) & " added values match the expected values in galois_operations.ascii"
        severity error;
  end if;
  
  if correct_values_mul = total_values then
    report
      "All " & integer'image(total_values) & " multiplied values match the expected values in galois_operations.ascii"
        severity note;
  else
    report
      "[Error] " & integer'image(correct_values_mul) & " out of " & integer'image(total_values) & " multiplied values match the expected values in galois_operations.ascii"
        severity error;
  end if;
  wait;

end process;

end Behavioral;
