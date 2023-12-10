library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


use work.PKG_matrix_types.all;

entity mayo_verify_datapath is
    Generic(
      M : integer := PKG_M;
      O : integer := PKG_O;
      N : integer := PKG_N;
      K : integer := PKG_K;
      P1_BYTES : integer := PKG_P1_BYTES;
      P2_BYTES : integer := PKG_P2_BYTES;
      P3_BYTES : integer := PKG_P3_BYTES
    );
    Port ( 
      clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       en : in STD_LOGIC;
       
       load_p_storage : in std_logic;
       load_s_storage : in std_logic;
       en_compute_y_long : in std_logic;
       en_collapse_y_long : in std_logic;
       
       done_p_storage : out std_logic;
       done_s_storage : out std_logic;
       done_compute_y_long : out std_logic;
       rd_y : out std_logic;
       
       data_in : in std_logic_vector( 7 downto 0 );
       y : out std_logic_vector( 3 downto 0 )
    );
end mayo_verify_datapath;

architecture Behavioral of mayo_verify_datapath is

signal p_rd_slice_addr : std_logic_vector( natural(log2(real(M))) - 1 downto 0 ) := ( others => '0' );
signal p_rd_slice_data : nxn_mat_2d := ( others => ( others => ( others => '0' ) ) );

signal s_rd_addr_0, s_rd_addr_1 : std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 ) := ( others => '0' );
signal s_rd_data_0, s_rd_data_1 : n_mat_1d := ( others => ( others => '0' ) );

signal y_long : m2_mat_1d := ( others => ( others => '0' ) );

begin

inst_p_mat_storage: entity work.p_mat_storage
  port map(
    clk => clk,
    rst => rst,
    load => load_p_storage,
    done => done_p_storage,
    data_in => data_in,
    rd_slice_addr => p_rd_slice_addr,
    rd_slice_data => p_rd_slice_data
  );
  
inst_s_vec_storage: entity work.s_vec_storage
  port map(
    clk => clk,
    rst => rst,
    load => load_s_storage,
    done => done_s_storage,
    data_in => data_in,
    rd_addr_0 => s_rd_addr_0,
    rd_data_0 => s_rd_data_0,
    rd_addr_1 => s_rd_addr_1,
    rd_data_1 => s_rd_data_1
  );
  
inst_compute_y_long: entity work.compute_y_long
  port map(
    clk => clk,
    rst => rst,
    en => en_compute_y_long,
    done => done_compute_y_long,
    S_addr_0 => s_rd_addr_0,
    S_data_0 => s_rd_data_0,
    S_addr_1 => s_rd_addr_1,
    S_data_1 => s_rd_data_1,
    P_addr => p_rd_slice_addr,
    P_data => p_rd_slice_data,
    y_long => y_long
  );

inst_collapse_y_long: entity work.collapse_y_long
  port map(
    clk => clk,
    rst => rst, 
    en => en_collapse_y_long,
    y_long => y_long,
    rd_y => rd_y,
    y => y
  );

end Behavioral;
