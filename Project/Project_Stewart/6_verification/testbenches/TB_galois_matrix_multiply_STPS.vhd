library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library std;
use std.textio.all;

use work.PKG_matrix_types.all;

entity TB_galois_matrix_multiply_STPS is
--  Port ( );
end TB_galois_matrix_multiply_STPS;

architecture Behavioral of TB_galois_matrix_multiply_STPS is

signal S : n_mat_1d  := (x"B",x"8",x"0",x"A",x"B",x"1",x"C",x"E",x"0",x"A",x"9",x"B",x"8",x"4",x"A",x"D",x"7",x"5",x"6",x"6",x"D",x"2",x"A",x"5",x"7",x"2",x"B",x"1",x"3",x"A",x"2",x"5",x"9",x"2",x"C",x"1",x"F",x"C",x"0",x"5",x"9",x"6",x"2",x"6",x"1",x"7",x"D",x"7",x"9",x"5",x"C",x"0",x"6",x"1",x"4",x"5",x"F",x"0",x"8",x"1",x"A",x"7",x"0",x"1",x"5",x"D");

signal P : nxn_mat_2d := 
((x"1",x"9",x"1",x"F",x"E",x"E",x"6",x"6",x"5",x"B",x"3",x"C",x"4",x"4",x"0",x"7",x"D",x"9",x"D",x"8",x"5",x"E",x"6",x"C",x"F",x"E",x"5",x"E",x"8",x"A",x"6",x"2",x"A",x"8",x"9",x"2",x"8",x"2",x"8",x"C",x"9",x"F",x"9",x"6",x"2",x"D",x"E",x"F",x"8",x"1",x"2",x"2",x"C",x"B",x"7",x"C",x"5",x"1",x"B",x"D",x"9",x"5",x"A",x"A",x"D",x"7"),
(x"0",x"4",x"6",x"7",x"3",x"0",x"7",x"4",x"3",x"6",x"F",x"F",x"3",x"F",x"D",x"8",x"2",x"7",x"D",x"3",x"5",x"F",x"7",x"2",x"8",x"B",x"2",x"C",x"A",x"5",x"C",x"0",x"C",x"1",x"6",x"C",x"D",x"D",x"8",x"2",x"3",x"2",x"C",x"F",x"1",x"4",x"B",x"D",x"E",x"5",x"8",x"8",x"0",x"8",x"5",x"4",x"2",x"5",x"6",x"0",x"4",x"7",x"4",x"2",x"F",x"2"),
(x"0",x"0",x"3",x"A",x"1",x"0",x"4",x"7",x"F",x"C",x"D",x"8",x"C",x"A",x"0",x"D",x"C",x"A",x"F",x"0",x"F",x"1",x"D",x"1",x"A",x"9",x"F",x"F",x"1",x"C",x"5",x"B",x"6",x"C",x"0",x"B",x"6",x"C",x"0",x"7",x"F",x"8",x"3",x"7",x"E",x"A",x"A",x"5",x"9",x"C",x"D",x"F",x"C",x"4",x"2",x"6",x"7",x"C",x"D",x"1",x"0",x"D",x"8",x"3",x"A",x"1"),
(x"0",x"0",x"0",x"9",x"D",x"9",x"B",x"0",x"0",x"5",x"0",x"C",x"4",x"1",x"B",x"D",x"8",x"F",x"E",x"0",x"3",x"0",x"C",x"B",x"9",x"5",x"0",x"9",x"6",x"7",x"7",x"A",x"E",x"E",x"E",x"8",x"E",x"A",x"2",x"2",x"8",x"8",x"6",x"7",x"6",x"A",x"7",x"F",x"3",x"6",x"4",x"3",x"7",x"2",x"4",x"F",x"2",x"B",x"5",x"8",x"D",x"8",x"E",x"3",x"4",x"9"),
(x"0",x"0",x"0",x"0",x"D",x"E",x"4",x"C",x"D",x"B",x"C",x"1",x"D",x"3",x"A",x"9",x"F",x"7",x"1",x"1",x"5",x"4",x"5",x"E",x"B",x"3",x"0",x"8",x"F",x"A",x"0",x"0",x"E",x"6",x"C",x"F",x"F",x"5",x"7",x"7",x"3",x"2",x"E",x"8",x"C",x"E",x"B",x"D",x"4",x"1",x"2",x"A",x"A",x"1",x"C",x"1",x"E",x"D",x"2",x"5",x"0",x"F",x"E",x"C",x"B",x"7"),
(x"0",x"0",x"0",x"0",x"0",x"6",x"B",x"1",x"6",x"6",x"5",x"7",x"B",x"2",x"7",x"9",x"B",x"1",x"B",x"0",x"9",x"E",x"1",x"5",x"0",x"C",x"D",x"F",x"D",x"B",x"7",x"7",x"2",x"8",x"2",x"1",x"F",x"5",x"C",x"B",x"C",x"6",x"3",x"9",x"7",x"F",x"C",x"E",x"5",x"D",x"6",x"3",x"0",x"A",x"F",x"2",x"4",x"2",x"B",x"6",x"A",x"B",x"1",x"3",x"F",x"D"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"C",x"5",x"6",x"9",x"8",x"3",x"4",x"D",x"4",x"A",x"A",x"D",x"D",x"1",x"C",x"9",x"5",x"D",x"4",x"E",x"0",x"A",x"8",x"2",x"B",x"7",x"0",x"8",x"A",x"1",x"9",x"7",x"0",x"8",x"2",x"0",x"6",x"E",x"4",x"9",x"2",x"D",x"1",x"F",x"F",x"1",x"C",x"D",x"7",x"D",x"E",x"A",x"4",x"8",x"A",x"1",x"6",x"3",x"0",x"1"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"A",x"C",x"4",x"C",x"2",x"D",x"5",x"4",x"F",x"3",x"5",x"5",x"7",x"1",x"4",x"F",x"5",x"2",x"0",x"D",x"5",x"4",x"7",x"F",x"6",x"5",x"4",x"F",x"E",x"1",x"7",x"1",x"9",x"9",x"3",x"A",x"2",x"9",x"5",x"5",x"0",x"C",x"C",x"E",x"0",x"6",x"E",x"4",x"5",x"6",x"5",x"B",x"0",x"1",x"4",x"A",x"E",x"F"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"4",x"8",x"9",x"D",x"8",x"C",x"2",x"9",x"A",x"F",x"D",x"6",x"4",x"2",x"D",x"A",x"D",x"5",x"0",x"D",x"4",x"0",x"1",x"C",x"4",x"3",x"A",x"F",x"C",x"8",x"9",x"4",x"4",x"3",x"5",x"9",x"C",x"F",x"7",x"4",x"F",x"4",x"B",x"D",x"A",x"3",x"D",x"7",x"7",x"0",x"7",x"1",x"5",x"3",x"9",x"1",x"3"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"4",x"0",x"8",x"6",x"6",x"C",x"7",x"F",x"1",x"E",x"1",x"1",x"0",x"1",x"0",x"5",x"D",x"E",x"1",x"9",x"E",x"C",x"5",x"7",x"D",x"5",x"C",x"B",x"D",x"3",x"7",x"A",x"2",x"A",x"B",x"6",x"6",x"9",x"2",x"4",x"1",x"4",x"7",x"7",x"5",x"E",x"0",x"1",x"3",x"3",x"6",x"A",x"E",x"3",x"6",x"E",x"F"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"2",x"5",x"1",x"8",x"0",x"F",x"5",x"5",x"8",x"2",x"1",x"1",x"3",x"7",x"8",x"3",x"E",x"3",x"4",x"A",x"F",x"D",x"7",x"6",x"A",x"F",x"D",x"4",x"6",x"1",x"C",x"1",x"A",x"E",x"D",x"0",x"9",x"5",x"A",x"3",x"7",x"7",x"3",x"7",x"4",x"3",x"C",x"F",x"1",x"9",x"8",x"7",x"E",x"0",x"A"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"7",x"1",x"3",x"8",x"6",x"4",x"6",x"E",x"4",x"B",x"0",x"D",x"B",x"6",x"7",x"8",x"F",x"4",x"2",x"0",x"C",x"8",x"C",x"7",x"F",x"6",x"6",x"2",x"0",x"B",x"D",x"4",x"9",x"E",x"1",x"4",x"5",x"0",x"C",x"C",x"B",x"A",x"4",x"2",x"2",x"A",x"9",x"4",x"D",x"E",x"7",x"C",x"9",x"4",x"C"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"7",x"2",x"2",x"E",x"0",x"C",x"7",x"2",x"7",x"F",x"9",x"3",x"A",x"2",x"6",x"9",x"7",x"6",x"A",x"4",x"8",x"F",x"D",x"A",x"7",x"A",x"0",x"4",x"3",x"2",x"1",x"C",x"D",x"7",x"A",x"A",x"2",x"7",x"6",x"5",x"E",x"3",x"A",x"3",x"6",x"D",x"B",x"6",x"6",x"7",x"B",x"A"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"D",x"A",x"0",x"3",x"8",x"3",x"B",x"1",x"8",x"7",x"2",x"C",x"E",x"9",x"C",x"8",x"A",x"9",x"9",x"0",x"2",x"4",x"4",x"A",x"0",x"1",x"3",x"5",x"B",x"5",x"8",x"0",x"4",x"F",x"B",x"1",x"7",x"1",x"1",x"4",x"9",x"5",x"8",x"A",x"3",x"9",x"7",x"C",x"2",x"A",x"5",x"5"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"5",x"7",x"B",x"B",x"8",x"5",x"9",x"6",x"8",x"1",x"D",x"E",x"F",x"C",x"3",x"8",x"6",x"B",x"E",x"C",x"8",x"2",x"2",x"C",x"0",x"4",x"A",x"0",x"A",x"C",x"4",x"F",x"C",x"9",x"4",x"2",x"0",x"1",x"9",x"8",x"E",x"3",x"2",x"E",x"0",x"7",x"7",x"C",x"E",x"2",x"A",x"9"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"8",x"3",x"1",x"0",x"5",x"7",x"4",x"3",x"A",x"D",x"5",x"2",x"1",x"D",x"F",x"A",x"7",x"2",x"C",x"A",x"A",x"7",x"F",x"B",x"2",x"5",x"2",x"1",x"7",x"4",x"1",x"B",x"C",x"A",x"7",x"4",x"D",x"7",x"2",x"A",x"9",x"9",x"6",x"9",x"A",x"5",x"B",x"C",x"F",x"7",x"C"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"C",x"6",x"7",x"D",x"1",x"A",x"C",x"D",x"E",x"C",x"C",x"1",x"4",x"9",x"B",x"9",x"A",x"8",x"B",x"B",x"4",x"7",x"A",x"5",x"4",x"0",x"5",x"4",x"D",x"7",x"2",x"5",x"F",x"1",x"3",x"5",x"8",x"8",x"9",x"1",x"7",x"3",x"9",x"4",x"3",x"E",x"B",x"F",x"0",x"F"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"5",x"5",x"0",x"4",x"2",x"A",x"F",x"A",x"6",x"E",x"9",x"4",x"D",x"7",x"5",x"8",x"8",x"4",x"5",x"D",x"5",x"7",x"0",x"B",x"D",x"F",x"5",x"D",x"D",x"D",x"F",x"1",x"8",x"0",x"5",x"9",x"0",x"E",x"A",x"9",x"F",x"F",x"B",x"A",x"A",x"F",x"4",x"6",x"B"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"2",x"4",x"D",x"F",x"2",x"3",x"C",x"B",x"0",x"3",x"9",x"8",x"B",x"A",x"B",x"F",x"7",x"8",x"5",x"7",x"9",x"4",x"9",x"5",x"C",x"8",x"D",x"3",x"3",x"7",x"C",x"4",x"D",x"A",x"9",x"4",x"7",x"5",x"F",x"3",x"D",x"3",x"6",x"C",x"0",x"7",x"9"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"7",x"5",x"D",x"D",x"2",x"9",x"9",x"4",x"E",x"2",x"8",x"F",x"B",x"F",x"3",x"8",x"D",x"3",x"E",x"9",x"E",x"7",x"9",x"8",x"9",x"E",x"8",x"6",x"4",x"9",x"0",x"2",x"E",x"2",x"B",x"E",x"A",x"0",x"8",x"C",x"0",x"3",x"8",x"D"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"E",x"8",x"7",x"B",x"A",x"7",x"5",x"2",x"6",x"F",x"0",x"B",x"9",x"2",x"2",x"2",x"F",x"3",x"D",x"7",x"C",x"F",x"C",x"7",x"0",x"E",x"7",x"2",x"A",x"F",x"E",x"9",x"E",x"D",x"0",x"1",x"B",x"8",x"0",x"C",x"4",x"0",x"C",x"4",x"F",x"1"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"7",x"1",x"C",x"F",x"7",x"8",x"8",x"9",x"9",x"3",x"E",x"9",x"6",x"C",x"3",x"F",x"C",x"2",x"8",x"0",x"2",x"4",x"4",x"0",x"2",x"8",x"3",x"7",x"1",x"B",x"E",x"3",x"D",x"B",x"1",x"0",x"A",x"B",x"C",x"9",x"E",x"F",x"5",x"B",x"E"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"4",x"4",x"1",x"0",x"8",x"F",x"6",x"3",x"F",x"1",x"B",x"E",x"2",x"3",x"3",x"E",x"D",x"0",x"A",x"D",x"2",x"4",x"0",x"B",x"9",x"1",x"B",x"A",x"7",x"6",x"B",x"B",x"3",x"D",x"2",x"3",x"9",x"E",x"6",x"1",x"9",x"6",x"2",x"B"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"6",x"B",x"E",x"2",x"3",x"C",x"B",x"0",x"0",x"7",x"A",x"A",x"C",x"D",x"C",x"C",x"1",x"7",x"6",x"A",x"2",x"6",x"4",x"C",x"8",x"5",x"8",x"A",x"3",x"1",x"E",x"1",x"D",x"C",x"6",x"3",x"0",x"D",x"0",x"A",x"9",x"1",x"0"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"A",x"6",x"E",x"3",x"E",x"C",x"5",x"9",x"0",x"3",x"8",x"1",x"6",x"C",x"5",x"0",x"B",x"6",x"F",x"8",x"C",x"D",x"1",x"2",x"8",x"3",x"1",x"D",x"5",x"A",x"9",x"1",x"3",x"0",x"5",x"A",x"C",x"2",x"0",x"A",x"B"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"9",x"D",x"5",x"3",x"E",x"C",x"8",x"D",x"E",x"B",x"B",x"4",x"A",x"F",x"A",x"2",x"8",x"C",x"4",x"5",x"E",x"2",x"4",x"0",x"9",x"4",x"8",x"5",x"C",x"6",x"3",x"1",x"3",x"F",x"5",x"F",x"B",x"8",x"8",x"0"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"C",x"1",x"C",x"E",x"B",x"6",x"E",x"A",x"B",x"A",x"B",x"1",x"C",x"3",x"7",x"6",x"7",x"6",x"1",x"1",x"A",x"C",x"8",x"B",x"7",x"F",x"E",x"B",x"7",x"4",x"5",x"F",x"A",x"D",x"B",x"4",x"E",x"F",x"F",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"C",x"4",x"E",x"C",x"4",x"4",x"D",x"9",x"7",x"9",x"F",x"9",x"2",x"D",x"B",x"F",x"D",x"E",x"A",x"1",x"E",x"B",x"D",x"B",x"9",x"6",x"8",x"C",x"5",x"5",x"C",x"5",x"E",x"0",x"3",x"D",x"D",x"F",x"E"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"9",x"D",x"F",x"E",x"6",x"A",x"5",x"2",x"B",x"D",x"0",x"E",x"5",x"3",x"B",x"F",x"6",x"C",x"2",x"5",x"C",x"5",x"A",x"D",x"4",x"6",x"8",x"3",x"9",x"7",x"D",x"0",x"1",x"6",x"4",x"8",x"0",x"0"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"5",x"4",x"4",x"A",x"3",x"C",x"5",x"7",x"8",x"D",x"9",x"F",x"1",x"2",x"2",x"C",x"C",x"5",x"F",x"1",x"A",x"7",x"8",x"B",x"F",x"9",x"E",x"C",x"2",x"8",x"9",x"A",x"0",x"0",x"2",x"1",x"2"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"3",x"2",x"0",x"7",x"8",x"1",x"A",x"1",x"D",x"1",x"7",x"1",x"5",x"6",x"A",x"A",x"B",x"1",x"9",x"3",x"7",x"2",x"B",x"3",x"A",x"A",x"A",x"8",x"3",x"F",x"4",x"B",x"4",x"0",x"3"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"B",x"5",x"A",x"9",x"3",x"3",x"4",x"A",x"7",x"F",x"7",x"B",x"1",x"A",x"E",x"3",x"1",x"C",x"C",x"9",x"7",x"0",x"3",x"9",x"8",x"4",x"D",x"D",x"D",x"2",x"6",x"F",x"B",x"A",x"0"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"9",x"5",x"D",x"E",x"A",x"9",x"9",x"2",x"9",x"9",x"0",x"1",x"0",x"0",x"3",x"9",x"4",x"A",x"1",x"B",x"2",x"D",x"5",x"A",x"5",x"5",x"3",x"1",x"4",x"B",x"7",x"E",x"3",x"9"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"8",x"D",x"C",x"5",x"4",x"8",x"6",x"0",x"3",x"6",x"C",x"7",x"B",x"7",x"0",x"D",x"A",x"6",x"6",x"0",x"1",x"E",x"D",x"4",x"7",x"7",x"0",x"F",x"A",x"9",x"E",x"A",x"8"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"5",x"9",x"4",x"6",x"C",x"C",x"7",x"B",x"1",x"A",x"8",x"A",x"D",x"C",x"7",x"7",x"B",x"9",x"7",x"8",x"3",x"0",x"8",x"C",x"9",x"4",x"F",x"F",x"1",x"1",x"8",x"2"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"5",x"C",x"C",x"3",x"E",x"1",x"B",x"C",x"4",x"1",x"6",x"3",x"4",x"6",x"D",x"D",x"E",x"3",x"2",x"E",x"4",x"4",x"A",x"1",x"8",x"A",x"9",x"6",x"A",x"E",x"7"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"9",x"A",x"C",x"E",x"9",x"A",x"5",x"0",x"4",x"E",x"F",x"3",x"4",x"8",x"6",x"1",x"8",x"2",x"0",x"2",x"7",x"E",x"3",x"2",x"9",x"6",x"2",x"3",x"1",x"2"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"7",x"A",x"1",x"5",x"5",x"9",x"3",x"2",x"D",x"0",x"9",x"D",x"E",x"B",x"8",x"2",x"7",x"5",x"4",x"3",x"7",x"3",x"C",x"D",x"0",x"3",x"1",x"C",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"F",x"3",x"B",x"4",x"6",x"F",x"4",x"8",x"F",x"D",x"D",x"3",x"5",x"9",x"5",x"3",x"6",x"9",x"E",x"2",x"4",x"9",x"2",x"1",x"0",x"7",x"A",x"1"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"F",x"4",x"9",x"9",x"A",x"9",x"C",x"9",x"C",x"5",x"9",x"4",x"3",x"A",x"E",x"1",x"C",x"3",x"F",x"5",x"7",x"A",x"2",x"7",x"7",x"C"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"2",x"7",x"1",x"9",x"A",x"4",x"7",x"7",x"C",x"6",x"3",x"1",x"8",x"0",x"2",x"2",x"2",x"7",x"6",x"4",x"5",x"1",x"3",x"E",x"F"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"F",x"C",x"D",x"5",x"5",x"B",x"F",x"9",x"B",x"B",x"6",x"5",x"F",x"5",x"1",x"6",x"2",x"6",x"1",x"1",x"F",x"9",x"7",x"D",x"1"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"9",x"2",x"F",x"9",x"A",x"8",x"B",x"C",x"2",x"8",x"C",x"0",x"9",x"8",x"E",x"D",x"E",x"E",x"F",x"6",x"0",x"1",x"A",x"A"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"4",x"C",x"9",x"B",x"A",x"7",x"5",x"8",x"1",x"7",x"5",x"8",x"B",x"A",x"5",x"C",x"6",x"1",x"B",x"6",x"0",x"A"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"4",x"8",x"E",x"C",x"C",x"9",x"7",x"A",x"C",x"C",x"2",x"B",x"B",x"B",x"1",x"3",x"2",x"F",x"8",x"8",x"C",x"3"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"D",x"9",x"1",x"E",x"2",x"9",x"2",x"A",x"F",x"C",x"2",x"D",x"C",x"B",x"E",x"2",x"C",x"6",x"2",x"0",x"D"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"F",x"C",x"0",x"1",x"0",x"4",x"F",x"1",x"B",x"E",x"2",x"C",x"A",x"C",x"2",x"9",x"A",x"B",x"A",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"A",x"D",x"3",x"6",x"C",x"6",x"9",x"2",x"B",x"9",x"3",x"4",x"B",x"2",x"7",x"8",x"F",x"3",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1",x"F",x"4",x"3",x"3",x"0",x"0",x"E",x"1",x"C",x"3",x"5",x"7",x"F",x"B",x"4",x"1",x"4"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"C",x"A",x"E",x"F",x"A",x"8",x"B",x"E",x"2",x"0",x"5",x"6",x"E",x"B",x"3",x"5",x"3"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"A",x"3",x"B",x"6",x"7",x"5",x"6",x"D",x"B",x"F",x"9",x"C",x"7",x"7",x"6",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"E",x"C",x"F",x"0",x"1",x"1",x"A",x"C",x"F",x"0",x"E",x"1",x"E",x"A",x"E"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"5",x"0",x"B",x"B",x"C",x"0",x"9",x"6",x"3",x"F",x"E",x"E",x"5",x"7"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"B",x"4",x"9",x"5",x"1",x"6",x"4",x"D",x"6",x"7",x"6",x"6",x"E"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"E",x"B",x"F",x"3",x"1",x"1",x"2",x"7",x"B",x"2",x"8"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"F",x"9",x"7",x"3",x"F",x"4",x"B",x"6",x"2",x"A"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"F",x"0",x"7",x"7",x"2",x"0",x"F",x"3",x"D",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"8",x"9",x"8",x"1",x"E",x"E",x"B",x"6",x"D"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"E",x"1",x"1",x"8",x"1",x"5",x"E"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1",x"4",x"0",x"E",x"2",x"0",x"4"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"2",x"6",x"8",x"9",x"2",x"6"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"C",x"0",x"5",x"8",x"1"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"3",x"4",x"D",x"C"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"6",x"9",x"F"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"4",x"3"),
(x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"4"));

signal result, result_expected : std_logic_vector( 3 downto 0 ) := x"4";

begin

dut: entity work.galois_matrix_multiply_STPS
  port map(
    ST => S,
    P => P,
    S => S,
    result => result
  );

process
begin
  wait;
end process;

end Behavioral;