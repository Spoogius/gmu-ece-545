library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity galois_matrix_multiply_row_col is
  Generic(
    N : integer := PKG_N
  );
  Port(
    left_row  : in n_mat_1d;
    right_col : in n_mat_1d;
    result    : out std_logic_vector( 3 downto 0 )
  );
end galois_matrix_multiply_row_col;

architecture Behavioral of galois_matrix_multiply_row_col is

type SUM_RESULT_TYPE is array( N-1 downto 0 ) of std_logic_vector( 3 downto 0 );

signal product_result : n_mat_1d := ( others => ( others => '0' ) );
signal sum_result : SUM_RESULT_TYPE := ( others => ( others => '0' ) );

begin

-- For Generate here computes the xor of all the values
-- in product_result. Equlviant to galois array sum.
result <= sum_result( N-1 );
sum_result(0) <= product_result(0);
galois_sum_result_FOR_GEN: for sum_idx in 1 to N-1 generate
  sum_result(sum_idx) <= sum_result(sum_idx-1) xor product_result(sum_idx);
end generate galois_sum_result_FOR_GEN;

-- Crates N galois multipliers to compute the the element wise product of the
-- input row and column in parallel
galois_product_result_FOR_GEN: for prod_idx in 0 to N-1 generate
  inst_galois_multiply: entity work.galois_multiply
    port map(
      in_0 => left_row( prod_idx ),
      in_1 => right_col( prod_idx ),
      out_0 => product_result( prod_idx )
    );
end generate galois_product_result_FOR_GEN;

end Behavioral;
