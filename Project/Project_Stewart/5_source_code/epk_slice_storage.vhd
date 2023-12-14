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
    wr_mode : in std_logic;
    wr_done : out std_logic;
    wr_data_in : in m_mat_1d;
    wr_row_idx : in std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    wr_col_idx : in std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    rd_slice_addr : in std_logic_vector( natural(log2(real(M))) - 1 downto 0 );
    rd_slice_data : out nxn_mat_2d
  );
end epk_slice_storage;

architecture Behavioral of epk_slice_storage is

-- Create 3d register array
--signal data_store : nxnxm_mat_3d := (others => (others => (others => (others => '0') ) ) );
--type TYPE_DATA_STORE is array( 0 to (N*N)-1 ) of std_logic_vector( 3 downto 0 );

signal RAM_data_in, RAM_data_out, ram_data_mask, data_in_extended, data_in_shifted : std_logic_vector( ((N*N)*4)-1 downto 0 ) := ( others => '0' );
signal RAM_data_in_reg : nn_mat_1d := ( others => ( others => '0' ) );
signal RAM_addr : std_logic_vector( natural(log2(real(M))) - 1 downto 0 ) := ( others => '0' );
signal slice_idx : integer := 0;

signal RAM_wr_en, wr_flag : std_logic := '0';

begin


inst_epk_slice_RAM: entity work.epk_slice_RAM
  port map(
    clk => clk,
    wr_en => wr_flag,
    wr_data_in => RAM_data_in,
    slice_addr => RAM_addr,
    rd_slice_data => RAM_data_out
  );
  
RAM_addr <= std_logic_vector( to_unsigned( slice_idx, natural(log2(real(M))) ) ) when wr_mode
            else rd_slice_addr;
            
-- For Gens are Converstion to and from arrays
row_idx_FOR_GEN: for row_idx in 0 to N-1 generate
  col_idx_FOR_GEN: for col_idx in 0 to N-1 generate
    rd_slice_data(row_idx)(col_idx) <= RAM_data_out( (row_idx*N*4)+(col_idx*4)+3 downto (row_idx*N*4)+(col_idx*4) );
  end generate col_idx_FOR_GEN;  
end generate row_idx_FOR_GEN;

nn_idx_FOR_GEN: for nn_idx in 0 to (N*N)-1 generate
  RAM_data_in( nn_idx*4 + 3 downto nn_idx*4 ) <= RAM_data_in_reg(nn_idx);
end generate nn_idx_FOR_GEN;            

process( clk, rst )
begin
  if( rst = '1' ) then
    wr_done <= '0';
    wr_flag <= '0';
    slice_idx <= 0;
  else
    if( rising_edge( clk ) ) then
      wr_done <= '0';
      wr_flag <= '0';
      if( wr_mode = '1' and wr_done = '0' ) then
        if( slice_idx < M ) then
          if( wr_flag = '0' ) then
            for RAM_data_in_reg_idx in 0 to (N*N)-1 loop
              RAM_data_in_reg(RAM_data_in_reg_idx) <= RAM_data_out(RAM_data_in_reg_idx*4 + 3 downto RAM_data_in_reg_idx*4);
            end loop;
            RAM_data_in_reg( (to_integer( unsigned(wr_row_idx))*N) +
                              to_integer( unsigned(wr_col_idx)))  <= wr_data_in(slice_idx);
            wr_flag <= '1';
          else
            slice_idx <= slice_idx + 1;
            wr_flag <= '0';
          end if;
        else
          slice_idx <= 0; 
          wr_done <= '1';
          wr_flag <= '0';
        end if;
      end if; -- wr_en
    end if; --r_e(clk)
  end if; -- rst

end process;


end Behavioral;
