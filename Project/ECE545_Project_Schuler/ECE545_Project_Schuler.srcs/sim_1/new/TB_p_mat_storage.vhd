library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use IEEE.std_logic_textio.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_p_mat_storage is
--  Port ( );
end TB_p_mat_storage;

architecture Behavioral of TB_p_mat_storage is

signal clk : std_logic := '1';
signal rst : std_logic := '1';
signal load  : std_logic := '0';
signal p_mat_storage_done : std_logic := '0';

signal data_in : std_logic_vector( 7 downto 0 ) := ( others => '0' );
signal rd_slice_idx : std_logic_vector( natural(log2(real(PKG_M))) - 1 downto 0 ) := ( others => '0' );
signal rd_slice_data : nxn_mat_2d := ( others => ( others => ( others => '0' ) ) );

-- DEBUG SIGNALS
signal rd_data_0_0, rd_data_0_1, rd_data_0_2, rd_data_1_0, rd_data_1_1 : std_logic_vector( 3 downto 0 ) := ( others => '0' );

constant CLK_PERIOD : time := 20 ns;

begin

dut: entity work.p_mat_storage
  port map(
    clk => clk,
    rst => rst,
    load => load,
    done => p_mat_storage_done,
    data_in => data_in, 
    rd_slice_idx  => rd_slice_idx,
    rd_slice_data => rd_slice_data
  );

clk <= not clk after CLK_PERIOD/2;


-- DEBUG
rd_data_0_0 <= rd_slice_data(0)(0);
rd_data_0_1 <= rd_slice_data(0)(1);
rd_data_0_2 <= rd_slice_data(0)(2);
rd_data_1_0 <= rd_slice_data(1)(0);
rd_data_1_1 <= rd_slice_data(1)(1);

process
  FILE epk_golden_file : text open READ_MODE is "EPK.ascii";
  FILE p_golden_file : text open READ_MODE is "p_golden.ascii";
  variable vector_line : line;
  variable vector_valid : boolean;
  variable file_epk_data : std_logic_vector( 7 downto 0 );
  variable file_p_data : std_logic_vector( 3 downto 0 );
  
  variable total_values : integer := 0;
  variable correct_values : integer := 0;
  
begin
  rst <= '1';
  wait for 4*CLK_PERIOD;
  
  rst <= '0';
  load <= '1';
  
  while not endfile( epk_golden_file ) loop
  --for ii in 0 to 59*PKG_M/2 - 1 loop
    readline( epk_golden_file, vector_line );
    hread( vector_line, file_epk_data , good=>vector_valid );
    next when not vector_valid;
    
    data_in <= file_epk_data;
    
    wait for CLK_PERIOD;
    
  end loop;
  
  wait until p_mat_storage_done = '1';
  load <= '0';
    
  
  
  for slice_idx in 0 to PKG_M-1 loop
  --for slice_idx in 0 to 2 loop
    rd_slice_idx <= std_logic_vector( to_unsigned( slice_idx, natural(log2(real(PKG_M))) ) );
    wait for CLK_PERIOD;
      for row_idx in 0 to PKG_N-1 loop
        for col_idx in 0 to PKG_N-1 loop
          readline( p_golden_file, vector_line );
          hread( vector_line, file_p_data , good=>vector_valid );
          next when not vector_valid;
          
          total_values := total_values + 1;
          if file_p_data /= rd_slice_data( row_idx )( col_idx ) then
            report "[Warning] S: " & integer'image(slice_idx) & " R: " & integer'image(row_idx) & " C: " & integer'image(col_idx) & " Expected: " & to_hstring(file_p_data) & " Read: "  & to_hstring(rd_slice_data( row_idx )( col_idx ))
              severity warning;
          else
            correct_values := correct_values + 1;
          end if;
          wait for CLK_PERIOD;
        end loop;
      end loop;
      
  end loop;
  
  if correct_values = total_values then
    report
      "All " & integer'image(total_values) & " values in P match the expected values in p_golden.ascii"
        severity note;
  else
    report
      "[Error] " & integer'image(correct_values) & " out of " & integer'image(total_values) & " values in P match the expected values in p_golden.ascii"
        severity error;
  end if;
  
  rd_slice_idx <= (others=> '0');
  wait;
end process;


end Behavioral;
