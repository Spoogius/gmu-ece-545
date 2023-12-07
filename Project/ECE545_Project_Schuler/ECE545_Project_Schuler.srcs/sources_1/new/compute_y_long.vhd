library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity compute_y_long is
  Generic(
    M : integer := PKG_M;
    N : integer := PKG_N;
    K : integer := PKG_K
  );
  Port(
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    done : out std_logic;
    S_idx_0 : out std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 );
    S_idx_1 : out std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 );
    S_data_0 : in n_mat_1d;
    S_data_1 : in n_mat_1d;
    P_data   : in nxn_mat_2d;
    y_long   : out m2_mat_1d
    
  );
end compute_y_long;

architecture Behavioral of compute_y_long is

signal u_arr, u_arr_0, u_arr_1, u_arr_iieqjj, u_arr_iineqjj : m_mat_1d := ( others => ( others => '0' ) );
signal ii, jj, l : integer := 0;
signal y_long_reg : m2_mat_1d := ( others => ( others => '0' ) );

begin

p_slice_idx_FOR_GEN: for p_slice_idx in 0 to M-1 generate
  -- Used for parallel computaiton of
  -- S_i'(ii) * P * S_i(jj)
  inst_galois_matrix_multiply_STPS_0: entity work.galois_matrix_multiply_STPS
    port map(
      ST => S_data_0,
      P => P_data,
      S => S_data_1,
      result => u_arr_0( p_slice_idx )
    );
    
    -- S_i'(jj) * P * S_i(ii)
    inst_galois_matrix_multiply_STPS_1: entity work.galois_matrix_multiply_STPS
    port map(
      ST => S_data_1,
      P => P_data,
      S => S_data_0,
      result => u_arr_1( p_slice_idx )
    );
end generate p_slice_idx_FOR_GEN;

-- Implementation of array element wise xor (galois add) for u_arr_0 and u_arr_1
u_arr_iineqjj_idx_FOR_GEN: for u_arr_iineqjj_idx_FOR_GEN in 0 to M-1 generate
  u_arr_iineqjj( u_arr_iineqjj_idx_FOR_GEN ) <= u_arr_0( u_arr_iineqjj_idx_FOR_GEN ) xor u_arr_1( u_arr_iineqjj_idx_FOR_GEN );
end generate u_arr_iineqjj_idx_FOR_GEN;
-- If ii == jj expected value of u is just u_arr_0
u_arr_iieqjj <= u_arr_0;

-- Assign u_arr depending on if ii==jj
-- u_arr is used to compute y_long
u_arr <= u_arr_iieqjj when ii = jj
    else u_arr_iineqjj;

-- output y_long
y_long <= y_long_reg;

process( clk, rst ) 
begin
  if( rst = '1' ) then
    done <= '0';
    y_long <= ( others => ( others => '0' ) );
    S_idx_0 <= ( others => '0' );
    S_idx_1 <= ( others => '0' );
    u_arr <= ( others => ( others => '0' ) );
    ii <= 0;
    jj <= K-1;
    l <= 0;
    
  elsif( rising_edge(clk) ) then
    done <= '0';
    if en = '1' then
      if ii < K-1 then
        if jj >= ii then
          
          for y_long_idx in 0 to M-1 loop
            y_long_reg( y_long_idx + l ) <= y_long_reg( y_long_idx + l  ) xor u_arr( y_long_idx );
          end loop;
          
          -- l increments every itteration
          l <= l + 1;
          
          -- Adjust loop counters as needed
          if jj = ii  then
            jj <= K-1;
            ii <= ii+1;
          else
            jj <= jj-1;
          end if;
          
        end if;
      else
        ii <= 0;
        jj <= K-1;
        l  <= 0;
        done <= '1';
      end if;
    end if;
  end if;
end process;

end Behavioral;
