library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity TB_epk_slice_storage is
--  Port ( );
end TB_epk_slice_storage;

architecture Behavioral of TB_epk_slice_storage is

signal clk   : std_logic := '0';
signal rst   : std_logic := '1';
signal wr_mode, wr_done : std_logic := '0';
signal wr_data_in    : m_mat_1d := (others => (others => '0'));
signal wr_row_idx    : std_logic_vector( natural(ceil(log2(real(PKG_N)))) - 1 downto 0 ) := (others => '0');
signal wr_col_idx    : std_logic_vector( natural(ceil(log2(real(PKG_N)))) - 1 downto 0 ) := (others => '0');
signal rd_slice_addr  : std_logic_vector( natural(log2(real(PKG_M))) - 1 downto 0 ) := (others => '0');
signal rd_slice_data : nxn_mat_2d := (others => (others => (others => '0')));


CONSTANT CLK_PERIOD : time := 20 ns;

CONSTANT DATA_ROW : m_mat_1d := ( x"1", x"2", x"3", x"4");

begin

dut: entity work.epk_slice_storage
  generic map(
    N => 4,
    M => 4
  )
  port map(
    clk => clk,
    rst => rst,
    wr_mode => wr_mode,
    wr_done => wr_done,
    wr_data_in => wr_data_in,
    wr_row_idx => wr_row_idx,
    wr_col_idx => wr_col_idx,
    rd_slice_addr => rd_slice_addr,
    rd_slice_data => rd_slice_data
  );

clk <= not clk after CLK_PERIOD/2;
process
begin
  wait for 4*CLK_PERIOD;
  rst <= '0';
  
  wait for CLK_PERIOD;
  
  wr_mode <= '1';
  for row_idx in 0 to PKG_M-1 loop
    for col_idx in 0 to PKG_M-1 loop
    
      wr_col_idx <= std_logic_vector( to_unsigned( col_idx, natural(ceil(log2(real(PKG_N)))) ) );
      wr_row_idx <= std_logic_vector( to_unsigned( row_idx, natural(ceil(log2(real(PKG_N)))) ) );
      wr_data_in <= DATA_ROW;
      wait until wr_done = '1';
    end loop;
  end loop;
  wr_mode <= '0';
  wait for CLK_PERIOD;
  
  for slice_idx in 0 to PKG_M loop
    rd_slice_addr <= std_logic_vector( to_unsigned( slice_idx, natural(log2(real(PKG_M))) ) );
    wait for CLK_PERIOD;
  end loop;
  

  
  wait;
end process;

end Behavioral;
