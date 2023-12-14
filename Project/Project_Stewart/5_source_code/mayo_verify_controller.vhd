library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.PKG_matrix_types.all;
entity mayo_verify_controller is
  Generic(
    M : integer := PKG_M;
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
    
    rd_data_in : in std_logic;
    rdy_data_in : out std_logic;
    p_rdy_data_in : in std_logic;
    
    done_p_storage : in std_logic;
    done_s_storage : in std_logic;
    done_compute_y_long : in std_logic;
    rd_y : in std_logic
  );
end mayo_verify_controller;

architecture Behavioral of mayo_verify_controller is

type states is ( p_storage, p_reading, s_storage, compute_y_long, collapse_y_long, output_y );
signal curr_state : states := p_reading;

signal bytes_read, frame_bytes_read : integer := 0;
signal p_storage_finished : std_logic := '0';
signal s_rdy_data_in : std_logic := '0';

begin
/* load_p_storage is an asynchonronous output because 
the input interface has data_in being changed the first value
and en being set high at the same time. If I needed to wait a clock
cycle in the state machine until I see en = '1' then by the time 
load_p_storage goes high the next value of data_in will have arrivd
and the first value is missed.
*/
load_p_storage <= rd_data_in when ((curr_state = p_storage) or (curr_state = p_reading)) and (rst = '0') and (en = '1')
                  else '0';
rdy_data_in <= p_rdy_data_in when ((curr_state = p_storage) or (curr_state = p_reading)) and (rst = '0') and (en = '1')
                  else s_rdy_data_in;

          
process( clk, rst )
begin

  if (rst = '1') then
    curr_state <= p_reading;
    bytes_read <= 0;
    frame_bytes_read <= 0;
    
    load_s_storage <= '0';
    en_compute_y_long <= '0';
    en_collapse_y_long <= '0';
    
  elsif( rising_edge( clk ) ) then
    -- Default values
    load_s_storage <= '0';
    en_compute_y_long <= '0';
    en_collapse_y_long <= '0';
    if( en = '1' ) then
      case curr_state is
      
        -- State p_reading
        when p_reading =>
          if( rd_data_in = '1' ) then
            bytes_read <= bytes_read + 1;
            frame_bytes_read <= frame_bytes_read + 1;
            if( frame_bytes_read = M/2-1 ) then
              curr_state <= p_storage;
            end if;
          end if;
          
        -- State p_storage
        when p_storage =>
          if( done_p_storage = '1' ) then
            curr_state <= s_storage;
            load_s_storage <= '1';
            s_rdy_data_in <= '1';
          elsif( rdy_data_in = '1' ) then
            curr_state <= p_reading;
            frame_bytes_read <= 0;
          end if;
         
          
        -- State s_stroage
        when s_storage =>
          
          load_s_storage <= '1';
          if( rd_data_in = '1' ) then
            s_rdy_data_in <= '0';
          end if;
          if( done_s_storage = '1') then
            load_s_storage <= '0';
            en_compute_y_long <= '1';
            curr_state <= compute_y_long;
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
            bytes_read <= 0;
            
          end if;
      end case;
    end if; -- en
  end if; -- r_e(clk)
end process;
end Behavioral;
