clear; clc;

EPK_bytes = 70752;
P1_bytes = 54752;
P2_bytes = 14848;
P3_bytes = EPK_bytes - P1_bytes - P2_bytes;
sig_bytes = 321;
m = 64;
n = 66;
v = 58;
o = 8;
k = 9;

for fname = ["epk", "sig", "s", "y", "f_tail" ]
    fin = fopen( sprintf("c_data/%s.bin", fname), 'r' );
    eval( sprintf( "%s_golden = fread( fin, 'uint8=>uint8');", fname ), fin );
    fclose( fin );
end
save mayo_example.mat;