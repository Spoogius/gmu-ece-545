library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;
entity mayo_verify_controller is
  Generic(
    P1_BYTES : integer := PKG_P1_BYTES;
    P2_BYTES : integer := PKG_P2_BYTES;
    P3_BYTES : integer := PKG_P3_BYTES;
    SIG_BYTES : integer := PKG_SIG_BYTES
  );
  Port( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    en : in std_logic;
    load_p_storage : out std_logic;
    load_s_storage : out std_logic;
    en_compute_y_long : out std_logic;
    en_collapse_y_long : out std_logic;
    
    done_p_storage : in std_logic;
    done_s_storage : in std_logic;
    done_compute_y_long : in std_logic;
    rd_y : in std_logic
  );
end mayo_verify_controller;

architecture Behavioral of mayo_verify_controller is

type states is ( p_storage, s_storage, compute_y_long, collapse_y_long, output_y );
signal curr_state : states := p_storage;

signal bytes_read : integer := 0;
signal p_storage_finished : std_logic := '0';

begin
/* load_p_storage is an asynchonronous output because 
the input interface has data_in being changed the first value
and en being set high at the same time. If I needed to wait a clock
cycle in the state machine until I see en = '1' then by the time 
load_p_storage goes high the next value of data_in will have arrivd
and the first value is missed.
*/
load_p_storage <= en when ((curr_state = p_storage) and (rst = '0')) or ((curr_state = s_storage) and ( p_storage_finished = '0' ))
                     else '0';
                     
process( clk, rst )
begin

  if (rst = '1') then
    curr_state <= p_storage;
    bytes_read <= 0;
    
    load_s_storage <= '0';
    en_compute_y_long <= '0';
    en_collapse_y_long <= '0';
    p_storage_finished <= '0';
    
  elsif( rising_edge( clk ) ) then
    -- Default values
    load_s_storage <= '0';
    en_compute_y_long <= '0';
    en_collapse_y_long <= '0';
    if( en = '1' ) then
      case curr_state is
        -- State p_storage
        when p_storage =>
          
          bytes_read <= bytes_read + 1;
          if( bytes_read + 1 >= ( P1_BYTES + P2_BYTES + P3_BYTES ) ) then
            curr_state <= s_storage;
            load_s_storage <= '1';
            bytes_read <= bytes_read + 1;
          end if;
        
        -- State s_stroage
        when s_storage =>
          load_s_storage <= '1';
          
          if( done_p_storage = '1' ) then
            p_storage_finished <= '1';
          end if;
          
          bytes_read <= bytes_read + 1;
          if( bytes_read > ( P1_BYTES + P2_BYTES + P3_BYTES + SIG_BYTES ) ) then
            curr_state <= compute_y_long;
            load_s_storage <= '0';
            en_compute_y_long <= '1';
          end if;
        
        -- State compute_y_long
        when compute_y_long =>
          en_compute_y_long <= '1'; 
          if( done_compute_y_long = '1' ) then
            curr_state <= collapse_y_long;
            en_compute_y_long <= '0';
            en_collapse_y_long <= '1';
          end if;
          
        -- State Collapse_y_long
        when collapse_y_long =>
          en_collapse_y_long <= '1';
          if( rd_y = '1' ) then
            curr_state <= output_y;
          end if;
        
        -- State output_y
        when output_y =>
          en_collapse_y_long <= '1';
          if( rd_y = '0' ) then
            curr_state <= p_storage;
            en_collapse_y_long <= '0';
            p_storage_finished <= '0';
            bytes_read <= 0;
          end if;
      end case;
    end if; -- en
  end if; -- r_e(clk)
end process;
end Behavioral;
