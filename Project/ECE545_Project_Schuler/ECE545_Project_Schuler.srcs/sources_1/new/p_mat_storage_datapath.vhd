library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity p_mat_storage_datapath is
Generic(
    M : integer := PKG_M;
    N : integer := PKG_N
  );
  Port(
    -- External
    clk : in std_logic;
    rst : in std_logic;
    
    data_in : in std_logic_vector( 7 downto 0 );
    storage_rd_slice_idx : in std_logic_vector( natural(log2(real(M))) - 1 downto 0 );
    storage_rd_slice_data : out nxn_mat_2d;
    
    -- From Controller
    decode_en : in std_logic;
    decode_data_ready : out std_logic;
    
    storage_wr_en   : in std_logic;
    storage_row_idx : in std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    storage_col_idx : in std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 )
    
  );
end p_mat_storage_datapath;

architecture Behavioral of p_mat_storage_datapath is

signal bitsliced_data : m_mat_1d;

begin

inst_epk_slice_storage: entity work.epk_slice_storage
  port map(
    clk => clk,
    rst => rst,
    wr_en => storage_wr_en,
    wr_data_in => bitsliced_data,
    wr_row_idx => storage_row_idx,
    wr_col_idx => storage_col_idx,
    rd_slice_idx => storage_rd_slice_idx,
    rd_slice_data => storage_rd_slice_data 
  );
  
inst_bitslice_vector_decode_epk: entity work.bitslice_vector_decode_epk
  port map(
    clk => clk,
    rst => rst,
    en => decode_en,
    data_in => data_in,
    data_out => bitsliced_data,
    data_ready => decode_data_ready
  );

end Behavioral;
