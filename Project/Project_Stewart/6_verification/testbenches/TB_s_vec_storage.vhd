library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use IEEE.std_logic_textio.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_s_vec_storage is
--  Port ( );
end TB_s_vec_storage;

architecture Behavioral of TB_s_vec_storage is

signal clk  : std_logic := '1';
signal rst  : std_logic := '1';
signal load : std_logic := '0';
signal s_vec_storage_done : std_logic := '0';

signal data_in : std_logic_vector( 7 downto 0 ) := ( others => '0' );
signal rd_addr_0, rd_addr_1 : std_logic_vector( natural(ceil(log2(real(PKG_K)))) - 1 downto 0 ) := ( others => '0' );
signal rd_data_0, rd_data_1 : n_mat_1d := ( others => ( others => '0' ) );

constant CLK_PERIOD : time := 20 ns;

-- DEBUG
signal data_in_cnt : integer := 0;

begin

dut: entity work.s_vec_storage
  Port Map(
    clk => clk,
    rst => rst,
    load => load,
    done => s_vec_storage_done,
    data_in => data_in,
    rd_addr_0 => rd_addr_0,
    rd_data_0 => rd_data_0,
    rd_addr_1 => rd_addr_1,
    rd_data_1 => rd_data_1
  );


clk <= not clk after CLK_PERIOD/2;

process
  FILE sig_golden_file : text open READ_MODE is "sig.ascii";
  FILE s_golden_file : text open READ_MODE is "s_golden.ascii";
  variable vector_line : line;
  variable vector_valid : boolean;
  variable file_sig_data : std_logic_vector( 7 downto 0 );
  variable file_s_data : std_logic_vector( 3 downto 0 );
  
  variable total_values : integer := 0;
  variable correct_values : integer := 0;
  
  
begin
  rst <= '1';
  wait for 4*CLK_PERIOD;
  
  rst <= '0';
  load <= '1';
  
  while not endfile( sig_golden_file ) loop
    readline( sig_golden_file, vector_line );
    hread( vector_line, file_sig_data , good=>vector_valid );
    next when not vector_valid;
    
    data_in_cnt <= data_in_cnt + 1;
    
    data_in <= file_sig_data;
    
    wait for CLK_PERIOD;
    
  end loop;
  
  wait until s_vec_storage_done = '1';
  load <= '0';
  
  for s_idx in 0 to PKG_K - 1 loop
    rd_addr_0 <= std_logic_vector( to_unsigned( s_idx, natural(ceil(log2(real(PKG_K)))) ) );
    wait for CLK_PERIOD;
    for s_i_idx in 0 to PKG_N - 1 loop
      readline( s_golden_file, vector_line );
      hread( vector_line, file_s_data , good=>vector_valid );
      
      total_values := total_values + 1;
      if file_s_data /= rd_data_0( s_i_idx ) then
        report "[Warning] S: " & integer'image(s_idx) & " S_i: " & integer'image(s_i_idx) & " Expected: " & to_hstring(file_s_data) & " Read: " & to_hstring(rd_data_0( s_i_idx ))
              severity warning;
      else
        correct_values := correct_values + 1;
      end if;
        
      wait for CLK_PERIOD;
    end loop;
  end loop;
  
  if correct_values = total_values then
    report
      "All " & integer'image(total_values) & " values in s match the expected values in s_golden.ascii"
        severity note;
  else
    report
      "[Error] " & integer'image(correct_values) & " out of " & integer'image(total_values) & " values in s match the expected values in s_golden.ascii"
        severity error;
  end if;
  
  wait;
end process;

end Behavioral;
