library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;

entity p_mat_storage_controller is
  Generic(
    M : integer := PKG_M;
    O : integer := PKG_O;
    N : integer := PKG_N;
    P1_BYTES : integer := PKG_P1_BYTES;
    P2_BYTES : integer := PKG_P2_BYTES;
    P3_BYTES : integer := PKG_P3_BYTES
  );
  Port(
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    decode_data_ready : in std_logic;
    decode_en : out std_logic;
    storage_wr_en : out std_logic;
    storage_row_idx : out std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    storage_col_idx : out std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 );
    done : out std_logic
  );
end p_mat_storage_controller;

architecture Behavioral of p_mat_storage_controller is

--type states is ( waiting, reading, storing_p1, storing_p2, storing_p3 );
type states is ( reading, storing_p1, storing_p2, storing_p3 );
signal curr_state, next_state : states := reading;

signal row_idx : std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 ) := (others => '0');
signal col_idx : std_logic_vector( natural(ceil(log2(real(N)))) - 1 downto 0 ) := (others => '0');
signal total_bytes_read : integer := 0;

begin

decode_en <= en;
storage_row_idx <= row_idx;
storage_col_idx <= col_idx;

process( clk, rst )
begin

  if (rst = '1') then
    --curr_state <= waiting;
    --next_state <= waiting;
    curr_state <= reading;
    next_state <= reading;
    --decode_en <= '0';
    storage_wr_en <= '0';
    done <= '0';
    row_idx <= (others=>'0');
    col_idx <= (others=>'0');
    
    
  elsif( rising_edge( clk ) ) then
    curr_state <= next_state;
    case curr_state is
--      -- State Waiting
--      when waiting =>
--        next_state <= waiting;
--        decode_en <= '0';
--        storage_wr_en <= '0';
--        if (en = '1') then
--          next_state <= reading;
--          decode_en <= '1';
--        end if;
        
      -- State Reading
      when reading =>
        --next_state <= waiting;
        next_state <= reading;
        --decode_en <= '1';
        storage_wr_en <= '0';
        done <= '0';
        if (en='1') then
          if (decode_data_ready = '1') then
            storage_wr_en <= '1';
            total_bytes_read <= total_bytes_read + M/2;
            if( total_bytes_read + M/2 <= P1_BYTES  ) then
              next_state <= storing_p1;
            elsif ( total_bytes_read + M/2 <= P1_BYTES + P2_BYTES ) then
              next_state <= storing_p2;
            else
              next_state <= storing_p3;
            end if;
          end if;
        end if;

      
      -- State Sorting P1
      when storing_p1 =>
        storage_wr_en <= '0';
        done <= '0';
        next_state <= reading;
--        -- RM DEBUEG
--        if (unsigned(col_idx) = 1 and unsigned(row_idx)=1) then
--          done <= '1';
--        elsif (unsigned(col_idx) = (N-O)-1) then
        if (unsigned(col_idx) = (N-O)-1) then
          if (unsigned(row_idx) = (N-O)-1) then
            col_idx <= std_logic_vector( to_unsigned( N-O,natural(ceil(log2(real(N))))));
            row_idx <= ( others => '0' );
          else
            row_idx <= std_logic_vector( unsigned(row_idx) + 1 );
            col_idx <= std_logic_vector( unsigned(row_idx) + 1 ); -- Upper triangular
          end if;
        else
          col_idx <= std_logic_vector( unsigned(col_idx) + 1 );
        end if;

      -- State Sorting P2
      when storing_p2 =>
        storage_wr_en <= '0';
        done <= '0';
        next_state <= reading;
        if (unsigned(col_idx) = (N)-1) then
          if (unsigned(row_idx) = (N-O)-1) then
            col_idx <= std_logic_vector( to_unsigned( N-O,natural(ceil(log2(real(N))))));
            row_idx <= std_logic_vector( to_unsigned( N-O,natural(ceil(log2(real(N))))));
          else
            row_idx <= std_logic_vector( unsigned(row_idx) + 1 );
            col_idx <= std_logic_vector( to_unsigned( N-O,natural(ceil(log2(real(N)))))); -- Not Upper trianglur
          end if;
        else
          col_idx <= std_logic_vector( unsigned(col_idx) + 1 );
        end if;
      
      -- State Sorting P3
      when storing_p3 =>
        done <= '0';
        storage_wr_en <= '0';
        next_state <= reading;
        if (unsigned(col_idx) = (N)-1) then
          if (unsigned(row_idx) = (N)-1) then
            col_idx <= ( others => '0' );
            row_idx <= ( others => '0' );
            done <= '1';
            total_bytes_read <= 0;
          else
            row_idx <= std_logic_vector( unsigned(row_idx) + 1 );
            col_idx <= std_logic_vector( unsigned(row_idx) + 1 ); -- Upper triangular
          end if;
        else
          col_idx <= std_logic_vector( unsigned(col_idx) + 1 );
        end if;

    end case;
  
  end if;
end process;

end Behavioral;
