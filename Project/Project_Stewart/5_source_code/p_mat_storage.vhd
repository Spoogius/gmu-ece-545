library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity p_mat_storage is
  Generic(
    M : integer := PKG_M;
    O : integer := PKG_O;
    N : integer := PKG_N;
    P1_BYTES : integer := PKG_P1_BYTES;
    P2_BYTES : integer := PKG_P2_BYTES;
    P3_BYTES : integer := PKG_P3_BYTES
  );
  Port(
    clk : in std_logic;
    rst : in std_logic;
    load  : in std_logic;
    done : out std_logic;
    data_in : in std_logic_vector( 7 downto 0 );
    rd_data_in : in std_logic;
    rdy_data_in: out std_logic;
    rd_slice_addr : in std_logic_vector( natural(log2(real(M))) - 1 downto 0 );
    rd_slice_data : out nxn_mat_2d
    
  );
end p_mat_storage;

architecture Behavioral of p_mat_storage is

signal decode_en, storage_wr_en, storage_wr_done, decode_data_ready: std_logic := '0';
signal storage_row_idx, storage_col_idx : std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );

begin


inst_p_mat_storage_datapath: entity work.p_mat_storage_datapath
  port map(
    clk => clk,
    rst => rst,
    data_in => data_in,
    storage_rd_slice_addr => rd_slice_addr,
    storage_rd_slice_data => rd_slice_data,
    decode_en => decode_en,
    decode_data_ready => decode_data_ready,
    storage_wr_en => storage_wr_en,
    storage_row_idx => storage_row_idx,
    storage_col_idx => storage_col_idx,
    storage_wr_done => storage_wr_done
  );
  
inst_p_mat_storage_controller: entity work.p_mat_storage_controller
  port map(
    clk => clk,
    rst => rst,
    en => load,
    rd_data_in => rd_data_in,
    rdy_data_in => rdy_data_in,
    done => done,
    decode_data_ready => decode_data_ready,
    decode_en => decode_en,
    storage_wr_en => storage_wr_en,
    storage_row_idx => storage_row_idx,
    storage_col_idx => storage_col_idx,
    storage_wr_done => storage_wr_done
  );

end Behavioral;
