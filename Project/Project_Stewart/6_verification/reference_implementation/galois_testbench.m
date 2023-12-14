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
fprintf("All Scalar Operations Test Cases Passed\n" );

for rand_idx = [0:(2^m)-1]
    shared_size = 1+randi(15);
    a_size_1 = 1+randi(15);
    b_size_2 = 1+randi(15);

    % Create as Square matricies for adding
    a = gf(randi((2^m)-1, shared_size,shared_size), m );
    b = gf(randi((2^m)-1, shared_size,shared_size), m );

    if ~all(all(galois.mathworks_galois_matrix_add( a, b ) == galois.galois_matrix_add( a, b )))
        fprintf("Galois Matrix Add failed in case:\n");
        display(a)
        display(b)
    end

    % Reshape to not nessecarily be square for multiplication
    a = gf(randi((2^m)-1, a_size_1,shared_size), m );
    b = gf(randi((2^m)-1, shared_size,b_size_2), m );

    if ~all(all(galois.mathworks_galois_matrix_multiply( a, b ) == galois.galois_matrix_multiply( a, b )))
        fprintf("Galois Matrix Multiply failed in case:\n");
        display(a)
        display(b)
    end
end
fprintf("All Matrix Test Cases Passed\n" );

