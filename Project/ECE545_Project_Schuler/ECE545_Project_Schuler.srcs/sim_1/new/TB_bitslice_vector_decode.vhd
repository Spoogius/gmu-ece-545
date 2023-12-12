library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity TB_bitslice_vector_decode is
--  Port ( );
end TB_bitslice_vector_decode;

architecture Behavioral of TB_bitslice_vector_decode is

type const_input_data_type is array( 0 to PKG_M/2 - 1 ) of std_logic_vector( 7 downto 0 );
constant CONST_INPUT_DATA : const_input_data_type :=
(x"E1", x"8B", x"A3", x"B8", x"E2", x"E2", x"2B", x"85", x"AA", x"34", x"19", x"D4", x"72", x"D2", x"E5", x"B5", x"CA", x"AA", x"0E", x"CE", x"22", x"AC", x"B8", x"26", x"90", x"18", x"9E", x"5F", x"88", x"4B", x"1C", x"3A" );


signal clk : std_logic := '1';
signal rst : std_logic := '1';
signal en : std_logic := '0';

signal data_in : std_logic_vector( 7 downto 0 ) := (others => '0');
signal data_out : m_mat_1d := (others => (others => '0') );
signal data_ready : std_logic := '0';

constant CLK_PERIOD : time := 20 ns;

begin

dut: entity work.bitslice_vector_decode_epk
  port map(
    clk => clk,
    rst => rst,
    en => en,
    data_in => data_in,
    data_out => data_out,
    data_ready => data_ready
  );
  
clk <= not clk after CLK_PERIOD/2;  

process
begin
 wait for 4*CLK_PERIOD;
  rst <= '0';
  wait for CLK_PERIOD;
  en <= '1';
  
  for data_in_idx in 0 to PKG_M/2 - 1 loop
    data_in <= CONST_INPUT_DATA( data_in_idx );
    wait for CLK_PERIOD;
  end loop;
  
  wait until data_ready = '1';
  en <= '0';
  
  wait;
 
end process;

end Behavioral;
