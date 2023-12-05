library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity epk_slice_storage is
  Generic(
    M : integer := PKG_M;
    N : integer := PKG_N
  );
  Port(
    clk : in std_logic;
    rst : in std_logic;
    wr_en : in std_logic;
    wr_data_in : in m_mat_1d;
    wr_row_idx : in std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    wr_col_idx : in std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    rd_slice_idx : in std_logic_vector( natural(log2(real(M))) - 1 downto 0 );
    rd_slice_data : out nxn_mat_2d
  );
end epk_slice_storage;

architecture Behavioral of epk_slice_storage is

-- Create 3d register array
signal data_store : nxnxm_mat_3d := (others => (others => (others => (others => '0') ) ) );
--signal tmp_data_store : m_mat_3d := ( 
--   (( x"1", x"2", x"3", x"4"), ( x"1", x"2", x"3", x"4"), ( x"1", x"2", x"3", x"4") , ( x"1", x"2", x"3", x"4")),
--   (( x"2", x"3", x"4", x"1"), ( x"2", x"3", x"4", x"1"), ( x"2", x"3", x"4", x"1") , ( x"2", x"3", x"4", x"1")),
--   (( x"3", x"4", x"1", x"2"), ( x"3", x"4", x"1", x"2"), ( x"3", x"5", x"1", x"2") , ( x"3", x"4", x"1", x"2")),
--   (( x"4", x"1", x"2", x"3"), ( x"4", x"1", x"2", x"3"), ( x"4", x"1", x"2", x"3") , ( x"4", x"1", x"2", x"3"))
--);

--signal slice_0, slice_1, slice_2, slice_3 : m_mat_2d;
begin

--slice_0 <= tmp_data_store(0);
--slice_1 <= tmp_data_store(1);
--slice_2 <= tmp_data_store(2);
--slice_3 <= tmp_data_store(3);

rd_slice_data <= data_store(to_integer(unsigned( rd_slice_idx ) ) );


process( clk, rst )
begin

  if(rst = '1') then
    -- Reset memory to '0'
    data_store <= (others => (others => (others => (others => '0') ) ) );
  else
    if( rising_edge( clk ) ) then
      if( wr_en = '1' ) then
        slice_write_FOR: for slice_store_idx in 0 to M-1 loop
          data_store(slice_store_idx)(to_integer(unsigned( wr_row_idx )))(to_integer(unsigned( wr_col_idx ))) <= wr_data_in(slice_store_idx);
        end loop slice_write_FOR;
      end if;
    end if;
  end if;
  
end process;

end Behavioral;
