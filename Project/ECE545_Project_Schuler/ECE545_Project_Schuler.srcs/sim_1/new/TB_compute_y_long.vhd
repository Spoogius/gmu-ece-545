library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_compute_y_long is
--  Port ( );
end TB_compute_y_long;

architecture Behavioral of TB_compute_y_long is

signal clk, rst, en, done : std_logic := '0';

signal S_idx_0, S_idx_1 : std_logic_vector( natural(ceil(log2(real(PKG_K)))) - 1 downto 0 ) := ( others => '0' );
signal S_data_0, s_data_1 : n_mat_1d := ( others => ( others => '0' ) );
signal P_data : nxn_mat_2d := ( others => ( others => ( others => '0' ) ) );
signal y_long : m2_mat_1d := ( others => ( others => '0' ) );

constant CLK_PERIOD : time := 20 ns;

begin

dut: entity work.compute_y_long 
  Port Map(
    clk => clk,
    rst => rst,
    en => en,
    done => done,
    S_idx_0 => S_idx_0,
    S_idx_1 => S_idx_1,
    S_data_0 => S_data_0,
    S_data_1 => s_data_1,
    P_data   => P_data,
    y_long   => y_long
    
  );
  
  clk <= not clk after CLK_PERIOD/2;
  
process
begin
  rst <= '1';
  wait for 4 * CLK_PERIOD;
  
  rst <= '0';
  en <= '1';
  
  wait;
end process;

end Behavioral;
