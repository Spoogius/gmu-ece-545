library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use work.PKG_matrix_types.all;

entity TB_mul_f is
--  Port ( );
end TB_mul_f;

architecture Behavioral of TB_mul_f is

signal in_0, in_1, out_0, out_expected : std_logic_vector( 3 downto 0 ) := ( others => '0' );
signal clk : std_logic := '0';

CONSTANT CLK_PERIOD : time := 20 ns;

begin

dut: entity work.mul_f
  port map(
    in_0 => in_0,
    in_1 => in_1,
    out_0 => out_0
  );
  
clk <= not clk after CLK_PERIOD/2;

process
begin
  
  in_0 <= x"1";
  in_1 <= x"3";
  out_expected <= x"3";
  wait for CLK_PERIOD;
  
  in_0 <= x"C";
  in_1 <= x"7";
  out_expected <= x"2";
  wait for CLK_PERIOD;
  
  in_0 <= x"F";
  in_1 <= x"9";
  out_expected <= x"E";
  wait for CLK_PERIOD;
  
  in_0 <= x"6";
  in_1 <= x"7";
  out_expected <= x"1";
  wait for CLK_PERIOD;
  
  in_0 <= x"9";
  in_1 <= x"8";
  out_expected <= x"4";
  wait for CLK_PERIOD;
  
  wait;
end process;

end Behavioral;
