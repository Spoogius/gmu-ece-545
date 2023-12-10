library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_mayo_verify_controller is
--  Port ( );
end TB_mayo_verify_controller;

architecture Behavioral of TB_mayo_verify_controller is

signal clk, rst, en, load_p_storage, load_s_storage, en_compute_y_long, en_collapse_y_long, done_p_storage, done_s_storage, done_compute_y_long, rd_y : std_logic := '0';
signal ctrl_load_p_storage, ctrl_load_s_storage, ctrl_en_compute_y_long, ctrl_en_collapse_y_long : std_logic := '0';
signal data_in : std_logic_vector( 7 downto 0 ) := ( others => '0' );
signal y, y_expected : std_logic_vector( 3 downto 0 ) := ( others => '0' );

constant CLK_PERIOD : time := 20 ns;

--debug
signal debug_bytes_read : integer := 0;

begin

dut_datapath: entity work.mayo_verify_datapath
  port map(
    clk => clk,
    rst => rst,
    en => en,
    load_p_storage => ctrl_load_p_storage,
    load_s_storage => ctrl_load_s_storage,
    en_compute_y_long => ctrl_en_compute_y_long,
    en_collapse_y_long => ctrl_en_collapse_y_long,
    done_p_storage => done_p_storage,
    done_s_storage => done_s_storage,
    done_compute_y_long => done_compute_y_long,
    data_in => data_in,
    rd_y => rd_y,
    y => y
  );

dut_controller: entity work.mayo_verify_controller
  port map(
    clk => clk,
    rst => rst,
    en => en,
    load_p_storage => ctrl_load_p_storage,
    load_s_storage => ctrl_load_s_storage,
    en_compute_y_long => ctrl_en_compute_y_long,
    en_collapse_y_long => ctrl_en_collapse_y_long,
    done_p_storage => done_p_storage,
    done_s_storage => done_s_storage,
    done_compute_y_long => done_compute_y_long,
    rd_y => rd_y
  );

clk <= not clk after CLK_PERIOD/2;

process
  FILE epk_golden_file : text open READ_MODE is "EPK.ascii";
  FILE sig_golden_file : text open READ_MODE is "sig.ascii";
  FILE y_golden_file : text open READ_MODE is "y_golden.ascii";
  
  variable vector_line : line;
  variable vector_valid : boolean;
  
  variable file_epk_data : std_logic_vector( 7 downto 0 );
  variable file_sig_data : std_logic_vector( 7 downto 0 );
  variable file_y_data : std_logic_vector( 3 downto 0 );
begin
  
  rst <= '1';
  wait for 2*CLK_PERIOD;
  
  rst <= '0';
  en <= '1';

  while not endfile( epk_golden_file ) loop
    readline( epk_golden_file, vector_line );
    hread( vector_line, file_epk_data , good=>vector_valid );
    next when not vector_valid;
    
    data_in <= file_epk_data;
    debug_bytes_read <= debug_bytes_read + 1;
    
    wait for CLK_PERIOD;
  end loop;
  
  while not endfile( sig_golden_file ) loop
    readline( sig_golden_file, vector_line );
    hread( vector_line, file_sig_data , good=>vector_valid );
    next when not vector_valid;

    data_in <= file_sig_data;
    debug_bytes_read <= debug_bytes_read + 1;
    
    wait for CLK_PERIOD;
    
  end loop;
  
  wait until rd_y <= '1';
  while not endfile( y_golden_file ) loop
    readline( y_golden_file, vector_line );
    hread( vector_line, file_y_data , good=>vector_valid );
    next when not vector_valid;

    y_expected <= file_y_data;
    
    wait for CLK_PERIOD;
  end loop;
  
  en_collapse_y_long <= '0';
  y_expected <= ( others => '0' );
  wait;
  
end process;
end Behavioral;
