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
    S_addr_0 : out std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 );
    S_data_0 : in n_mat_1d;
    S_addr_1 : out std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 );
    S_data_1 : in n_mat_1d;
    P_addr    : out std_logic_vector( natural(ceil(log2(real(M)))) - 1 downto 0 ); 
    P_data   : in nxn_mat_2d;
    y_long   : out m2_mat_1d
    
  );
end compute_y_long;

architecture Behavioral of compute_y_long is

signal u, u_0, u_1 : std_logic_vector( 3 downto 0 ) := ( others => '0' );
signal ii, jj, aa, l : integer := 0;
signal y_long_reg : m2_mat_1d := ( others => ( others => '0' ) );
--signal u_store : m_mat_1d := ( others => ( others => '0' ) );
begin

inst_galois_matrix_multiply_STPS_0: entity work.galois_matrix_multiply_STPS
  port map(
    ST => S_data_0,
    P => P_data,
    S => S_data_1,
    result => u_0
  );
  
  -- S_i'(jj) * P * S_i(ii)
  inst_galois_matrix_multiply_STPS_1: entity work.galois_matrix_multiply_STPS
  port map(
    ST => S_data_1,
    P => P_data,
    S => S_data_0,
    result => u_1
  );

-- If ii != jj expected value is u_0 xor u_1
-- If ii == jj expected value of u is just u_0
u <= u_0 when ii = jj
    else u_0 xor u_1;

-- Map internal indicies to external slv outputs
P_addr <= std_logic_vector( to_unsigned( aa, natural(ceil(log2(real(M)))) ) );
S_addr_0 <= std_logic_vector( to_unsigned( ii, natural(ceil(log2(real(K)))) ) );
S_addr_1 <= std_logic_vector( to_unsigned( jj, natural(ceil(log2(real(K)))) ) );

process( clk, rst ) 
begin
  if( rst = '1' ) then
    done <= '0';
    y_long <= ( others => ( others => '0' ) );
    ii <= 0;
    jj <= K-1;
    aa <= 0;
    l <= 0;
    
  elsif( rising_edge(clk) ) then
    done <= '0';
    if en = '1' then
      if ii < K then
        if jj >= ii then
          if aa < M then
          
--          for y_long_idx in 0 to M-1 loop
--            y_long_reg( y_long_idx + l ) <= y_long_reg( y_long_idx + l  ) xor u_arr( y_long_idx );
--          end loop;
          
            y_long_reg( aa + l ) <= y_long_reg( aa + l ) xor u; -- u is u(aa)
            --u_store( aa ) <= u;
            aa <= aa + 1;
          else -- else aa < M-1
          
             -- l increments every itteration for jj
            l <= l + 1;
            aa <= 0;
            -- Adjust loop counters as needed
            if jj = ii  then
              jj <= K-1;
              ii <= ii+1;
            else
              jj <= jj-1;
            end if;
          end if; -- aa < M-1
        end if; -- jj >= ii
      else
        ii <= 0;
        jj <= K-1;
        l  <= 0;
        done <= '1';
        y_long <= y_long_reg;
        
      end if; -- ii < K-1
    end if; -- en = '1'
  end if; -- r_e(clk)
end process;

end Behavioral;
