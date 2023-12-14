library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_mayo_verify is
--  Port ( );
end TB_mayo_verify;

architecture Behavioral of TB_mayo_verify is

signal clk : std_logic := '1'; 
signal rst, en, rd_y, rd_data_in, rdy_data_in : std_logic := '0';
signal data_in : std_logic_vector( 7 downto 0 ) := ( others => '0' );
signal y, y_expected : std_logic_vector( 3 downto 0 ) := ( others => '0' );

constant CLK_PERIOD : time := 20 ns;

begin

dut: entity work.mayo_verify
  port map(
    clk => clk,
    rst => rst,
    en => en,
    rdy_data_in => rdy_data_in,
    rd_data_in => rd_data_in,
    data_in => data_in,
    rd_y => rd_y,
    y => y
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
  
  variable total_values : integer := 0;
  variable correct_values : integer := 0;
begin
  
  rst <= '1';
  wait for 2*CLK_PERIOD;
  
  rst <= '0';
  en <= '1';

  while not endfile( epk_golden_file ) loop
    if( rdy_data_in = '1' ) then
      for epk_M_div_2_cnt in 0 to PKG_M/2 - 1 loop
        rd_data_in <= '1';
        readline( epk_golden_file, vector_line );
        hread( vector_line, file_epk_data , good=>vector_valid );
        next when not vector_valid;
        
        data_in <= file_epk_data;
        wait for CLK_PERIOD;
      end loop;
      rd_data_in <= '0';
    else
      rd_data_in <= '0';
      wait for CLK_PERIOD;
    end if;
  end loop;
  
  wait until rdy_data_in <= '1';
  rd_data_in <= '1';
  
  while not endfile( sig_golden_file ) loop
    readline( sig_golden_file, vector_line );
    hread( vector_line, file_sig_data , good=>vector_valid );
    next when not vector_valid;

    data_in <= file_sig_data;
    wait for CLK_PERIOD;
  end loop;
  rd_data_in <= '0';
  
  wait until rd_y <= '1';
  while not endfile( y_golden_file ) loop
    readline( y_golden_file, vector_line );
    hread( vector_line, file_y_data , good=>vector_valid );
    next when not vector_valid;

    y_expected <= file_y_data;
    
    wait for CLK_PERIOD/2;
    total_values := total_values + 1;
    if y_expected /= y then
      report "[Warning] y mismatch at index: " & integer'image(total_values) & " Expected: " & to_hstring(y_expected) & " Read: "  & to_hstring(y)
        severity warning;
    else
      correct_values := correct_values + 1;
    end if;
    wait for CLK_PERIOD/2;
  end loop;
  
  wait until rd_y <= '0';
  y_expected <= ( others => '0' );
  en <= '0';

  if correct_values = total_values then
    report
      "All " & integer'image(total_values) & " values in y match the expected values in y_golden.ascii"
        severity note;
  else
    report
      "[Error] " & integer'image(correct_values) & " out of " & integer'image(total_values) & " values in y match the expected values in y_golden.ascii"
        severity error;
  end if;

  wait;
  
end process;
end Behavioral;
