library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


use work.PKG_matrix_types.all;

entity galois_add is
  Generic(
    GALOIS_WIDTH : integer := 4
  );
  Port( 
    in_0  : in  std_logic_vector( GALOIS_WIDTH - 1 downto 0 );
    in_1  : in  std_logic_vector( GALOIS_WIDTH - 1 downto 0 );
    out_0 : out std_logic_vector( GALOIS_WIDTH - 1 downto 0 )
  );
end galois_add;

architecture Behavioral of galois_add is

begin

out_0 <= in_0 xor in_1;

end Behavioral;
