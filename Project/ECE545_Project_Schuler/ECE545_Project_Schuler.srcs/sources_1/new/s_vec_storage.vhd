library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity s_vec_storage is
  Generic(
    N : integer := PKG_N;
    K : integer := PKG_K
  );
  Port( 
    clk : in std_logic;
    rst : in std_logic;
    load  : in std_logic;
    done : out std_logic;
    data_in : in std_logic_vector( 7 downto 0 );
    rd_addr : in std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 );
    rd_data : out n_mat_1d
    
  );
end s_vec_storage;

architecture Behavioral of s_vec_storage is

type DATA_STORE_TYPE is array( K downto 0 ) of n_mat_1d;
signal data_store : DATA_STORE_TYPE := ( others => ( others => ( others => '0' ) ) );
signal data_store_val_reg : n_mat_1d := ( others => ( others => '0' ) );

signal val_reg_idx : std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 ) := ( others => '0' );
signal wr_ready : std_logic := '0';
signal wr_addr :  std_logic_vector( natural(ceil(log2(real(K)))) - 1 downto 0 ) := ( others => '0' );

begin

rd_data <= data_store( to_integer( unsigned(rd_addr ) ) );

-- RAM Process
-- Read back asynchronous
process( clk, rst )
begin
  if( rst = '1' ) then
    data_store <= ( others => ( others => ( others => '0' ) ) );
    wr_addr <= ( others => '0' );
    done <= '0';
  elsif( rising_edge( clk ) ) then
    done <= '0';
    if( wr_ready = '1' ) then
      data_store( to_integer( unsigned( wr_addr ) ) ) <= data_store_val_reg;
      
      -- Increment wr_addr about K
      if to_integer(unsigned(wr_addr)) = K-1 then
        wr_addr <= ( others => '0' );
        done <= '1';
      else
        wr_addr <= std_logic_vector( unsigned(wr_addr ) + 1 );
      end if;
    end if;
  end if;
end process;

-- Store in val reg
process( clk, rst )
begin
  if( rst = '1' ) then
    data_store_val_reg <= ( others => ( others => '0' ) );
    val_reg_idx <= ( others => '0' );
    wr_ready <= '0';
  elsif( rising_edge( clk ) ) then
    wr_ready <= '0';
    if( load = '1' ) then
      data_store_val_reg( to_integer(unsigned(val_reg_idx )) + 0 ) <= data_in( 3 downto 0 );
      data_store_val_reg( to_integer(unsigned(val_reg_idx )) + 1 ) <= data_in( 7 downto 4 );
      
      -- Increment val_reg_idx about N
      if to_integer(unsigned(val_reg_idx)) = N-2 then
        wr_ready <= '1';
        val_reg_idx <= ( others => '0' );
      else
        val_reg_idx <= std_logic_vector( unsigned(val_reg_idx ) + 2 );
      end if;
      
    end if;
  end if;
end process;



end Behavioral;
