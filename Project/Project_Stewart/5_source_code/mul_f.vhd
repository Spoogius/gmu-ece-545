library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


use work.PKG_matrix_types.all;
entity mul_f is
  Port(
    in_0 : in std_logic_vector( 3 downto 0 );
    in_1 : in std_logic_vector( 3 downto 0 );
    out_0 : out std_logic_vector( 3 downto 0 )
  );
end mul_f;

architecture Behavioral of mul_f is

type P_ARR is array( 3 downto 0 ) of std_logic_vector( 7 downto 0 );
signal p : P_ARR := ( others => ( others => '0' ) );

signal in_0_extended, in_1_extended, p_extended: std_logic_vector( 7 downto 0 ) := ( others => '0' );

begin

  in_0_extended( 3 downto 0 ) <= in_0;
  in_1_extended( 3 downto 0 ) <= in_1;
  

  p(0) <= std_logic_vector( to_unsigned( 
    to_integer( unsigned( in_0_extended and x"01" ) ) *
    to_integer( unsigned( in_1_extended ) ) 
    ,8 ) );
    
  p(1) <= std_logic_vector( to_unsigned( 
    to_integer( unsigned( in_0_extended and x"02" ) ) *
    to_integer( unsigned( in_1_extended ) ) 
    ,8 ) );
    
  p(2) <= std_logic_vector( to_unsigned( 
    to_integer( unsigned( in_0_extended and x"04" ) ) *
    to_integer( unsigned( in_1_extended ) ) 
    ,8 ) );
    
  p(3) <= std_logic_vector( to_unsigned( 
    to_integer( unsigned( in_0_extended and x"08" ) ) *
    to_integer( unsigned( in_1_extended ) ) 
    ,8 ) );

  p_extended <= (p(0) xor p(1) xor p(2) xor p(3));
  out_0 <= ( p_extended( 7 downto 4 ) xor 
             p_extended( 6 downto 4 ) & '0' xor
             p_extended( 3 downto 0 ));

end Behavioral;
