library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity epk_slice_RAM is
Generic(
    M : integer := PKG_M;
    N : integer := PKG_N
  );
  Port(
    clk : in std_logic;
    wr_en : in std_logic;
    wr_data_in : in std_logic_vector( ((N*N)*4)-1 downto 0 );
    slice_addr : in std_logic_vector( natural(log2(real(M))) - 1 downto 0 );
    rd_slice_data : out std_logic_vector( ((N*N)*4)-1 downto 0 )
  );

end epk_slice_RAM;

architecture Behavioral of epk_slice_RAM is

type TYPE_DATA_STORE is array( 0 to M-1 ) of std_logic_vector( ((N*N)*4)-1 downto 0 );
signal data_store : TYPE_DATA_STORE := ( others => ( others => '0' ) );

begin

rd_slice_data <= data_store( to_integer( unsigned( slice_addr ) ) );

process( clk )
begin
  if( rising_edge(clk) ) then
    if( wr_en = '1' ) then
      data_store( to_integer( unsigned( slice_addr ) ) ) <= wr_data_in;
    end if;
  end if;
end process;

end Behavioral;
