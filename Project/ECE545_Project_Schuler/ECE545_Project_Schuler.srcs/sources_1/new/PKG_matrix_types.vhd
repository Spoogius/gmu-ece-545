library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package PKG_matrix_types is

  CONSTANT PKG_M : integer := 64;
  CONSTANT PKG_O : integer := 8;
  CONSTANT PKG_N : integer := 66;
  CONSTANT PKG_K : integer := 9;
  CONSTANT PKG_P1_BYTES : integer := 54752;
  CONSTANT PKG_P2_BYTES : integer := 14848;
  CONSTANT PKG_P3_BYTES : integer := 1152;

  
  
  -- Defined 3d MxMxM array of std_logic_vector[4]
  type m_mat_1d is array( 0 to PKG_M-1 ) of std_logic_vector( 3 downto 0 );
  type m_mat_2d is array( 0 to PKG_M-1 ) of m_mat_1d;
  type m_mat_3d is array( 0 to PKG_M-1 ) of m_mat_2d;
  
  type n_mat_1d is array( 0 to PKG_N-1 ) of std_logic_vector( 3 downto 0 );
  type nxn_mat_2d is array( 0 to PKG_N-1 ) of n_mat_1d;
  type nxnxm_mat_3d is array( 0 to PKG_M-1 ) of nxn_mat_2d;
end package;