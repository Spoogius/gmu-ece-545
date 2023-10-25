library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
  port (
  clk : in std_logic;
  reset : in std_logic;
  s : in std_logic;
  MiltMj: in std_logic;
  zi: in std_logic;  
  zj: in std_logic;    
  Wr : out std_logic;
  Li : out std_logic;
  Ei : out std_logic;
  Lj : out std_logic;
  Ej : out std_logic;
  Done: out std_logic
   );
end Controller;

architecture behavioral of controller is
TYPE state is (S0,S1,S2,S3,S4);
signal state_reg, state_next: state;
begin

reg: process(clk, reset)
begin
    if reset = '1' then
        state_reg <= S0;
    elsif rising_edge(clk) then
        state_reg <= state_next;
    end if;
end process;

logic: process(state_reg, s, MiltMj, zi, zj)
begin

  state_next <= state_reg;
  Wr <= '0';
  Li <= '0';
  Ei <= '0';
  Lj <= '0';
  Ej <= '0';
  Done <= '0';

  CASE state_reg is
	when S0 =>
    	Li <= '1';
    	if s ='1' then
        	state_next <= S1;
    	else
        	state_next <= S0;
    	end if;
    when S1 =>
    	Lj <= '1';
        state_next <= S2;
    when S2 =>
    	state_next <= S3;
    when S3 =>
    	if MiltMj = '1' then
        	Wr <= '1';
    	end if;
    	if zj = '0' then
    		Ej <= '1';
    		state_next <= S2;
    	elsif zi = '0' then
    		Ei <= '1';
    		state_next <= S1;
    	else
    		state_next <= S4;
    	end if;
    when S4 =>
    	Done <= '1';
    	if s = '1' then
        	state_next <= S4;
    	else
        	state_next <= S0;
    	end if;
  end case;
end process;

end behavioral;
