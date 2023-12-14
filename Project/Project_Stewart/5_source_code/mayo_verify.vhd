library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity mayo_verify is
  Generic(
      M : integer := PKG_M;
      O : integer := PKG_O;
      N : integer := PKG_N;
      K : integer := PKG_K;
      P1_BYTES : integer := PKG_P1_BYTES;
      P2_BYTES : integer := PKG_P2_BYTES;
      P3_BYTES : integer := PKG_P3_BYTES;
      SIG_BYTES : integer := PKG_SIG_BYTES
    );
    Port ( 
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
      en : in STD_LOGIC;
      rdy_data_in : out std_logic;
      rd_data_in : in std_logic;
      data_in : in std_logic_vector( 7 downto 0 );
      rd_y : out std_logic;
      y : out std_logic_vector( 3 downto 0 )
    );
end mayo_verify;

architecture Behavioral of mayo_verify is

signal clk_s, rst_s, en_s, rd_y_s, load_p_storage, load_s_storage, en_compute_y_long, p_rdy_data_in, en_collapse_y_long, done_p_storage, done_s_storage, done_compute_y_long : std_logic := '0';

begin

rd_y <= rd_y_s;

mayo_verify_datapath: entity work.mayo_verify_datapath
  port map(
    clk => clk,
    rst => rst,
    en => en,
    load_p_storage => load_p_storage,
    load_s_storage => load_s_storage,
    en_compute_y_long => en_compute_y_long,
    en_collapse_y_long => en_collapse_y_long,
    p_rdy_data_in => p_rdy_data_in,
    p_rd_data_in => load_p_storage,
    done_p_storage => done_p_storage,
    done_s_storage => done_s_storage,
    done_compute_y_long => done_compute_y_long,
    rd_y => rd_y_s, 
    data_in => data_in,
    y => y
  );
  
mayo_verify_controller: entity work.mayo_verify_controller
  port map(
    clk => clk,
    rst => rst,
    en => en,
    load_p_storage => load_p_storage,
    load_s_storage => load_s_storage,
    en_compute_y_long => en_compute_y_long,
    en_collapse_y_long => en_collapse_y_long,
    rd_data_in => rd_data_in,
    rdy_data_in => rdy_data_in,
    p_rdy_data_in => p_rdy_data_in,
    done_p_storage => done_p_storage,
    done_s_storage => done_s_storage,
    done_compute_y_long => done_compute_y_long,
    rd_y => rd_y_s
  );
  
end Behavioral;
