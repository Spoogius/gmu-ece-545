library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity bitslice_vector_decode_epk is
  Generic(
    M : integer := PKG_M
  );
  Port(
    clk : in std_logic;
    rst : in std_logic;
    en  : in std_logic;
    data_in : in std_logic_vector( 7 downto 0 );
    data_out : out m_mat_1d;
    data_ready : out std_logic
  );
end bitslice_vector_decode_epk;

architecture Behavioral of bitslice_vector_decode_epk is

signal data_out_reg : m_mat_1d := (others => (others => '0') );
signal decode_flag : std_logic := '0';

signal input_counter : std_logic_vector( natural(log2(real(M/2))) - 1 downto 0 ) := ( others => '0' );

type shift_reg_8xM_div_2 is array( M/2 - 1 downto 0 ) of std_logic_vector( 7 downto 0 );
signal input_shift_reg : shift_reg_8xM_div_2 := (others => (others => '0') );

begin

input_data_FOR_GEN: for input_idx in 0 to (M/8)-1 generate
  bit_FOR_GEN: for bit_idx in 0 to 7 generate
    data_out_reg(input_idx*8 + bit_idx) <= input_shift_reg( 3*M/8 + input_idx)(bit_idx)
                                         & input_shift_reg( 2*M/8 + input_idx)(bit_idx) 
                                         & input_shift_reg( 1*M/8 + input_idx)(bit_idx) 
                                         & input_shift_reg( 0*M/8 + input_idx)(bit_idx); 
  end generate bit_FOR_GEN;
end generate input_data_FOR_GEN;

-- Counter Process to signal to choose when to decode
process( clk, rst )
begin
  if (rst = '1') then
    decode_flag <=  '0';
    input_counter <= ( others => '0' );
  elsif( rising_edge( clk ) ) then
   
    if unsigned( input_counter ) = M/2-1 then
      decode_flag <= '1';
      input_counter <= ( others => '0' );
    else
      decode_flag <= '0';
      input_counter <= std_logic_vector( unsigned(input_counter) + 1 );
    end if;
  end if;
end process;

process( clk, rst )
begin

  if(rst = '1') then
    -- Reset memory to '0'
    data_out <= (others => (others => '0') );
    data_ready <= '0';
  else
    if( rising_edge( clk ) ) then
      data_ready <= '0';
      
      if( en = '1' ) then
        -- Store input data into shift reg
        -- Index 0 is the oldest data. Index M/2 -1 is the newest
        for shift_reg_idx in M/2 - 2 downto 0 loop
          input_shift_reg(shift_reg_idx) <= input_shift_reg(shift_reg_idx+1);
        end loop;
        input_shift_reg(M/2 - 1) <= data_in;
      end if;
     -- Write to output reg
     -- Outside of enable check to handle case of enable turning off at the same time data is finished. Enable off will disable the counter
     -- So this block will only trigger once while enable is low
      if( decode_flag = '1' ) then
        data_out <= data_out_reg;
        data_ready <= '1';
      end if;
    end if;
  end if;
end process;

end Behavioral;
