clear; clc;

% This only works for m = 4 since a galois_multiply needs a different LUT
% to support other values. 
m = 4;
for a_val = [0:(2^m)-1]
    for b_val = [0:(2^m)-1]
        a = gf( a_val, m );
        b = gf( a_val, m );
        if galois.mathworks_galois_add( a, b ) ~= galois.galois_add( a, b )
            fprintf("Galois Add failed in case: a=%d b=%d\n", a.x, b.x );
        end
        if galois.mathworks_galois_multiply( a, b ) ~= galois.galois_multiply( a, b )
            fprintf("Galois Multiply failed in case: a=%d b=%d\n", a.x, b.x );
        end
    end
end
fprintf("All Test Cases Passed\n" );
