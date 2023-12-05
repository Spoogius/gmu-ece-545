library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


use work.PKG_matrix_types.all;

entity galois_multiply is
  Generic(
    -- Not a real param becuase LUTs are hardcoded as if GALOIS_WIDTH can only equal 4.
    GALOIS_WIDTH : integer := 4
  );
  Port( 
    in_0  : in  std_logic_vector( GALOIS_WIDTH - 1 downto 0 );
    in_1  : in  std_logic_vector( GALOIS_WIDTH - 1 downto 0 );
    out_0 : out std_logic_vector( GALOIS_WIDTH - 1 downto 0 )
  );
end galois_multiply;

architecture Behavioral of galois_multiply is

type LUT_4x4 is array( 0 to 15 ) of std_logic_vector( GALOIS_WIDTH-1 downto 0 );
type LUT_5x4 is array( 0 to 31 ) of std_logic_vector( GALOIS_WIDTH-1 downto 0 );

CONSTANT LUT_LOG  : LUT_4x4 := ( x"0", x"0", x"1", x"4", x"2", x"8", x"5", x"A", x"3", x"E", x"9", x"7", x"6", x"D", x"B", x"C" );
CONSTANT LUT_ALOG : LUT_4x4 := ( x"1", x"2", x"4", x"8", x"3", x"6", x"C", x"B", x"5", x"A", x"7", x"E", x"F", x"D", x"9", x"0" );
CONSTANT LUT_MOD_15 : LUT_5x4 := (x"0", x"1", x"2", x"3", x"4", x"5", x"6", x"7", x"8", x"9", x"A", x"B", x"C", x"D", x"E", x"0", x"1", x"2", x"3", x"4", x"5", x"6", x"7", x"8", x"9", x"A", x"B", x"C", x"D", x"E", x"0", x"1");
signal log_sum : std_logic_vector( GALOIS_WIDTH downto 0 ) := ( others => '0' );

signal lut_res_0, lut_res_1 : std_logic_vector( GALOIS_WIDTH - 1 downto 0 ) := ( others => '0' );

begin

lut_res_0 <= LUT_LOG(to_integer(unsigned(in_0)));
lut_res_1 <= LUT_LOG(to_integer(unsigned(in_1)));

log_sum <= std_logic_vector(to_unsigned( 
              to_integer(unsigned( lut_res_0 )) +
              to_integer(unsigned( lut_res_1 )),
              GALOIS_WIDTH + 1 ));
out_0 <= LUT_ALOG(to_integer(unsigned( LUT_MOD_15( to_integer(unsigned(log_sum)) ) )) );

end Behavioral;
