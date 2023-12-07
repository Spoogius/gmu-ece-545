library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity galois_matrix_multiply_STPS is
  Generic(
    N : integer := PKG_N
  );
  Port(
    ST : in n_mat_1d;
    P  : in nxn_mat_2d;
    S  : in n_mat_1d;
    result : out std_logic_vector(3 downto 0)
  );
end galois_matrix_multiply_STPS;

architecture Behavioral of galois_matrix_multiply_STPS is


signal p_col_major : nxn_mat_2d := ( others => ( others => ( others => '0' ) ) );
signal u_arr : n_mat_1d := ( others => ( others => '0' ) );

begin

-- Effectively does a transpose operation. Allows to take a column slice of 
-- P as p_col_major(i) where as there is no way to column slice P.
-- Since this is implemented as just rearanging wires this is a very cheap operation.
p_row_idx_FOR_GEN: for p_row_idx in 0 to N-1 generate
  p_col_idx_FOR_GEN: for p_col_idx in 0 to N-1 generate
    p_col_major(p_row_idx)(p_col_idx) <= P(p_col_idx)(p_row_idx);
  end generate p_col_idx_FOR_GEN;
end generate p_row_idx_FOR_GEN;

-- Compute ST * P store in u
p_slice_idx_FOR_GEN: for p_slice_idx in 0 to N-1 generate
  inst_galois_matrix_multiply_row_col_ST_P: entity work.galois_matrix_multiply_row_col
    port map(
      left_row => ST,
      right_col => p_col_major( p_slice_idx ),
      result => u_arr( p_slice_idx )
    );
end generate p_slice_idx_FOR_GEN;

-- Compute u * S result is scalar output
inst_galois_matrix_multiply_row_col_u_S: entity work.galois_matrix_multiply_row_col
    port map(
      left_row => u_arr,
      right_col => S,
      result => result
    );



end Behavioral;
