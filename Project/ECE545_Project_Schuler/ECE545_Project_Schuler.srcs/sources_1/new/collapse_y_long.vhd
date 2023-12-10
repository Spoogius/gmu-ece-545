library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use work.PKG_matrix_types.all;

entity collapse_y_long is
  Generic(
    M : integer := PKG_M;
    N : integer := PKG_N;
    K : integer := PKG_K;
    F_TAIL_LEN : integer := PKG_F_TAIL_LEN
  );
  Port ( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    en : in STD_LOGIC;
    y_long : in m2_mat_1d;
    rd_y : out STD_LOGIC;
    y : out std_logic_vector( 3 downto 0 ) 
  );
end collapse_y_long;

architecture Behavioral of collapse_y_long is

signal idx_i, idx_wr : integer := 0;
signal idx_o : integer := M + K * (K+1) / 2 - 2;
signal y_long_reg : m2_mat_1d := ( others => ( others => '0' ) );
signal y_long_reg_stashed, comp_phase, finished: std_logic := '0';

signal mul_f_out: std_logic_vector( 3 downto 0 ) := ( others => '0' );

begin

inst_mul_f: entity work.mul_f
  port map(
    in_0 => y_long_reg( idx_o ),
    in_1 => PKG_F_TAIL( idx_i ),
    out_0 => mul_f_out
  );

process( clk, rst )
begin
  if( rst = '1' ) then
    y <= ( others => '0' );
    rd_y <= '0';
    idx_wr <= 0;
    finished <= '0';
  else
    if( en = '1' and comp_phase = '0' and finished = '0' ) then
      if( rising_edge( clk ) ) then
        rd_y <= '0';
        y <= ( others => '0' );
        if( idx_wr < M ) then
          y <= y_long_reg( idx_wr );
          rd_y <= '1';
          idx_wr <= idx_wr + 1;
        else
          finished <= '1';
          idx_wr <= 0;
        end if;
      end if; -- r_e(clk)
    end if; -- en
  end if; --rst
end process;

process( clk, rst )
begin

  if( rst = '1' ) then
    idx_o <= M + K * (K+1) / 2 - 2;
    idx_i <= 0;
    comp_phase <= '1';
  else
    if( en = '1' and comp_phase = '1' ) then
      if( rising_edge( clk ) ) then
        if( y_long_reg_stashed = '0' ) then
          y_long_reg <= y_long;
          y_long_reg_stashed <= '1';
        else
          if( idx_o >= M ) then
            if( idx_i < F_TAIL_LEN-1 ) then
              y_long_reg(idx_o - M + idx_i) <= y_long_reg(idx_o - M + idx_i) xor mul_f_out;
              idx_i <= idx_i + 1;
            else
              idx_i <= 0;
              idx_o <= idx_o - 1;
            end if; -- idx_i < F_TAIL_LEN
          else
            idx_o <= M + K * (K+1) / 2 - 2;
            idx_i <= 0;
            comp_phase <= '0';
            y_long_reg_stashed <= '0';
            
          end if; -- idx_o >= M
        end if; -- y_long_reg_stashed
      end if; -- r_e(clk)
    end if; -- en
  end if; -- rst
end process;

end Behavioral;
