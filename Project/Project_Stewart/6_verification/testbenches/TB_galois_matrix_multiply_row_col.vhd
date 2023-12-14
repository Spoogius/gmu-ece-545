library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_galois_matrix_multiply_row_col is
--  Port ( );
end TB_galois_matrix_multiply_row_col;

architecture Behavioral of TB_galois_matrix_multiply_row_col is

--signal left_row : n_mat_1d  := ( x"B", x"7", x"4", x"B", x"7", x"E", x"A", x"6", x"6", x"3", x"9", x"B", x"A", x"F", x"C", x"4", x"A", x"B", x"D", x"8", x"D", x"B", x"2", x"F", x"1", x"3", x"A", x"4", x"B", x"9", x"C", x"5", x"4", x"F", x"3", x"4", x"9", x"B", x"5", x"8", x"4", x"9", x"6", x"8", x"7", x"F", x"F", x"D", x"2", x"D", x"5", x"8", x"2", x"7", x"5", x"A", x"6", x"A", x"D", x"D", x"9", x"A", x"5", x"2", x"1", x"A" );
--signal right_col : n_mat_1d := ( x"8", x"1", x"9", x"6", x"1", x"A", x"9", x"7", x"D", x"3", x"C", x"8", x"7", x"B", x"F", x"F", x"F", x"8", x"A", x"D", x"4", x"B", x"8", x"4", x"7", x"A", x"A", x"A", x"E", x"A", x"1", x"7", x"8", x"5", x"5", x"9", x"9", x"6", x"9", x"2", x"5", x"8", x"9", x"7", x"8", x"6", x"3", x"E", x"6", x"9", x"9", x"A", x"A", x"B", x"B", x"7", x"3", x"1", x"7", x"D", x"E", x"D", x"9", x"B", x"B", x"D" );
--signal result, result_expected : std_logic_vector( 3 downto 0 ) := x"4";

signal left_row : n_mat_1d  := (x"8", x"3", x"4", x"E", x"9", x"D", x"8", x"D", x"4", x"2", x"A", x"2", x"5", x"2", x"5", x"E", x"8", x"4", x"6", x"8", x"C", x"4", x"A", x"F", x"1", x"7", x"8", x"E", x"3", x"3", x"E", x"C", x"3", x"F", x"1", x"6", x"B", x"1", x"E", x"E", x"7", x"4", x"A", x"E", x"A", x"1", x"F", x"5", x"4", x"6", x"4", x"4", x"6", x"3", x"C", x"9", x"5", x"E", x"E", x"7", x"2", x"A", x"D", x"E", x"A", x"7" );
signal right_col : n_mat_1d := (x"1", x"F", x"8", x"6", x"9", x"E", x"7", x"B", x"E", x"2", x"4", x"8", x"C", x"7", x"3", x"E", x"1", x"6", x"D", x"C", x"A", x"8", x"2", x"4", x"7", x"8", x"9", x"8", x"7", x"8", x"3", x"4", x"3", x"B", x"9", x"2", x"6", x"E", x"2", x"E", x"B", x"3", x"E", x"2", x"B", x"B", x"B", x"F", x"1", x"A", x"8", x"5", x"3", x"F", x"F", x"E", x"C", x"6", x"A", x"B", x"1", x"9", x"9", x"F", x"2", x"A" );
signal result, result_expected : std_logic_vector( 3 downto 0 ) := x"C";
begin

dut: entity work.galois_matrix_multiply_row_col
  port map(
    left_row => left_row,
    right_col => right_col,
    result => result
  );


process
begin
  wait;
  
end process;
end Behavioral;
